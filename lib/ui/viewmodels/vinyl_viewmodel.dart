import 'package:flutter/material.dart';
import '../../data/models/vinyl_model.dart';
import '../../data/repositories/db_repository.dart';

class VinylViewModel extends ChangeNotifier {
  final DBRepository _dbRepository = DBRepository();
  List<VinylModel> _vinyls = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<VinylModel> get vinyls => _vinyls;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Método para obtener los vinilos desde la base de datos
  Future<void> fetchVinyls() async {
    _isLoading = true;
    _errorMessage = ''; // Resetear mensaje de error
    notifyListeners();

    try {
      _vinyls = await _dbRepository.getVinyls();
    } catch (e) {
      _errorMessage = 'Error al cargar los vinilos: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Método para agregar un vinilo a la base de datos
  Future<void> addVinyl(VinylModel vinyl) async {
    try {
      await _dbRepository.addVinyl(vinyl);
      fetchVinyls();
    } catch (e) {
      _errorMessage = 'Error al agregar el vinilo: $e';
      notifyListeners();
    }
  }

  // Método para actualizar un vinilo en la base de datos
  Future<void> updateVinyl(VinylModel oldVinyl, VinylModel updatedVinyl) async {
    try {
      // Pasamos solo el vinilo actualizado
      await _dbRepository.updateVinyl(updatedVinyl);
      fetchVinyls();
    } catch (e) {
      _errorMessage = 'Error al actualizar el vinilo: $e';
      notifyListeners();
    }
  }

  // Método para eliminar un vinilo de la base de datos
  Future<void> deleteVinyl(VinylModel vinyl) async {
    try {
      await _dbRepository.deleteVinyl(vinyl);
      fetchVinyls();
    } catch (e) {
      _errorMessage = 'Error al eliminar el vinilo: $e';
      notifyListeners();
    }
  }
}
