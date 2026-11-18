import '../../../data/repositories/usuarios_repository.dart';
import '../../../data/repositories/reservas_repository.dart';
import '../../../data/repositories/comentarios_repository.dart';

import 'package:material_ui/material_ui.dart';

import '../../../config/tema_app.dart';

import '../../core/ui/controles/boton_accion.dart';
import '../../core/ui/controles/insignia_usuario.dart';
import '../../core/ui/estructura/barra_superior.dart';
import '../../core/ui/estructura/scaffold_app.dart';
import '../../core/ui/estructura/panel.dart';
import '../../core/ui/perfil/tarjeta_dato.dart';
import '../../core/ui/textos/titulo_principal.dart';
import '../../core/ui/textos/titulo_seccion.dart';
import '../view_models/perfil_view_model.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({
    super.key,
    required this.usuariosRepository,
    required this.reservasRepository,
    required this.comentariosRepository,
    required this.fechaReferencia,
    required this.alCerrarSesion,
  });
  final UsuariosRepository usuariosRepository;
  final ReservasRepository reservasRepository;
  final ComentariosRepository comentariosRepository;
  final DateTime fechaReferencia;
  final VoidCallback alCerrarSesion;
  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  late final PerfilViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = PerfilViewModel(
      usuariosRepository: widget.usuariosRepository,
      reservasRepository: widget.reservasRepository,
      comentariosRepository: widget.comentariosRepository,
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
    builder: (context, child) => ScaffoldApp(
      titulo: 'Mi perfil',
      barra: const BarraSuperior(),
      hijos: [
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: InsigniaUsuario(iniciales: _viewModel.iniciales, grande: true),
        ),
        const SizedBox(height: 8),
        TituloPrincipal(
          _viewModel.usuario.nombre,
          subtitulo: _viewModel.usuario.correo,
        ),
        Row(
          children: [
            Expanded(
              child: TarjetaDato(
                icono: Icons.event_available_rounded,
                color: TemaApp.acento,
                valor: '${_viewModel.reservasProximas}',
                etiqueta: 'próximas',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TarjetaDato(
                icono: Icons.task_alt_rounded,
                color: TemaApp.exito,
                valor: '${_viewModel.reservasRealizadas}',
                etiqueta: 'realizadas',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TarjetaDato(
                icono: Icons.rate_review_rounded,
                color: TemaApp.azul,
                valor: '${_viewModel.opinionesPublicadas}',
                etiqueta: 'opiniones',
              ),
            ),
          ],
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
              const SizedBox(height: 6),
              const Text(
                'Un lugar para reunirse, crear y celebrar. Proyecto integrador de PMDM desarrollado con Flutter.',
              ),
              const SizedBox(height: 6),
              Text(
                'Datos ficticios y reservas de ejemplo, sin cobros ni cuentas externas.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        BotonAccion(
          texto: 'Cerrar sesión',
          secundario: true,
          icono: Icons.logout,
          alPulsar: widget.alCerrarSesion,
        ),
      ],
    ),
  );
}
