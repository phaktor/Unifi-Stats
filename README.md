# UnifiPoller

Hello! This repository is intended to setup an environment with UnifiPoller. There are two main parts in this project. First one is terraform(tf) files to create the desired infrastructure. The second part is the bash scripts (sh) to build the correct packages to achieve our goal. This guide will lead you to correctly setup these two main parts.

1) First we will setup the infrastructure which will be independent from our bash scripts. To achieve this, first create a file called "secret-variables.auto.tfvars" in project folder and enter the below lines.

        aws_access_key_id = "your_access_key_id_here"
        aws_secret_access_key = "your_secret_access_key_here"
        
2) Now run below command to start the installation of the infrastructure. These terraform codes will launch an Amazon EC2 instance with Ubuntu 18.04 operating system in it. It will also adjust the firewall rules accordingly to set the communication between tools.

        terraform apply 
        #then type "yes" as input
        
3) Our infrastructure is created successfully. We will start building the first tool called "Grafana". This tool is used to create great dashboards with the given data. Now navigate to the "Systems Manager">"Session Manager" tab in AWS console and start a session with our newly created instance. Perform the below changes. We will perform all steps with "root" user. Type "sudo su -" to switch to root user before starting.

        - copy the content of "grafana_installer_1.sh" file in GitHub repository.
        - create a file with the same name and edit it in Linux terminal with below command. 
        
        "vi grafana_installer_1.sh"
        
        - Type "i" to switch into insert mode. Then paste all the lines to here. Press "ESC", type ":wq!" and then press    enter. You may perform these steps with your favourite editor.
        - Finally run "sh grafana_installer_1.sh" to initiate the script.
        
4) Grafana is installed successfully. Now you need to navigate to the grafana webpage and login. Perform below steps to login.

        - Switch to the EC2 console. Click on the instance and copy the public IP of the instance.
        - Go to your web browser and navigate to "http://<public_IP_of_the_instance>:3000".
        - The initial username/password of Grafana is "admin/admin". Type these credentials and it'll redirect you a page to         change your password. Note the newly created password somewhere.
        
5) It's time to build InfluxDB. This tool will receive the metrics from unifi-poller software. Also grafana will pull the data from InfluxDB to create the dashboard. Perform the below steps to install InfluxDB.

        - copy the content of "influxdb_installer_2.sh" file in GitHub repository.
        - create a file with the same name and edit it in Linux terminal with below command. 
        
        "vi influxdb_installer_2.sh"
        
        - Type "i" to switch into insert mode. Then paste all the lines to here. Press "ESC", type ":wq!" and then press     enter. You may perform these steps with your favourite editor.
        - Finally run "sh influxdb_installer_2.sh" to initiate the script.
        
6) Now we will create a database inside InfluxDB to host the data which will be received from unifi-poller. Perform the below steps to configure InfluxDB.
 
        - Run "influx -host localhost -port 8086" to connect InfluxDB.
        - "CREATE DATABASE unifi" to create a database named unifi.
        - "CREATE USER unifipoller WITH PASSWORD 'unifipoller' WITH ALL PRIVILEGES" to create a user inside DB. Change the   username and password with your desired values.
        - "GRANT ALL ON unifi TO unifipoller" to adjust privileges.
        - Type "exit" command to close the connection.
        
7) Now that we've created the DB and configured successfully, it's time to connect InfluxDB and Grafana. To perform this, navigate to Grafana webpage. Perform the below steps to set the connection.
 
        - On Grafana web interface, click on "data source" button which you can see in main page.
        - Choose "InfluxDB" from the menu bar.
        - Type "URL" section under "HTTP" bar: "http://localhost:8086"
        - Type "Database" section under "InfluxDB Details" bar: "unifi"
        - Type "User" section under "InfluxDB Details" bar: "your_username"
        - Type "Password" section under "InfluxDB Details" bar: "your_password"
        - Leave everything as it is and click on "Save&Test" button below.
        - You should see "Data source is working" popup in green.
        
8) Grafana and InfluxDB processes are done. Now we will work on unifi-poller. First we will install unifi-poller package. Perform below steps to install unifi-poller.

        - copy the content of "unifi-poller_installer_3.sh" file in GitHub repository.
        - create a file with the same name and edit it in Linux terminal with below command. 
        
        "vi unifi-poller_installer_3.sh"
        
        - Type "i" to switch into insert mode. Then paste all the lines to here. Press "ESC", type ":wq!" and then press     enter. You may perform these steps with your favourite editor.
        - Finally run "sh unifi-poller_installer_3.sh" to initiate the script.
        
9) Now you need to configure your physical Unifi-Controller.

        - Login to your Unifi-Controller device.
        - Go to Settings --> Admins
        - Add a read-only user with name unifipoller and with a password.
        
10) Now we will configure the unifi-poller package to pull data from Unifi-Controller and send this data to InfluxDB.

        - Go and edit unifi-poller config file with "vi /etc/unifi-poller/up.conf" command.
        - Under [InfluxDB] section edit the "user" and "pass" lines with the ones that you've created.
        - Under [unifi.defaults] section edit the "url" section and enter your Unifi-Controller's URL with :8443 port in the end.
        - Also edit the "user" and "pass" sections so that unifi-poller will be able to login to your Unifi-Controller   without any problem.
        - Run "systemctl restart unifi-poller" to reflect the changes.

11) As last step, go to Grafana web interface. Click "+" button on the left page and click on "import" button from dropdown menu. Type one the below IDs to the "ID" section, then press load. You will see that Unifi-Poller section is loaded automatically. Now in "Unifi-Poller" section in the last, choose "InfluxDB" from dropdown menu. Finally click on "Import" button.

Client DPI --> ID:10419 --> …enabled save_dpi

Sites      --> ID:10414	--> …enabled save_sites

USW        --> ID:10417	--> …have UniFi Switches

USG        --> ID:10416	--> …have UniFi Gateways

UAP        --> ID:10415	--> …have UniFi Access Points

Clients    --> ID:10418	--> …love nano
        
All steps are done! Now wait for a while for Unifi-poller to pull some metrics from Unifi-Controller.



 
        
