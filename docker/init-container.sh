#!/bin/sh

# Default values
DEFAULT_PASSWORD="defaultpassword"
DOMAIN="p.hymnsinger.com"

# Environment-specific setup
if [ "$ENVIRONMENT" = "prod" ]; then
    echo "Setting up production environment..."
    
    # Create password file with provided or default password
    htpasswd -cb /usr/local/apache2/conf/.htpasswd user "${PASSWORD:-$DEFAULT_PASSWORD}"
    
    # Get Let's Encrypt certificate
    if [ ! -f /etc/letsencrypt/live/$DOMAIN/fullchain.pem ]; then
        certbot certonly --standalone \
            --agree-tos \
            --non-interactive \
            --domain $DOMAIN \
            --email "${EMAIL:-admin@example.com}" \
            --preferred-challenges http
    fi
    
    # Use Let's Encrypt certificate paths
    sed -i "s|SSLCertificateFile.*|SSLCertificateFile /etc/letsencrypt/live/$DOMAIN/fullchain.pem|g" /usr/local/apache2/conf/httpd.conf
    sed -i "s|SSLCertificateKeyFile.*|SSLCertificateKeyFile /etc/letsencrypt/live/$DOMAIN/privkey.pem|g" /usr/local/apache2/conf/httpd.conf

else
    echo "Setting up development environment..."
    
    # Create self-signed certificate for development
    if [ ! -f /usr/local/apache2/conf/server.crt ]; then
        openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
            -keyout /usr/local/apache2/conf/server.key \
            -out /usr/local/apache2/conf/server.crt \
            -subj "/CN=localhost"
    fi
    
    # Use self-signed certificate paths
    sed -i "s|SSLCertificateFile.*|SSLCertificateFile /usr/local/apache2/conf/server.crt|g" /usr/local/apache2/conf/httpd.conf
    sed -i "s|SSLCertificateKeyFile.*|SSLCertificateKeyFile /usr/local/apache2/conf/server.key|g" /usr/local/apache2/conf/httpd.conf
    
    # Create password file with default password for development
    htpasswd -cb /usr/local/apache2/conf/.htpasswd user "devpassword"
    
    # Replace domain name with localhost
    sed -i "s|ServerName.*|ServerName localhost|g" /usr/local/apache2/conf/httpd.conf
fi

# Start Apache
httpd-foreground
