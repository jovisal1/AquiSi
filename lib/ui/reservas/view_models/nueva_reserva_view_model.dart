import 'package:flutter/foundation.dart';

import '../../../data/repositories/disponibilidad_repository.dart';
import '../../../data/repositories/espacios_repository.dart';
import '../../../data/repositories/reservas_repository.dart';
import '../../../data/repositories/usuarios_repository.dart';
import '../../../domain/models/disponibilidad_dia.dart';
import '../../../domain/models/espacio.dart';
import '../../../domain/models/franja_disponibilidad.dart';
import '../../../domain/models/reserva.dart';
import '../../../domain/models/servicio_contratado.dart';
import '../../../domain/models/servicio_extra.dart';

class NuevaReservaViewModel extends ChangeNotifier {
  NuevaReservaViewModel({
    required String espacioId,
    required EspaciosRepository espaciosRepository,
    required UsuariosRepository usuariosRepository,
    required DisponibilidadRepository disponibilidadRepository,
    required ReservasRepository reservasRepository,
    required DateTime referencia,
  }) : _usuariosRepository = usuariosRepository,
       _reservasRepository = reservasRepository,
       _referencia = referencia,
       espacio =
           espaciosRepository.obtenerPorId(espacioId) ??
           (throw StateError('Espacio inexistente')) {
    dias = disponibilidadRepository.obtenerDias(
      espacioId,
      referencia,
      diasReservables,
    );
    _preseleccionarPrimeraFranjaLibre();
  }

  final Espacio espacio;
  final UsuariosRepository _usuariosRepository;
  final ReservasRepository _reservasRepository;
  final DateTime _referencia;

  String get iniciales => _usuariosRepository.obtenerUsuarioDemo().iniciales;

  String get actividad => espacio.actividades.first;
  int get asistentes => espacio.aforo < 12 ? espacio.aforo : 12;

  static const diasReservables = 60;

  late final List<DisponibilidadDia> dias;

  DateTime get primerDia => dias.first.fecha;
  DateTime get ultimoDia => dias.last.fecha;

  int _indiceDia = 0;
  int get indiceDia => _indiceDia;
  DisponibilidadDia get diaSeleccionado => dias[_indiceDia];

  FranjaDisponibilidad? _franja;
  FranjaDisponibilidad? get franjaSeleccionada => _franja;
  bool get hayFranja => _franja != null;

  bool estaDisponible(FranjaDisponibilidad franja) =>
      franja.disponible && franja.inicio.isAfter(_referencia);

  DateTime get referencia => _referencia;

  bool haPasado(FranjaDisponibilidad franja) =>
      !franja.inicio.isAfter(_referencia);

  bool estaSeleccionada(FranjaDisponibilidad franja) =>
      identical(franja, _franja);

  List<bool> get diasConFranjaLibre => List.unmodifiable([
    for (final dia in dias) dia.franjas.any(estaDisponible),
  ]);

  int _indiceDe(DateTime fecha) {
    final dia = DateTime(fecha.year, fecha.month, fecha.day);
    return dias.indexWhere((d) => d.fecha == dia);
  }

  bool tieneFranjaLibre(DateTime fecha) {
    final indice = _indiceDe(fecha);
    return indice >= 0 && dias[indice].franjas.any(estaDisponible);
  }

  void seleccionarFecha(DateTime fecha) => seleccionarDia(_indiceDe(fecha));

  DateTime? get inicio => _franja?.inicio;
  DateTime? get fin => _franja?.fin;
  int get horas {
    final franja = _franja;
    return franja == null ? 0 : franja.fin.difference(franja.inicio).inHours;
  }

  void seleccionarDia(int indice) {
    if (indice < 0 || indice >= dias.length || indice == _indiceDia) return;
    if (!dias[indice].franjas.any(estaDisponible)) return;
    _indiceDia = indice;
    _franja = _primeraLibre(dias[indice]);
    notifyListeners();
  }

  void seleccionarFranja(FranjaDisponibilidad franja) {
    if (!estaDisponible(franja) || !diaSeleccionado.franjas.contains(franja)) {
      return;
    }
    _franja = franja;
    notifyListeners();
  }

  FranjaDisponibilidad? _primeraLibre(DisponibilidadDia dia) {
    for (final franja in dia.franjas) {
      if (estaDisponible(franja)) return franja;
    }
    return null;
  }

  void _preseleccionarPrimeraFranjaLibre() {
    for (var i = 0; i < dias.length; i++) {
      final libre = _primeraLibre(dias[i]);
      if (libre != null) {
        _indiceDia = i;
        _franja = libre;
        return;
      }
    }
  }

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

  Reserva? confirmar() {
    final franja = _franja;
    if (franja == null) return null;
    final solicitud = Reserva(
      id: 'solicitud',
      espacio: espacio,
      usuario: _usuariosRepository.obtenerUsuarioDemo(),
      actividad: actividad,
      inicio: franja.inicio,
      fin: franja.fin,
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
    return _reservasRepository.registrar(solicitud);
  }
}
