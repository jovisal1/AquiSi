import '../../../data/repositories/espacios_repository.dart';
import '../../../data/repositories/usuarios_repository.dart';
import '../../../data/repositories/reservas_repository.dart';
import '../../../data/repositories/comentarios_repository.dart';
import '../../../data/repositories/disponibilidad_repository.dart';

import 'package:material_ui/material_ui.dart';

import '../../../domain/models/espacio.dart';
import '../../core/ui/controles/campo_texto.dart';
import '../../core/ui/espacios/espacio_tarjeta.dart';
import '../../core/ui/controles/insignia_usuario.dart';
import '../../core/ui/estructura/barra_superior.dart';
import '../../core/ui/estructura/scaffold_app.dart';
import '../../core/ui/estructura/panel.dart';
import '../../core/ui/controles/selector_segmentado.dart';
import '../../core/ui/textos/titulo_principal.dart';
import '../../core/ui/textos/titulo_seccion.dart';
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
    required this.alVerPerfil,
    required this.alVolverASeccion,
  });

  final VoidCallback alVerPerfil;
  final ValueChanged<int> alVolverASeccion;
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
      usuariosRepository: widget.usuariosRepository,
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
          alVolverASeccion: widget.alVolverASeccion,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _viewModel,
    builder: (context, child) => ScaffoldApp(
      titulo: 'Espacios',
      barra: BarraSuperior(
        avatar: InsigniaUsuario(
          iniciales: _viewModel.iniciales,
          alPulsar: widget.alVerPerfil,
        ),
      ),
      hijos: [
        const TituloPrincipal(
          'Haz sitio a tus planes.',
          subtitulo: 'Espacios cercanos. Posibilidades infinitas.',
        ),
        CampoTexto(
          etiqueta: 'Buscar espacios',
          icono: Icons.search,
          alCambiar: _viewModel.buscar,
        ),
        const SizedBox(height: 8),
        SelectorSegmentado(
          opciones: _viewModel.actividades,
          seleccionada: _viewModel.actividad,
          alSeleccionar: _viewModel.filtrarPorActividad,
        ),
        TituloSeccion(
          'Cerca de ti',
          subtitulo: '${_viewModel.espacios.length} espacios para compartir',
        ),
        if (_viewModel.espacios.isEmpty)
          const Panel(
            hijo: Text('No encontramos espacios para esta búsqueda.'),
          ),
        for (final e in _viewModel.espacios)
          Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: EspacioTarjeta(espacio: e, alAbrir: () => _abrirDetalle(e)),
          ),
      ],
    ),
  );
}
