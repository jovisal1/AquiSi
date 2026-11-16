import 'package:flutter/gestures.dart';
import 'package:material_ui/material_ui.dart';

class GaleriaEspacio extends StatefulWidget {
  const GaleriaEspacio({
    super.key,
    required this.imagenes,
    required this.nombre,
    required this.indice,
    required this.alCambiar,
  });
  final List<String> imagenes;
  final String nombre;
  final int indice;
  final ValueChanged<int> alCambiar;
  @override
  State<GaleriaEspacio> createState() => _GaleriaEspacioState();
}

class _GaleriaEspacioState extends State<GaleriaEspacio> {
  final _controlador = PageController();
  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  void _mover(int indice) => _controlador.animateToPage(
    indice,
    duration: const Duration(milliseconds: 250),
    curve: Curves.easeOut,
  );
  @override
  Widget build(BuildContext context) => Column(
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: AspectRatio(
          aspectRatio: 4 / 3,
          child: ScrollConfiguration(
            behavior: const MaterialScrollBehavior().copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
                PointerDeviceKind.trackpad,
              },
            ),
            child: PageView(
              controller: _controlador,
              onPageChanged: widget.alCambiar,
              children: [
                for (final imagen in widget.imagenes)
                  Image.asset(
                    imagen,
                    fit: BoxFit.cover,
                    semanticLabel: widget.nombre,
                  ),
              ],
            ),
          ),
        ),
      ),
      Row(
        children: [
          IconButton(
            tooltip: 'Imagen anterior',
            onPressed: widget.indice > 0
                ? () => _mover(widget.indice - 1)
                : null,
            icon: const Icon(Icons.chevron_left),
          ),
          Expanded(
            child: Text(
              'Imagen ${widget.indice + 1} de ${widget.imagenes.length}',
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            tooltip: 'Imagen siguiente',
            onPressed: widget.indice < widget.imagenes.length - 1
                ? () => _mover(widget.indice + 1)
                : null,
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < widget.imagenes.length; i++)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: i == widget.indice ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: i == widget.indice
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
        ],
      ),
    ],
  );
}
