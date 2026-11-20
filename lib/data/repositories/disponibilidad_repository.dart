import '../../domain/models/disponibilidad_dia.dart';
import '../../domain/models/franja_disponibilidad.dart';
import '../services/datos_simulados_service.dart';
import 'conversiones.dart';
import 'espacios_repository.dart';
import 'reservas_repository.dart';

class DisponibilidadRepository {
  DisponibilidadRepository({
    required DatosSimuladosService service,
    required EspaciosRepository espacios,
    required ReservasRepository reservas,
  }) : _reservas = reservas {
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
  final ReservasRepository _reservas;
  late final List<DisponibilidadDia> _dias;
  List<DisponibilidadDia> obtenerSieteDias(String id, DateTime desde) =>
      obtenerDias(id, desde, 7);

  List<DisponibilidadDia> obtenerDias(
    String id,
    DateTime desde,
    int cantidad,
  ) {
    comprobar(cantidad > 0, 'Periodo vacío');
    final inicio = DateTime(desde.year, desde.month, desde.day);
    final fin = DateTime(inicio.year, inicio.month, inicio.day + cantidad);
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
    comprobar(lista.length == cantidad, 'Periodo incompleto en la fuente');
    // Las franjas ya reservadas en la app dejan de estar disponibles.
    return List.unmodifiable([
      for (final dia in lista)
        DisponibilidadDia(
          espacioId: dia.espacioId,
          fecha: dia.fecha,
          franjas: [
            for (final f in dia.franjas)
              FranjaDisponibilidad(
                inicio: f.inicio,
                fin: f.fin,
                disponible:
                    f.disponible && !_reservas.estaOcupado(id, f.inicio, f.fin),
              ),
          ],
        ),
    ]);
  }
}
