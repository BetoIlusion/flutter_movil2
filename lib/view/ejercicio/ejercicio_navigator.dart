import 'package:flutter_movil2/exports.dart';

class EjercicioNavigator {
  late final String token;
  late final int leccId;
  late int progreso;

  final ApiService _api = ApiService();
  dynamic _ejercicio = [];
  int cantEjercicio = 0;

  EjercicioNavigator({
    required this.token,
    required this.leccId,
    required this.progreso,
  });

  Future<void> _fetch() async {
    print("fetching");
    print("token: ${token}");
    print("leccion_id: ${leccId}");
    try {
      final data = await _api.getEjerciciosXLeccion(token, leccId);
      if (data.isNotEmpty) {
        cantEjercicio = data.length;
        if (progreso > cantEjercicio) {
          
        }
        print("cantidad de ejercicio${cantEjercicio}");
        _ejercicio = data[progreso];
        print("id ejercicio: ${_ejercicio['id']}");
      } else {
        print("No hay ejercicios disponibles");
      }
    } catch (e) {
      print("Error al obtener los ejercicios: $e");
    }
  }

  void _case1Opciones(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EjercicioXPreguntaScreen(
          token: token,
          progreso: progreso,
          ejercicioId: _ejercicio['id'],
        ),
      ),
    );
  }

  void _case2Pronunciar(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EjercicioXPreguntaScreen3(
          token: token,
          progreso: progreso,
          ejercicioId: _ejercicio['id'],
        ),
      ),
    );
  }

  void _case3Escribir(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EjercicioXPreguntaScreen3(
          token: token,
          progreso: progreso,
          ejercicioId: _ejercicio['id'],
        ),
      ),
    );
  }

  void _viewReporte(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EjercicioReporte(token: token),
      ),
    );
  }

  void prueba() {
    var data = _api.getEjerciciosXLeccion(this.token, this.leccId);
    print("valores: (${data}");
  }

  int _getTipo() {
    if (cantEjercicio != 0) {
      if (progreso == cantEjercicio) {
        progreso = 0;
        return 0;
      } else {
        progreso++;

        return int.parse(_ejercicio['tipo']);
      }
    }
    print("progreso dentro de _getiTipo: ${progreso}");
    return -1;
  }

  Future<void> navegarAlSiguienteEjercicio(BuildContext context) async {
    print("entro al navegator++++++++++++++++++++++++++++++++++++++++++++++++");
    await _fetch();
    final int _case = _getTipo(); //si es -1 no hay data
    print(
        "valor del case: ${_case} +++++++++ para entra a una de las 3 vistas");
    switch (_case) {
      case 3:
        _case3Escribir(context);
        break;
      case 2:
        _case1Opciones(context);
      case 1:
        _case2Pronunciar(context);
        break;
      case 0:
        _viewReporte(context);
        break;
      default:
        print(
            "Última vista: se dirige a la pregunta con IA si el caso tiene un fallo.");
        break;
    }
  }
}
