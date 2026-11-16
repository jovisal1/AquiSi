import '../../../data/repositories/espacios_repository.dart';
import '../../../data/repositories/usuarios_repository.dart';
import '../../../data/repositories/reservas_repository.dart';
import '../../../data/repositories/comentarios_repository.dart';
import '../../../data/repositories/disponibilidad_repository.dart';

import 'package:material_ui/material_ui.dart';

import '../../core/ui/boton_accion.dart';
import '../../core/ui/campo_texto.dart';
import '../../core/ui/pagina.dart';
import '../../core/ui/titulo_seccion.dart';
import '../../navegacion/ui/inicio_screen.dart';
import '../view_models/acceso_view_model.dart';
import 'registro_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
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
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final AccesoViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = AccesoViewModel(usuariosRepository: widget.usuariosRepository);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void _entrar() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(
        builder: (context) => InicioScreen(
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

  void _abrirRegistro() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) =>
            RegistroScreen(usuariosRepository: widget.usuariosRepository),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _viewModel,
    builder: (context, child) => Pagina(
      titulo: 'EspaiReserva',
      hijos: [
        const SizedBox(height: 24),
        Icon(
          Icons.space_dashboard_rounded,
          size: 64,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 16),
        Text(
          'Un espacio para\ncada encuentro.',
          style: Theme.of(context).textTheme.headlineLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        const Text(
          'Reúne a tu equipo, comparte ideas y celebra. Encuentra tu próximo espacio.',
        ),
        const TituloSeccion('Te damos la bienvenida'),
        CampoTexto(
          etiqueta: 'Correo electrónico',
          inicial: _viewModel.correo,
          tipo: TextInputType.emailAddress,
          icono: Icons.mail_outline,
        ),
        CampoTexto(
          etiqueta: 'Contraseña',
          inicial: _viewModel.claveInicial,
          oculto: true,
          icono: Icons.lock_outline,
        ),
        BotonAccion(
          texto: 'Entrar',
          icono: Icons.arrow_forward,
          alPulsar: () {
            _viewModel.acceder();
            _entrar();
          },
        ),
        const SizedBox(height: 16),
        const Center(child: Text('O continúa con')),
        BotonAccion(
          texto: 'Google',
          secundario: true,
          icono: Icons.account_circle_outlined,
          alPulsar: () {
            _viewModel.acceder();
            _entrar();
          },
        ),
        BotonAccion(
          texto: 'Apple',
          secundario: true,
          icono: Icons.apple,
          alPulsar: () {
            _viewModel.acceder();
            _entrar();
          },
        ),
        TextButton(
          onPressed: _abrirRegistro,
          child: const Text('¿Primera vez? Registrarse'),
        ),
        const Text(
          'Acceso de demostración con datos ficticios.',
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
