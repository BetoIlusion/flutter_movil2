import 'package:flutter_movil2/exports.dart';

class EjercicioReporte extends StatefulWidget {
  final String token;

  EjercicioReporte({required this.token});

  @override
  _EjercicioReporteState createState() => _EjercicioReporteState();
}

String _setTitulo() {
  return "";
}

String _setContenido() {
  // Obtener el singleton
  EjercicioSingleton manager = EjercicioSingleton.instance;

  // Construir una lista con los tipos de todos los ejercicios
  String contenido = "";
  for (int i = 0; i < manager.getEjercicios().length; i++) {
    EjercicioModel? ejercicio = manager.getEjercicio(i);
    if (ejercicio != null) {
      contenido += 'Tipo del ejercicio ${i + 1}: ${ejercicio.getTipo}\n';
    }
  }

  // Verificar si la lista está vacía
  if (contenido.isEmpty) {
    contenido = "No hay ejercicios registrados.";
  }

  // Retornar el contenido concatenado
  return contenido;
}


String _setButton() {
  return "";
}

class _EjercicioReporteState extends State<EjercicioReporte> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ejercicio Reporte'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _setTitulo(),
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              _setContenido(),
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                _setButton();
              },
              child: Text('Finalizar'),
            ),
          ],
        ),
      ),
    );
  }
}
