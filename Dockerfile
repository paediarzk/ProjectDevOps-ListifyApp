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

# Create non-root user
RUN useradd -m -s /bin/bash gradle && \
    mkdir -p ${ANDROID_HOME} && \
    chown -R gradle:gradle ${ANDROID_HOME}

# Switch to non-root user
USER gradle

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
ENV GRADLE_USER_HOME=/home/gradle/.gradle
RUN mkdir -p ${GRADLE_USER_HOME} && \
    chmod 755 ${GRADLE_USER_HOME}

# Add a script to handle gradle commands
RUN echo '#!/bin/bash\n\
if [ -f "./gradlew" ]; then\n\
    cp -f ./gradlew ./gradlew.original\n\
    dos2unix ./gradlew\n\
    chmod +x ./gradlew\n\
    ./gradlew "$@"\n\
    EXIT_CODE=$?\n\
    mv -f ./gradlew.original ./gradlew\n\
    exit $EXIT_CODE\n\
else\n\
    echo "gradlew not found"\n\
    exit 1\n\
fi' > /home/gradle/run-gradle.sh && \
    chmod +x /home/gradle/run-gradle.sh

ENTRYPOINT ["/home/gradle/run-gradle.sh"]
CMD ["assembleDebug"]