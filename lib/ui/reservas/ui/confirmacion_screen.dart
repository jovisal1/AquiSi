import '../../../data/repositories/espacios_repository.dart';
import '../../../data/repositories/usuarios_repository.dart';
import '../../../data/repositories/reservas_repository.dart';
import '../../../data/repositories/comentarios_repository.dart';
import '../../../data/repositories/disponibilidad_repository.dart';

import 'package:material_ui/material_ui.dart';

import '../../../domain/models/reserva.dart';
import '../../core/ui/boton_accion.dart';
import '../../core/ui/pagina.dart';
import '../../core/ui/reserva_tarjeta.dart';
import '../../core/ui/titulo_seccion.dart';
import '../../navegacion/ui/inicio_screen.dart';
import '../view_models/confirmacion_view_model.dart';

class ConfirmacionScreen extends StatefulWidget {
  const ConfirmacionScreen({
    super.key,
    required this.espaciosRepository,
    required this.usuariosRepository,
    required this.reservasRepository,
    required this.comentariosRepository,
    required this.disponibilidadRepository,
    required this.fechaReferencia,
    required this.reserva,
  });
  final EspaciosRepository espaciosRepository;
  final UsuariosRepository usuariosRepository;
  final ReservasRepository reservasRepository;
  final ComentariosRepository comentariosRepository;
  final DisponibilidadRepository disponibilidadRepository;
  final DateTime fechaReferencia;
  final Reserva reserva;
  @override
  State<ConfirmacionScreen> createState() => _ConfirmacionScreenState();
}

class _ConfirmacionScreenState extends State<ConfirmacionScreen> {
  late final ConfirmacionViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ConfirmacionViewModel(reserva: widget.reserva);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void _verReservas() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(
        builder: (context) => InicioScreen(
          espaciosRepository: widget.espaciosRepository,
          usuariosRepository: widget.usuariosRepository,
          reservasRepository: widget.reservasRepository,
          comentariosRepository: widget.comentariosRepository,
          disponibilidadRepository: widget.disponibilidadRepository,
          fechaReferencia: widget.fechaReferencia,
          seccionInicial: 1,
        ),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _viewModel,
    builder: (context, child) => Pagina(
      titulo: 'Confirmación',
      hijos: [
        Icon(
          Icons.check_circle_outline,
          size: 72,
          color: Theme.of(context).colorScheme.primary,
        ),
        const TituloSeccion(
          '¡Todo listo!',
          subtitulo: 'Esta confirmación de ejemplo conserva tu selección. Las reservas precargadas permanecen sin cambios.',
        ),
        ReservaTarjeta(reserva: _viewModel.reserva, mostrarDesglose: true),
        BotonAccion(
          texto: 'Ir a mis reservas',
          icono: Icons.event_note_outlined,
          alPulsar: _verReservas,
        ),
      ],
    ),
  );
}
