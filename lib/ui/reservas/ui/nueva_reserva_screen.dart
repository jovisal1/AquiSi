import '../../../data/repositories/espacios_repository.dart';
import '../../../data/repositories/usuarios_repository.dart';
import '../../../data/repositories/reservas_repository.dart';
import '../../../data/repositories/comentarios_repository.dart';
import '../../../data/repositories/disponibilidad_repository.dart';

import 'package:material_ui/material_ui.dart';

import '../../../domain/models/reserva.dart';
import '../../core/formatos.dart';
import '../../core/ui/boton_accion.dart';
import '../../core/ui/campo_texto.dart';
import '../../core/ui/contacto_panel.dart';
import '../../core/ui/fila_importe.dart';
import '../../core/ui/pagina.dart';
import '../../core/ui/panel.dart';
import '../../core/ui/titulo_seccion.dart';
import '../view_models/nueva_reserva_view_model.dart';
import 'confirmacion_screen.dart';

class NuevaReservaScreen extends StatefulWidget {
  const NuevaReservaScreen({
    super.key,
    required this.espaciosRepository,
    required this.usuariosRepository,
    required this.reservasRepository,
    required this.comentariosRepository,
    required this.disponibilidadRepository,
    required this.fechaReferencia,
    required this.espacioId,
  });
  final EspaciosRepository espaciosRepository;
  final UsuariosRepository usuariosRepository;
  final ReservasRepository reservasRepository;
  final ComentariosRepository comentariosRepository;
  final DisponibilidadRepository disponibilidadRepository;
  final DateTime fechaReferencia;
  final String espacioId;
  @override
  State<NuevaReservaScreen> createState() => _NuevaReservaScreenState();
}

class _NuevaReservaScreenState extends State<NuevaReservaScreen> {
  late final NuevaReservaViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = NuevaReservaViewModel(
      espacioId: widget.espacioId,
      espaciosRepository: widget.espaciosRepository,
      usuariosRepository: widget.usuariosRepository,
      referencia: widget.fechaReferencia,
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void _confirmar(Reserva reserva) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (context) => ConfirmacionScreen(
          espaciosRepository: widget.espaciosRepository,
          usuariosRepository: widget.usuariosRepository,
          reservasRepository: widget.reservasRepository,
          comentariosRepository: widget.comentariosRepository,
          disponibilidadRepository: widget.disponibilidadRepository,
          fechaReferencia: widget.fechaReferencia,
          reserva: reserva,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _viewModel,
    builder: (context, child) => Pagina(
      titulo: 'Nueva reserva',
      hijos: [
        TituloSeccion(
          _viewModel.espacio.nombre,
          subtitulo: _viewModel.espacio.ubicacion,
        ),
        const Text('Prepara tu encuentro con esta propuesta de reserva.'),
        CampoTexto(
          etiqueta: 'Actividad',
          inicial: _viewModel.actividad,
          soloLectura: true,
          icono: Icons.celebration_outlined,
        ),
        CampoTexto(
          etiqueta: 'Fecha',
          inicial: Formatos.fecha(_viewModel.inicio),
          soloLectura: true,
          icono: Icons.event_outlined,
        ),
        Row(
          children: [
            Expanded(
              child: CampoTexto(
                etiqueta: 'Hora de inicio',
                inicial: Formatos.hora(_viewModel.inicio),
                soloLectura: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CampoTexto(
                etiqueta: 'Hora de fin',
                inicial: Formatos.hora(_viewModel.fin),
                soloLectura: true,
              ),
            ),
          ],
        ),
        CampoTexto(
          etiqueta: 'Número de asistentes',
          inicial: '${_viewModel.asistentes}',
          soloLectura: true,
          icono: Icons.people_outline,
        ),
        const TituloSeccion(
          'Dale un extra a tu encuentro',
          subtitulo: 'Precio final por reserva, IVA incluido.',
        ),
        for (final servicio in _viewModel.espacio.serviciosDisponibles)
          Card(
            child: CheckboxListTile(
              value: _viewModel.estaSeleccionado(servicio.id),
              onChanged: (_) => _viewModel.alternarExtra(servicio.id),
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(servicio.nombre),
              subtitle: Text(
                '${servicio.descripcion}\n${Formatos.dinero(servicio.precioCentimos, _viewModel.espacio.moneda)}',
              ),
            ),
          ),
        const TituloSeccion('Tu resumen'),
        Panel(
          hijo: Column(
            children: [
              FilaImporte(
                etiqueta: 'Duración',
                importe: '${_viewModel.horas} horas',
              ),
              FilaImporte(
                etiqueta: 'Tarifa por hora',
                importe: Formatos.dinero(
                  _viewModel.espacio.precioHoraCentimos,
                  _viewModel.espacio.moneda,
                ),
              ),
              FilaImporte(
                etiqueta: 'Subtotal de alquiler',
                importe: Formatos.dinero(
                  _viewModel.subtotalAlquilerCentimos,
                  _viewModel.espacio.moneda,
                ),
              ),
              for (final s in _viewModel.seleccionados)
                FilaImporte(
                  etiqueta: s.nombre,
                  importe: Formatos.dinero(
                    s.precioCentimos,
                    _viewModel.espacio.moneda,
                  ),
                ),
              FilaImporte(
                etiqueta: 'Subtotal de extras',
                importe: Formatos.dinero(
                  _viewModel.subtotalExtrasCentimos,
                  _viewModel.espacio.moneda,
                ),
              ),
              const Divider(),
              FilaImporte(
                etiqueta: 'Total · IVA incluido',
                importe: Formatos.dinero(
                  _viewModel.totalCentimos,
                  _viewModel.espacio.moneda,
                ),
                destacada: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ContactoPanel(contacto: _viewModel.espacio.contacto),
        const SizedBox(height: 16),
        BotonAccion(
          texto: 'Confirmar reserva',
          icono: Icons.check,
          alPulsar: () => _confirmar(_viewModel.confirmar()),
        ),
      ],
    ),
  );
}
