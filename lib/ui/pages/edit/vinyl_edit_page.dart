import 'package:flutter/material.dart';
import 'package:vinyl_allosa/data/models/track_model.dart';
import 'package:vinyl_allosa/ui/pages/home_page.dart';
import '../../../data/models/vinyl_model.dart';
import '../../../data/repositories/db_repository.dart';

class VinylEditPage extends StatefulWidget {
  final VinylModel vinyl;

  VinylEditPage({required this.vinyl});

  @override
  _VinylEditPageState createState() => _VinylEditPageState();
}

class _VinylEditPageState extends State<VinylEditPage> {
  final DBRepository _dbRepository = DBRepository();
  late VinylModel vinyl;
  final List<TextEditingController> _sideATrackControllers = [];
  final List<TextEditingController> _sideBTrackControllers = [];
  late TextEditingController titleController;
  late TextEditingController artistController;
  late TextEditingController yearController;
  late TextEditingController imageUrlController;
  late TextEditingController codeController;

  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      vinyl = widget.vinyl;
      titleController = TextEditingController(text: vinyl.title);
      artistController = TextEditingController(text: vinyl.artist);
      yearController = TextEditingController(text: vinyl.year?.toString() ?? '');
      imageUrlController = TextEditingController(text: vinyl.imageUrl ?? '');
      codeController = TextEditingController(text: vinyl.code);

      _initializeTrackControllers();
      _isInitialized = true;
    }
  }

  void _initializeTrackControllers() {
    _sideATrackControllers.clear();
    _sideBTrackControllers.clear();

    for (var track in vinyl.sideA) {
      _sideATrackControllers.add(TextEditingController(text: track.name));
    }
    if (vinyl.sideB != null) {
      for (var track in vinyl.sideB!) {
        _sideBTrackControllers.add(TextEditingController(text: track.name));
      }
    }
  }

  void _addTrackField(String side) {
    setState(() {
      if (side == 'A') {
        _sideATrackControllers.add(TextEditingController());
      } else if (side == 'B') {
        _sideBTrackControllers.add(TextEditingController());
      }
    });
  }

  void _removeTrackField(String side, int index) {
    setState(() {
      if (side == 'A') {
        _sideATrackControllers.removeAt(index);
      } else if (side == 'B') {
        _sideBTrackControllers.removeAt(index);
      }
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    artistController.dispose();
    yearController.dispose();
    imageUrlController.dispose();
    for (var controller in _sideATrackControllers) {
      controller.dispose();
    }
    for (var controller in _sideBTrackControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text(
          'Editar Vinilo',
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
              _buildTextField(label: 'Título', controller: titleController),
              _buildTextField(label: 'Artista', controller: artistController),
              _buildTextField(
                label: 'Año de lanzamiento',
                controller: yearController,
                keyboardType: TextInputType.number,
              ),
              _buildTextField(
                label: 'URL de la Imagen',
                controller: imageUrlController,
                keyboardType: TextInputType.url,
              ),
              SizedBox(height: 10),
              if (imageUrlController.text.isNotEmpty)
                Center(
                  child: Image.network(
                    imageUrlController.text,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Text(
                        'Vista previa no disponible',
                        style: TextStyle(color: Colors.white70),
                      );
                    },
                  ),
                ),SizedBox(height: 10),
                // Campo para el código
                _buildTextField(
                  label: 'Código',
                  controller: codeController,
                ),
              SizedBox(height: 20),
              Text(
                'Lado A - Pistas',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              ..._sideATrackControllers.asMap().entries.map((entry) {
                int index = entry.key;
                return Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        label: 'Pista ${index + 1}',
                        controller: entry.value,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () => _removeTrackField('A', index),
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
                'Lado B - Pistas',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              ..._sideBTrackControllers.asMap().entries.map((entry) {
                int index = entry.key;
                return Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        label: 'Pista ${index + 1}',
                        controller: entry.value,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () => _removeTrackField('B', index),
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
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    final updatedTracks = [
                      ..._sideATrackControllers.map(
                        (controller) => Track(name: controller.text, side: 'A'),
                      ),
                      ..._sideBTrackControllers.map(
                        (controller) => Track(name: controller.text, side: 'B'),
                      ),
                    ];

                    final updatedVinyl = VinylModel(
                      id: vinyl.id,
                      title: titleController.text,
                      artist: artistController.text,
                      year: int.tryParse(yearController.text),
                      sideA: updatedTracks.where((track) => track.side == 'A').toList(),
                      sideB: updatedTracks.where((track) => track.side == 'B').toList(),
                      imageUrl: imageUrlController.text.isNotEmpty ? imageUrlController.text : null,
                      code: vinyl.code, // Mantener el código original, si no se edita
                    );

                    // Asegurarse de que el id es correcto y que el vinilo se está actualizando correctamente
                    print("ID del vinilo a actualizar: ${updatedVinyl.id}");
                    _dbRepository.updateVinyl(updatedVinyl);
                    // Redirigir al Home (o la pantalla principal) y recargarla
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),  // Reemplaza 'HomePage' por tu widget principal
                      );
                  },
                  child: Text(
                    'Guardar Cambios',
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
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.white),
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[400]),
          filled: true,
          fillColor: Colors.grey[850],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[700]!),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}