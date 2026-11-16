import 'package:material_ui/material_ui.dart';

import '../../../domain/models/contacto_local.dart';
import 'dato_icono.dart';
import 'panel.dart';

class ContactoPanel extends StatelessWidget {
  const ContactoPanel({super.key, required this.contacto});
  final ContactoLocal contacto;
  @override
  Widget build(BuildContext context) => Panel(
    hijo: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contacto del local',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        DatoIcono(icono: Icons.person_outline, texto: contacto.nombre),
        DatoIcono(icono: Icons.phone_outlined, texto: contacto.telefono),
        DatoIcono(icono: Icons.mail_outline, texto: contacto.correo),
      ],
    ),
  );
}
