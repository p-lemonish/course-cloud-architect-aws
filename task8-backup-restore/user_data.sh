#!/bin/bash
sudo yum update -y
sudo yum install -y nginx
sudo systemctl enable nginx
sudo systemctl start nginx
echo "hello world, from task7 user_data" > task7.html
sudo mv task7.html /usr/share/nginx/html/task7.html
