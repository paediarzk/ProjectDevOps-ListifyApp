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
RUN mkdir -p ${ANDROID_HOME}/cmdline-tools && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -O /tmp/cmdline-tools.zip && \
    unzip /tmp/cmdline-tools.zip -d ${ANDROID_HOME}/cmdline-tools && \
    mkdir -p ${ANDROID_HOME}/cmdline-tools/latest && \
    mv ${ANDROID_HOME}/cmdline-tools/cmdline-tools/* ${ANDROID_HOME}/cmdline-tools/latest && \
    rm /tmp/cmdline-tools.zip

# Menambah sdkmanager ke path
ENV PATH=${ANDROID_HOME}/cmdline-tools/latest/bin:${PATH}

# Accept licenses
RUN yes | sdkmanager --licenses

# Install required Android packages
RUN sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"

# Menyiapkan direktori Gradle untuk cache
RUN mkdir -p /root/.gradle && chmod -R 777 /root/.gradle

# Menyalin semua file aplikasi ke dalam direktori kerja
COPY . .

# Mengonversi semua skrip shell agar sesuai dengan format Unix (LF)
RUN find . -type f -name "*.sh" -exec dos2unix {} \; && \
    dos2unix gradlew gradlew.bat

# Memastikan gradlew dapat dieksekusi
RUN chmod +x gradlew

# Menjalankan perintah build Gradle untuk membangun APK
CMD ["./gradlew", "assembleDebug", "--info", "--stacktrace"]
