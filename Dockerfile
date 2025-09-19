FROM jenkins/jenkins:lts

USER root

RUN apt-get update && apt-get install -y docker.io
RUN adduser jenkins docker
