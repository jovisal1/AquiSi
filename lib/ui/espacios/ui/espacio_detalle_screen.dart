import '../../../data/repositories/espacios_repository.dart';
import '../../../data/repositories/usuarios_repository.dart';
import '../../../data/repositories/reservas_repository.dart';
import '../../../data/repositories/comentarios_repository.dart';
import '../../../data/repositories/disponibilidad_repository.dart';

import 'package:material_ui/material_ui.dart';

import '../../../config/tema_app.dart';
import '../../core/formatos.dart';
import '../../core/ui/estructura/barra_accion_inferior.dart';
import '../../core/ui/controles/boton_accion.dart';
import '../../core/ui/reservas/contacto_panel.dart';
import '../../core/ui/espacios/espacio_tarjeta.dart';
import '../../core/ui/textos/etiqueta.dart';
import '../../core/ui/textos/fila_informacion.dart';
import '../../core/ui/controles/insignia_usuario.dart';
import '../../core/ui/estructura/barra_superior.dart';
import '../../core/ui/controles/selector_segmentado.dart';
import '../../core/ui/textos/titulo_seccion.dart';
import '../../reservas/ui/nueva_reserva_screen.dart';
import '../view_models/espacio_detalle_view_model.dart';
import 'cabecera_espacio.dart';
import 'disponibilidad_panel.dart';
import 'formulario_opinion.dart';
import 'galeria_espacio.dart';
import 'opiniones_panel.dart';

class EspacioDetalleScreen extends StatefulWidget {
  const EspacioDetalleScreen({
    super.key,
    required this.espaciosRepository,
    required this.usuariosRepository,
    required this.reservasRepository,
    required this.comentariosRepository,
    required this.disponibilidadRepository,
    required this.fechaReferencia,
    required this.espacioId,
    required this.alVolverASeccion,
  });
  final EspaciosRepository espaciosRepository;
  final UsuariosRepository usuariosRepository;
  final ReservasRepository reservasRepository;
  final ComentariosRepository comentariosRepository;
  final DisponibilidadRepository disponibilidadRepository;
  final DateTime fechaReferencia;
  final String espacioId;
  final ValueChanged<int> alVolverASeccion;
  @override
  State<EspacioDetalleScreen> createState() => _EspacioDetalleScreenState();
}

class _EspacioDetalleScreenState extends State<EspacioDetalleScreen> {
  late final EspacioDetalleViewModel _viewModel;

  static const _secciones = ['Incluye', 'Detalles', 'Contacto'];

