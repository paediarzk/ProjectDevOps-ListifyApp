# Menggunakan image openjdk 17
FROM openjdk:17-jdk-slim

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    unzip \
    gradle \
    dos2unix

# Mengatur variabel lingkungan untuk Android SDK
ENV ANDROID_HOME=/root/Android/Sdk
ENV PATH=${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${PATH}

# Mengatur direktori kerja
WORKDIR /app

# Mengunduh dan menginstal Android SDK Command Line Tools
RUN mkdir -p ${ANDROID_HOME}/cmdline-tools/latest && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-7583922_latest.zip -O /tmp/cmdline-tools.zip && \
    unzip /tmp/cmdline-tools.zip -d ${ANDROID_HOME}/cmdline-tools/latest && \
    rm /tmp/cmdline-tools.zip

# Accept licenses
RUN yes | sdkmanager --licenses

# Install required Android packages
RUN sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"

# Menyiapkan direktori Gradle untuk cache
RUN mkdir -p /root/.gradle && chmod -R 777 /root/.gradle

# Menyalin semua file aplikasi ke dalam direktori kerja
COPY . .

# Memastikan gradlew dapat dieksekusi
RUN chmod +x gradlew

# Menjalankan perintah build Gradle untuk membangun APK
CMD ./gradlew assembleDebug --info --stacktrace
