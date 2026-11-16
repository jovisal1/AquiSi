import '../../../data/repositories/usuarios_repository.dart';

import 'package:material_ui/material_ui.dart';

import '../../core/ui/boton_accion.dart';
import '../../core/ui/campo_texto.dart';
import '../../core/ui/pagina.dart';
import '../../core/ui/titulo_seccion.dart';
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
    builder: (context, child) => Pagina(
      titulo: 'Crear cuenta',
      hijos: [
        const TituloSeccion(
          'Tu próximo encuentro empieza aquí',
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
        BotonAccion(
          texto: 'Crear cuenta de ejemplo',
          alPulsar: () => Navigator.of(context).pop(),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Volver al inicio de sesión'),
        ),
      ],
    ),
  );
}
