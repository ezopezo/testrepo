FROM registry.access.redhat.com/ubi8/ubi:latest

RUN dnf install -y nginx

RUN dnf install python3-pip -y

RUN pip3 install black

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
