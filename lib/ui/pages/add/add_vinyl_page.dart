import 'package:flutter/material.dart';
import 'package:vinyl_allosa/data/models/track_model.dart';
import 'package:vinyl_allosa/ui/pages/home_page.dart';
import '../../../data/repositories/db_repository.dart';
import '../../../data/models/vinyl_model.dart';

class AddVinylPage extends StatefulWidget {
  @override
  _AddVinylPageState createState() => _AddVinylPageState();
}

class _AddVinylPageState extends State<AddVinylPage> {
  final DBRepository dbRepository = DBRepository();
  final _formKey = GlobalKey<FormState>();

  String _title = '';
  String _artist = '';
  int? _year;
  String _imageUrl = '';
  List<Track> _sideATracks = []; // Pistas del lado A
  List<Track> _sideBTracks = []; // Pistas del lado B
  String _code = ''; // Variable para el código

  void _addTrackField(String side) {
    setState(() {
      if (side == 'A') {
        _sideATracks.add(Track(name: '', side: 'A')); // Agregar pista al lado A
      } else {
        _sideBTracks.add(Track(name: '', side: 'B')); // Agregar pista al lado B
      }
    });
  }

  void _updateTrack(int index, String value, String side) {
    setState(() {
      if (side == 'A') {
        _sideATracks[index].name = value;
      } else {
        _sideBTracks[index].name = value;
      }
    });
  }

  void _removeTrackField(int index, String side) {
    setState(() {
      if (side == 'A') {
        _sideATracks.removeAt(index);
      } else {
        _sideBTracks.removeAt(index);
      }
    });
  }

  void _saveVinyl() async {
    if (_formKey.currentState?.validate() ?? false) {
      final newVinyl = VinylModel(
        id: '', // ID se generará en la base de datos
        title: _title,
        artist: _artist,
        year: _year,
        sideA: _sideATracks.where((track) => track.name.isNotEmpty).toList(),
        sideB: _sideBTracks.where((track) => track.name.isNotEmpty).toList(),
        imageUrl: _imageUrl,
        code: _code, // Agregar el código al nuevo vinilo
      );

      // Insertar vinilo en la base de datos
      await dbRepository.addVinyl(newVinyl);

      // Regresar a la página anterior y recargar los vinilos
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text(
          'Añadir Vinilo',
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
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Información del Vinilo',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                _buildTextField(
                  label: 'Título',
                  onChanged: (value) => setState(() => _title = value),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa un título';
                    }
                    return null;
                  },
                ),
                _buildTextField(
                  label: 'Artista',
                  onChanged: (value) => setState(() => _artist = value),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa un artista';
                    }
                    return null;
                  },
                ),
                _buildTextField(
                  label: 'Año',
                  keyboardType: TextInputType.number,
                  onChanged: (value) => setState(() => _year = int.tryParse(value)),
                  validator: (value) {
                    if (value != null && value.isNotEmpty && int.tryParse(value) == null) {
                      return 'Por favor ingresa un año válido';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                // Campo para el código
                _buildTextField(
                  label: 'Código',
                  onChanged: (value) => setState(() => _code = value),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa un código';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                _buildTextField(
                  label: 'URL de la Imagen',
                  onChanged: (value) => setState(() => _imageUrl = value),
                  validator: (value) {
                    if (value != null && value.isNotEmpty && !Uri.tryParse(value)!.isAbsolute) {
                      return 'Por favor ingresa una URL válida';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                // Vista previa de la imagen
                if (_imageUrl.isNotEmpty)
                  Center(
                    child: Image.network(
                      _imageUrl,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Text(
                          'Vista previa no disponible',
                          style: TextStyle(color: Colors.white70),
                        );
                      },
                    ),
                  ),
                SizedBox(height: 20),
                Text(
                  'Pistas Lado A',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                ..._sideATracks.asMap().entries.map((entry) {
                  int index = entry.key;
                  return Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          label: 'Pista ${index + 1}',
                          onChanged: (value) => _updateTrack(index, value, 'A'),
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              return 'El nombre de la pista no puede estar vacío';
                            }
                            return null;
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.remove_circle, color: Colors.red),
                        onPressed: () => _removeTrackField(index, 'A'),
                      ),
                    ],
                  );
                }).toList(),
                ElevatedButton.icon(
                  onPressed: () => _addTrackField('A'),
                  icon: Icon(Icons.add, color: Colors.white),
                  label: Text(
                    'Agregar Pista al Lado A',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey[800],
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Pistas Lado B',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                ..._sideBTracks.asMap().entries.map((entry) {
                  int index = entry.key;
                  return Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          label: 'Pista ${index + 1}',
                          onChanged: (value) => _updateTrack(index, value, 'B'),
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              return 'El nombre de la pista no puede estar vacío';
                            }
                            return null;
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.remove_circle, color: Colors.red),
                        onPressed: () => _removeTrackField(index, 'B'),
                      ),
                    ],
                  );
                }).toList(),
                ElevatedButton.icon(
                  onPressed: () => _addTrackField('B'),
                  icon: Icon(Icons.add, color: Colors.white),
                  label: Text(
                    'Agregar Pista al Lado B',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey[800],
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _saveVinyl,
                    child: Text(
                      'Guardar Vinilo',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      backgroundColor: Colors.blueGrey[900],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required Function(String) onChanged,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        keyboardType: keyboardType,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white),
          filled: true,
          fillColor: Colors.blueGrey[800],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }
}