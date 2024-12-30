# dev.sh
docker build . \
    --build-arg ENVIRONMENT=dev  \
    --build-arg USERNAME=u  \
    --build-arg PASSWORD=p  \
    -t personal-hymns-dev && \
docker run -it -p 8080:80 personal-hymns-dev

docker run -it --entrypoint /bin/sh -p 8080:80 personal-hymns

# prod.sh
docker build --build-arg ENVIRONMENT=prod -t personal-hymns-prod . && \
docker run -p 80:80 -p 443:443 \
    -e ENVIRONMENT=prod \
    -e USERNAME="user" \
    -e PASSWORD="your_secure_password" \
    -e EMAIL="your@email.com" \
    -e DOMAIN="yourdomain.com" \
    -v letsencrypt:/etc/letsencrypt \
    personal-hymns-prod