#!/bin/bash

TOMURL="https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.75/bin/apache-tomcat-9.0.75.tar.gz"
JAVA_VERSION=11

# Install Java, Git, Maven, and wget
dnf -y install java-${JAVA_VERSION}-openjdk java-${JAVA_VERSION}-openjdk-devel git maven wget

# Download and extract Tomcat
cd /tmp/
wget $TOMURL -O tomcatbin.tar.gz
tar xzf tomcatbin.tar.gz
TOMDIR=$(tar tzf tomcatbin.tar.gz | head -1 | cut -f1 -d'/')
rsync -avzh /tmp/$TOMDIR/ /usr/local/tomcat/
chown -R tomcat:tomcat /usr/local/tomcat

# Create and configure Tomcat systemd service
cat <<EOT > /etc/systemd/system/tomcat.service
[Unit]
Description=Tomcat
After=network.target

[Service]
User=tomcat
Group=tomcat
WorkingDirectory=/usr/local/tomcat
Environment=JAVA_HOME=/usr/lib/jvm/java-${JAVA_VERSION}-openjdk
Environment=CATALINA_HOME=/usr/local/tomcat
Environment=CATALINA_BASE=/usr/local/tomcat
ExecStart=/usr/local/tomcat/bin/catalina.sh run
ExecStop=/usr/local/tomcat/bin/shutdown.sh
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOT

# Reload systemd and start Tomcat service
systemctl daemon-reload
systemctl enable --now tomcat

# Clone and build the Java application
cd /tmp/
git clone -b main https://github.com/Ankit8848/devops.git
cd devops
mvn install

# Deploy the application to Tomcat
systemctl stop tomcat
sleep 20
rm -rf /usr/local/tomcat/webapps/ROOT*
cp target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war
systemctl start tomcat
sleep 20

# Disable firewall temporarily for testing purposes
systemctl stop firewalld
systemctl disable firewalld

# Restart Tomcat to apply changes
systemctl restart tomcat
