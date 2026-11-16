import 'package:material_ui/material_ui.dart';

class DatoIcono extends StatelessWidget {
  const DatoIcono({super.key, required this.icono, required this.texto});
  final IconData icono;
  final String texto;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icono, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Expanded(child: Text(texto)),
      ],
    ),
  );
}
