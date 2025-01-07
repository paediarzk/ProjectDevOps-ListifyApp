FROM eclipse-temurin:17-jdk

# Install required packages
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    gradle \
    dos2unix

# Install Android SDK
ENV ANDROID_HOME=/opt/android-sdk \
    ANDROID_SDK_URL=https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip

# Download and setup Android SDK
RUN mkdir -p ${ANDROID_HOME}/cmdline-tools && \
    cd ${ANDROID_HOME}/cmdline-tools && \
    curl -sSL ${ANDROID_SDK_URL} -o android_tools.zip && \
    unzip android_tools.zip && \
    mv cmdline-tools latest && \
    rm android_tools.zip

# Set PATH
ENV PATH=${PATH}:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools

# Accept licenses
RUN yes | sdkmanager --licenses

# Install required Android packages
RUN sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"

WORKDIR /app

# Setup Gradle directories with proper permissions
RUN mkdir -p /root/.gradle && \
    chmod -R 777 /root/.gradle && \
    mkdir -p /.gradle && \
    chmod -R 777 /.gradle

# Create a directory for the gradlew script
RUN mkdir -p /scripts && \
    chmod -R 777 /scripts

# Copy gradlew to a temporary location and fix permissions
COPY gradlew /scripts/
RUN dos2unix /scripts/gradlew && \
    chmod +x /scripts/gradlew

ENTRYPOINT ["/bin/bash", "-c"]
CMD ["cp /scripts/gradlew . && ./gradlew assembleDebug"]