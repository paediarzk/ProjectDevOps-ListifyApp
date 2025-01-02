# Dockerfile
FROM openjdk:17-jdk-slim

# Mengatur variabel lingkungan untuk Android SDK
ENV ANDROID_HOME=/root/Android/Sdk
ENV PATH=${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${PATH}

# Menginstal dependensi yang diperlukan
RUN apt-get update --fix-missing && \
    apt-get install -y wget unzip && \
    apt-get clean

# Menyalin semua file proyek ke dalam image
COPY . /app
WORKDIR /app

# Memastikan gradlew dapat dieksekusi dan menjalankan build
RUN chmod +x ./gradlew && ./gradlew build
