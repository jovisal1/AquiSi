import '../../../data/repositories/espacios_repository.dart';
import '../../../data/repositories/usuarios_repository.dart';
import '../../../data/repositories/reservas_repository.dart';
import '../../../data/repositories/disponibilidad_repository.dart';

import 'package:material_ui/material_ui.dart';

import '../../../domain/models/franja_disponibilidad.dart';
import '../../../domain/models/reserva.dart';
import '../../../config/tema_app.dart';
import '../../core/formatos.dart';
import '../../core/ui/estructura/barra_accion_inferior.dart';
import '../../core/ui/controles/boton_accion.dart';
import '../../core/ui/reservas/contacto_panel.dart';
import '../../core/ui/textos/dato_icono.dart';
import '../../core/ui/reservas/fila_importe.dart';
import '../../core/ui/reservas/fila_franja.dart';
import '../../core/ui/reservas/indicador_pasos.dart';
import '../../core/ui/controles/insignia_usuario.dart';
import '../../core/ui/controles/selector_segmentado.dart';
import '../../core/ui/estructura/barra_superior.dart';
import '../../core/ui/estructura/scaffold_app.dart';
import '../../core/ui/reservas/selector_dia.dart';
import '../../core/ui/textos/titulo_principal.dart';
import '../../core/ui/textos/titulo_seccion.dart';
import '../view_models/nueva_reserva_view_model.dart';
import 'confirmacion_screen.dart';
import 'opcion_extra.dart';

class NuevaReservaScreen extends StatefulWidget {
  const NuevaReservaScreen({
    super.key,
    required this.espaciosRepository,
    required this.usuariosRepository,
    required this.reservasRepository,
    required this.disponibilidadRepository,
    required this.fechaReferencia,
    required this.espacioId,
    required this.alVolverASeccion,
  });
  final EspaciosRepository espaciosRepository;
  final UsuariosRepository usuariosRepository;
  final ReservasRepository reservasRepository;
  final DisponibilidadRepository disponibilidadRepository;
  final DateTime fechaReferencia;
  final String espacioId;
  final ValueChanged<int> alVolverASeccion;
  @override
  State<NuevaReservaScreen> createState() => _NuevaReservaScreenState();
}

