import 'package:material_ui/material_ui.dart';

class Etiqueta extends StatelessWidget {
  const Etiqueta({super.key, required this.texto, this.icono, this.color});
  final String texto;
  final IconData? icono;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    final tinta = color ?? Theme.of(context).colorScheme.primary;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: tinta.withValues(alpha: 0.06),
        border: Border.all(color: tinta.withValues(alpha: 0.2)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icono != null) ...[
            Icon(icono, size: 16, color: tinta),
            const SizedBox(width: 6),
          ],
          Flexible(
            child: Text(texto, style: TextStyle(color: tinta)),
          ),
        ],
      ),
    );
  }
}
