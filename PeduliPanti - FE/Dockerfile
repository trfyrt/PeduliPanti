# Tahap 1: Build Flutter Web menggunakan image resmi Flutter
FROM ghcr.io/cirruslabs/flutter:3.24.3 AS build
WORKDIR /app
COPY . .
# Jalankan perintah build ke web
RUN flutter pub get
RUN flutter build web -v 

# Tahap 2: Pindahkan hasil build ke web server Nginx yang ringan
FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html
EXPOSE 80