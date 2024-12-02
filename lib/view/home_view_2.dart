import '../exports.dart';

class HomeView2 extends StatefulWidget {
  final String token;
  HomeView2({required this.token});

  @override
  State<HomeView2> createState() => _HomeView2State();
}

class _HomeView2State extends State<HomeView2> {
  final HomeController controller = HomeController();
  final ApiService _apiService = ApiService();

  List<dynamic> niveles = [];
  // List<Map<String, String>> niveles = [
  //   {'nombre': 'Básico', 'descripcion': 'Nivel inicial'},
  //   {'nombre': 'Intermedio', 'descripcion': 'Mayor dificultad'},
  //   {'nombre': 'Avanzado', 'descripcion': 'Nivel experto'},
  // ];
  bool showDetails =
      false; // Controlador para mostrar u ocultar la lista de detalles
  List<Map<String, String>> nivelDetalles = [
    {'titulo': 'Lección 1', 'descripcion': 'Introducción a la gramática'},
    {'titulo': 'Lección 2', 'descripcion': 'Tiempos verbales en presente'},
    {'titulo': 'Lección 3', 'descripcion': 'Vocabulario esencial'},
  ];
  Map<String, String> selectedDetails = {};
  @override
  void initState() {
    super.initState();
    _fetchNiveles();
  }

  // Método para obtener los niveles desde la API
  void _fetchNiveles() async {
    final data = await _apiService.getNiveles(widget.token);
    setState(() {
      niveles = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.blueAccent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: const [
              Icon(Icons.school,
                  color: Colors.blueAccent), // Icono para la app de aprendizaje
              SizedBox(width: 8),
              Text(
                '¡Bienvenido de nuevo!',
                style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.blueAccent),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.blueAccent),
            onPressed: () {
              // Acción para notificaciones
            },
          ),
        ],
      ),
      drawer: FutureBuilder<User>(
        future: controller.fetchUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return DrawerMenu(
                user: snapshot.data!); // Pasar usuario al DrawerMenu
          } else {
            return DrawerMenu(
              // Eliminar 'const' aquí
              user: User(
                  id: '0',
                  name: 'Cargando...',
                  email: 'cargando...'), // Placeholder
            );
          }
        },
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<User>(
            future: controller.fetchUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                User user = snapshot.data!;
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Saludo al usuario
                      Text(
                        'Hola, ${user.name}!',
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '¡Continúa aprendiendo inglés con tus lecciones personalizadas!',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Barra de progreso de aprendizaje con animación
                      const Text(
                        'Progreso del Curso',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0, end: 0.6),
                        duration: const Duration(seconds: 2),
                        builder: (context, value, _) => LinearProgressIndicator(
                          value: value,
                          backgroundColor: Colors.white.withOpacity(0.3),
                          color: Colors.white,
                          minHeight: 8,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Sección de lecciones recomendadas con diseño atractivo
                      const Text(
                        'Lecciones Recomendadas',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      // _buildLessonCard(
                      //     'Vocabulario Básico',
                      //     'Aprende las palabras esenciales',
                      //     'assets/ingles.png'),
                      // _buildLessonCard(
                      //     'Gramática Avanzada',
                      //     'Domina la estructura del idioma',
                      //     'assets/grammar.jpg'),
                      const SizedBox(height: 30),

                      // Botones de acción rápida con diseño amigable
                      const Text(
                        'Explora Más',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildActionButton(
                              FontAwesomeIcons.bookOpen, 'Mis Lecciones'),
                          _buildActionButton(
                              FontAwesomeIcons.listAlt, 'Vocabulario'),
                          _buildActionButton(
                              FontAwesomeIcons.puzzlePiece, 'Exámenes'),
                        ],
                      ),
                      //+++++++++++++++++++++++++++++++++++++++++
                      niveles.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Niveles Disponibles',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                const SizedBox(height: 10),
                                ...niveles.map((nivel) {
                                  // Asegurarse de que nivel sea Map<String, String>
                                  var nivelStr = {
                                    'nombre': nivel['nombre'] ?? 'Sin nombre',
                                    'descripcion': nivel['descripcion'] ??
                                        'Sin descripción',
                                  };

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5.0),
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          // Mostrar el popup al presionar el botón
                                          //_showNivelPopup(context, nivelStr, widget.token);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 20),
                                          backgroundColor:
                                              Colors.white.withOpacity(0.6),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          elevation: 5,
                                        ),
                                        child: Text(
                                          nivel['nombre'] ?? 'Sin nombre',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                                const SizedBox(height: 30),
                              ],
                            )
                          : const Center(
                              child: Text(
                                'Cargando niveles...',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),

                      //+++++++++++++++++++++++++++++++++++++++
                      // Llamada a la acción para continuar la lección con diseño llamativo
                      const SizedBox(height: 30),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            // Navegar a la próxima lección
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orangeAccent,
                            //onPrimary: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 15),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            elevation: 5,
                          ),
                          child: const Text('Continuar Lección',
                              style: TextStyle(fontSize: 18)),
                        ),
                      ),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => EjercicioXPreguntaScreen2()));

                            
                            _bottonPrueba();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orangeAccent,
                            // onPrimary: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 15),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            elevation: 5,
                          ),
                          child: const Text('boton de pruebas',
                              style: TextStyle(fontSize: 18)),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(child: Text('No hay datos del usuario'));
              }
            },
          ),
        ),
      ),
    );
  }

  // Método para construir una tarjeta de lección con diseño atractivo
  Widget _buildLessonCard(String title, String description, String imagePath) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blue.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(10),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(imagePath,
                width: 50, height: 50, fit: BoxFit.cover),
          ),
          title: Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black)),
          subtitle:
              Text(description, style: const TextStyle(color: Colors.black54)),
          trailing: const Icon(Icons.arrow_forward, color: Colors.blueAccent),
          onTap: () {
            // Acción al tocar la tarjeta
          },
        ),
      ),
    );
  }

