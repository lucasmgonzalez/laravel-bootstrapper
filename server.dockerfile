
FROM nginx:latest

# Nginx Custom config
# ADD deploy/nginx/nginx.conf /etc/nginx/ 

# Nginx virtual host config
ADD ./deploy/nginx/default.conf /etc/nginx/conf.d/

# Static files config
ADD public /usr/share/nginx/html

WORKDIR /usr/share/nginx/html
