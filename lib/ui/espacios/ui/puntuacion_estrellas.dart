import 'package:material_ui/material_ui.dart';

import '../../../config/tema_app.dart';

class PuntuacionEstrellas extends StatelessWidget {
  const PuntuacionEstrellas({
    super.key,
    required this.puntuacion,
    this.alSeleccionar,
    this.tamano = 18,
  });

  final num puntuacion;
  final ValueChanged<int>? alSeleccionar;
  final double tamano;

  IconData _icono(int indice) {
    if (puntuacion >= indice + 0.75) return Icons.star_rounded;
    if (puntuacion >= indice + 0.25) return Icons.star_half_rounded;
    return Icons.star_border_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final seleccionar = alSeleccionar;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var indice = 0; indice < 5; indice++)
          if (seleccionar == null)
            Icon(_icono(indice), size: tamano, color: TemaApp.acento)
          else
            IconButton(
              tooltip: '${indice + 1} de 5 estrellas',
              visualDensity: VisualDensity.compact,
              onPressed: () => seleccionar(indice + 1),
              icon: Icon(_icono(indice), size: tamano, color: TemaApp.acento),
            ),
      ],
    );
  }
}
