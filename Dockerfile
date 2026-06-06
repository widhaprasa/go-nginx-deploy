# Step 1: Build the Go app
FROM golang:1.26.4-trixie as builder

WORKDIR /app
COPY . .

# Build the Go app
RUN go build -o app .

# Step 2: Create the image with Nginx and the Go binary
FROM nginx:1.31.1-trixie

# Install supervisor to run multiple processes
RUN apt-get update && \
    apt-get install -y --no-install-recommends supervisor && \
    rm -rf /var/lib/apt/lists/*

# Copy the supervisor configuration
ADD supervisord.conf /etc/

# Copy the compiled Go app from the builder image
COPY --from=builder /app/app /usr/local/bin/

# Expose Nginx default port (80)
EXPOSE 80

# Expose App service port (8080)
EXPOSE 8080

# Command to run using supervisor
ENTRYPOINT ["supervisord", "-n", "-c", "/etc/supervisord.conf"]
