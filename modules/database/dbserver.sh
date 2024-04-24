#!/bin/bash

sudo yum install mysql -y
sudo systemctl start mysql
sudo systemctl enable mysql
sudo systemctl status mysql