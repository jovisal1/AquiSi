import '../../../data/repositories/espacios_repository.dart';
import '../../../data/repositories/usuarios_repository.dart';
import '../../../data/repositories/reservas_repository.dart';
import '../../../data/repositories/disponibilidad_repository.dart';

import 'package:material_ui/material_ui.dart';

import '../../../domain/models/franja_disponibilidad.dart';
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
      final inicio = _viewModel.inicio;
      final fin = _viewModel.fin;
      String dinero(int centimos) => Formatos.dinero(centimos, espacio.moneda);

      return ScaffoldApp(
        titulo: 'Nueva reserva',
        // Sin acción: salir al perfil a mitad de la reserva la perdería.
        barra: BarraSuperior(
          avatar: InsigniaUsuario(iniciales: _viewModel.iniciales),
        ),
        accionInferior: BarraAccionInferior(
          etiqueta: inicio == null || fin == null
              ? 'Elige una franja libre'
              : '${Formatos.diaCorto(inicio)} · ${Formatos.intervalo(inicio, fin)}',
          valor: dinero(_viewModel.totalCentimos),
          boton: BotonAccion(
            texto: 'Confirmar',
            icono: Icons.check,
            alPulsar: _viewModel.hayFranja ? _confirmar : null,
            compacto: true,
          ),
        ),
        hijos: [
          const IndicadorPasos(paso: 2, total: 3),
          TituloPrincipal(
            espacio.nombre,
            antetitulo: 'Día y hora, extras y resumen',
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
          const TituloSeccion(
            'Elige día y hora',
            subtitulo: 'Hasta dos meses vista. Los días con punto tienen huecos.',
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
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
                  if (!_viewModel.hayFranja)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'No quedan franjas libres en los próximos '
                        '${NuevaReservaViewModel.diasReservables} días.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    )
                  else
                    for (final franja in _franjasVisibles()) _filaFranja(franja),
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
                  if (inicio != null && fin != null)
                    FilaImporte(
                      etiqueta: 'Fecha y horario',
                      importe:
                          '${Formatos.fecha(inicio)} · ${Formatos.intervalo(inicio, fin)}',
                    ),
                  FilaImporte(
                    etiqueta: 'Tarifa por hora',
                    importe: dinero(espacio.precioHoraCentimos),
                  ),
                  FilaImporte(
                    etiqueta: 'Alquiler · ${_viewModel.horas} horas',
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
    alPulsar: () => _viewModel.seleccionarFranja(franja),
  );
}
