import '../models/comentario_dto.dart';
import '../models/disponibilidad_dia_dto.dart';
import '../models/espacio_dto.dart';
import '../models/reserva_dto.dart';
import '../models/usuario_dto.dart';

class DatosSimuladosService {
  DatosSimuladosService({
    required List<EspacioDto> espacios,
    required List<UsuarioDto> usuarios,
    required List<ReservaDto> reservas,
    required List<ComentarioDto> comentarios,
    required List<DisponibilidadDiaDto> disponibilidad,
  }) : _espacios = List.unmodifiable(espacios),
       _usuarios = List.unmodifiable(usuarios),
       _reservas = List.unmodifiable(reservas),
       _comentarios = List.unmodifiable(comentarios),
       _disponibilidad = List.unmodifiable(disponibilidad);
  final List<EspacioDto> _espacios;
  List<EspacioDto> leerEspacios() => _espacios;
  final List<UsuarioDto> _usuarios;
  List<UsuarioDto> leerUsuarios() => _usuarios;
  final List<ReservaDto> _reservas;
  List<ReservaDto> leerReservas() => _reservas;
  final List<ComentarioDto> _comentarios;
  List<ComentarioDto> leerComentarios() => _comentarios;
  final List<DisponibilidadDiaDto> _disponibilidad;
  List<DisponibilidadDiaDto> leerDisponibilidad() => _disponibilidad;
}
