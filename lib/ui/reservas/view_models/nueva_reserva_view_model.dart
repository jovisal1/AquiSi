import 'package:flutter/foundation.dart';

import '../../../data/repositories/espacios_repository.dart';
import '../../../data/repositories/usuarios_repository.dart';
import '../../../domain/models/espacio.dart';
import '../../../domain/models/reserva.dart';
import '../../../domain/models/servicio_contratado.dart';
import '../../../domain/models/servicio_extra.dart';

class NuevaReservaViewModel extends ChangeNotifier {
  NuevaReservaViewModel({
    required String espacioId,
    required EspaciosRepository espaciosRepository,
    required this._usuariosRepository,
    required DateTime referencia,
  }) : espacio =
           espaciosRepository.obtenerPorId(espacioId) ??
           (throw StateError('Espacio inexistente')) {
    inicio = DateTime(
      referencia.year,
      referencia.month,
      referencia.day + 1,
      10,
    );
    fin = DateTime(referencia.year, referencia.month, referencia.day + 1, 12);
  }
  final Espacio espacio;
  final UsuariosRepository _usuariosRepository;
  late final DateTime inicio;
  late final DateTime fin;
  String get actividad => espacio.actividades.first;
  int get asistentes => espacio.aforo < 12 ? espacio.aforo : 12;
  int get horas => fin.difference(inicio).inHours;
  final Set<String> _seleccionados = {};
  bool estaSeleccionado(String id) => _seleccionados.contains(id);
  List<ServicioExtra> get seleccionados => List.unmodifiable(
    espacio.serviciosDisponibles.where((s) => _seleccionados.contains(s.id)),
  );
  int get subtotalAlquilerCentimos => espacio.precioHoraCentimos * horas;
  int get subtotalExtrasCentimos =>
      seleccionados.fold(0, (t, s) => t + s.precioCentimos);
  int get totalCentimos => subtotalAlquilerCentimos + subtotalExtrasCentimos;
  void alternarExtra(String id) {
    if (!espacio.serviciosDisponibles.any((s) => s.id == id)) return;
    if (!_seleccionados.remove(id)) _seleccionados.add(id);
    notifyListeners();
  }

  Reserva confirmar() => Reserva(
    id: 'solicitud',
    espacio: espacio,
    usuario: _usuariosRepository.obtenerUsuarioDemo(),
    actividad: actividad,
    inicio: inicio,
    fin: fin,
    asistentes: asistentes,
    estado: EstadoReserva.confirmada,
    serviciosContratados: seleccionados
        .map(
          (s) => ServicioContratado(
            servicioId: s.id,
            nombre: s.nombre,
            precioCentimos: s.precioCentimos,
          ),
        )
        .toList(),
    tarifaHoraCentimos: espacio.precioHoraCentimos,
    precioTotalCentimos: totalCentimos,
    moneda: espacio.moneda,
  );
}
