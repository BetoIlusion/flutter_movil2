

import 'package:flutter_movil2/exports.dart';

class DrawerMenu extends StatelessWidget {
  final User user;

  const DrawerMenu({super.key, required this.user});  // Pasar usuario como parámetro

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _buildDrawerHeader(context),
            _buildDrawerItem(context, FontAwesomeIcons.home, 'Inicio'),
            _buildDrawerItem(context, FontAwesomeIcons.bookOpen, 'Mis Lecciones'),
            _buildDrawerItem(context, FontAwesomeIcons.listAlt, 'Vocabulario'),
            _buildDrawerItem(context, FontAwesomeIcons.puzzlePiece, 'Exámenes'),
            const Divider(),
            _buildDrawerItem(context, FontAwesomeIcons.cog, 'Configuración'),
          ],
        ),
      ),
    );
  }

  // encabezado
  Widget _buildDrawerHeader(BuildContext context) {
    return DrawerHeader(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.blue, Colors.blueAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        image: DecorationImage(
          image: AssetImage('assets/background.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.blue.withOpacity(0.2), BlendMode.dstATop),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage('assets/user_avatar.png'),
          ),
          const SizedBox(height: 10),
          Text(
            user.name,
            style: GoogleFonts.poppins(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            user.email,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  // Método para construir elementos del Drawer con animación
  Widget _buildDrawerItem(BuildContext context, IconData icon, String title) {
    return ListTile(
      leading: FaIcon(icon, color: Colors.white),
      title: Text(
        title,
        style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
      ),
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$title seleccionado'),
            duration: const Duration(milliseconds: 500),
          ),
        );
      },
      hoverColor: Colors.blueAccent.withOpacity(0.2),
      tileColor: Colors.transparent,  
      splashColor: Colors.white54,
    );
  }
}
