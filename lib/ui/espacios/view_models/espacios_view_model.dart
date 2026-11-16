import 'package:flutter/foundation.dart';

import '../../../data/repositories/espacios_repository.dart';
import '../../../domain/models/espacio.dart';

class EspaciosViewModel extends ChangeNotifier {
  EspaciosViewModel({required this._espaciosRepository});
  final EspaciosRepository _espaciosRepository;
  String _consulta = '';
  String get consulta => _consulta;
  List<Espacio> get espacios => List.unmodifiable(
    _espaciosRepository.obtenerTodos().where(
      (e) =>
          e.nombre.toLowerCase().contains(_consulta.toLowerCase()) ||
          e.ubicacion.toLowerCase().contains(_consulta.toLowerCase()),
    ),
  );
  void buscar(String consulta) {
    _consulta = consulta;
    notifyListeners();
  }
}