// Función para mostrar el popup
  void _showNivelPopup(
      BuildContext context, Map<String, String> nivel, String token) async {
    // Obtenemos las lecciones para el nivel seleccionado
    int nivelId = int.parse(
        nivel['id'] ?? '0'); // Asegúrate de que 'id' sea el ID del nivel
    List<dynamic> lecciones = await _apiService.getLecciones(token, nivelId);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.blueAccent.withOpacity(0.9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            nivel['nombre'] ?? 'Sin nombre',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text(
                  nivel['descripcion'] ?? 'Sin descripción',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 10),
                // Mostrar las lecciones como botones
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: lecciones.map<Widget>((leccion) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // Aquí se navega a la nueva vista pasando el id de la lección y el token
                          Navigator.of(context).pop(); // Cerrar el popup
                          _navigateToLeccion(context, leccion['id'], token);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          backgroundColor: Colors.white.withOpacity(0.6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 5,
                        ),
                        child: Text(
                          leccion['nombre'] ?? 'Lección sin nombre',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el popup
              },
              child: Text(
                'Cerrar',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

// Función para navegar a la nueva vista pasando el id de la lección y el token
  void _navigateToLeccion(BuildContext context, int leccionId, String token) {
    // Aquí debes crear la vista de la lección donde recibirás el id y el token
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => LeccionDetailPage(
    //       leccionId: leccionId,
    //       token: token,
    //     ),
    //   ),
    // );
  }
  // Método para construir botones de acción rápida con diseño amigable
  Widget _buildActionButton(IconData icon, String label) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            // Acción rápida
          },
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(20),
            backgroundColor: Colors.white,
            // onPrimary: Colors.blueAccent,
            elevation: 5,
          ),
          child: FaIcon(icon,
              color: Colors.blueAccent,
              size: 30), // Usamos FaIcon para FontAwesome
        ),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.white)),
      ],
    );
  }

  void _bottonPrueba() {
    EjercicioNavigator navigator =
      EjercicioNavigator(token: widget.token, leccId: 1, progreso: 0);
    navigator.navegarAlSiguienteEjercicio(context);
  }
}
