FROM openjdk:22-jdk-slim
ENV ANDROID_HOME /root/Android/Sdk
ENV PATH $ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$PATH
WORKDIR /app

# Copy repository files
COPY . .

# Install dependencies
RUN apt-get update && apt-get install -y openjdk-22-jdk && \
    apt-get install -y gradle && \
    apt-get install -y unzip && \
    yes | sdkmanager --licenses && \
    sdkmanager "platforms;android-30" "build-tools;30.0.3"

# Build the Android project
CMD ./gradlew assembleDebug
