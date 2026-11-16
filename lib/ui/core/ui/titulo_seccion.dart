import 'package:material_ui/material_ui.dart';

class TituloSeccion extends StatelessWidget {
  const TituloSeccion(this.texto, {super.key, this.subtitulo});
  final String texto;
  final String? subtitulo;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 24, bottom: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          texto,
          style: Theme.of(context).textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        if (subtitulo != null) ...[
          const SizedBox(height: 4),
          Text(subtitulo!, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ],
    ),
  );
}
