# Base image
FROM ubuntu

# Set non-interactive mode
ENV DEBIAN_FRONTEND=noninteractive

# Expose port 80
EXPOSE 80

# Install Apache, PHP, and other required packages
RUN apt-get update -y
RUN apt-get install -y apache2 php libapache2-mod-php inetutils-ping

# Start Apache and PHP
CMD ["apache2ctl", "-D", "FOREGROUND"]
