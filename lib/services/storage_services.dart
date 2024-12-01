import 'dart:io'; // Necesario para la clase File
import 'package:firebase_storage/firebase_storage.dart';
import 'package:vinyl_allosa/services/firebase_services.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseService.storage;

  // Método para subir la imagen de portada
  Future<String> uploadCoverImage(String vinyleId, String imagePath) async {
    try {
      // Convertir la ruta del archivo en un objeto de tipo File
      File imageFile = File(imagePath);  // Esto convierte la ruta String en un objeto File

      // Referencia al directorio de almacenamiento de imágenes en Firebase Storage
      final ref = _storage.ref().child('vinyl_covers/$vinyleId');

      // Subir el archivo a Firebase Storage
      await ref.putFile(imageFile);

      // Obtener la URL de descarga de la imagen subida
      String downloadUrl = await ref.getDownloadURL();

      // Retornar la URL para que se pueda usar en la base de datos
      return downloadUrl;
    } catch (e) {
      print('Error al subir la imagen de portada: $e');
      throw e; // Propagar el error en caso de que ocurra algún problema
    }
  }
}
