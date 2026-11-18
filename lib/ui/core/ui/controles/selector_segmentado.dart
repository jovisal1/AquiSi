import 'package:material_ui/material_ui.dart';

import '../../../../config/tema_app.dart';

class SelectorSegmentado extends StatelessWidget {
  const SelectorSegmentado({
    super.key,
    required this.opciones,
    required this.seleccionada,
    required this.alSeleccionar,
    this.expandir = false,
  });
  final List<String> opciones;
  final String seleccionada;
  final ValueChanged<String> alSeleccionar;

  final bool expandir;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(4),
    decoration: const ShapeDecoration(
      color: TemaApp.superficieAtenuada,
      shape: StadiumBorder(),
    ),
    child: expandir
        ? Row(
            children: [
              for (final opcion in opciones)
                Expanded(child: _segmento(opcion)),
            ],
          )
        : SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [for (final opcion in opciones) _segmento(opcion)],
            ),
          ),
  );

  Widget _segmento(String opcion) => _Segmento(
    texto: opcion,
    seleccionado: opcion == seleccionada,
    alPulsar: () => alSeleccionar(opcion),
  );
}

class _Segmento extends StatelessWidget {
  const _Segmento({
    required this.texto,
    required this.seleccionado,
    required this.alPulsar,
  });
  final String texto;
  final bool seleccionado;
  final VoidCallback alPulsar;

  static const _duracion = Duration(milliseconds: 220);

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: alPulsar,
    behavior: HitTestBehavior.opaque,
    child: AnimatedContainer(
      duration: _duracion,
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: ShapeDecoration(
        color: seleccionado ? TemaApp.superficie : Colors.transparent,
        shape: const StadiumBorder(),
        shadows: seleccionado
            ? const [
                BoxShadow(
                  color: TemaApp.sombra,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ]
            : const [],
      ),
      child: AnimatedDefaultTextStyle(
        duration: _duracion,
        style: TextStyle(
          fontSize: 13.5,
          fontWeight: seleccionado ? FontWeight.w800 : FontWeight.w600,
          color: seleccionado ? TemaApp.tinta : TemaApp.textoSecundario,
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(texto, textAlign: TextAlign.center, maxLines: 1),
        ),
      ),
    ),
  );
}
