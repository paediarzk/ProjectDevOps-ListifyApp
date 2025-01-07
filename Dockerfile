# Menggunakan image openjdk 17
FROM openjdk:17-jdk-slim

# Install required packages
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    gradle

# Mengatur variabel lingkungan untuk Android SDK
ENV ANDROID_HOME=/root/Android/Sdk
ENV PATH=${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${PATH}

# Mengatur direktori kerja
WORKDIR /app

# Menginstal dependensi yang diperlukan, termasuk dos2unix
RUN apt-get update --fix-missing && \
    apt-get install -y wget unzip dos2unix && \
    apt-get clean



# Mengunduh dan menginstal Android SDK Command Line Tools
RUN mkdir -p ${ANDROID_HOME}/cmdline-tools && \
    cd ${ANDROID_HOME}/cmdline-tools && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-7583922_latest.zip 
    curl -sSL ${ANDROID_SDK_URL} -o android_tools.zip && \
    unzip android_tools.zip && \
    mv cmdline-tools latest && \
    rm android_tools.zip

# Accept licenses
RUN yes | sdkmanager --licenses

# Install required Android packages
RUN sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"

RUN mkdir -p /root/.gradle && \
    chmod -R 777 /root/.gradle

# Make gradlew executable
RUN mkdir -p .gradle && \
    chmod -R 777 .gradle

# Memastikan gradlew dapat dieksekusi
RUN chmod +x gradlew || true

# Menjalankan gradlew untuk membangun aplikasi
RUN ./gradlew build
