import '../../../data/repositories/usuarios_repository.dart';

import 'package:material_ui/material_ui.dart';

import '../../core/ui/controles/boton_accion.dart';
import '../../core/ui/controles/campo_texto.dart';
import '../../core/ui/controles/enlace_accion.dart';
import '../../core/ui/estructura/barra_superior.dart';
import '../../core/ui/estructura/scaffold_app.dart';
import '../../core/ui/textos/titulo_principal.dart';
import '../view_models/acceso_view_model.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key, required this.usuariosRepository});
  final UsuariosRepository usuariosRepository;
  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
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

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _viewModel,
    builder: (context, child) => ScaffoldApp(
      titulo: 'Crear cuenta',
      barra: const BarraSuperior(),
      hijos: [
        const TituloPrincipal(
          'Tu próximo encuentro empieza aquí',
          centrado: true,
          subtitulo:
              'Registro de ejemplo. Accede después desde el inicio de sesión.',
        ),
        CampoTexto(
          etiqueta: 'Nombre y apellidos',
          inicial: _viewModel.nombre,
          icono: Icons.person_outline,
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
        CampoTexto(
          etiqueta: 'Repetir contraseña',
          inicial: _viewModel.claveInicial,
          oculto: true,
          icono: Icons.lock_outline,
        ),
        const SizedBox(height: 8),
        BotonAccion(
          texto: 'Crear cuenta de ejemplo',
          alPulsar: () => Navigator.of(context).pop(),
        ),
        const SizedBox(height: 4),
        EnlaceAccion(
          texto: '¿Ya tienes cuenta? Inicia sesión',
          alPulsar: () => Navigator.of(context).pop(),
          centrado: true,
        ),
      ],
    ),
  );
}
