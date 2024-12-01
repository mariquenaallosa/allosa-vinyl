import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:vinyl_allosa/data/models/vinyl_model.dart';
import 'package:vinyl_allosa/services/firebase_services.dart';
import '../../core/constants/firebase_constants.dart';

class DBService {
  final FirebaseFirestore _firestore = FirebaseService.firestore;
  final FirebaseStorage _storage = FirebaseService.storage;

  Future<void> addVinyl(VinylModel vinyl) async {
    await _firestore.collection(FirebaseConstants.vinylesCollection).add(vinyl.toMap());
  }

  Future<void> updateVinyl(VinylModel oldVinyl, VinylModel updatedVinyl) async {
    await _firestore
        .collection(FirebaseConstants.vinylesCollection)
        .doc(oldVinyl.id)
        .update(updatedVinyl.toMap());
  }

  Future<void> deleteVinyl(VinylModel vinyl) async {
    await _firestore.collection(FirebaseConstants.vinylesCollection).doc(vinyl.id).delete();
  }

  Future<List<VinylModel>> getVinyls() async {
  final snapshot = await _firestore.collection(FirebaseConstants.vinylesCollection).get();
  return snapshot.docs.map((doc) => VinylModel.fromMap(doc.data() as Map<String, dynamic>)).toList(); // Eliminar el cast innecesario
}


  Future<void> uploadCoverImage(String vinyleId, String imagePath) async {
    File imageFile = File(imagePath);
    await _storage.ref('vinyl_covers/$vinyleId').putFile(imageFile);
  }

  
}
