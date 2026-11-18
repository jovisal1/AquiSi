import 'package:material_ui/material_ui.dart';

import '../../../../config/tema_app.dart';
import '../../../../domain/models/contacto_local.dart';
import '../textos/fila_informacion.dart';

class ContactoPanel extends StatelessWidget {
  const ContactoPanel({super.key, required this.contacto});
  final ContactoLocal contacto;

  @override
  Widget build(BuildContext context) {
    final temaTexto = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 22,
                  backgroundColor: TemaApp.acentoSuave,
                  child: Icon(Icons.person_rounded, color: TemaApp.acento),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(contacto.nombre, style: temaTexto.titleMedium),
                      Text('Responsable del espacio', style: temaTexto.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Divider(height: 16),
            FilaInformacion(
              icono: Icons.phone_rounded,
              etiqueta: 'Teléfono',
              valor: contacto.telefono,
              color: TemaApp.exito,
            ),
            FilaInformacion(
              icono: Icons.mail_rounded,
              etiqueta: 'Correo electrónico',
              valor: contacto.correo,
              color: TemaApp.azul,
            ),
          ],
        ),
      ),
    );
  }
}
