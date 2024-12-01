import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vinyl_allosa/ui/components/vinyl_card.dart';
import 'package:vinyl_allosa/ui/pages/add/add_vinyl_page.dart';
import '../../../data/repositories/db_repository.dart';
import '../../../data/models/vinyl_model.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DBRepository dbRepository = DBRepository();
  final TextEditingController searchController = TextEditingController();
  List<VinylModel> allVinyls = [];
  List<VinylModel> filteredVinyls = [];

  @override
  void initState() {
    super.initState();
    _loadVinyls();
  }

  Future<void> _loadVinyls() async {
    try {
      final vinyls = await dbRepository.getVinyls();
      setState(() {
        allVinyls = vinyls;
        filteredVinyls = vinyls; // Inicialmente, todos los vinilos están visibles.
      });
    } catch (e) {
      // Manejo de errores opcional
      print("Error loading vinyls: $e");
    }
  }

  void _filterVinyls(String query) {
    final filtered = query.isEmpty
        ? allVinyls // Si la consulta está vacía, mostrar todos los vinilos
        : allVinyls.where((vinyl) {
            final title = vinyl.title.toLowerCase();
            final artist = vinyl.artist.toLowerCase();
            final tracksA = (vinyl.sideA ?? []).map((track) => track.name.toLowerCase()).toList();
            final tracksB = (vinyl.sideB ?? []).map((track) => track.name.toLowerCase()).toList();
            final lowerQuery = query.toLowerCase();

            return title.contains(lowerQuery) ||
                artist.contains(lowerQuery) ||
                tracksA.any((track) => track.contains(lowerQuery)) ||
                tracksB.any((track) => track.contains(lowerQuery));
          }).toList();

    setState(() {
      filteredVinyls = filtered;
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text(
          'Mi Biblioteca de Vinilos',
          style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.05),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.home, color: Colors.white),
          onPressed: () {
            // Regresar al HomePage
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.red),
            onPressed: () async {
              // Cerrar sesión en Firebase
              await FirebaseAuth.instance.signOut();

              // Redirigir al login después de cerrar sesión
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: TextField(
              controller: searchController,
              onChanged: _filterVinyls,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Buscar por artista, canción o álbum',
                hintStyle: TextStyle(color: Colors.grey[400]),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.search, color: Colors.white),
              ),
            ),
          ),
          Expanded(
            child: filteredVinyls.isEmpty
                ? Center(
                    child: Text(
                      searchController.text.isEmpty
                          ? 'No hay vinilos en la biblioteca'
                          : 'No se encontraron resultados',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: screenWidth * 0.04,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                    child: RefreshIndicator(
                      onRefresh: _loadVinyls,  // Método para recargar los vinilos
                      child: ListView.builder(
                        itemCount: filteredVinyls.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
                            child: VinylCard(vinyl: filteredVinyls[index]),
                          );
                        },
                      ),
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddVinylPage()),
          ).then((_) => _loadVinyls()); // Recargar la lista al volver
        },
        backgroundColor: Colors.blueGrey[800],
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}