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
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            etiqueta,
            style: destacada ? Theme.of(context).textTheme.titleMedium : null,
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            importe,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontWeight: destacada ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );
}
