import 'package:vinyl_allosa/data/models/track_model.dart';

class VinylModel {
  String id; // Identificador único del vinilo
  final String title; // Título del vinilo
  final String artist; // Artista del vinilo
  final int? year; // Año de lanzamiento
  final List<Track> sideA;  // Lista de pistas para el lado A
  final List<Track>? sideB; // Lista de pistas para el lado B
  final String? imageUrl; // URL de la imagen de portada
  final String code; // Nuevo campo para código de vinilo

  VinylModel({
    required this.id,
    required this.title,
    required this.artist,
    required this.year,
    required this.sideA,
    this.sideB,
    this.imageUrl,
    required this.code, // Incluir el nuevo campo en el constructor
  });

  // Convertir a Map para Firebase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'year': year,
      'sideA': sideA.map((track) => track.toMap()).toList(), // Convertir las pistas del lado A
      'sideB': sideB?.map((track) => track.toMap()).toList(), // Convertir las pistas del lado B (si existen)
      'imageUrl': imageUrl,
      'code': code, // Incluir el nuevo campo en el Map
    };
  }

  // Crear desde un Map
  factory VinylModel.fromMap(Map<String, dynamic> map) {
    return VinylModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      artist: map['artist'] ?? '',
      year: map['year'],
      sideA: List<Track>.from(map['sideA']?.map((x) => Track.fromMap(x)) ?? []), // Convertir las pistas del lado A
      sideB: map['sideB'] != null ? List<Track>.from(map['sideB']?.map((x) => Track.fromMap(x))) : null, // Convertir las pistas del lado B (si existen)
      imageUrl: map['imageUrl'] ?? '',
      code: map['code'], // Extraer el nuevo campo del mapa
    );
  }
}
