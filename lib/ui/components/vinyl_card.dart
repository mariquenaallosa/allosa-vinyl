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
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen de portada (más grande)
              Container(
                width: 150,  // Imagen más grande
                height: 150, // Imagen más grande
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(
                      vinyl.imageUrl ?? 'https://via.placeholder.com/150?text=No+Image', // URL genérica si no hay imagen
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Información del vinilo
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título
                    Text(
                      vinyl.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Artista
                    Text(
                      vinyl.artist,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Año de lanzamiento
                    if (vinyl.year != null)
                      Text(
                        'Año: ${vinyl.year}',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                    const SizedBox(height: 8),
                    // Código del vinilo
                    Text(
                      'Código: ${vinyl.code}',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              // Column with icons (Ver Detalles, Editar, Eliminar)
              Column(
                children: [
                  // Ver Detalles
                  IconButton(
                    icon: Icon(Icons.remove_red_eye, color: Colors.blue),
                    onPressed: () {
                      Navigator.pushNamed(context, '/details', arguments: vinyl);
                    },
                  ),
                  // Editar
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.green),
                    onPressed: () {
                      Navigator.pushNamed(context, '/edit', arguments: vinyl);
                    },
                  ),
                  // Eliminar
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      // Confirmación antes de eliminar
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
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
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
