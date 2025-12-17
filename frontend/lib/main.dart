import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Países',
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();

  Map<String, dynamic>? pais;
  String? error;
  bool cargando = false;

  Future<void> buscarPais() async {
    setState(() {
      cargando = true;
      error = null;
      pais = null;
    });

    final nombre = _controller.text.trim();

    if (nombre.isEmpty) {
      setState(() {
        cargando = false;
        error = 'Ingrese un país';
      });
      return;
    }

    try {
      final url = Uri.parse(
  'https://proyecto-paises.onrender.com/pais/$nombre',
);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          pais = jsonDecode(response.body);
        });
      } else {
        setState(() {
          error = 'País no encontrado';
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error al conectar con la API';
      });
    } finally {
      setState(() {
        cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Información de Países'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ingrese el nombre del país (en inglés):',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Ejemplo: Guatemala',
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: cargando ? null : buscarPais,
              child: const Text('Buscar'),
            ),
            const SizedBox(height: 30),

            if (cargando) const CircularProgressIndicator(),

            if (error != null)
              Text(
                error!,
                style: const TextStyle(color: Colors.red),
              ),

            if (pais != null) ...[
              Text('Nombre: ${pais!['nombre']}'),
              Text('Capital: ${pais!['capital']}'),
              Text('Región: ${pais!['region']}'),
              Text('Población: ${pais!['poblacion']}'),
              const SizedBox(height: 10),
              Image.network(
                pais!['bandera'],
                width: 150,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
