import 'package:material_ui/material_ui.dart';

import '../../../../config/tema_app.dart';

enum EstadoFranja { libre, ocupada, pasada }

class FilaFranja extends StatelessWidget {
  const FilaFranja({
    super.key,
    required this.horario,
    required this.estado,
    this.seleccionada = false,
    this.alPulsar,
  });
  final String horario;
  final EstadoFranja estado;
  final bool seleccionada;
  final VoidCallback? alPulsar;

  @override
  Widget build(BuildContext context) {
    final libre = estado == EstadoFranja.libre;
    final seleccionable = alPulsar != null && libre;
    final texto = switch (estado) {
      EstadoFranja.libre => seleccionada ? 'Elegida' : 'Libre',
      EstadoFranja.ocupada => 'Ocupada',
      EstadoFranja.pasada => 'Pasada',
    };
    final colorEstado = !libre
        ? TemaApp.textoSecundario
        : seleccionada
        ? TemaApp.acentoTexto
        : TemaApp.exito;

    return Material(
      color: seleccionada ? TemaApp.acentoSuave : Colors.transparent,
      borderRadius: BorderRadius.circular(TemaApp.radioControl),
      child: InkWell(
        borderRadius: BorderRadius.circular(TemaApp.radioControl),
        onTap: seleccionable ? alPulsar : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          child: Row(
            children: [
              if (alPulsar != null) ...[
                Icon(
                  seleccionada
                      ? Icons.check_box_rounded
                      : Icons.check_box_outline_blank_rounded,
                  size: 20,
                  color: seleccionada
                      ? TemaApp.acento
                      : libre
                      ? TemaApp.textoSecundario
                      : TemaApp.borde,
                ),
                const SizedBox(width: 10),
              ] else ...[
                Icon(
                  Icons.schedule_rounded,
                  size: 18,
                  color: libre ? TemaApp.tinta : TemaApp.textoSecundario,
                ),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: Text(
                  horario,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: libre ? TemaApp.tinta : TemaApp.textoSecundario,
                    decoration: libre ? null : TextDecoration.lineThrough,
                    decorationColor: TemaApp.textoSecundario,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: ShapeDecoration(
                  color: !libre
                      ? TemaApp.superficieAtenuada
                      : seleccionada
                      ? TemaApp.superficie
                      : TemaApp.exito.withValues(alpha: 0.12),
                  shape: const StadiumBorder(),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: colorEstado,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      texto,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: colorEstado,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
