import '../../../data/repositories/espacios_repository.dart';
import '../../../data/repositories/usuarios_repository.dart';
import '../../../data/repositories/reservas_repository.dart';
import '../../../data/repositories/comentarios_repository.dart';
import '../../../data/repositories/disponibilidad_repository.dart';

import 'package:material_ui/material_ui.dart';

import '../../core/formatos.dart';
import '../../core/ui/boton_accion.dart';
import '../../core/ui/contacto_panel.dart';
import '../../core/ui/dato_icono.dart';
import '../../core/ui/etiqueta.dart';
import '../../core/ui/fila_importe.dart';
import '../../core/ui/pagina.dart';
import '../../core/ui/titulo_seccion.dart';
import '../../reservas/ui/nueva_reserva_screen.dart';
import '../view_models/espacio_detalle_view_model.dart';
import 'disponibilidad_panel.dart';
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
  });
  final EspaciosRepository espaciosRepository;
  final UsuariosRepository usuariosRepository;
  final ReservasRepository reservasRepository;
  final ComentariosRepository comentariosRepository;
  final DisponibilidadRepository disponibilidadRepository;
  final DateTime fechaReferencia;
  final String espacioId;
  @override
  State<EspacioDetalleScreen> createState() => _EspacioDetalleScreenState();
}

class _EspacioDetalleScreenState extends State<EspacioDetalleScreen> {
  late final EspacioDetalleViewModel _viewModel;

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
          comentariosRepository: widget.comentariosRepository,
          disponibilidadRepository: widget.disponibilidadRepository,
          fechaReferencia: widget.fechaReferencia,
          espacioId: widget.espacioId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _viewModel,
    builder: (context, child) {
      final e = _viewModel.espacio;
      return Pagina(
        titulo: e.nombre,
        hijos: [
          GaleriaEspacio(
            imagenes: e.imagenesAssets,
            nombre: e.nombre,
            indice: _viewModel.imagenActual,
            alCambiar: _viewModel.cambiarImagen,
          ),
          TituloSeccion(e.nombre, subtitulo: e.descripcion),
          DatoIcono(icono: Icons.place_outlined, texto: e.ubicacion),
          DatoIcono(
            icono: Icons.people_outline,
            texto: 'Hasta ${e.aforo} personas',
          ),
          Wrap(
            spacing: 8,
            children: [
              for (final actividad in e.actividades) Etiqueta(texto: actividad),
            ],
          ),
          FilaImporte(
            etiqueta: 'Tarifa por hora · IVA incluido',
            importe: Formatos.dinero(e.precioHoraCentimos, e.moneda),
            destacada: true,
          ),
          BotonAccion(
            texto: 'Reservar este espacio',
            icono: Icons.event_available,
            alPulsar: _reservar,
          ),
          const TituloSeccion(
            'Todo lo que necesitas',
            subtitulo: 'Equipamiento incluido en la tarifa',
          ),
          for (final equipo in e.equipamiento)
            DatoIcono(icono: Icons.check_circle_outline, texto: equipo),
          const TituloSeccion('Antes de venir'),
          DatoIcono(icono: Icons.schedule, texto: e.horario),
          DatoIcono(icono: Icons.info_outline, texto: e.condicionesUso),
          DatoIcono(
            icono: Icons.language,
            texto: e.sitioWeb ?? 'Sin sitio web',
          ),
          const SizedBox(height: 16),
          ContactoPanel(contacto: e.contacto),
          const TituloSeccion(
            'Los próximos siete días',
            subtitulo: 'Disponibilidad simulada',
          ),
          DisponibilidadPanel(dias: _viewModel.disponibilidad),
          const TituloSeccion('Lo que dicen de este espacio'),
          OpinionesPanel(
            comentarios: _viewModel.comentarios,
            media: _viewModel.media,
            puntuacion: _viewModel.puntuacion,
            alPuntuar: _viewModel.cambiarPuntuacion,
            alEditar: _viewModel.editarOpinion,
            alPublicar: _viewModel.puedePublicar
                ? _viewModel.publicarOpinion
                : null,
          ),
          const SizedBox(height: 24),
          BotonAccion(texto: 'Reservar ${e.nombre}', alPulsar: _reservar),
        ],
      );
    },
  );
}
