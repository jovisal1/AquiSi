import 'contacto_local.dart';
import 'servicio_extra.dart';

class Espacio {
  Espacio({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.ubicacion,
    required this.horario,
    required this.condicionesUso,
    required this.imagenAsset,
    required List<String> imagenesAssets,
    required this.sitioWeb,
    required List<ServicioExtra> serviciosDisponibles,
    required this.aforo,
    required this.precioHoraCentimos,
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
  final List<ServicioExtra> serviciosDisponibles;
  final int aforo;
  final int precioHoraCentimos;
  final List<String> actividades;
  final List<String> equipamiento;
  final ContactoLocal contacto;
  final String moneda;
  bool admiteActividad(String actividad) => actividades.contains(actividad);
}
