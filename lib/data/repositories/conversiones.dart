import '../../domain/models/contacto_local.dart';
import '../../domain/models/espacio.dart';
import '../../domain/models/servicio_contratado.dart';
import '../../domain/models/servicio_extra.dart';
import '../../domain/models/usuario.dart';
import '../models/contacto_local_dto.dart';
import '../models/espacio_dto.dart';
import '../models/servicio_contratado_dto.dart';
import '../models/servicio_extra_dto.dart';
import '../models/usuario_dto.dart';

ContactoLocal convertirContactoLocal(ContactoLocalDto dto) => ContactoLocal(
  id: dto.id,
  nombre: dto.nombre,
  telefono: dto.telefono,
  correo: dto.correo,
);
Usuario convertirUsuario(UsuarioDto dto) =>
    Usuario(id: dto.id, nombre: dto.nombre, correo: dto.correo);
ServicioExtra convertirServicioExtra(ServicioExtraDto dto) => ServicioExtra(
  id: dto.id,
  nombre: dto.nombre,
  descripcion: dto.descripcion,
  precioCentimos: dto.precioCentimos,
);
ServicioContratado convertirServicioContratado(ServicioContratadoDto dto) =>
    ServicioContratado(
      servicioId: dto.servicioId,
      nombre: dto.nombre,
      precioCentimos: dto.precioCentimos,
    );
Espacio convertirEspacio(EspacioDto dto) => Espacio(
  id: dto.id,
  nombre: dto.nombre,
  descripcion: dto.descripcion,
  ubicacion: dto.ubicacion,
  horario: dto.horario,
  condicionesUso: dto.condicionesUso,
  imagenAsset: dto.imagenAsset,
  imagenesAssets: dto.imagenesAssets,
  sitioWeb: dto.sitioWeb,
  serviciosDisponibles: dto.serviciosDisponibles
      .map(convertirServicioExtra)
      .toList(),
  aforo: dto.aforo,
  precioHoraCentimos: dto.precioHoraCentimos,
  precioDiaCentimos: dto.precioDiaCentimos,
  actividades: dto.actividades,
  equipamiento: dto.equipamiento,
  contacto: convertirContactoLocal(dto.contacto),
  moneda: dto.moneda,
);

void comprobar(bool condicion, String mensaje) {
  if (!condicion) throw StateError(mensaje);
}

void comprobarIdentificadores(Iterable<String> ids) {
  final lista = ids.toList();
  comprobar(
    lista.every((id) => id.trim().isNotEmpty) &&
        lista.toSet().length == lista.length,
    'Identificadores vacíos o duplicados',
  );
}
