# Menggunakan image openjdk 17
FROM openjdk:17-jdk-slim

# Mengatur variabel lingkungan untuk Android SDK
ENV ANDROID_HOME=/root/Android/Sdk
ENV PATH=${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${PATH}

# Mengatur direktori kerja
WORKDIR /app

# Menginstal dependensi yang diperlukan dan dos2unix untuk memperbaiki masalah line endings
RUN apt-get update --fix-missing && \
    apt-get install -y wget unzip dos2unix && \
    apt-get clean


# Mengunduh dan menginstal Android SDK Command Line Tools
RUN mkdir -p ${ANDROID_HOME}/cmdline-tools && \
    cd ${ANDROID_HOME}/cmdline-tools && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-7583922_latest.zip && \
    unzip commandlinetools-linux-7583922_latest.zip && \
    rm commandlinetools-linux-7583922_latest.zip && \
    mv cmdline-tools latest

# Menjalankan sdkmanager untuk menginstal platform dan build-tools
RUN yes | ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager --sdk_root=${ANDROID_HOME} --licenses && \
    ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager --sdk_root=${ANDROID_HOME} "platforms;android-30" "build-tools;30.0.3"

# Membangun aplikasi
RUN ./gradlew build
