#-----------------------------------------------------------------------------------------------
# configure application
# for details see https://typeofnan.dev/how-to-serve-a-static-app-with-nginx-in-docker/
#-----------------------------------------------------------------------------------------------

# nginx state for serving content
FROM nginx:alpine

# Set working directory to nginx asset directory
WORKDIR /usr/share/nginx/html
# Remove default nginx static assets
RUN rm -rf ./*
# Copy static assets over
COPY ./static-site-nginx/* ./

#-----------------------------------------------------------------------------------------------
# configure ssh
# for details see https://learn.microsoft.com/en-us/azure/app-service/configure-custom-container
#-----------------------------------------------------------------------------------------------

# Install OpenSSH and set the password for root to "Docker!". In this example, "apk add" is the install instruction for an Alpine Linux-based image.
RUN apk add openssh && echo "root:Docker!" | chpasswd

# Copy the sshd_config file to the /etc/ssh/ directory
COPY ssh/sshd_config /etc/ssh/

# Copy and configure the ssh_setup file
RUN mkdir -p /tmp
COPY ssh/ssh_setup.sh /tmp
RUN chmod +x /tmp/ssh_setup.sh && (sleep 1;/tmp/ssh_setup.sh 2>&1 > /dev/null)

#-----------------------------------------------------------------------------------------------
# add startscript for sshd and nginx
#-----------------------------------------------------------------------------------------------
COPY startup.sh /startup.sh
RUN chmod +x /startup.sh

# # Containers run nginx with global directives and daemon off
# ENTRYPOINT ["nginx", "-g", "daemon off;"]

ENTRYPOINT ["/startup.sh"]

#-----------------------------------------------------------------------------------------------
# expose web and ssh ports
#-----------------------------------------------------------------------------------------------

# Open port 2222 for SSH access
EXPOSE 80 2222
