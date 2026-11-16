import 'package:material_ui/material_ui.dart';

class PuntuacionEstrellas extends StatelessWidget {
  const PuntuacionEstrellas({super.key, required this.puntuacion});

  final int puntuacion;

  @override
  Widget build(BuildContext context) => Semantics(
    label: '$puntuacion de 5 estrellas',
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var indice = 0; indice < 5; indice++)
          Icon(
            indice < puntuacion
                ? Icons.star_rounded
                : Icons.star_border_rounded,
            size: 18,
            color: Theme.of(context).colorScheme.primary,
          ),
      ],
    ),
  );
}
