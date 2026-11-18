import 'package:material_ui/material_ui.dart';

import 'app.dart';
import 'data/repositories/comentarios_repository.dart';
import 'data/repositories/disponibilidad_repository.dart';
import 'data/repositories/espacios_repository.dart';
import 'data/repositories/reservas_repository.dart';
import 'data/repositories/usuarios_repository.dart';
import 'data/services/datos_demo.dart';
import 'data/services/datos_simulados_service.dart';
import 'ui/acceso/ui/login_screen.dart';
import 'ui/navegacion/ui/inicio_screen.dart';

void main() {
  final service = DatosSimuladosService(
    espacios: espaciosDemo,
    usuarios: usuariosDemo,
    reservas: reservasDemo,
    comentarios: comentariosDemo,
    disponibilidad: disponibilidadDemo,
  );
  final espaciosRepository = EspaciosRepository(service: service);
  final usuariosRepository = UsuariosRepository(service: service);
  final reservasRepository = ReservasRepository(
    service: service,
    espacios: espaciosRepository,
    usuarios: usuariosRepository,
  );
  final comentariosRepository = ComentariosRepository(
    service: service,
    espacios: espaciosRepository,
    usuarios: usuariosRepository,
  );
  final disponibilidadRepository = DisponibilidadRepository(
    service: service,
    espacios: espaciosRepository,
  );

  // Las dos pantallas raíz se construyen aquí, donde están todas las
  // dependencias: el acceso solo necesita los usuarios y el inicio reparte a
  // cada sección los repositorios que usa.
  late final Widget Function() crearLogin;
  Widget crearInicio() => InicioScreen(
    espaciosRepository: espaciosRepository,
    usuariosRepository: usuariosRepository,
    reservasRepository: reservasRepository,
    comentariosRepository: comentariosRepository,
    disponibilidadRepository: disponibilidadRepository,
    fechaReferencia: fechaReferenciaDemo,
    crearLogin: crearLogin,
  );
  crearLogin = () => LoginScreen(
    usuariosRepository: usuariosRepository,
    crearInicio: crearInicio,
  );

  runApp(EspaiReservaApp(pantallaInicial: crearLogin()));
}
