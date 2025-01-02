FROM openjdk:17-jdk-slim

# Copy gradlew file
COPY gradlew ./
COPY gradlew.bat ./
COPY settings.gradle ./

# Ensure gradlew is executable
RUN chmod +x ./gradlew

# Build the application
RUN ./gradlew build
