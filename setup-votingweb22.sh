#!/bin/sh

# Install required packages
wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
wget -q http://mirrors.kernel.org/ubuntu/pool/main/i/icu/libicu60_60.2-3ubuntu3_amd64.deb
wget -q http://mirrors.kernel.org/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2.23_amd64.deb
wget -q http://mirrors.kernel.org/ubuntu/pool/main/u/ust/liblttng-ust0_2.11.0-1_amd64.deb
wget -q http://mirrors.kernel.org/ubuntu/pool/main/libu/liburcu/liburcu6_0.11.1-2_amd64.deb
wget -q http://mirrors.kernel.org/ubuntu/pool/main/u/ust/liblttng-ust-ctl4_2.11.0-1_amd64.deb
dpkg -i packages-microsoft-prod.deb
dpkg -i libicu60_60.2-3ubuntu3_amd64.deb
dpkg -i  liburcu6_0.11.1-2_amd64.deb 
dpkg -i  liblttng-ust-ctl4_2.11.0-1_amd64.deb
dpkg -i liblttng-ust0_2.11.0-1_amd64.deb
dpkg -i libssl1.1_1.1.1f-1ubuntu2.23_amd64.deb
add-apt-repository universe
apt-get -y install apt-transport-https
apt-get -y update
apt-get -y install apache2 dotnet-sdk-2.2 unzip

# Copy site to /var/www/votingweb
unzip -d /var/www/votingweb votingweb.zip
chown -hR www-data:www-data /var/www/votingweb

# Enable required Apache modules
a2enmod headers
a2enmod proxy_html
a2enmod proxy_http
a2enmod ssl

# Disable default Apache site
a2dissite 000-default

# Setup VotingWeb Apache site
cp votingweb.conf /etc/apache2/sites-available
cp votingweb-ssl.conf /etc/apache2/sites-available
a2ensite votingweb
a2ensite votingweb-ssl

# Setup VotingWeb as a service
cp votingweb.service /etc/systemd/system
systemctl enable votingweb.service
systemctl start votingweb.service

# Restart Apache
systemctl restart apache2