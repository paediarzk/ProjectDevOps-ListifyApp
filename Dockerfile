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

# Create and set permissions for Gradle directories
RUN mkdir -p /root/.gradle && \
    chmod -R 777 /root/.gradle && \
    mkdir -p .gradle && \
    chmod -R 777 .gradle

# Copy the entire project
COPY . .

# Convert Windows line endings to Unix
RUN dos2unix gradlew

# Make gradlew executable
RUN chmod +x gradlew

CMD ["./gradlew", "assembleDebug"]