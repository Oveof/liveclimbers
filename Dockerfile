# Stage 1: Build the Rust application
FROM rust:latest AS builder

WORKDIR /app

# Cache dependencies
COPY Cargo.toml Cargo.lock ./
RUN mkdir src && echo "fn main() {}" > src/main.rs
RUN cargo build --release && rm -rf src

# Copy the source code and build
COPY . .
RUN cargo build --release

# Stage 2: Run the Rust application in a minimal environment
FROM debian:bullseye-slim

WORKDIR /app

# Copy the compiled binary from builder stage
COPY --from=builder /app/target/release/liveclimbers /app/liveclimbers

# Set executable permission
RUN chmod +x /app/liveclimbers

# Define the startup command
CMD ["/app/liveclimbers"]

