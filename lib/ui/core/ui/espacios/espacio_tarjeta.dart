import 'package:material_ui/material_ui.dart';

import '../../../../config/tema_app.dart';
import '../../../../domain/models/espacio.dart';
import '../../formatos.dart';
import 'insignia_imagen.dart';

class EspacioTarjeta extends StatelessWidget {
  const EspacioTarjeta({
    super.key,
    required this.espacio,
    required this.alAbrir,
  });
  final Espacio espacio;
  final VoidCallback alAbrir;

  static String heroTag(String espacioId) => 'espacio-imagen-$espacioId';

  static const _equipamientoVisible = 2;

  @override
  Widget build(BuildContext context) {
    final temaTexto = Theme.of(context).textTheme;
    final equipamiento = espacio.equipamiento;
    final resto = equipamiento.length - _equipamientoVisible;
    final resumenEquipamiento = [
      ...equipamiento.take(_equipamientoVisible),
      if (resto > 0) '+$resto',
    ].join(' · ');

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: alAbrir,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 2 / 1,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: heroTag(espacio.id),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(TemaApp.radio),
                      ),
                      child: Image.asset(
                        espacio.imagenAsset,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: 72,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0x00000000), Color(0x40000000)],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: InsigniaImagen(
                      icono: Icons.groups_rounded,
                      texto: 'Hasta ${espacio.aforo}',
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: _Precio(
                      importe: Formatos.dineroCorto(
                        espacio.precioHoraCentimos,
                        espacio.moneda,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 12, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              espacio.nombre,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: temaTexto.titleLarge,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.place_outlined,
                                  size: 15,
                                  color: TemaApp.textoSecundario,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    espacio.ubicacion,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: temaTexto.bodySmall,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const _BotonFlecha(),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.check_circle_rounded,
                        size: 16,
                        color: TemaApp.exito,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          resumenEquipamiento,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: temaTexto.bodySmall?.copyWith(
                            color: TemaApp.tinta,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      for (final actividad in espacio.actividades)
                        _Actividad(texto: actividad),
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
}

class _Precio extends StatelessWidget {
  const _Precio({required this.importe});
  final String importe;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(12, 6, 12, 7),
    decoration: const ShapeDecoration(
      color: TemaApp.tinta,
      shape: StadiumBorder(),
    ),
    child: Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: importe,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
          ),
          const TextSpan(
            text: ' /h',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
      style: const TextStyle(color: Colors.white),
    ),
  );
}

class _BotonFlecha extends StatelessWidget {
  const _BotonFlecha();

  @override
  Widget build(BuildContext context) => Container(
    width: 36,
    height: 36,
    decoration: const BoxDecoration(
      color: TemaApp.acentoSuave,
      shape: BoxShape.circle,
    ),
    child: const Icon(
      Icons.arrow_forward_rounded,
      size: 20,
      color: TemaApp.acento,
    ),
  );
}

class _Actividad extends StatelessWidget {
  const _Actividad({required this.texto});
  final String texto;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: const ShapeDecoration(
      color: TemaApp.superficieAtenuada,
      shape: StadiumBorder(),
    ),
    child: Text(
      texto,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: TemaApp.tinta,
      ),
    ),
  );
}
