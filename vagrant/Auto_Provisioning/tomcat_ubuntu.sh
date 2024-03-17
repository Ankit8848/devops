#!/bin/bash

# Update package repositories and upgrade existing packages
sudo apt update
sudo apt upgrade -y

# Install OpenJDK 8 and Tomcat 8 along with related packages
sudo apt install openjdk-8-jdk tomcat8 tomcat8-admin tomcat8-docs tomcat8-common git -y
