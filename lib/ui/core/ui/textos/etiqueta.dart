import 'package:material_ui/material_ui.dart';

import '../../../../config/tema_app.dart';

class Etiqueta extends StatelessWidget {
  const Etiqueta({super.key, required this.texto, this.icono, this.color});
  final String texto;
  final IconData? icono;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final tinta = color ?? TemaApp.tinta;
    final fondo = color == null
        ? TemaApp.superficie
        : color!.withValues(alpha: 0.10);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: fondo,
        borderRadius: BorderRadius.circular(20),
        border: color == null ? Border.all(color: TemaApp.borde) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icono != null) ...[
            Icon(icono, size: 16, color: tinta),
            const SizedBox(width: 6),
          ],
          Flexible(
            child: Text(
              texto,
              style: TextStyle(
                color: tinta,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
