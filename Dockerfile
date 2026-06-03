FROM public.ecr.aws/docker/library/nginx:1.27-alpine

# Copy the nginx configuration file to the container
COPY ./config/nginx.conf /etc/nginx/nginx.conf
RUN mkdir /etc/nginx/conf/
COPY ./config/mime.types /etc/nginx/conf/mime.types
COPY ./config/fastcgi.conf /etc/nginx/fastcgi.conf
COPY ./config/proxy.conf /etc/nginx/proxy.conf

# Copy the production-ready static site assets
COPY ./src/ /usr/share/nginx/html/

# Expose port 80
EXPOSE 80

# Start nginx in container
CMD ["nginx", "-g", "daemon off;"]
