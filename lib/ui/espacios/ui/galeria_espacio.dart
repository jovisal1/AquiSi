import 'package:flutter/gestures.dart';
import 'package:material_ui/material_ui.dart';

class GaleriaEspacio extends StatelessWidget {
  const GaleriaEspacio({
    super.key,
    required this.imagenes,
    required this.indice,
    required this.alCambiar,
    this.heroTag,
    this.mostrarContador = true,
  });
  final List<String> imagenes;
  final int indice;
  final ValueChanged<int> alCambiar;
  final String? heroTag;
  final bool mostrarContador;

  @override
  Widget build(BuildContext context) {
    final galeria = Stack(
      fit: StackFit.expand,
      children: [
        // Permite deslizar las fotos también con el ratón en la web.
        ScrollConfiguration(
          behavior: const MaterialScrollBehavior().copyWith(
            dragDevices: {
              PointerDeviceKind.touch,
              PointerDeviceKind.mouse,
              PointerDeviceKind.trackpad,
            },
          ),
          child: PageView(
            onPageChanged: alCambiar,
            children: [
              for (final imagen in imagenes)
                Image.asset(imagen, fit: BoxFit.cover),
            ],
          ),
        ),
        if (mostrarContador)
          Positioned(
            right: 16,
            bottom: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${indice + 1} / ${imagenes.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    );

    final tag = heroTag;
    if (tag == null) return galeria;
    return Hero(
      tag: tag,
      flightShuttleBuilder: (context, animacion, direccion, desde, hacia) =>
          Image.asset(imagenes.first, fit: BoxFit.cover),
      child: galeria,
    );
  }
}
