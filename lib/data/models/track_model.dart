class Track {
  String name; // Nombre de la pista
  String side; // Lado A o B

  Track({
    required this.name,
    required this.side,
  });

  // Convertir la pista a un Map para Firebase
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'side': side,
    };
  }

  // Crear una pista desde un Map
  factory Track.fromMap(Map<String, dynamic> map) {
    return Track(
      name: map['name'] ?? '',
      side: map['side'] ?? '',
    );
  }
}
