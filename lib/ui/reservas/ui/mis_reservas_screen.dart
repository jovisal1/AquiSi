import '../../../data/repositories/reservas_repository.dart';
import '../../../data/repositories/usuarios_repository.dart';

import 'package:material_ui/material_ui.dart';

import '../../core/ui/pagina.dart';
import '../../core/ui/panel.dart';
import '../../core/ui/reserva_tarjeta.dart';
import '../../core/ui/titulo_seccion.dart';
import '../view_models/mis_reservas_view_model.dart';

class MisReservasScreen extends StatefulWidget {
  const MisReservasScreen({
    super.key,
    required this.reservasRepository,
    required this.usuariosRepository,
  });
  final ReservasRepository reservasRepository;
  final UsuariosRepository usuariosRepository;
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
    builder: (context, child) => Pagina(
      titulo: 'Mis reservas',
      hijos: [
        const TituloSeccion(
          'Tus próximos encuentros',
          subtitulo: 'Consulta aquí tus reservas de ejemplo y el contacto de cada local.',
        ),
        if (_viewModel.reservas.isEmpty)
          const Panel(
            hijo: Text(
              'Todavía no tienes reservas. Explora los espacios para preparar un encuentro.',
            ),
          ),
        for (final r in _viewModel.reservas)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ReservaTarjeta(reserva: r),
          ),
      ],
    ),
  );
}
