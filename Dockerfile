# use image base Android
FROM openjdk:11-jdk

# Set working directory
WORKDIR /app

# copy all project file to container 
COPY . .

# Instal Gradle wrapper & build app
RUN ./gradlew assembleDebug

# Command default (opsional)
CMD ["./gradlew", "installDebug"]