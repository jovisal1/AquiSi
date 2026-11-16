import 'package:material_ui/material_ui.dart';

class BotonAccion extends StatelessWidget {
  const BotonAccion({
    super.key,
    required this.texto,
    required this.alPulsar,
    this.icono,
    this.secundario = false,
  });
  final String texto;
  final VoidCallback? alPulsar;
  final IconData? icono;
  final bool secundario;
  @override
  Widget build(BuildContext context) {
    final contenido = Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icono != null) ...[Icon(icono), const SizedBox(width: 8)],
          Flexible(child: Text(texto, textAlign: TextAlign.center)),
        ],
      ),
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
