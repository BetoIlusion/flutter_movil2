import 'package:flutter_movil2/exports.dart';

//TODO: VISTA DE OPCIONES A SELECCIONAR
class EjercicioXPreguntaScreen extends StatefulWidget {
  final String token;
  int progreso;
  final int ejercicioId;
  EjercicioXPreguntaScreen(
      {required this.token, required this.progreso, required this.ejercicioId});

  @override
  _EjercicioXPreguntaScreenState createState() =>
      _EjercicioXPreguntaScreenState();
}

class _EjercicioXPreguntaScreenState extends State<EjercicioXPreguntaScreen> {
  late final ApiService _api;

  String titulo = "";
  String contenido = "Aquí el contenido del ejercicio.";
  List<String> opciones = [];
  Map<String, String> contextoBotones = {};
  var ejercicio;
  String textoSeleccionado = "";

  @override
  void initState() {
    super.initState();
    _api = ApiService();
    _fetchLlenarOpciones();
  }

  void _fetchLlenarOpciones() async {
    try {
      dynamic ejercicio1 =
          await _api.getEjercicioShow(widget.token, widget.ejercicioId);

      if (ejercicio1 != null &&
          ejercicio1['opciones'] != null &&
          ejercicio1['opciones'] is List &&
          (ejercicio1['opciones'] as List).isNotEmpty) {
        List<String> nuevasOpciones = [];
        List<dynamic> opcionesLista = ejercicio1['opciones'];

        for (var opcion in opcionesLista) {
          if (opcion is Map && opcion.isNotEmpty) {
            nuevasOpciones.add(opcion.values.first.toString());
          }
        }

        setState(() {
          ejercicio = ejercicio1;
          opciones = nuevasOpciones;
        });

        // Manejar contextoBotones fuera de setState
        Map<String, String> nuevoContextoBotones = {};
        for (var opcion in opciones) {
          nuevoContextoBotones[opcion] = await _mensajeIa(opcion);
        }

        setState(() {
          contextoBotones = nuevoContextoBotones;
        });

        print("Opciones: $opciones");
        print("ContextoBotones: $contextoBotones");
      } else {
        setState(() {
          opciones = [];
          contextoBotones = {};
        });
        print("No se encontró una lista válida en 'opciones'");
      }

      setState(() {
        contenido = ejercicio1['pregunta_texto'] ?? "Contenido no disponible";
      });
    } catch (e) {
      print("Error al obtener las opciones: $e");
      setState(() {
        opciones = [];
        contextoBotones = {};
      });
    }
  }

  void _botonNavegatorView(String opcion) async {
    setState(() {
      print(contextoBotones[opcion]);
      textoSeleccionado = contextoBotones[opcion] ?? "dfdsds";
    });
    print(textoSeleccionado);
    _insertSingleton(opcion);
    await Future.delayed(Duration(seconds: 3));
    EjercicioNavigator ejercicioNavigator = EjercicioNavigator(
            token: widget.token,
            leccId: ejercicio['leccion_id'],
            progreso: widget.progreso);
    ejercicioNavigator.navegarAlSiguienteEjercicio(context);
    // // Mostrar todos los ejercicios en consola o en pantalla
    // List<EjercicioModel> todosEjercicios =
    //     EjercicioSingleton.instance.getAllEjercicios();
    // for (var ejercicio in todosEjercicios) {
    //   print(
    //       'Ejercicio ID: ${ejercicio.getEjercicioId}, Opción: ${ejercicio.getOpcion}');
    // }

    // Navegar a la nueva vista con la opción seleccionada
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => NuevaVistaScreen(opcionElegida: opcionSeleccionada),
    //   ),
    // );
  }

  void _insertSingleton(String opcion) {
    bool correctoVerif;
    if (opcion == ejercicio['respuesta_texto']) {
      correctoVerif = true;
    } else {
      correctoVerif = false;
    }

    //final EjercicioSingleton ejercicioSingleton;
    EjercicioModel ejercicioModel = EjercicioModel(
      opcion: opcion,
      respuestaTexto: ejercicio['respuesta_texto'],
      ejercicioId: ejercicio['id'],
      correcto: correctoVerif,
      tipo: 1,
    );
    EjercicioSingleton.instance.addEjercicio(ejercicioModel);
  }

  Future<String> _mensajeIa(String opcion) async {
    print("Entró a la función _mensajeIa");
    if (opcion != ejercicio['respuesta_texto']) {
      final gemini = Gemini.instance;
      String prompt =
          "Contexto: Esto es una app para aprender ingles-español y dame un ejemplo de la frase o palabra ya que fallo en seleccionar la respuesta correcta; Genera una respuesta corta para el siguiente contexto:'${opcion}', comparando con esta: '${ejercicio['respuesta_texto']}', responde en español con ejemplo en ingles, ademas solo responde respecto a la comparacion";
      try {
        var value = await gemini.text(prompt);
        String contenidoGenerado =
            value?.output ?? 'No se pudo generar contenido';
        print("Contenido generado: $contenidoGenerado");
        return formatearCadaCuatroPalabras(contenidoGenerado);
      } catch (e) {
        print("Error al generar preguntas: $e");
        return 'Error al generar preguntas: $e';
      }
    } else {
      return formatearCadaCuatroPalabras("Excelente, sigue así");
    }
  }

  String formatearCadaCuatroPalabras(String texto) {
    List<String> palabras = texto.split(' ');
    StringBuffer resultado = StringBuffer();

    for (int i = 0; i < palabras.length; i++) {
      resultado.write(palabras[i]);

      // Agregar un salto de línea después de cada 4 palabras
      if ((i + 1) % 4 == 0) {
        resultado.write('\n');
      } else {
        resultado.write(' '); // Agregar un espacio entre palabras
      }
    }

    return resultado
        .toString()
        .trim(); // Eliminar espacios o saltos de línea extra al final
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Modificar el título para que incluya el progreso
    titulo = "Progreso: ${widget.progreso} / 10";

    return Scaffold(
      appBar: AppBar(
        title: Text(
          titulo,
          style: GoogleFonts.roboto(fontSize: screenWidth * 0.05),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent.withOpacity(0.1),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              contenido,
              style: GoogleFonts.roboto(
                fontSize: screenWidth * 0.045,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            Spacer(),
            Stack(
              children: [
                Positioned.fill(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white,
                                Colors.white.withOpacity(0.5),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.5),
                                Colors.white,
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: opciones.map((opcion) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.02),
                        child: Column(
                          children: [
                            TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.0075,
                                  horizontal: screenWidth * 0.02,
                                ),
                                backgroundColor:
                                    Colors.blueAccent.withOpacity(0.1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                print("navegadorVIew -> ${opcion}");
                                _botonNavegatorView(opcion);
                              },
                              child: Text(
                                opcion,
                                style: GoogleFonts.roboto(
                                  fontSize: screenWidth * 0.03,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ),
                            if (textoSeleccionado == contextoBotones[opcion])
                              Padding(
                                padding:
                                    EdgeInsets.only(top: screenHeight * 0.01),
                                child: Text(
                                  textoSeleccionado,
                                  style: GoogleFonts.roboto(
                                    fontSize: screenWidth * 0.035,
                                    color: Colors.black54,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            Spacer(),
            Text(
              "Ejercicio tipo: ${ejercicio['tipo']}",
              style: GoogleFonts.roboto(
                fontSize: screenWidth * 0.04,
                fontStyle: FontStyle.italic,
                color: Colors.blueAccent,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
