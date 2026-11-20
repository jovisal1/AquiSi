import '../../domain/models/reserva.dart';
import '../../domain/models/tramo_reserva.dart';
import '../services/datos_simulados_service.dart';
import 'conversiones.dart';
import 'espacios_repository.dart';
import 'usuarios_repository.dart';

class ReservasRepository {
  ReservasRepository({
    required DatosSimuladosService service,
    required EspaciosRepository espacios,
    required UsuariosRepository usuarios,
  }) {
    final origen = service.leerReservas();
    comprobarIdentificadores(origen.map((r) => r.id));
    _reservas.addAll(
      origen.map((dto) {
        final espacio = espacios.obtenerPorId(dto.espacioId);
        final usuario = usuarios.obtenerPorId(dto.usuarioId);
        comprobar(
          espacio != null && usuario != null,
          'Referencia de reserva inexistente',
        );
        final inicio = DateTime.parse(dto.inicioIso);
        final fin = DateTime.parse(dto.finIso);
        final estado = switch (dto.codigoEstado) {
          'CONF' => EstadoReserva.confirmada,
          'PEND' => EstadoReserva.pendiente,
          'CANC' => EstadoReserva.cancelada,
          _ => throw FormatException('Estado desconocido'),
        };
        final servicios = dto.serviciosContratados
            .map(convertirServicioContratado)
            .toList();
        comprobarIdentificadores(servicios.map((s) => s.servicioId));
        comprobar(
          servicios.every(
            (s) =>
                s.precioCentimos >= 0 &&
                espacio!.serviciosDisponibles.any((e) => e.id == s.servicioId),
          ),
          'Extra ajeno al espacio o importe negativo',
        );
        final minutos = fin.difference(inicio).inMinutes;
        comprobar(
          fin.isAfter(inicio) &&
              inicio.year == fin.year &&
              inicio.month == fin.month &&
              inicio.day == fin.day &&
              minutos % 60 == 0 &&
              inicio.minute == 0 &&
              fin.minute == 0 &&
              inicio.second == 0 &&
              fin.second == 0 &&
              inicio.millisecond == 0 &&
              fin.millisecond == 0 &&
              inicio.microsecond == 0 &&
              fin.microsecond == 0,
          'Intervalo inválido',
        );
        comprobar(
          dto.asistentes > 0 &&
              dto.asistentes <= espacio!.aforo &&
              espacio.admiteActividad(dto.actividad),
          'Actividad o asistentes inválidos',
        );
        comprobar(
          dto.tarifaHoraCentimos >= 0 &&
              dto.moneda == espacio!.moneda &&
              dto.precioTotalCentimos ==
                  dto.tarifaHoraCentimos * (minutos ~/ 60) +
                      servicios.fold<int>(0, (t, s) => t + s.precioCentimos),
          'Importe incoherente',
        );
        return Reserva(
          id: dto.id,
          espacio: espacio!,
          usuario: usuario!,
          actividad: dto.actividad,
          modalidad: ModalidadReserva.porHoras,
          tramos: [TramoReserva(inicio: inicio, fin: fin)],
          asistentes: dto.asistentes,
          estado: estado,
          serviciosContratados: servicios,
          tarifaCentimos: dto.tarifaHoraCentimos,
          precioTotalCentimos: dto.precioTotalCentimos,
          moneda: dto.moneda,
        );
      }),
    );
  }
  final List<Reserva> _reservas = [];
  int _nuevas = 0;

  Reserva registrar(Reserva solicitud) {
    final tramos = solicitud.tramos;
    comprobar(tramos.isNotEmpty, 'Reserva sin horario');
    for (var i = 0; i < tramos.length; i++) {
      comprobar(tramos[i].fin.isAfter(tramos[i].inicio), 'Intervalo inválido');
      if (i > 0) {
        comprobar(
          !tramos[i].inicio.isBefore(tramos[i - 1].fin),
          'Tramos desordenados o solapados',
        );
      }
    }
    comprobar(
      !tramos.any(
        (t) => estaOcupado(solicitud.espacio.id, t.inicio, t.fin),
      ),
      'El horario ya está reservado',
    );
    comprobar(
      solicitud.precioTotalCentimos ==
          solicitud.alquilerCentimos + solicitud.totalServiciosCentimos,
      'Importe incoherente',
    );
    _nuevas++;
    final reserva = Reserva(
      id: 'app-$_nuevas',
      espacio: solicitud.espacio,
      usuario: solicitud.usuario,
      actividad: solicitud.actividad,
      modalidad: solicitud.modalidad,
      tramos: tramos,
      asistentes: solicitud.asistentes,
      estado: solicitud.estado,
      serviciosContratados: solicitud.serviciosContratados,
      tarifaCentimos: solicitud.tarifaCentimos,
      precioTotalCentimos: solicitud.precioTotalCentimos,
      moneda: solicitud.moneda,
    );
    _reservas.add(reserva);
    return reserva;
  }

  bool estaOcupado(String espacioId, DateTime inicio, DateTime fin) =>
      _reservas.any(
        (r) =>
            r.espacio.id == espacioId &&
            r.estado != EstadoReserva.cancelada &&
            r.tramos.any((t) => t.inicio.isBefore(fin) && inicio.isBefore(t.fin)),
      );

  List<Reserva> obtenerPorUsuario(String id) =>
      List.unmodifiable(_reservas.where((r) => r.usuario.id == id));
  Reserva? obtenerPorId(String id) {
    for (final r in _reservas) {
      if (r.id == id) return r;
    }
    return null;
  }
}
