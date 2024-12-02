import 'package:flutter_movil2/exports.dart';

class HomeController {
  // Simulación de una llamada de red asíncrona para obtener datos de usuario
  Future<User> fetchUser() async {
    await Future.delayed(const Duration(seconds: 2)); // Simula el retraso de la red
    // Supongamos que obtenemos esta respuesta de un servidor
    Map<String, dynamic> response = {
      'id': '1',
      'name': 'Rene Chungara',
      'email': 'rene@gmail.com',
    };

    // Convertimos la respuesta JSON a un objeto User
    return User.fromJson(response);
  }
}
