import 'package:material_ui/material_ui.dart';

import '../../../domain/models/comentario.dart';
import '../../core/formatos.dart';
import '../../core/ui/boton_accion.dart';
import '../../core/ui/campo_texto.dart';
import '../../core/ui/panel.dart';
import '../../core/ui/titulo_seccion.dart';
import 'puntuacion_estrellas.dart';

class OpinionesPanel extends StatelessWidget {
  const OpinionesPanel({
    super.key,
    required this.comentarios,
    required this.media,
    required this.puntuacion,
    required this.alPuntuar,
    required this.alEditar,
    required this.alPublicar,
  });
  final List<Comentario> comentarios;
  final double? media;
  final int puntuacion;
  final ValueChanged<int> alPuntuar;
  final ValueChanged<String> alEditar;
  final VoidCallback? alPublicar;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        media == null
            ? 'Sin valoraciones'
            : '${media!.toStringAsFixed(1).replaceAll('.', ',')} / 5 · ${comentarios.length} ${comentarios.length == 1 ? 'valoración' : 'valoraciones'}',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      for (final comentario in comentarios)
        Panel(
          hijo: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                comentario.autor.nombre,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Wrap(
                spacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  PuntuacionEstrellas(puntuacion: comentario.puntuacion),
                  Text(Formatos.fecha(comentario.fecha)),
                ],
              ),
              const SizedBox(height: 8),
              Text(comentario.texto),
            ],
          ),
        ),
      const TituloSeccion('Comparte tu experiencia'),
      DropdownButtonFormField<int>(
        initialValue: puntuacion,
        isExpanded: true,
        decoration: const InputDecoration(labelText: 'Puntuación'),
        items: [
          for (var i = 1; i <= 5; i++)
            DropdownMenuItem(value: i, child: Text('$i de 5 estrellas')),
        ],
        onChanged: (v) {
          if (v != null) alPuntuar(v);
        },
      ),
      CampoTexto(
        key: ValueKey(comentarios.length),
        etiqueta: 'Tu opinión',
        lineas: 3,
        alCambiar: alEditar,
      ),
      BotonAccion(
        texto: 'Publicar opinión',
        icono: Icons.rate_review_outlined,
        alPulsar: alPublicar,
      ),
    ],
  );
}
