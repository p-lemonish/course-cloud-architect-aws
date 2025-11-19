#!/bin/bash
sudo yum update -y
sudo yum install -y nginx
sudo systemctl enable nginx
sudo systemctl start nginx
echo "hello, to whoever can read this, from the private subnet!" > task9.html
sudo mv task9.html /usr/share/nginx/html/task9.html
