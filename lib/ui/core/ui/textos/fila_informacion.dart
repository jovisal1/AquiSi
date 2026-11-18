import 'package:material_ui/material_ui.dart';

import '../../../../config/tema_app.dart';

class FilaInformacion extends StatelessWidget {
  const FilaInformacion({
    super.key,
    required this.icono,
    required this.etiqueta,
    required this.valor,
    this.color = TemaApp.acento,
  });
  final IconData icono;
  final String etiqueta;
  final String valor;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final temaTexto = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icono, size: 19, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(etiqueta, style: temaTexto.bodySmall),
                const SizedBox(height: 2),
                Text(
                  valor,
                  style: temaTexto.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
