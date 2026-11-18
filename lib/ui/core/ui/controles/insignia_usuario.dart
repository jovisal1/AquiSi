import 'package:material_ui/material_ui.dart';

import '../../../../config/tema_app.dart';

class InsigniaUsuario extends StatelessWidget {
  const InsigniaUsuario({
    super.key,
    required this.iniciales,
    this.grande = false,
    this.alPulsar,
  });
  final String iniciales;
  final bool grande;
  final VoidCallback? alPulsar;

  @override
  Widget build(BuildContext context) {
    final diametro = grande ? 76.0 : 36.0;
    final avatar = Container(
      width: diametro,
      height: diametro,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: grande ? TemaApp.acento : TemaApp.acentoSuave,
        border: grande
            ? Border.all(color: TemaApp.superficie, width: 3)
            : null,
        boxShadow: grande
            ? const [
                BoxShadow(
                  color: TemaApp.sombra,
                  blurRadius: 16,
                  offset: Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: Text(
        iniciales,
        style: TextStyle(
          fontSize: grande ? 24 : 13,
          fontWeight: FontWeight.w700,
          letterSpacing: grande ? -0.5 : 0,
          color: grande ? Colors.white : TemaApp.acentoTexto,
        ),
      ),
    );

    final pulsar = alPulsar;
    if (pulsar == null) {
      return avatar;
    }
    return Tooltip(
      message: 'Mi perfil',
      child: InkResponse(
        onTap: pulsar,
        radius: 24,
        child: SizedBox.square(
          dimension: 44,
          child: Center(child: avatar),
        ),
      ),
    );
  }
}
