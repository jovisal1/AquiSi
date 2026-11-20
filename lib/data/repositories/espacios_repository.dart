import '../../domain/models/espacio.dart';
import '../services/datos_simulados_service.dart';
import 'conversiones.dart';

class EspaciosRepository {
  EspaciosRepository({required DatosSimuladosService service}) {
    final origen = service.leerEspacios();
    comprobarIdentificadores(origen.map((e) => e.id));
    _espacios = List.unmodifiable(
      origen.map((dto) {
        comprobar(
          dto.aforo > 0 &&
              dto.precioHoraCentimos >= 0 &&
              dto.precioDiaCentimos >= 0 &&
              dto.moneda == 'EUR',
          'Aforo, tarifa o moneda inválidos',
        );
        comprobar(
          dto.imagenesAssets.length >= 3 &&
              dto.imagenesAssets.contains(dto.imagenAsset) &&
              dto.actividades.isNotEmpty &&
              dto.equipamiento.length >= 3,
          'Espacio incompleto',
        );
        comprobarIdentificadores(dto.serviciosDisponibles.map((s) => s.id));
        comprobar(
          dto.serviciosDisponibles.every((s) => s.precioCentimos >= 0),
          'Extra con precio negativo',
        );
        return convertirEspacio(dto);
      }),
    );
  }
  late final List<Espacio> _espacios;
  List<Espacio> obtenerTodos() => _espacios;
  Espacio? obtenerPorId(String id) {
    for (final e in _espacios) {
      if (e.id == id) return e;
    }
    return null;
  }
}
