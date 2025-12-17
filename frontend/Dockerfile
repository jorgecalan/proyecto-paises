# Etapa 1: Build Flutter Web (Flutter moderno)
FROM ghcr.io/cirruslabs/flutter:3.22.0 AS build

WORKDIR /app

# Copiamos solo pubspec primero
COPY pubspec.yaml .
COPY pubspec.lock .

RUN flutter pub get

# Copiamos el resto del proyecto
COPY . .

# Construimos Flutter Web
RUN flutter build web

# Etapa 2: Servidor web Nginx
FROM nginx:alpine

COPY nginx/default.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/build/web /usr/share/nginx/html

EXPOSE 80

