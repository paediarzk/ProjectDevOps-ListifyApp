# Menggunakan image dasar OpenJDK 17
FROM openjdk:17-jdk-slim

# Mengatur direktori kerja di dalam container
WORKDIR /app

# Menyalin semua file proyek ke dalam image
COPY . .

# Memberikan izin eksekusi untuk Gradle Wrapper
RUN chmod +x gradlew

# Menjalankan perintah build aplikasi
<<<<<<< HEAD
CMD ["./gradlew", "assembleDebug"]
=======
CMD ["./gradlew", "assembleDebug"]
>>>>>>> eee3dad4559d63ce546ef3bc6511d5ed29e4c836
