class EjercicioModel {
  String opcion;
  String respuestaTexto;
  int ejercicioId;
  bool correcto;
  int tipo;

  EjercicioModel({
    required this.opcion,
    required this.respuestaTexto,
    required this.ejercicioId,
    required this.correcto,
    required this.tipo,
  });

  // Método getToString para devolver una representación como String
  String getToString() {
    return 'opcion: $opcion\nRespuesta Texto: $respuestaTexto\nTipo: $tipo';
  }


  // Getters para acceder a los valores
  String get getOpcion => opcion;
  String get getRespuestaTexto => respuestaTexto;
  int get getEjercicioId => ejercicioId;
  bool get getCorrecto => correcto;
  int get getTipo => tipo;
}
