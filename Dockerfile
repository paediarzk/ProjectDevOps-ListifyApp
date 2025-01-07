# Base image with OpenJDK (required for Gradle and Android builds)
FROM openjdk:11-jdk-slim

# Set the working directory inside the container
WORKDIR /app

# Copy all files from the current directory to the container
COPY . .

# Grant execute permissions to the Gradle wrapper
RUN chmod +x gradlew

# Install additional dependencies
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    && apt-get clean

# Download and set up Android SDK Command-line Tools
RUN mkdir -p /usr/local/android-sdk && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -O /tmp/cmdline-tools.zip && \
    unzip -q /tmp/cmdline-tools.zip -d /usr/local/android-sdk && \
    mv /usr/local/android-sdk/cmdline-tools /usr/local/android-sdk/tools && \
    rm /tmp/cmdline-tools.zip

# Set environment variables for Android SDK
ENV ANDROID_HOME=/usr/local/android-sdk
ENV PATH="$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$PATH"

# Accept Android SDK licenses
RUN yes | sdkmanager --licenses

# Install required SDK components (modify as needed)
RUN sdkmanager \
    "platform-tools" \
    "platforms;android-33" \
    "build-tools;33.0.2"

# Default entry point for Gradle commands
ENTRYPOINT ["./gradlew"]
