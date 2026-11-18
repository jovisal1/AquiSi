import 'package:material_ui/material_ui.dart';

class BotonAccion extends StatelessWidget {
  const BotonAccion({
    super.key,
    required this.texto,
    required this.alPulsar,
    this.icono,
    this.secundario = false,
    this.compacto = false,
  });
  final String texto;
  final VoidCallback? alPulsar;
  final IconData? icono;
  final bool secundario;
  final bool compacto;

  @override
  Widget build(BuildContext context) {
    if (compacto) {
      // El tema fija un ancho mínimo infinito: aquí se sustituye para que el
      // botón pueda vivir en una fila sin restricción de ancho.
      const estilo = ButtonStyle(
        minimumSize: WidgetStatePropertyAll(Size(0, 48)),
        padding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 22),
        ),
      );
      final contenido = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icono != null) ...[Icon(icono, size: 18), const SizedBox(width: 8)],
          Text(texto),
        ],
      );
      return secundario
          ? OutlinedButton(onPressed: alPulsar, style: estilo, child: contenido)
          : FilledButton(onPressed: alPulsar, style: estilo, child: contenido);
    }

    final contenido = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icono != null) ...[Icon(icono, size: 20), const SizedBox(width: 8)],
        Flexible(child: Text(texto, textAlign: TextAlign.center)),
      ],
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: SizedBox(
        width: double.infinity,
        child: secundario
            ? OutlinedButton(onPressed: alPulsar, child: contenido)
            : FilledButton(onPressed: alPulsar, child: contenido),
      ),
    );
  }
}
