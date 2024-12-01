import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/vinyl_model.dart';
import '../../core/constants/firebase_constants.dart';

class DBRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Método para agregar un vinilo a la base de datos
Future<void> addVinyl(VinylModel vinyl) async {
  // Agregar el vinilo a la colección y obtener la referencia del documento
  var docRef = await _firestore
      .collection(FirebaseConstants.vinylesCollection)
      .add(vinyl.toMap());

  // Asignar el ID generado por Firestore al objeto VinylModel
  vinyl.id = docRef.id;

  // Actualizar el documento con el ID en Firestore
  await docRef.update({'id': vinyl.id});
}



  // Método para obtener los vinilos de la base de datos
  Future<List<VinylModel>> getVinyls() async {
    QuerySnapshot snapshot =
        await _firestore.collection(FirebaseConstants.vinylesCollection).get();

    return snapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;

      return VinylModel.fromMap({
        'id': doc.id, // Obtener el ID del documento
        'title': data['title'] ?? '',
        'artist': data['artist'] ?? '',
        'year': data['year'],
        'sideA': data['sideA'] ?? [],
        'sideB': data['sideB'] ?? [],
        'imageUrl': data['imageUrl'] ?? '',
        'code': data['code'] ?? '',
      });
    }).toList();
  }

  // Método para eliminar un vinilo de la base de datos
Future<void> deleteVinyl(VinylModel vinyl) async {
  try {
    print('Intentando eliminar el vinilo con ID: ${vinyl.id}');
    await _firestore.collection(FirebaseConstants.vinylesCollection).doc(vinyl.id).delete();    print("Vinilo eliminado con éxito.");
  } catch (e) {
    print('Error al eliminar el vinilo: $e');
    throw Exception('Error al eliminar el vinilo');
  }
}


  // Método para actualizar un vinilo en la base de datos
  Future<void> updateVinyl(VinylModel vinyl) async {
  try {
    var docRef = _firestore
        .collection(FirebaseConstants.vinylesCollection)
        .doc(vinyl.id);

    // Verifica si el documento existe
    var docSnapshot = await docRef.get();
    if (!docSnapshot.exists) {
      throw Exception("Documento no encontrado");
    }

    // Si el documento existe, actualiza los datos
    await docRef.update(vinyl.toMap());
    print("Vinilo actualizado con éxito.");
  } catch (e) {
    print("Error al actualizar el vinilo: $e");
    throw Exception("Error al actualizar el vinilo: $e");
  }
}


}
