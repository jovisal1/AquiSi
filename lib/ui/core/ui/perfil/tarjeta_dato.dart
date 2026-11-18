import 'package:material_ui/material_ui.dart';

class TarjetaDato extends StatelessWidget {
  const TarjetaDato({
    super.key,
    required this.icono,
    required this.color,
    required this.etiqueta,
    required this.valor,
  });
  final IconData icono;
  final Color color;
  final String etiqueta;
  final String valor;

  @override
  Widget build(BuildContext context) {
    final temaTexto = Theme.of(context).textTheme;
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icono, size: 21, color: color),
            ),
            const SizedBox(height: 10),
            Text(
              valor,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: temaTexto.titleLarge,
            ),
            Text(etiqueta, style: temaTexto.bodySmall),
          ],
        ),
      ),
    );
  }
}
