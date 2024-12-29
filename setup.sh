# dev.sh
docker build --build-arg ENVIRONMENT=dev -t jekyll-site . && \
docker run -it -p 8080:80 jekyll-site

docker run -it --entrypoint /bin/sh -p 8080:80 jekyll-site

# prod.sh
docker build --build-arg ENVIRONMENT=prod -t jekyll-site . && \
docker run -p 80:80 -p 443:443 \
    -e ENVIRONMENT=prod \
    -e PASSWORD="your_secure_password" \
    -e EMAIL="your@email.com" \
    -v letsencrypt:/etc/letsencrypt \
    jekyll-site