import 'package:material_ui/material_ui.dart';

import '../../../../config/tema_app.dart';

class BarraAccionInferior extends StatelessWidget {
  const BarraAccionInferior({
    super.key,
    required this.boton,
    this.etiqueta,
    this.valor,
  });
  final Widget boton;
  final String? etiqueta;
  final String? valor;

  @override
  Widget build(BuildContext context) {
    final temaTexto = Theme.of(context).textTheme;
    final valor = this.valor;
    final etiqueta = this.etiqueta;

    final contenido = valor == null && etiqueta == null
        ? boton
        : Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (valor != null)
                      Text(valor, maxLines: 1, style: temaTexto.titleLarge),
                    if (etiqueta != null)
                      Text(
                        etiqueta,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: temaTexto.bodySmall,
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              boton,
            ],
          );

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: TemaApp.fondo,
        border: Border(top: BorderSide(color: TemaApp.borde)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          // heightFactor: 1 hace que la barra ocupe solo la altura de su
          // contenido y no toda la que le ofrece el Scaffold.
          child: Center(
            heightFactor: 1,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: contenido,
            ),
          ),
        ),
      ),
    );
  }
}
