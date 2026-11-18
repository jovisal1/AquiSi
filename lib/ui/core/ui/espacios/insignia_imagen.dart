import 'package:material_ui/material_ui.dart';

import '../../../../config/tema_app.dart';

class InsigniaImagen extends StatelessWidget {
  const InsigniaImagen({
    super.key,
    required this.icono,
    required this.texto,
    this.colorIcono = TemaApp.tinta,
  });
  final IconData icono;
  final String texto;
  final Color colorIcono;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: ShapeDecoration(
      color: Colors.white.withValues(alpha: 0.92),
      shape: const StadiumBorder(),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icono, size: 15, color: colorIcono),
        const SizedBox(width: 5),
        Text(
          texto,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: TemaApp.tinta,
          ),
        ),
      ],
    ),
  );
}
