import 'package:flutter/material.dart';
import 'package:vinyl_allosa/data/models/track_model.dart';
import 'package:vinyl_allosa/ui/pages/home_page.dart';
import '../../../data/models/vinyl_model.dart';

class VinylDetailsPage extends StatelessWidget {
  final VinylModel vinyl;

  VinylDetailsPage({required this.vinyl});

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text(
          'Detalles del Vinilo',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(Icons.home, color: Colors.white),
          onPressed: () {
            // Regresar al HomePage
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        )
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen de portada
              Center(
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(
                        vinyl.imageUrl?.isNotEmpty ?? false
                            ? vinyl.imageUrl!
                            : 'https://via.placeholder.com/150?text=No+Image',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Información del vinilo (Artista, Año, Título)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Detalles al costado
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Título: ${vinyl.title}',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Artista: ${vinyl.artist}',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Año: ${vinyl.year ?? 'Desconocido'}',
                        style: TextStyle(color: Colors.white54, fontSize: 14),
                      ),
                      SizedBox(height: 8),
                      // Mostrar el 'code' si no es nulo
                      if (vinyl.code?.isNotEmpty ?? false)
                        Text(
                          'Código: ${vinyl.code ?? 'Desconocido'}', // Usar 'Desconocido' si es null
                          style: TextStyle(color: Colors.white54, fontSize: 14),
                        ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Lista de pistas (separadas por lado)
              if ((vinyl.sideA ?? []).isNotEmpty || (vinyl.sideB ?? []).isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pistas:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    _buildTrackList(vinyl.sideA ?? [], vinyl.sideB ?? []), // Usar listas vacías si son null
                  ],
                ),
              SizedBox(height: 20),
              // Botón de "Editar"
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/edit', arguments: vinyl);
                  },
                  child: Text(
                    'Editar Vinilo',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey[800],
                  ),
                
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Método para mostrar las pistas agrupadas por lado
  Widget _buildTrackList(List<Track> sideA, List<Track> sideB) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Lado A
        if (sideA.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Lado A:',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              ...sideA.map((track) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    track.name,
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                );
              }).toList(),
            ],
          ),
        SizedBox(height: 10),
        // Lado B
        if (sideB.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Lado B:',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              ...sideB.map((track) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    track.name,
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                );
              }).toList(),
            ],
          ),
      ],
    );
  }
}