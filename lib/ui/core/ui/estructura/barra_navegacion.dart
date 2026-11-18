import 'package:material_ui/material_ui.dart';

import '../../../../config/tema_app.dart';

class DestinoNavegacion {
  const DestinoNavegacion({
    required this.icono,
    required this.iconoSeleccionado,
    required this.etiqueta,
  });
  final IconData icono;
  final IconData iconoSeleccionado;
  final String etiqueta;
}

class BarraNavegacion extends StatelessWidget {
  const BarraNavegacion({
    super.key,
    required this.destinos,
    required this.seleccionado,
    required this.alSeleccionar,
  });
  final List<DestinoNavegacion> destinos;
  final int seleccionado;
  final ValueChanged<int> alSeleccionar;

  @override
  Widget build(BuildContext context) => SafeArea(
    top: false,
    minimum: const EdgeInsets.fromLTRB(20, 0, 20, 14),
    child: Center(
      heightFactor: 1,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Material(
          color: TemaApp.superficie,
          elevation: 8,
          shadowColor: TemaApp.sombra,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
            side: const BorderSide(color: TemaApp.borde),
          ),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Row(
              children: [
                for (var i = 0; i < destinos.length; i++)
                  Expanded(
                    child: _ElementoNavegacion(
                      destino: destinos[i],
                      seleccionado: i == seleccionado,
                      alPulsar: () => alSeleccionar(i),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class _ElementoNavegacion extends StatelessWidget {
  const _ElementoNavegacion({
    required this.destino,
    required this.seleccionado,
    required this.alPulsar,
  });
  final DestinoNavegacion destino;
  final bool seleccionado;
  final VoidCallback alPulsar;

  static const _duracion = Duration(milliseconds: 260);
  static const _curva = Curves.easeOutCubic;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: alPulsar,
    borderRadius: BorderRadius.circular(22),
    child: AnimatedContainer(
      duration: _duracion,
      curve: _curva,
      margin: const EdgeInsets.symmetric(horizontal: 3),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: seleccionado ? TemaApp.acentoSuave : Colors.transparent,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedScale(
            duration: _duracion,
            curve: _curva,
            scale: seleccionado ? 1.1 : 1,
            child: Icon(
              seleccionado ? destino.iconoSeleccionado : destino.icono,
              size: 22,
              color: seleccionado ? TemaApp.acento : TemaApp.textoSecundario,
            ),
          ),
          const SizedBox(height: 3),
          AnimatedDefaultTextStyle(
            duration: _duracion,
            curve: _curva,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: seleccionado ? FontWeight.w800 : FontWeight.w600,
              color: seleccionado
                  ? TemaApp.acentoTexto
                  : TemaApp.textoSecundario,
            ),
            child: Text(
              destino.etiqueta,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    ),
  );
}
