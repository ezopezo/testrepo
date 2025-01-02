FROM registry.access.redhat.com/ubi8/ubi:latest

RUN dnf install -y nginx

RUN pip install tensorflow

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
