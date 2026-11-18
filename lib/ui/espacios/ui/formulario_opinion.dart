import 'package:material_ui/material_ui.dart';

import '../../core/ui/controles/boton_accion.dart';
import '../../core/ui/controles/campo_texto.dart';
import 'puntuacion_estrellas.dart';

class FormularioOpinion extends StatelessWidget {
  const FormularioOpinion({
    super.key,
    required this.nombreEspacio,
    required this.puntuacion,
    required this.textoInicial,
    required this.alPuntuar,
    required this.alEditar,
    required this.alPublicar,
  });
  final String nombreEspacio;
  final int puntuacion;
  final String textoInicial;
  final ValueChanged<int> alPuntuar;
  final ValueChanged<String> alEditar;
  final VoidCallback? alPublicar;

  @override
  Widget build(BuildContext context) {
    final temaTexto = Theme.of(context).textTheme;
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Comparte tu experiencia',
            textAlign: TextAlign.center,
            style: temaTexto.titleLarge,
          ),
          const SizedBox(height: 4),
          Text(
            nombreEspacio,
            textAlign: TextAlign.center,
            style: temaTexto.bodySmall,
          ),
          const SizedBox(height: 12),
          Center(
            child: PuntuacionEstrellas(
              puntuacion: puntuacion,
              alSeleccionar: alPuntuar,
              tamano: 34,
            ),
          ),
          Text(
            puntuacion == 0
                ? 'Toca una estrella para puntuar'
                : '$puntuacion de 5',
            textAlign: TextAlign.center,
            style: temaTexto.bodySmall,
          ),
          const SizedBox(height: 8),
          CampoTexto(
            etiqueta: 'Cuéntanos qué tal fue',
            inicial: textoInicial,
            lineas: 4,
            alCambiar: alEditar,
          ),
          const SizedBox(height: 8),
          BotonAccion(texto: 'Publicar opinión', alPulsar: alPublicar),
        ],
      ),
    );
  }
}
