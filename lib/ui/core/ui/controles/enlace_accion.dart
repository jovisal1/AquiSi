import 'package:material_ui/material_ui.dart';

class EnlaceAccion extends StatelessWidget {
  const EnlaceAccion({
    super.key,
    required this.texto,
    required this.alPulsar,
    this.centrado = false,
  });
  final String texto;
  final VoidCallback? alPulsar;
  final bool centrado;

  @override
  Widget build(BuildContext context) => Align(
    alignment: centrado ? Alignment.center : Alignment.centerLeft,
    child: TextButton(
      onPressed: alPulsar,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: const Size(0, 40),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text('$texto →'),
    ),
  );
}
