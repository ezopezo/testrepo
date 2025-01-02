FROM registry.access.redhat.com/ubi8/ubi:latest

RUN dnf install -y nginx

RUN pip3 install tensorflow

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
