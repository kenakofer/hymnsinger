# Build arguments for configuration
ARG ENVIRONMENT=dev
arg USERNAME=user
ARG PASSWORD=overrideme
ARG DOMAIN=localhost
ARG EMAIL=your@email.com

FROM ruby:3.2-bullseye as builder

# Install essential build tools
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    apache2-utils \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /docs

# Copy Gemfile first and install
COPY ./docs/Gemfile ./docs/Gemfile.lock ./
RUN bundle install

# Now copy the rest of the docs
COPY ./docs/ ./

# Build the html files with explicit theme
RUN bundle exec jekyll build --trace

# Final image
FROM httpd:2.4-alpine

# Build arguments in final stage
ARG ENVIRONMENT
ENV ENVIRONMENT=${ENVIRONMENT}
ARG USERNAME
ENV USERNAME=${USERNAME}
ARG PASSWORD
ENV PASSWORD=${PASSWORD}
ARG DOMAIN
ENV DOMAIN=${DOMAIN}
ARG EMAIL
ENV EMAIL=${EMAIL}

# Install additional tools only in production
RUN if [ "$ENVIRONMENT" = "prod" ]; then \
        apk add --no-cache certbot certbot-apache python3 apache2-utils; \
    else \
        apk add --no-cache apache2-utils openssl; \
    fi

# Copy configs and scripts
COPY apache-config.conf /usr/local/apache2/conf/httpd.conf
COPY init-container.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/init-container.sh

# Copy the built site
COPY --from=builder /docs/_site/ /usr/local/apache2/htdocs/

# Create required directories for SSL
RUN mkdir -p /etc/letsencrypt /var/lib/letsencrypt /var/log/letsencrypt

# Expose ports
EXPOSE 80 443

# Start script handles environment-specific setup
CMD ["/usr/local/bin/init-container.sh"]