import 'package:material_ui/material_ui.dart';

import '../../../config/tema_app.dart';

class OpcionExtra extends StatelessWidget {
  const OpcionExtra({
    super.key,
    required this.titulo,
    required this.descripcion,
    required this.precio,
    required this.seleccionada,
    required this.alPulsar,
  });
  final String titulo;
  final String descripcion;
  final String precio;
  final bool seleccionada;
  final VoidCallback alPulsar;

  @override
  Widget build(BuildContext context) {
    final temaTexto = Theme.of(context).textTheme;
    final forma = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(TemaApp.radio),
      side: BorderSide(
        color: seleccionada ? TemaApp.acento : Colors.transparent,
      ),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Semantics(
        checked: seleccionada,
        child: Material(
          color: seleccionada ? TemaApp.acentoSuave : TemaApp.superficie,
          shape: forma,
          child: InkWell(
            customBorder: forma,
            onTap: alPulsar,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    seleccionada
                        ? Icons.check_box_rounded
                        : Icons.check_box_outline_blank_rounded,
                    color: seleccionada
                        ? TemaApp.acento
                        : TemaApp.textoSecundario,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(titulo, style: temaTexto.titleMedium),
                        const SizedBox(height: 2),
                        Text(descripcion, style: temaTexto.bodySmall),
                        const SizedBox(height: 6),
                        Text(
                          precio,
                          style: const TextStyle(
                            color: TemaApp.acentoTexto,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
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
}
