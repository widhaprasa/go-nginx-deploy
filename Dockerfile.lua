# Step 1: Build the Go app
FROM golang:1.25.1-alpine3.22 as builder

WORKDIR /app
COPY . .

# Build the Go app
RUN go build -o app .

# Step 2: Create the image with Nginx and the Go binary
FROM fabiocicerchia/nginx-lua:1.28.0-alpine3.22.1

# Install supervisor to run multiple processes
RUN apk add --no-cache supervisor

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
