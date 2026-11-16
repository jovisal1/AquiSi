import 'package:material_ui/material_ui.dart';

class CampoTexto extends StatelessWidget {
  const CampoTexto({
    super.key,
    required this.etiqueta,
    this.inicial,
    this.oculto = false,
    this.icono,
    this.tipo,
    this.alCambiar,
    this.controlador,
    this.soloLectura = false,
    this.lineas = 1,
  });
  final String etiqueta;
  final String? inicial;
  final bool oculto;
  final IconData? icono;
  final TextInputType? tipo;
  final ValueChanged<String>? alCambiar;
  final TextEditingController? controlador;
  final bool soloLectura;
  final int lineas;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: TextFormField(
      controller: controlador,
      initialValue: controlador == null ? inicial : null,
      obscureText: oculto,
      keyboardType: tipo,
      onChanged: alCambiar,
      readOnly: soloLectura,
      maxLines: lineas,
      decoration: InputDecoration(
        labelText: etiqueta,
        prefixIcon: icono == null ? null : Icon(icono),
        alignLabelWithHint: true,
      ),
    ),
  );
}
