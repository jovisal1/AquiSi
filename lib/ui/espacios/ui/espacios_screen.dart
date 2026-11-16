import '../../../data/repositories/espacios_repository.dart';
import '../../../data/repositories/usuarios_repository.dart';
import '../../../data/repositories/reservas_repository.dart';
import '../../../data/repositories/comentarios_repository.dart';
import '../../../data/repositories/disponibilidad_repository.dart';

import 'package:material_ui/material_ui.dart';

import '../../../domain/models/espacio.dart';
import '../../core/ui/campo_texto.dart';
import '../../core/ui/espacio_tarjeta.dart';
import '../../core/ui/pagina.dart';
import '../../core/ui/panel.dart';
import '../../core/ui/titulo_seccion.dart';
import '../view_models/espacios_view_model.dart';
import 'espacio_detalle_screen.dart';

class EspaciosScreen extends StatefulWidget {
  const EspaciosScreen({
    super.key,
    required this.espaciosRepository,
    required this.usuariosRepository,
    required this.reservasRepository,
    required this.comentariosRepository,
    required this.disponibilidadRepository,
    required this.fechaReferencia,
  });
  final EspaciosRepository espaciosRepository;
  final UsuariosRepository usuariosRepository;
  final ReservasRepository reservasRepository;
  final ComentariosRepository comentariosRepository;
  final DisponibilidadRepository disponibilidadRepository;
  final DateTime fechaReferencia;
  @override
  State<EspaciosScreen> createState() => _EspaciosScreenState();
}

class _EspaciosScreenState extends State<EspaciosScreen> {
  late final EspaciosViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = EspaciosViewModel(
      espaciosRepository: widget.espaciosRepository,
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void _abrirDetalle(Espacio espacio) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => EspacioDetalleScreen(
          espaciosRepository: widget.espaciosRepository,
          usuariosRepository: widget.usuariosRepository,
          reservasRepository: widget.reservasRepository,
          comentariosRepository: widget.comentariosRepository,
          disponibilidadRepository: widget.disponibilidadRepository,
          fechaReferencia: widget.fechaReferencia,
          espacioId: espacio.id,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _viewModel,
    builder: (context, child) => Pagina(
      titulo: 'EspaiReserva',
      hijos: [
        Text(
          'Haz sitio a tus planes.',
          style: Theme.of(context).textTheme.headlineMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text('Espacios cercanos. Posibilidades infinitas.'),
        CampoTexto(
          etiqueta: 'Buscar un espacio o ubicación',
          icono: Icons.search,
          alCambiar: _viewModel.buscar,
        ),
        TituloSeccion(
          'Explora los espacios',
          subtitulo: '${_viewModel.espacios.length} espacios para compartir',
        ),
        if (_viewModel.espacios.isEmpty)
          const Panel(
            hijo: Text('No encontramos espacios para esta búsqueda.'),
          ),
        for (final e in _viewModel.espacios)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: EspacioTarjeta(espacio: e, alAbrir: () => _abrirDetalle(e)),
          ),
      ],
    ),
  );
}