class _NuevaReservaScreenState extends State<NuevaReservaScreen> {
  late final NuevaReservaViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 700), () {
      if (mounted) _aceptaToques = true;
    });
    _viewModel = NuevaReservaViewModel(
      espacioId: widget.espacioId,
      espaciosRepository: widget.espaciosRepository,
      usuariosRepository: widget.usuariosRepository,
      disponibilidadRepository: widget.disponibilidadRepository,
      reservasRepository: widget.reservasRepository,
      referencia: widget.fechaReferencia,
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  /// Evita que un doble toque en «Reservar» (detalle) confirme la reserva
  /// sin haberla visto: el botón ignora toques durante el primer instante.
  bool _aceptaToques = false;

  void _confirmar() {
    if (!_aceptaToques) return;
    final reserva = _viewModel.confirmar();
    if (reserva == null) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (context) => ConfirmacionScreen(
          reserva: reserva,
          alVolverASeccion: widget.alVolverASeccion,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _viewModel,
    builder: (context, child) {
      final espacio = _viewModel.espacio;
      String dinero(int centimos) => Formatos.dinero(centimos, espacio.moneda);

      return ScaffoldApp(
        titulo: 'Nueva reserva',
        // Sin acción: salir al perfil a mitad de la reserva la perdería.
        barra: BarraSuperior(
          avatar: InsigniaUsuario(iniciales: _viewModel.iniciales),
        ),
        accionInferior: BarraAccionInferior(
          etiqueta: _resumenSeleccion(),
          valor: dinero(_viewModel.totalCentimos),
          boton: BotonAccion(
            texto: 'Confirmar',
            icono: Icons.check,
            alPulsar: _viewModel.puedeConfirmar ? _confirmar : null,
            compacto: true,
          ),
        ),
        hijos: [
          const IndicadorPasos(paso: 2, total: 3),
          TituloPrincipal(
            espacio.nombre,
            antetitulo: 'Fechas, extras y resumen',
            subtitulo: espacio.ubicacion,
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  DatoIcono(
                    icono: Icons.celebration_outlined,
                    texto: _viewModel.actividad,
                  ),
                  DatoIcono(
                    icono: Icons.people_outline,
                    texto: '${_viewModel.asistentes} asistentes',
                  ),
                ],
              ),
            ),
          ),
          TituloSeccion(
            '¿Cuándo?',
            subtitulo: _viewModel.porDias
                ? 'Días completos seguidos, con todas sus franjas libres.'
                : 'Una o varias franjas del mismo día.',
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SelectorSegmentado(
                    opciones: _modalidades,
                    seleccionada: _modalidades[_viewModel.modalidad.index],
                    alSeleccionar: (opcion) => _viewModel.cambiarModalidad(
                      ModalidadReserva.values[_modalidades.indexOf(opcion)],
                    ),
                    expandir: true,
                  ),
                  const SizedBox(height: 16),
                  if (_viewModel.porDias)
                    ..._seleccionDias()
                  else
                    ..._seleccionHoras(),
                ],
              ),
            ),
          ),
          const TituloSeccion(
            'Dale un extra a tu encuentro',
            subtitulo: 'Precio final por reserva, IVA incluido.',
          ),
          for (final servicio in espacio.serviciosDisponibles)
            OpcionExtra(
              titulo: servicio.nombre,
              descripcion: servicio.descripcion,
              precio: dinero(servicio.precioCentimos),
              seleccionada: _viewModel.estaSeleccionado(servicio.id),
              alPulsar: () => _viewModel.alternarExtra(servicio.id),
            ),
          const TituloSeccion('Tu resumen'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (_viewModel.puedeConfirmar)
                    FilaImporte(
                      etiqueta: 'Cuándo',
                      importe: _resumenSeleccion(),
                    ),
                  FilaImporte(
                    etiqueta: _viewModel.porDias
                        ? 'Tarifa por día'
                        : 'Tarifa por hora',
                    importe: dinero(_viewModel.tarifaCentimos),
                  ),
                  FilaImporte(
                    etiqueta: _viewModel.porDias
                        ? 'Alquiler · ${Formatos.cantidad(_viewModel.numeroDias, 'día', 'días')}'
                        : 'Alquiler · ${Formatos.cantidad(_viewModel.horas, 'hora', 'horas')}',
                    importe: dinero(_viewModel.subtotalAlquilerCentimos),
                  ),
                  for (final s in _viewModel.seleccionados)
                    FilaImporte(
                      etiqueta: s.nombre,
                      importe: dinero(s.precioCentimos),
                    ),
                  FilaImporte(
                    etiqueta: 'Subtotal de extras',
                    importe: dinero(_viewModel.subtotalExtrasCentimos),
                  ),
                  const Divider(),
                  FilaImporte(
                    etiqueta: 'Total · IVA incluido',
                    importe: dinero(_viewModel.totalCentimos),
                    destacada: true,
                  ),
                ],
              ),
            ),
          ),
          const TituloSeccion('Contacto del local'),
          ContactoPanel(contacto: espacio.contacto),
        ],
      );
    },
  );

  static const _modalidades = ['Por horas', 'Días completos'];

  String _resumenSeleccion() {
    final tramos = _viewModel.tramos;
    if (tramos.isEmpty) {
      return _viewModel.porDias ? 'Elige los días' : 'Elige una o más franjas';
    }
    return Formatos.cuando(_viewModel.modalidad, tramos);
  }

  List<Widget> _seleccionHoras() => [
    Row(
      children: [
        Expanded(
          child: Text(
            Formatos.mesAnyo(_viewModel.diaSeleccionado.fecha),
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: TemaApp.tinta,
            ),
          ),
        ),
        TextButton.icon(
          onPressed: _abrirCalendario,
          icon: const Icon(Icons.calendar_month_outlined, size: 18),
          label: const Text('Ver calendario'),
          style: TextButton.styleFrom(
            foregroundColor: TemaApp.acentoTexto,
            minimumSize: const Size(48, 40),
          ),
        ),
      ],
    ),
    const SizedBox(height: 8),
    SelectorDia(
      dias: [for (final dia in _viewModel.dias) dia.fecha],
      seleccionado: _viewModel.indiceDia,
      habilitados: _viewModel.diasConFranjaLibre,
      alSeleccionar: _viewModel.seleccionarDia,
      referencia: _viewModel.referencia,
    ),
    const SizedBox(height: 8),
    for (final franja in _franjasVisibles()) _filaFranja(franja),
  ];

  List<Widget> _seleccionDias() {
    final desde = _viewModel.desde;
    final hasta = _viewModel.hasta;
    return [
      Row(
        children: [
          const Icon(Icons.date_range_outlined, color: TemaApp.acentoTexto),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              desde == null || hasta == null
                  ? 'No hay días completos libres'
                  : Formatos.periodo(desde, hasta),
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: TemaApp.tinta,
              ),
            ),
          ),
          TextButton(
            onPressed: desde == null ? null : _elegirPeriodo,
            style: TextButton.styleFrom(
              foregroundColor: TemaApp.acentoTexto,
              minimumSize: const Size(48, 44),
            ),
            child: const Text('Cambiar'),
          ),
        ],
      ),
    ];
  }

  Future<void> _elegirPeriodo() async {
    final periodo = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(
        start: _viewModel.desde!,
        end: _viewModel.hasta!,
      ),
      firstDate: _viewModel.primerDia,
      lastDate: _viewModel.ultimoDia,
      currentDate: _viewModel.referencia,
      helpText: 'Elige los días',
      saveText: 'Aceptar',
      selectableDayPredicate: (dia, _, _) => _viewModel.diaCompletoLibre(dia),
    );
    if (periodo == null || !mounted) return;
    if (!_viewModel.seleccionarPeriodo(periodo.start, periodo.end)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'El periodo incluye días con franjas ocupadas. Elige días seguidos libres.',
          ),
        ),
      );
    }
  }

  void _abrirCalendario() {
    final seleccionado = _viewModel.diaSeleccionado.fecha;
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: TemaApp.fondo,
      builder: (contextoHoja) => SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: CalendarDatePicker(
            initialDate: _viewModel.tieneFranjaLibre(seleccionado)
                ? seleccionado
                : null,
            firstDate: _viewModel.primerDia,
            lastDate: _viewModel.ultimoDia,
            currentDate: _viewModel.referencia,
            selectableDayPredicate: _viewModel.tieneFranjaLibre,
            onDateChanged: (dia) {
              _viewModel.seleccionarFecha(dia);
              Navigator.of(contextoHoja).pop();
            },
          ),
        ),
      ),
    );
  }

  List<FranjaDisponibilidad> _franjasVisibles() => [
    for (final franja in _viewModel.diaSeleccionado.franjas)
      if (!_viewModel.haPasado(franja)) franja,
  ];

  Widget _filaFranja(FranjaDisponibilidad franja) => FilaFranja(
    horario: Formatos.intervalo(franja.inicio, franja.fin),
    estado: _viewModel.estaDisponible(franja)
        ? EstadoFranja.libre
        : EstadoFranja.ocupada,
    seleccionada: _viewModel.estaSeleccionada(franja),
    alPulsar: () => _viewModel.alternarFranja(franja),
  );
}
