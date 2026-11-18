import 'package:material_ui/material_ui.dart';

class TituloPrincipal extends StatelessWidget {
  const TituloPrincipal(
    this.texto, {
    super.key,
    this.antetitulo,
    this.subtitulo,
    this.grande = false,
    this.centrado = false,
  });
  final String texto;
  final String? antetitulo;
  final String? subtitulo;
  final bool grande;
  final bool centrado;

  @override
  Widget build(BuildContext context) {
    final temaTexto = Theme.of(context).textTheme;
    final alineacion = centrado ? TextAlign.center : TextAlign.start;
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      child: Column(
        crossAxisAlignment: centrado
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          if (antetitulo != null) ...[
            Text(antetitulo!, style: temaTexto.bodySmall, textAlign: alineacion),
            const SizedBox(height: 6),
          ],
          Text(
            texto,
            textAlign: alineacion,
            style: grande ? temaTexto.headlineLarge : temaTexto.headlineMedium,
          ),
          if (subtitulo != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitulo!,
              textAlign: alineacion,
              style: temaTexto.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
