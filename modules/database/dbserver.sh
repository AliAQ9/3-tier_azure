#!/bin/bash

sudo yum install mysql -y
sudo systemctl start mysql
sudo systemctl enable mysql
sudo systemctl status mysql

#!/bin/bash
sudo yum update
sudo yum install mysql-server
sudo systemctl start mysqld
sudo systemctl enable mysqld
sudo systemctl enable --now mysqld
sudo mysql_secure_installation