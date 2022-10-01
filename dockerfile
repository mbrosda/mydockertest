# example taken from here: https://typeofnan.dev/how-to-serve-a-static-app-with-nginx-in-docker/
# kleine Änderung

# nginx state for serving content
FROM nginx:alpine

# # Set working directory to nginx asset directory
# WORKDIR /usr/share/nginx/html
# # Remove default nginx static assets
# RUN rm -rf ./*
# # Copy static assets over
# COPY ./* ./

# Containers run nginx with global directives and daemon off
ENTRYPOINT ["nginx", "-g", "daemon off;"]
