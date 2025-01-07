# Menggunakan image openjdk 17
FROM openjdk:17-jdk-slim

# Install required packages
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    gradle \
    dos2unix

# Mengatur variabel lingkungan untuk Android SDK
ENV ANDROID_HOME=/root/Android/Sdk
    ANDROID_SDK_URL=https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip


# Mengunduh dan menginstal Android SDK Command Line Tools
RUN mkdir -p ${ANDROID_HOME}/cmdline-tools && \
    cd ${ANDROID_HOME}/cmdline-tools && \
    curl -sSL ${ANDROID_SDK_URL} -o android_tools.zip && \
    unzip android_tools.zip && \
    mv cmdline-tools latest && \
    rm android_tools.zip

ENV PATH=${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${PATH}

# Accept licenses
RUN yes | sdkmanager --licenses

# Install required Android packages
RUN sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"

# Mengatur direktori kerja
WORKDIR /app

# Menyiapkan direktori gradle
RUN mkdir -p /root/.gradle && \
    chmod -R 777 /root/.gradle

# Memastikan gradlew dapat dieksekusi
RUN chmod +x gradlew || true

# Menjalankan gradlew untuk membangun aplikasi
RUN ./gradlew build
