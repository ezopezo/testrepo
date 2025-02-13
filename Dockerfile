# Step 1: First base image - UBI8 - builder
FROM registry.access.redhat.com/ubi8/ubi:latest AS base1

# irrelevant file - not binary
RUN echo "Hello from UBI8!" > /opt/ubi8_file.txt

# expected to be in final SBOM because binary is copied later
RUN dnf install -y nginx

# noit included in final SBOM - not copied
RUN dnf install -y npm

# Step 2: Second base image - Golang - builder2
FROM docker.io/library/golang:1.21-bullseye AS base2

# expected to be in final SBOM because binary is copied later
WORKDIR /app
RUN echo 'package main; import "fmt"; func main() { fmt.Println("Hello from Go!") }' > main.go && \
  go build -o hello main.go

# Step 4: Final image
FROM registry.access.redhat.com/ubi9/ubi:latest

# expected to be in SBOM
RUN dnf install python3-pip -y
RUN pip3 install semver==2.13.0

# Copy files from UBI8 base (including the generated file)
COPY --from=base1 /opt/ubi8_file.txt /usr/share/nginx/html/ubi8_file.txt
COPY --from=base1 /etc/nginx /etc/nginx
COPY --from=base1 /usr/sbin/nginx /usr/sbin/nginx

# copy something from external image
COPY --from=quay.io/centos/centos:stream9 /usr/bin/yum /usr/bin/yum

# Copy the Go binary from base2
COPY --from=base2 /app/hello /usr/local/bin/hello

# Expose port 80 for Nginx
EXPOSE 80

# Default command to run both Nginx and the Go binary
CMD ["sh", "-c", "hello & nginx -g 'daemon off;'"]
