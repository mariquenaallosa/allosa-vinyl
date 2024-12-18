import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Importa VinylViewModel
import 'package:vinyl_allosa/ui/viewmodels/vinyl_viewmodel.dart';
import '../../data/models/vinyl_model.dart';

class VinylCard extends StatelessWidget {
  final VinylModel vinyl;

  VinylCard({required this.vinyl});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blueGrey[900],
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15.0),
        onTap: () {
          Navigator.pushNamed(context, '/details', arguments: vinyl);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Stack para colocar la etiqueta sobre la imagen
            Stack(
              children: [
                // Imagen cuadrada
                Container(
                  width: double.infinity,
                  height: 350,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(15.0)),
                    image: DecorationImage(
                      image: NetworkImage(
                        vinyl.imageUrl ?? 'https://via.placeholder.com/150?text=No+Image',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Código del vinilo como un tag en la esquina superior derecha
                Positioned(
                  top: 10.0,
                  right: 10.0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(
                      '${vinyl.code}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Información del vinilo
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título
                  Text(
                    vinyl.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Artista
                  Text(
                    vinyl.artist,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Año de lanzamiento
                  if (vinyl.year != null)
                    Text(
                      '${vinyl.year}',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 16,
                      ),
                    ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            // Iconos en la parte inferior
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Ver Detalles
                IconButton(
                  icon: Icon(Icons.remove_red_eye, color: Colors.white),
                  onPressed: () {
                    Navigator.pushNamed(context, '/details', arguments: vinyl);
                  },
                ),
                // Editar
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.white),
                  onPressed: () {
                    Navigator.pushNamed(context, '/edit', arguments: vinyl);
                  },
                ),
                // Eliminar
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.white),
                  onPressed: () {
                    // Confirmación antes de eliminar
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Theme(
                          data: ThemeData.dark().copyWith(
                            dialogBackgroundColor: Colors.grey[850],
                            textTheme: TextTheme(
                              bodyLarge: TextStyle(color: Colors.white),
                              labelLarge: TextStyle(color: Colors.blue),
                            ),
                          ),
                          child: AlertDialog(
                            title: Text('Eliminar Vinilo'),
                            content: Text('¿Estás seguro de que deseas eliminar este vinilo?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // Cerrar el diálogo
                                },
                                child: Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Acceder al VinylViewModel
                                  final viewModel = Provider.of<VinylViewModel>(context, listen: false);
                                  // Llamar al método de eliminación desde el VinylViewModel
                                  viewModel.deleteVinyl(vinyl); // Elimina el vinilo
                                  Navigator.pop(context); // Cerrar el diálogo
                                },
                                child: Text('Eliminar'),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}