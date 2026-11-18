import '../../../data/repositories/usuarios_repository.dart';

import 'package:material_ui/material_ui.dart';

import '../../core/ui/controles/boton_accion.dart';
import '../../core/ui/controles/campo_texto.dart';
import '../../core/ui/controles/enlace_accion.dart';
import '../../core/ui/estructura/scaffold_app.dart';
import '../../core/ui/textos/titulo_principal.dart';
import '../view_models/acceso_view_model.dart';
import 'registro_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    required this.usuariosRepository,
    required this.crearInicio,
  });
  final UsuariosRepository usuariosRepository;

  final Widget Function() crearInicio;
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
    _viewModel.acceder();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(
        builder: (context) => widget.crearInicio(),
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
    builder: (context, child) => ScaffoldApp(
      titulo: 'Iniciar sesión',
      hijos: [
        Image.asset(
          'assets/images/logo_espaireserva.png',
          height: 240,
          semanticLabel: 'Logotipo de espaireserva',
        ),
        const SizedBox(height: 20),
        const TituloPrincipal(
          'Un espacio para\ncada encuentro.',
          grande: true,
          centrado: true,
          subtitulo:
              'Reúne a tu equipo, comparte ideas y celebra. Encuentra tu próximo espacio.',
        ),
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
        const SizedBox(height: 8),
        BotonAccion(
          texto: 'Entrar con correo',
          alPulsar: _entrar,
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: BotonAccion(
                texto: 'Google',
                secundario: true,
                icono: Icons.account_circle_outlined,
                alPulsar: _entrar,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: BotonAccion(
                texto: 'Apple',
                secundario: true,
                icono: Icons.apple,
                alPulsar: _entrar,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        EnlaceAccion(
          texto: '¿Primera vez? Crea tu cuenta',
          alPulsar: _abrirRegistro,
          centrado: true,
        ),
        Text(
          'Acceso de demostración con datos ficticios.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    ),
  );
}
