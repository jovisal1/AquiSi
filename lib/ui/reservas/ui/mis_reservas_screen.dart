import '../../../data/repositories/reservas_repository.dart';
import '../../../data/repositories/usuarios_repository.dart';

import 'package:material_ui/material_ui.dart';

import '../../core/ui/controles/enlace_accion.dart';
import '../../core/ui/controles/insignia_usuario.dart';
import '../../core/ui/estructura/barra_superior.dart';
import '../../core/ui/estructura/scaffold_app.dart';
import '../../core/ui/estructura/panel.dart';
import '../../core/ui/controles/selector_segmentado.dart';
import '../../core/ui/textos/titulo_principal.dart';
import '../view_models/mis_reservas_view_model.dart';
import 'reserva_ticket.dart';

class MisReservasScreen extends StatefulWidget {
  const MisReservasScreen({
    super.key,
    required this.reservasRepository,
    required this.usuariosRepository,
    required this.fechaReferencia,
    this.alExplorar,
    this.alVerPerfil,
  });
  final ReservasRepository reservasRepository;
  final UsuariosRepository usuariosRepository;
  final DateTime fechaReferencia;

  final VoidCallback? alExplorar;

  final VoidCallback? alVerPerfil;
  @override
  State<MisReservasScreen> createState() => _MisReservasScreenState();
}

class _MisReservasScreenState extends State<MisReservasScreen> {
  late final MisReservasViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = MisReservasViewModel(
      reservasRepository: widget.reservasRepository,
      usuariosRepository: widget.usuariosRepository,
      referencia: widget.fechaReferencia,
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _viewModel,
    builder: (context, child) {
      final opciones = [
        'Próximas · ${_viewModel.proximas.length}',
        'Historial · ${_viewModel.historial.length}',
      ];
      return ScaffoldApp(
        titulo: 'Mis reservas',
        barra: BarraSuperior(
          avatar: InsigniaUsuario(
            iniciales: _viewModel.iniciales,
            alPulsar: widget.alVerPerfil,
          ),
        ),
        hijos: [
          const TituloPrincipal(
            'Mis reservas',
            subtitulo: 'Toca una reserva para ver los extras y el contacto.',
          ),
          SelectorSegmentado(
            opciones: opciones,
            seleccionada: opciones[_viewModel.verHistorial ? 1 : 0],
            alSeleccionar: (opcion) =>
                _viewModel.mostrarHistorial(opcion == opciones[1]),
            expandir: true,
          ),
          const SizedBox(height: 16),
          if (_viewModel.visibles.isEmpty)
            Panel(
              hijo: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _viewModel.verHistorial
                        ? 'Aún no hay reservas en tu historial.'
                        : 'No tienes reservas próximas.',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Explora los espacios y prepara tu próximo encuentro.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  if (widget.alExplorar != null)
                    EnlaceAccion(
                      texto: 'Explorar espacios',
                      alPulsar: widget.alExplorar,
                    ),
                ],
              ),
            ),
          for (final r in _viewModel.visibles)
            ReservaTicket(
              reserva: r,
              desplegada: _viewModel.estaDesplegada(r.id),
              alPulsar: () => _viewModel.alternarDetalle(r.id),
              atenuada: _viewModel.verHistorial,
            ),
        ],
      );
    },
  );
}
