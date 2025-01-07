# Gunakan image dasar OpenJDK 17
FROM openjdk:17-jdk-slim

# Tetapkan direktori kerja di dalam container
WORKDIR /app

# Salin semua file dari host ke container
COPY . .

# Pastikan file gradlew memiliki izin eksekusi
RUN chmod +x gradlew || true

# Instal dependensi tambahan yang diperlukan
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    && apt-get clean

# Unduh dan instal Android SDK Command-line Tools
RUN mkdir -p /usr/local/android-sdk && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -O /tmp/cmdline-tools.zip && \
    unzip -q /tmp/cmdline-tools.zip -d /usr/local/android-sdk && \
    mv /usr/local/android-sdk/cmdline-tools /usr/local/android-sdk/tools && \
    rm /tmp/cmdline-tools.zip

# Atur variabel lingkungan untuk Android SDK
ENV ANDROID_HOME=/usr/local/android-sdk
ENV PATH="$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$PATH"

# Terima semua lisensi Android SDK
RUN yes | sdkmanager --licenses

# Instal komponen Android SDK yang diperlukan
RUN sdkmanager \
    "platform-tools" \
    "platforms;android-33" \
    "build-tools;33.0.2"

# Tetapkan entrypoint default untuk menjalankan Gradle
ENTRYPOINT ["./gradlew"]
