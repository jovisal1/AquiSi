import '../../../data/repositories/espacios_repository.dart';
import '../../../data/repositories/usuarios_repository.dart';
import '../../../data/repositories/reservas_repository.dart';
import '../../../data/repositories/comentarios_repository.dart';
import '../../../data/repositories/disponibilidad_repository.dart';

import 'package:material_ui/material_ui.dart';

import '../../acceso/ui/login_screen.dart';
import '../../core/ui/boton_accion.dart';
import '../../core/ui/pagina.dart';
import '../../core/ui/panel.dart';
import '../../core/ui/titulo_seccion.dart';
import '../view_models/perfil_view_model.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({
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
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  late final PerfilViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = PerfilViewModel(usuariosRepository: widget.usuariosRepository);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void _cerrarSesion() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(
        builder: (context) => LoginScreen(
          espaciosRepository: widget.espaciosRepository,
          usuariosRepository: widget.usuariosRepository,
          reservasRepository: widget.reservasRepository,
          comentariosRepository: widget.comentariosRepository,
          disponibilidadRepository: widget.disponibilidadRepository,
          fechaReferencia: widget.fechaReferencia,
        ),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _viewModel,
    builder: (context, child) => Pagina(
      titulo: 'Mi perfil',
      hijos: [
        const SizedBox(height: 16),
        Center(
          child: CircleAvatar(
            radius: 40,
            child: Text(
              _viewModel.iniciales,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
        ),
        TituloSeccion(
          _viewModel.usuario.nombre,
          subtitulo: _viewModel.usuario.correo,
        ),
        const TituloSeccion('Preferencias'),
        Panel(
          hijo: SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Recordatorios de encuentros'),
            subtitle: const Text('Preferencia local durante esta sesión.'),
            value: _viewModel.notificaciones,
            onChanged: _viewModel.cambiarNotificaciones,
          ),
        ),
        const TituloSeccion('Sobre EspaiReserva'),
        Panel(
          hijo: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'EspaiReserva · ${_viewModel.version}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              const Text(
                'Un lugar para reunirse, crear y celebrar. Proyecto integrador de PMDM desarrollado con Flutter.',
              ),
              const SizedBox(height: 8),
              const Text(
                'Datos ficticios y reservas de ejemplo, sin cobros ni cuentas externas.',
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        BotonAccion(
          texto: 'Cerrar sesión',
          secundario: true,
          icono: Icons.logout,
          alPulsar: _cerrarSesion,
        ),
      ],
    ),
  );
}
