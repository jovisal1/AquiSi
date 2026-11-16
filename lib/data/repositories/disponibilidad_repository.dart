import '../../domain/models/disponibilidad_dia.dart';
import '../../domain/models/franja_disponibilidad.dart';
import '../services/datos_simulados_service.dart';
import 'conversiones.dart';
import 'espacios_repository.dart';

class DisponibilidadRepository {
  DisponibilidadRepository({
    required DatosSimuladosService service,
    required EspaciosRepository espacios,
  }) {
    final claves = <String>{};
    _dias = List.unmodifiable(
      service.leerDisponibilidad().map((dto) {
        final fecha = DateTime.parse(dto.fechaIso);
        comprobar(
          espacios.obtenerPorId(dto.espacioId) != null &&
              fecha == DateTime(fecha.year, fecha.month, fecha.day),
          'Día o espacio inválido',
        );
        comprobar(
          claves.add('${dto.espacioId}/${fecha.toIso8601String()}'),
          'Día duplicado',
        );
        final franjas =
            dto.franjas
                .map(
                  (f) => FranjaDisponibilidad(
                    inicio: DateTime.parse(f.inicioIso),
                    fin: DateTime.parse(f.finIso),
                    disponible: f.disponible,
                  ),
                )
                .toList()
              ..sort((a, b) => a.inicio.compareTo(b.inicio));
        for (var i = 0; i < franjas.length; i++) {
          final f = franjas[i];
          comprobar(
            f.fin.isAfter(f.inicio) &&
                DateTime(f.inicio.year, f.inicio.month, f.inicio.day) ==
                    fecha &&
                DateTime(f.fin.year, f.fin.month, f.fin.day) == fecha,
            'Franja fuera del día',
          );
          if (i > 0) {
            comprobar(
              !f.inicio.isBefore(franjas[i - 1].fin),
              'Franjas solapadas',
            );
          }
        }
        comprobar(franjas.length == 3, 'Día incompleto');
        return DisponibilidadDia(
          espacioId: dto.espacioId,
          fecha: fecha,
          franjas: franjas,
        );
      }),
    );
  }
  late final List<DisponibilidadDia> _dias;
  List<DisponibilidadDia> obtenerSieteDias(String id, DateTime desde) {
    final inicio = DateTime(desde.year, desde.month, desde.day);
    final fin = DateTime(inicio.year, inicio.month, inicio.day + 7);
    final lista =
        _dias
            .where(
              (d) =>
                  d.espacioId == id &&
                  !d.fecha.isBefore(inicio) &&
                  d.fecha.isBefore(fin),
            )
            .toList()
          ..sort((a, b) => a.fecha.compareTo(b.fecha));
    comprobar(lista.length == 7, 'Semana incompleta en la fuente');
    return List.unmodifiable(lista);
  }
}
