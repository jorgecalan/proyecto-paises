# Imagen oficial de Dart
FROM dart:stable

# Directorio de trabajo dentro del contenedor
WORKDIR /app

# Copiamos SOLO el pubspec
COPY pubspec.yaml .

# Instalamos dependencias
RUN dart pub get

# Copiamos el resto del proyecto
COPY . .

# Exponemos el puerto
EXPOSE 8080

# Ejecutamos la API
CMD ["dart", "run", "bin/api_paises.dart"]
