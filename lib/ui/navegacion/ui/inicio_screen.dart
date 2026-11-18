import '../../../data/repositories/espacios_repository.dart';
import '../../../data/repositories/usuarios_repository.dart';
import '../../../data/repositories/reservas_repository.dart';
import '../../../data/repositories/comentarios_repository.dart';
import '../../../data/repositories/disponibilidad_repository.dart';

import 'package:material_ui/material_ui.dart';

import '../../core/ui/estructura/barra_navegacion.dart';
import '../../espacios/ui/espacios_screen.dart';
import '../../perfil/ui/perfil_screen.dart';
import '../../reservas/ui/mis_reservas_screen.dart';

class InicioScreen extends StatefulWidget {
  const InicioScreen({
    super.key,
    required this.espaciosRepository,
    required this.usuariosRepository,
    required this.reservasRepository,
    required this.comentariosRepository,
    required this.disponibilidadRepository,
    required this.fechaReferencia,
    required this.crearLogin,
  });
  final EspaciosRepository espaciosRepository;
  final UsuariosRepository usuariosRepository;
  final ReservasRepository reservasRepository;
  final ComentariosRepository comentariosRepository;
  final DisponibilidadRepository disponibilidadRepository;
  final DateTime fechaReferencia;

  final Widget Function() crearLogin;
  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  int _seccion = 0;

  /// Cambia al volver de un recorrido para que las secciones se vuelvan a
  /// crear y lean de nuevo los repositorios (por ejemplo, tras reservar).
  int _recargas = 0;

  void _cambiarSeccion(int seccion) => setState(() => _seccion = seccion);

  void _volverASeccion(int seccion) => setState(() {
    _seccion = seccion;
    _recargas++;
  });

  void _cerrarSesion() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (context) => widget.crearLogin()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    extendBody: true,
    body: IndexedStack(
      key: ValueKey(_recargas),
      index: _seccion,
      children: [
        EspaciosScreen(
          espaciosRepository: widget.espaciosRepository,
          usuariosRepository: widget.usuariosRepository,
          reservasRepository: widget.reservasRepository,
          comentariosRepository: widget.comentariosRepository,
          disponibilidadRepository: widget.disponibilidadRepository,
          fechaReferencia: widget.fechaReferencia,
          alVerPerfil: () => _cambiarSeccion(2),
          alVolverASeccion: _volverASeccion,
        ),
        MisReservasScreen(
          reservasRepository: widget.reservasRepository,
          usuariosRepository: widget.usuariosRepository,
          fechaReferencia: widget.fechaReferencia,
          alExplorar: () => _cambiarSeccion(0),
          alVerPerfil: () => _cambiarSeccion(2),
        ),
        PerfilScreen(
          usuariosRepository: widget.usuariosRepository,
          reservasRepository: widget.reservasRepository,
          comentariosRepository: widget.comentariosRepository,
          fechaReferencia: widget.fechaReferencia,
          alCerrarSesion: _cerrarSesion,
        ),
      ],
    ),
    bottomNavigationBar: BarraNavegacion(
      seleccionado: _seccion,
      alSeleccionar: _cambiarSeccion,
      destinos: const [
        DestinoNavegacion(
          icono: Icons.explore_outlined,
          iconoSeleccionado: Icons.explore,
          etiqueta: 'Explorar',
        ),
        DestinoNavegacion(
          icono: Icons.calendar_today_outlined,
          iconoSeleccionado: Icons.calendar_today,
          etiqueta: 'Mis reservas',
        ),
        DestinoNavegacion(
          icono: Icons.person_outline,
          iconoSeleccionado: Icons.person,
          etiqueta: 'Perfil',
        ),
      ],
    ),
  );
}
