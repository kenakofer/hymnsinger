#!/bin/sh
    
# Replace domain name with localhost
sed -i "s|ServerName.*|ServerName $DOMAIN|g" /usr/local/apache2/conf/httpd.conf
echo "${DOMAIN}" > /docs/CNAME

# Replace email in apache config
sed -i "s|ServerAdmin.*|ServerAdmin $EMAIL|g" /usr/local/apache2/conf/httpd.conf
    
# Create password file 
htpasswd -cb /usr/local/apache2/conf/.htpasswd ${USERNAME} ${PASSWORD}

# Environment-specific setup
if [ "$ENVIRONMENT" = "prod" ]; then
    echo "Setting up production environment..."
    
    # Get Let's Encrypt certificate
    if [ ! -f /etc/letsencrypt/live/$DOMAIN/fullchain.pem ]; then
        certbot certonly --standalone \
            --agree-tos \
            --non-interactive \
            --domain $DOMAIN \
            --email "${EMAIL}" \
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
fi

# Start Apache
httpd-foreground
