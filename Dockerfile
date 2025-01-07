# Base image with OpenJDK
FROM openjdk:11-jdk-slim

# Set working directory in container
WORKDIR /app

# Copy all files to container
COPY . .

# Grant execute permissions to gradlew
RUN chmod +x gradlew

# Default entry point for Gradle commands
ENTRYPOINT ["./gradlew"]
