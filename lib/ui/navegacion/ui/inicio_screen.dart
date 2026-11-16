import '../../../data/repositories/espacios_repository.dart';
import '../../../data/repositories/usuarios_repository.dart';
import '../../../data/repositories/reservas_repository.dart';
import '../../../data/repositories/comentarios_repository.dart';
import '../../../data/repositories/disponibilidad_repository.dart';

import 'package:material_ui/material_ui.dart';

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
    this.seccionInicial = 0,
  });
  final EspaciosRepository espaciosRepository;
  final UsuariosRepository usuariosRepository;
  final ReservasRepository reservasRepository;
  final ComentariosRepository comentariosRepository;
  final DisponibilidadRepository disponibilidadRepository;
  final DateTime fechaReferencia;
  final int seccionInicial;
  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  late int _seccion;
  late final List<Widget> _pantallas;
  @override
  void initState() {
    super.initState();
    _seccion = widget.seccionInicial;
    _pantallas = [
      EspaciosScreen(
        espaciosRepository: widget.espaciosRepository,
        usuariosRepository: widget.usuariosRepository,
        reservasRepository: widget.reservasRepository,
        comentariosRepository: widget.comentariosRepository,
        disponibilidadRepository: widget.disponibilidadRepository,
        fechaReferencia: widget.fechaReferencia,
      ),
      MisReservasScreen(
        reservasRepository: widget.reservasRepository,
        usuariosRepository: widget.usuariosRepository,
      ),
      PerfilScreen(
        espaciosRepository: widget.espaciosRepository,
        usuariosRepository: widget.usuariosRepository,
        reservasRepository: widget.reservasRepository,
        comentariosRepository: widget.comentariosRepository,
        disponibilidadRepository: widget.disponibilidadRepository,
        fechaReferencia: widget.fechaReferencia,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: IndexedStack(index: _seccion, children: _pantallas),
    bottomNavigationBar: NavigationBar(
      selectedIndex: _seccion,
      onDestinationSelected: (i) => setState(() => _seccion = i),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.grid_view_outlined),
          selectedIcon: Icon(Icons.grid_view_rounded),
          label: 'Espacios',
        ),
        NavigationDestination(
          icon: Icon(Icons.event_note_outlined),
          selectedIcon: Icon(Icons.event_note),
          label: 'Mis reservas',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Perfil',
        ),
      ],
    ),
  );
}
