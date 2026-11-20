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
import '../../../domain/models/tramo_reserva.dart';

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
    _preseleccionarPrimerDiaCompleto();
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

  ModalidadReserva _modalidad = ModalidadReserva.porHoras;
  ModalidadReserva get modalidad => _modalidad;
  bool get porDias => _modalidad == ModalidadReserva.porDias;

  void cambiarModalidad(ModalidadReserva modalidad) {
    if (modalidad == _modalidad) return;
    _modalidad = modalidad;
    notifyListeners();
  }

  bool estaDisponible(FranjaDisponibilidad franja) =>
      franja.disponible && franja.inicio.isAfter(_referencia);

  bool haPasado(FranjaDisponibilidad franja) =>
      !franja.inicio.isAfter(_referencia);

  DateTime get referencia => _referencia;

  int _indiceDe(DateTime fecha) {
    final dia = DateTime(fecha.year, fecha.month, fecha.day);
    return dias.indexWhere((d) => d.fecha == dia);
  }

  // ---- Por horas: varias franjas de un mismo día ----

  int _indiceDia = 0;
  int get indiceDia => _indiceDia;
  DisponibilidadDia get diaSeleccionado => dias[_indiceDia];

  final Set<FranjaDisponibilidad> _franjas = {};
  bool estaSeleccionada(FranjaDisponibilidad franja) =>
      _franjas.contains(franja);

  List<bool> get diasConFranjaLibre => List.unmodifiable([
    for (final dia in dias) dia.franjas.any(estaDisponible),
  ]);

  bool tieneFranjaLibre(DateTime fecha) {
    final indice = _indiceDe(fecha);
    return indice >= 0 && dias[indice].franjas.any(estaDisponible);
  }

  void seleccionarFecha(DateTime fecha) => seleccionarDia(_indiceDe(fecha));

  void seleccionarDia(int indice) {
    if (indice < 0 || indice >= dias.length || indice == _indiceDia) return;
    final libre = _primeraLibre(dias[indice]);
    if (libre == null) return;
    _indiceDia = indice;
    _franjas
      ..clear()
      ..add(libre);
    notifyListeners();
  }

  void alternarFranja(FranjaDisponibilidad franja) {
    if (!estaDisponible(franja) || !diaSeleccionado.franjas.contains(franja)) {
      return;
    }
    if (!_franjas.remove(franja)) _franjas.add(franja);
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
        _franjas.add(libre);
        return;
      }
    }
  }

  // ---- Por días: días completos consecutivos ----

  DateTime? _desde;
  DateTime? _hasta;
  DateTime? get desde => _desde;
  DateTime? get hasta => _hasta;

  bool diaCompletoLibre(DateTime fecha) {
    final indice = _indiceDe(fecha);
    if (indice < 0) return false;
    final franjas = dias[indice].franjas;
    return franjas.isNotEmpty && franjas.every(estaDisponible);
  }

  /// Devuelve false si algún día del periodo no está completamente libre.
  bool seleccionarPeriodo(DateTime desde, DateTime hasta) {
    final dias = _diasEntre(desde, hasta);
    if (dias.isEmpty || !dias.every(diaCompletoLibre)) return false;
    _desde = dias.first;
    _hasta = dias.last;
    notifyListeners();
    return true;
  }

  List<DateTime> _diasEntre(DateTime desde, DateTime hasta) => [
    for (
      var dia = DateTime(desde.year, desde.month, desde.day);
      !dia.isAfter(hasta);
      dia = DateTime(dia.year, dia.month, dia.day + 1)
    )
      dia,
  ];

  void _preseleccionarPrimerDiaCompleto() {
    for (final dia in dias) {
      if (diaCompletoLibre(dia.fecha)) {
        _desde = dia.fecha;
        _hasta = dia.fecha;
        return;
      }
    }
  }

  // ---- Resultado de la selección ----

  List<TramoReserva> get tramos {
    if (porDias) {
      final desde = _desde;
      final hasta = _hasta;
      if (desde == null || hasta == null) return const [];
      return [
        for (final fecha in _diasEntre(desde, hasta))
          TramoReserva(
            inicio: dias[_indiceDe(fecha)].franjas.first.inicio,
            fin: dias[_indiceDe(fecha)].franjas.last.fin,
          ),
      ];
    }
    final elegidas = _franjas.toList()
      ..sort((a, b) => a.inicio.compareTo(b.inicio));
    return [
      for (final franja in elegidas)
        TramoReserva(inicio: franja.inicio, fin: franja.fin),
    ];
  }

  bool get puedeConfirmar => tramos.isNotEmpty;

  int get horas => tramos.fold(0, (total, tramo) => total + tramo.horas);
  int get numeroDias => porDias ? tramos.length : 0;

  int get tarifaCentimos =>
      porDias ? espacio.precioDiaCentimos : espacio.precioHoraCentimos;
  int get unidades => porDias ? numeroDias : horas;

  final Set<String> _seleccionados = {};
  bool estaSeleccionado(String id) => _seleccionados.contains(id);
  List<ServicioExtra> get seleccionados => List.unmodifiable(
    espacio.serviciosDisponibles.where((s) => _seleccionados.contains(s.id)),
  );
  int get subtotalAlquilerCentimos => tarifaCentimos * unidades;
  int get subtotalExtrasCentimos =>
      seleccionados.fold(0, (t, s) => t + s.precioCentimos);
  int get totalCentimos => subtotalAlquilerCentimos + subtotalExtrasCentimos;
  void alternarExtra(String id) {
    if (!espacio.serviciosDisponibles.any((s) => s.id == id)) return;
    if (!_seleccionados.remove(id)) _seleccionados.add(id);
    notifyListeners();
  }

  Reserva? confirmar() {
    if (!puedeConfirmar) return null;
    final solicitud = Reserva(
      id: 'solicitud',
      espacio: espacio,
      usuario: _usuariosRepository.obtenerUsuarioDemo(),
      actividad: actividad,
      modalidad: _modalidad,
      tramos: tramos,
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
      tarifaCentimos: tarifaCentimos,
      precioTotalCentimos: totalCentimos,
      moneda: espacio.moneda,
    );
    return _reservasRepository.registrar(solicitud);
  }
}
