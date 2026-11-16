import 'package:material_ui/material_ui.dart';

import '../../../domain/models/espacio.dart';
import '../formatos.dart';
import 'dato_icono.dart';
import 'etiqueta.dart';

class EspacioTarjeta extends StatelessWidget {
  const EspacioTarjeta({
    super.key,
    required this.espacio,
    required this.alAbrir,
  });
  final Espacio espacio;
  final VoidCallback alAbrir;
  @override
  Widget build(BuildContext context) => Card(
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: alAbrir,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.asset(
              espacio.imagenAsset,
              fit: BoxFit.cover,
              semanticLabel: espacio.nombre,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  espacio.nombre,
                  style: Theme.of(context).textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                DatoIcono(
                  icono: Icons.place_outlined,
                  texto: espacio.ubicacion,
                ),
                Wrap(
                  spacing: 8,
                  children: [
                    Etiqueta(texto: '${espacio.aforo} personas'),
                    for (final actividad in espacio.actividades)
                      Etiqueta(texto: actividad),
                  ],
                ),
                const Divider(),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${Formatos.dinero(espacio.precioHoraCentimos, espacio.moneda)} / hora',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    const Icon(Icons.arrow_forward_rounded),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
