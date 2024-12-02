import 'package:flutter_movil2/exports.dart';
class EjercicioSingleton {
  final List<EjercicioModel> _ejercicios = [];

  EjercicioSingleton._privateConstructor();

  static final EjercicioSingleton _instance =
      EjercicioSingleton._privateConstructor();

  static EjercicioSingleton get instance => _instance;

  void addEjercicio(EjercicioModel ejercicio) {
    _ejercicios.add(ejercicio);
  }

  EjercicioModel? getEjercicio(int index) {
    if (index >= 0 && index < _ejercicios.length) {
      return _ejercicios[index];
    }
    return null;
  }

  List<EjercicioModel> getEjercicios() {
    return _ejercicios;
  }
}
