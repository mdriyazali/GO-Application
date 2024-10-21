# Stage 1: Build the Go app
FROM golang:1.17-alpine AS builder

# Set the working directory
WORKDIR /app

# Copy the go.mod file
COPY go.mod ./

# Download the Go module dependencies
RUN go mod download

# Copy the rest of your application files
COPY . .

# Build the Go application
RUN go build -o myapp .

# Stage 2: Create a minimal Docker image
FROM alpine:latest

# Set the working directory
WORKDIR /root/

# Copy the binary from the builder stage
COPY --from=builder /app/myapp .

# Command to run the executable
CMD ["./myapp"]