  @override
  void initState() {
    super.initState();
    _viewModel = EspacioDetalleViewModel(
      espacioId: widget.espacioId,
      espaciosRepository: widget.espaciosRepository,
      usuariosRepository: widget.usuariosRepository,
      comentariosRepository: widget.comentariosRepository,
      disponibilidadRepository: widget.disponibilidadRepository,
      referencia: widget.fechaReferencia,
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void _reservar() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => NuevaReservaScreen(
          espaciosRepository: widget.espaciosRepository,
          usuariosRepository: widget.usuariosRepository,
          reservasRepository: widget.reservasRepository,
          disponibilidadRepository: widget.disponibilidadRepository,
          fechaReferencia: widget.fechaReferencia,
          espacioId: widget.espacioId,
          alVolverASeccion: widget.alVolverASeccion,
        ),
      ),
    );
  }

  void _irAPerfil() {
    Navigator.of(context).popUntil((ruta) => ruta.isFirst);
    widget.alVolverASeccion(2);
  }

  void _abrirFormularioOpinion() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: TemaApp.fondo,
      builder: (contextoHoja) => ListenableBuilder(
        listenable: _viewModel,
        builder: (contextoHoja, child) => Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            0,
            20,
            20 + MediaQuery.viewInsetsOf(contextoHoja).bottom,
          ),
          child: SafeArea(
            top: false,
            child: FormularioOpinion(
              nombreEspacio: _viewModel.espacio.nombre,
              puntuacion: _viewModel.puntuacion,
              textoInicial: _viewModel.textoOpinion,
              alPuntuar: _viewModel.cambiarPuntuacion,
              alEditar: _viewModel.editarOpinion,
              alPublicar: _viewModel.puedePublicar
                  ? () {
                      _viewModel.publicarOpinion();
                      Navigator.of(contextoHoja).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Opinión publicada')),
                      );
                    }
                  : null,
            ),
          ),
        ),
      ),
    );
  }

  static const double _alturaCabecera = 340;
  static const double _alturaCabeceraPlegada = 150;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _viewModel,
    builder: (context, child) {
      final e = _viewModel.espacio;
      final media = _viewModel.media;
      return Title(
        title: '${e.nombre} · espaireserva',
        color: TemaApp.acento,
        child: Scaffold(
          appBar: BarraSuperior(
            avatar: InsigniaUsuario(
              iniciales: _viewModel.iniciales,
              alPulsar: _irAPerfil,
            ),
          ),
          bottomNavigationBar: BarraAccionInferior(
            etiqueta: 'por hora · IVA incluido',
            valor: Formatos.dineroCorto(e.precioHoraCentimos, e.moneda),
            boton: BotonAccion(
              texto: 'Reservar',
              icono: Icons.event_available,
              alPulsar: _reservar,
              compacto: true,
            ),
          ),
          body: CustomScrollView(
            slivers: [
              // Cabecera de imagen que se pliega al desplazar y queda fija
              // con su altura mínima (toolbarHeight).
              SliverAppBar(
                primary: false,
                pinned: true,
                automaticallyImplyLeading: false,
                expandedHeight: _alturaCabecera,
                toolbarHeight: _alturaCabeceraPlegada,
                backgroundColor: TemaApp.tinta,
                surfaceTintColor: Colors.transparent,
                flexibleSpace: LayoutBuilder(
                  builder: (context, restricciones) {
                    final progreso =
                        ((_alturaCabecera - restricciones.maxHeight) /
                                (_alturaCabecera - _alturaCabeceraPlegada))
                            .clamp(0.0, 1.0);
                    return CabeceraEspacio(
                      galeria: GaleriaEspacio(
                        imagenes: e.imagenesAssets,
                        indice: _viewModel.imagenActual,
                        alCambiar: _viewModel.cambiarImagen,
                        heroTag: EspacioTarjeta.heroTag(e.id),
                        mostrarContador: progreso < 0.5,
                      ),
                      nombre: e.nombre,
                      ubicacion: e.ubicacion,
                      aforo: e.aforo,
                      media: media,
                      progreso: progreso,
                    );
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            e.descripcion,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 14),
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              for (final actividad in e.actividades)
                                Etiqueta(texto: actividad, color: TemaApp.acentoTexto),
                            ],
                          ),
                          const SizedBox(height: 20),
                          SelectorSegmentado(
                            opciones: _secciones,
                            seleccionada: _secciones[_viewModel.seccionInformacion],
                            alSeleccionar: (opcion) => _viewModel
                                .seleccionarSeccionInformacion(_secciones.indexOf(opcion)),
                            expandir: true,
                          ),
                          const SizedBox(height: 8),
                          AnimatedSize(
                            duration: const Duration(milliseconds: 220),
                            curve: Curves.easeOutCubic,
                            alignment: Alignment.topCenter,
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 220),
                              child: KeyedSubtree(
                                key: ValueKey(_viewModel.seccionInformacion),
                                child: switch (_viewModel.seccionInformacion) {
                                  0 => Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                      children: [
                                        for (final equipo in e.equipamiento)
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 6),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.check_circle_rounded,
                                                  size: 20,
                                                  color: TemaApp.exito,
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(child: Text(equipo)),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                    ),
                                  ),
                                  1 => Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                      children: [
                                        FilaInformacion(
                                          icono: Icons.schedule_rounded,
                                          etiqueta: 'Horario',
                                          valor: e.horario,
                                        ),
                                        const Divider(height: 1),
                                        FilaInformacion(
                                          icono: Icons.info_outline_rounded,
                                          etiqueta: 'Condiciones de uso',
                                          valor: e.condicionesUso,
                                          color: TemaApp.azul,
                                        ),
                                        const Divider(height: 1),
                                        FilaInformacion(
                                          icono: Icons.language_rounded,
                                          etiqueta: 'Sitio web',
                                          valor: e.sitioWeb ?? 'Sin sitio web',
                                          color: TemaApp.exito,
                                        ),
                                      ],
                                    ),
                                    ),
                                  ),
                                  _ => ContactoPanel(contacto: e.contacto),
                                },
                              ),
                            ),
                          ),
                          const TituloSeccion(
                            'Disponibilidad',
                            subtitulo: 'Próximos siete días',
                          ),
                          DisponibilidadPanel(
                            dias: _viewModel.disponibilidad,
                            indiceDia: _viewModel.indiceDia,
                            alSeleccionarDia: _viewModel.seleccionarDia,
                            estaDisponible: _viewModel.estaDisponible,
                            haPasado: _viewModel.haPasado,
                            referencia: _viewModel.referencia,
                          ),
                          const TituloSeccion('Opiniones'),
                          OpinionesPanel(
                            comentarios: _viewModel.comentarios,
                            media: media,
                            distribucion: _viewModel.distribucion,
                            referencia: _viewModel.referencia,
                            alEscribir: _abrirFormularioOpinion,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
