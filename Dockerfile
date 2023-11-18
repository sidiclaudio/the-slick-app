# Base image
FROM centos:7

# Description
LABEL description="Dockerfile to containerize the slick app"

# Update all packages
RUN yum -y update

# Install apache
RUN yum install -y httpd

# Copy web app from local to the container 
COPY ./webapp/ /var/www/html

# Port on which the app should listen on
EXPOSE 80

# systemctl start httpd
ENTRYPOINT [ "/usr/sbin/httpd" ] 

# Run the container in the background (no exit)
CMD [ "-D", "FOREGROUND" ]

