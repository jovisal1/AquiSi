import 'package:flutter/gestures.dart';
import 'package:material_ui/material_ui.dart';

import '../../../config/tema_app.dart';

class GaleriaEspacio extends StatefulWidget {
  const GaleriaEspacio({
    super.key,
    required this.imagenes,
    required this.nombre,
    required this.indice,
    required this.alCambiar,
    this.heroTag,
    this.rellenar = false,
    this.mostrarControles = true,
  });
  final List<String> imagenes;
  final String nombre;
  final int indice;
  final ValueChanged<int> alCambiar;

  final String? heroTag;
  final bool rellenar;

  final bool mostrarControles;
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

  Widget _conHero(Widget imagen) {
    final tag = widget.heroTag;
    if (tag == null) return imagen;
    return Hero(
      tag: tag,
      flightShuttleBuilder: (context, animacion, direccion, desde, hacia) =>
          Image.asset(widget.imagenes.first, fit: BoxFit.cover),
      child: imagen,
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.imagenes.length;
    final fotos = Stack(
      fit: StackFit.expand,
      children: [
        ScrollConfiguration(
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
        if (widget.mostrarControles && widget.indice > 0)
          Positioned(
            left: 8,
            top: 0,
            bottom: 0,
            child: Center(
              child: _BotonGaleria(
                icono: Icons.chevron_left,
                tooltip: 'Imagen anterior',
                alPulsar: () => _mover(widget.indice - 1),
              ),
            ),
          ),
        if (widget.mostrarControles && widget.indice < total - 1)
          Positioned(
            right: 8,
            top: 0,
            bottom: 0,
            child: Center(
              child: _BotonGaleria(
                icono: Icons.chevron_right,
                tooltip: 'Imagen siguiente',
                alPulsar: () => _mover(widget.indice + 1),
              ),
            ),
          ),
        if (widget.mostrarControles)
          Positioned(
          right: 16,
          bottom: 16,
          child: Semantics(
            label: 'Imagen ${widget.indice + 1} de $total',
            excludeSemantics: true,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${widget.indice + 1} / $total',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ],
    );

    if (widget.rellenar) return _conHero(fotos);

    return Column(
      children: [
        _conHero(
          ClipRRect(
            borderRadius: BorderRadius.circular(TemaApp.radio),
            child: AspectRatio(aspectRatio: 4 / 3, child: fotos),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < total; i++)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: i == widget.indice ? 20 : 6,
                height: 6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: i == widget.indice ? TemaApp.acento : TemaApp.borde,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _BotonGaleria extends StatelessWidget {
  const _BotonGaleria({
    required this.icono,
    required this.tooltip,
    required this.alPulsar,
  });
  final IconData icono;
  final String tooltip;
  final VoidCallback alPulsar;

  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: tooltip,
    onPressed: alPulsar,
    style: IconButton.styleFrom(
      backgroundColor: Colors.white.withValues(alpha: 0.9),
      foregroundColor: TemaApp.tinta,
    ),
    icon: Icon(icono),
  );
}
