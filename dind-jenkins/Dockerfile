FROM jenkins/jenkins:lts-alpine

# Change user to root in order to have permissions to install packages.
USER root

# Only Docker client is required inside the Jenkins container as the host systems Docker engine is used from inside the container.
RUN apk add docker-cli

# Note that the user is not switched back to jenkins here. This is to avoid problems with docker socket permissions.
# Do not use root user in production. Instead, match group IDs of docker groups in host and container and add jenkins user to docker group.