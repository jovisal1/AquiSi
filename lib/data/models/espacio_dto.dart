import 'contacto_local_dto.dart';
import 'servicio_extra_dto.dart';

class EspacioDto {
  EspacioDto({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.ubicacion,
    required this.horario,
    required this.condicionesUso,
    required this.imagenAsset,
    required List<String> imagenesAssets,
    required this.sitioWeb,
    required List<ServicioExtraDto> serviciosDisponibles,
    required this.aforo,
    required this.precioHoraCentimos,
    required this.precioDiaCentimos,
    required List<String> actividades,
    required List<String> equipamiento,
    required this.contacto,
    required this.moneda,
  }) : imagenesAssets = List.unmodifiable(imagenesAssets),
       serviciosDisponibles = List.unmodifiable(serviciosDisponibles),
       actividades = List.unmodifiable(actividades),
       equipamiento = List.unmodifiable(equipamiento);
  final String id;
  final String nombre;
  final String descripcion;
  final String ubicacion;
  final String horario;
  final String condicionesUso;
  final String imagenAsset;
  final List<String> imagenesAssets;
  final String? sitioWeb;
  final List<ServicioExtraDto> serviciosDisponibles;
  final int aforo;
  final int precioHoraCentimos;
  final int precioDiaCentimos;
  final List<String> actividades;
  final List<String> equipamiento;
  final ContactoLocalDto contacto;
  final String moneda;
}
