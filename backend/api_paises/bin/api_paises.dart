import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:http/http.dart' as http;

void main() async {
  final app = Router();

  
  app.get('/pais/<nombre>', (Request request, String nombre) async {
    final url = Uri.parse(
        'https://restcountries.com/v3.1/name/$nombre?fullText=true');

    final response = await http.get(url);

    if (response.statusCode != 200) {
      return Response.notFound(
        jsonEncode({'error': 'País no encontrado'}),
        headers: {'Content-Type': 'application/json'},
      );
    }

    final data = jsonDecode(response.body);
    final pais = data[0];

    final resultado = {
      'nombre': pais['name']['common'],
      'capital': pais['capital']?[0] ?? 'No disponible',
      'region': pais['region'],
      'poblacion': pais['population'],
      'bandera': pais['flags']['png'],
    };

    return Response.ok(
      jsonEncode(resultado),
      headers: {'Content-Type': 'application/json'},
    );
  });

  
  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(_corsHeaders())
      .addHandler(app);

  final server = await serve(handler, '0.0.0.0', 8080);
  print('Servidor corriendo en http://${server.address.host}:${server.port}');
}

Middleware _corsHeaders() {
  return (Handler handler) {
    return (Request request) async {
      if (request.method == 'OPTIONS') {
        return Response.ok(
          '',
          headers: {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
            'Access-Control-Allow-Headers': 'Content-Type',
          },
        );
      }

      final response = await handler(request);
      return response.change(headers: {
        'Access-Control-Allow-Origin': '*',
      });
    };
  };
}
