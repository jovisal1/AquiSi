import 'package:material_ui/material_ui.dart';

class FilaImporte extends StatelessWidget {
  const FilaImporte({
    super.key,
    required this.etiqueta,
    required this.importe,
    this.destacada = false,
  });
  final String etiqueta;
  final String importe;
  final bool destacada;

  @override
  Widget build(BuildContext context) {
    final temaTexto = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              etiqueta,
              style: destacada
                  ? temaTexto.titleMedium
                  : temaTexto.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            importe,
            textAlign: TextAlign.end,
            style: destacada
                ? temaTexto.titleLarge
                : temaTexto.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
