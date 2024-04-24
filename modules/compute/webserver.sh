#!/bin/bash

sudo yum install httpd -y
sudo systemctl start httpd
sudo systemctl enable httpd
sudo systemctl status httpd

sudo yum install http -y
sudo systemctl start http
sudo systemctl enable http
sudo systemctl status http