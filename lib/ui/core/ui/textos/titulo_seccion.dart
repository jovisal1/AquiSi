import 'package:material_ui/material_ui.dart';

class TituloSeccion extends StatelessWidget {
  const TituloSeccion(this.texto, {super.key, this.subtitulo});
  final String texto;
  final String? subtitulo;

  @override
  Widget build(BuildContext context) {
    final temaTexto = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            texto,
            style: temaTexto.titleMedium?.copyWith(
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (subtitulo != null) ...[
            const SizedBox(height: 2),
            Text(subtitulo!, style: temaTexto.bodySmall),
          ],
        ],
      ),
    );
  }
}
