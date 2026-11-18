import 'dart:ui' show lerpDouble;

import 'package:material_ui/material_ui.dart';

import '../../../config/tema_app.dart';
import '../../core/ui/espacios/insignia_imagen.dart';

class CabeceraEspacio extends StatelessWidget {
  const CabeceraEspacio({
    super.key,
    required this.galeria,
    required this.nombre,
    required this.ubicacion,
    required this.aforo,
    required this.media,
    required this.progreso,
  });
  final Widget galeria;
  final String nombre;
  final String ubicacion;
  final int aforo;

  final double? media;
  final double progreso;

  @override
  Widget build(BuildContext context) => Stack(
    fit: StackFit.expand,
    children: [
      galeria,
      const IgnorePointer(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0, 0.25, 0.55, 1],
              colors: [
                Color(0x59000000),
                Color(0x00000000),
                Color(0x00000000),
                Color(0xb3000000),
              ],
            ),
          ),
        ),
      ),
      // Al plegarse, los datos se desplazan hacia la derecha y ocupan el
      // hueco de las flechas y el contador de la galería, que se ocultan.
      Positioned(
        left: 20,
        right: lerpDouble(88, 20, progreso),
        bottom: 16,
        child: IgnorePointer(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _alineado(
                Text(
                  nombre,
                  maxLines: progreso > 0.5 ? 1 : 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: progreso > 0.5 ? TextAlign.right : TextAlign.left,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: lerpDouble(30, 21, progreso),
                    height: 1.1,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.6,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              _alineado(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.place_rounded,
                      size: 15,
                      color: Colors.white70,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        ubicacion,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              _alineado(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InsigniaImagen(
                      icono: Icons.groups_rounded,
                      texto: 'Hasta $aforo',
                    ),
                    const SizedBox(width: 8),
                    InsigniaImagen(
                      icono: Icons.star_rounded,
                      colorIcono: TemaApp.acento,
                      texto: media == null
                          ? 'Nuevo'
                          : media!.toStringAsFixed(1).replaceAll('.', ','),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );

  Widget _alineado(Widget hijo) => Align(
    alignment: Alignment.lerp(
      Alignment.centerLeft,
      Alignment.centerRight,
      Curves.easeInOut.transform(progreso),
    )!,
    child: hijo,
  );
}
