import '../models/comentario_dto.dart';
import '../models/contacto_local_dto.dart';
import '../models/disponibilidad_dia_dto.dart';
import '../models/espacio_dto.dart';
import '../models/franja_disponibilidad_dto.dart';
import '../models/reserva_dto.dart';
import '../models/servicio_contratado_dto.dart';
import '../models/servicio_extra_dto.dart';
import '../models/usuario_dto.dart';

final contactoCentro = ContactoLocalDto(
  id: 'c1',
  nombre: 'Ana Soler',
  telefono: '600 000 101',
  correo: 'ana@example.com',
);
final contactoParque = ContactoLocalDto(
  id: 'c2',
  nombre: 'Pau Vidal',
  telefono: '600 000 102',
  correo: 'pau@example.com',
);
final contactoMirador = ContactoLocalDto(
  id: 'c3',
  nombre: 'Nora Ferrer',
  telefono: '600 000 103',
  correo: 'nora@example.com',
);
final e1Limpieza = ServicioExtraDto(
  id: 'e1_limpieza',
  nombre: 'Limpieza final',
  descripcion: 'Limpieza del espacio al terminar.',
  precioCentimos: 1500,
);
final e1Cafe = ServicioExtraDto(
  id: 'e1_cafe',
  nombre: 'Pausa café',
  descripcion: 'Bebidas calientes para el grupo.',
  precioCentimos: 1200,
);
final e2Decoracion = ServicioExtraDto(
  id: 'e2_decoracion',
  nombre: 'Decoración',
  descripcion: 'Preparación decorativa del patio.',
  precioCentimos: 6000,
);
final e2Limpieza = ServicioExtraDto(
  id: 'e2_limpieza',
  nombre: 'Limpieza final',
  descripcion: 'Recogida y limpieza posterior.',
  precioCentimos: 2500,
);
final e3Materiales = ServicioExtraDto(
  id: 'e3_materiales',
  nombre: 'Material de taller',
  descripcion: 'Material consumible para la actividad.',
  precioCentimos: 1000,
);
final e3Limpieza = ServicioExtraDto(
  id: 'e3_limpieza',
  nombre: 'Limpieza final',
  descripcion: 'Limpieza de mesas y utensilios.',
  precioCentimos: 1200,
);
final e4Cafe = ServicioExtraDto(
  id: 'e4_cafe',
  nombre: 'Pausa café',
  descripcion: 'Servicio de bebidas para la reunion.',
  precioCentimos: 1000,
);
final e4Grabacion = ServicioExtraDto(
  id: 'e4_grabacion',
  nombre: 'Grabación',
  descripcion: 'Grabación local de la sesión.',
  precioCentimos: 2000,
);
final e5Montaje = ServicioExtraDto(
  id: 'e5_montaje',
  nombre: 'Montaje especial',
  descripcion: 'Distribucion del mobiliario antes del acto.',
  precioCentimos: 8000,
);
final e5Limpieza = ServicioExtraDto(
  id: 'e5_limpieza',
  nombre: 'Limpieza final',
  descripcion: 'Limpieza al terminar la celebración.',
  precioCentimos: 4500,
);
final e6Carpa = ServicioExtraDto(
  id: 'e6_carpa',
  nombre: 'Carpa',
  descripcion: 'Instalacion de una carpa de sombra.',
  precioCentimos: 4000,
);
final e6Limpieza = ServicioExtraDto(
  id: 'e6_limpieza',
  nombre: 'Limpieza final',
  descripcion: 'Recogida del jardin tras la actividad.',
  precioCentimos: 2000,
);
final usuariosDemo = <UsuarioDto>[
  UsuarioDto(id: 'u1', nombre: 'Alex López', correo: 'alex@example.com'),
  UsuarioDto(id: 'u2', nombre: 'Cris Marín', correo: 'cris@example.com'),
  UsuarioDto(id: 'u3', nombre: 'Sam Roca', correo: 'sam@example.com'),
];
final espaciosDemo = <EspacioDto>[
  EspacioDto(
    id: 'e1',
    nombre: 'Sala Ágora',
    descripcion:
        'Sala luminosa para reuniones de equipo y talleres de pequeño formato.',
    ubicacion: 'Centro · Calle del Encuentro, 12',
    horario: '09:00–20:00',
    condicionesUso: 'No fumar. Recoger el material al finalizar.',
    imagenAsset: 'assets/images/sala_agora.jpg',
    imagenesAssets: [
      'assets/images/sala_agora.jpg',
      'assets/images/sala_agora_02.jpg',
      'assets/images/sala_agora_03.jpg',
    ],
    sitioWeb: 'https://example.com/espacios/e1',
    serviciosDisponibles: [e1Limpieza, e1Cafe],
    aforo: 20,
    precioHoraCentimos: 3000,
    actividades: ['Reunión', 'Taller'],
    equipamiento: ['Wi-Fi', 'Proyector', 'Acceso sin escalones'],
    contacto: contactoCentro,
    moneda: 'EUR',
  ),
  EspacioDto(
    id: 'e2',
    nombre: 'Patio Llum',
    descripcion: 'Patio exterior con zona cubierta para celebraciónes y actividades en grupo.',
    ubicacion: 'Barrio del Parque · Plaza de la Luz, 4',
    horario: '10:00–22:00',
    condicionesUso: 'Respetar el horario y evitar música amplificada.',
    imagenAsset: 'assets/images/patio_llum.jpg',
    imagenesAssets: [
      'assets/images/patio_llum.jpg',
      'assets/images/patio_llum_02.jpg',
      'assets/images/patio_llum_03.jpg',
    ],
    sitioWeb: 'https://example.com/espacios/e2',
    serviciosDisponibles: [e2Decoracion, e2Limpieza],
    aforo: 40,
    precioHoraCentimos: 4500,
    actividades: ['Celebración', 'Taller'],
    equipamiento: ['Mesas', 'Zona cubierta', 'Aseos accesibles'],
    contacto: contactoParque,
    moneda: 'EUR',
  ),
  EspacioDto(
    id: 'e3',
    nombre: 'Aula Crea',
    descripcion: 'Aula flexible para talleres creativos y encuentros de grupos reducidos.',
    ubicacion: 'Centro · Calle del Encuentro, 12',
    horario: '09:00–20:00',
    condicionesUso: 'Proteger las mesas y limpiar los utensilios utilizados.',
    imagenAsset: 'assets/images/aula_crea.jpg',
    imagenesAssets: [
      'assets/images/aula_crea.jpg',
      'assets/images/aula_crea_02.jpg',
      'assets/images/aula_crea_03.jpg',
    ],
    sitioWeb: null,
    serviciosDisponibles: [e3Materiales, e3Limpieza],
    aforo: 16,
    precioHoraCentimos: 2000,
    actividades: ['Taller', 'Reunión'],
    equipamiento: ['Pizarra', 'Mesas móviles', 'Fregadero'],
    contacto: contactoCentro,
    moneda: 'EUR',
  ),
  EspacioDto(
    id: 'e4',
    nombre: 'Sala Mirador',
    descripcion:
        'Espacio tranquilo con vistas para reuniones y presentaciones.',
    ubicacion: 'Barrio Alto · Paseo del Mirador, 8',
    horario: '08:00–19:00',
    condicionesUso: 'Mantener el volumen bajo y dejar las sillas ordenadas.',
    imagenAsset: 'assets/images/sala_mirador.jpg',
    imagenesAssets: [
      'assets/images/sala_mirador.jpg',
      'assets/images/sala_mirador_02.jpg',
      'assets/images/sala_mirador_03.jpg',
    ],
    sitioWeb: 'https://example.com/espacios/e4',
    serviciosDisponibles: [e4Cafe, e4Grabacion],
    aforo: 12,
    precioHoraCentimos: 2500,
    actividades: ['Reunión'],
    equipamiento: ['Pantalla', 'Wi-Fi', 'Aire acondicionado'],
    contacto: contactoMirador,
    moneda: 'EUR',
  ),
  EspacioDto(
    id: 'e5',
    nombre: 'Salón Nexo',
    descripcion:
        'Salón amplio para celebraciónes, reuniones y talleres colectivos.',
    ubicacion: 'Barrio Alto · Paseo del Mirador, 10',
    horario: '10:00–23:00',
    condicionesUso:
        'No utilizar confeti. Devolver el mobiliario a su posición.',
    imagenAsset: 'assets/images/salon_nexo.jpg',
    imagenesAssets: [
      'assets/images/salon_nexo.jpg',
      'assets/images/salon_nexo_02.jpg',
      'assets/images/salon_nexo_03.jpg',
    ],
    sitioWeb: 'https://example.com/espacios/e5',
    serviciosDisponibles: [e5Montaje, e5Limpieza],
    aforo: 60,
    precioHoraCentimos: 6000,
    actividades: ['Celebración', 'Reunión', 'Taller'],
    equipamiento: ['Equipo de sonido', 'Sillas', 'Aseos accesibles'],
    contacto: contactoMirador,
    moneda: 'EUR',
  ),
  EspacioDto(
    id: 'e6',
    nombre: 'Jardín Brisa',
    descripcion:
        'Jardín con sombra para talleres y celebraciónes al aire libre.',
    ubicacion: 'Barrio del Parque · Camino de la Brisa, 3',
    horario: '09:00–21:00',
    condicionesUso: 'Cuidar la vegetación y retirar todos los residuos.',
    imagenAsset: 'assets/images/jardin_brisa.jpg',
    imagenesAssets: [
      'assets/images/jardin_brisa.jpg',
      'assets/images/jardin_brisa_02.jpg',
      'assets/images/jardin_brisa_03.jpg',
    ],
    sitioWeb: null,
    serviciosDisponibles: [e6Carpa, e6Limpieza],
    aforo: 30,
    precioHoraCentimos: 3500,
    actividades: ['Taller', 'Celebración'],
    equipamiento: ['Bancos', 'Zona de sombra', 'Punto de agua'],
    contacto: contactoParque,
    moneda: 'EUR',
  ),
];
final reservasDemo = <ReservaDto>[
  ReservaDto(
    id: 'r1',
    espacioId: 'e1',
    usuarioId: 'u1',
    actividad: 'Reunión',
    inicioIso: '2026-11-12T10:00:00',
    finIso: '2026-11-12T12:00:00',
    asistentes: 12,
    codigoEstado: 'CONF',
    tarifaHoraCentimos: 3000,
    precioTotalCentimos: 7500,
    moneda: 'EUR',
    serviciosContratados: [
      ServicioContratadoDto(
        servicioId: 'e1_limpieza',
        nombre: 'Limpieza final',
        precioCentimos: 1500,
      ),
    ],
  ),
  ReservaDto(
    id: 'r2',
    espacioId: 'e2',
    usuarioId: 'u1',
    actividad: 'Celebración',
    inicioIso: '2026-11-20T17:00:00',
    finIso: '2026-11-20T20:00:00',
    asistentes: 25,
    codigoEstado: 'PEND',
    tarifaHoraCentimos: 4500,
    precioTotalCentimos: 19500,
    moneda: 'EUR',
    serviciosContratados: [
      ServicioContratadoDto(
        servicioId: 'e2_decoracion',
        nombre: 'Decoración',
        precioCentimos: 6000,
      ),
    ],
  ),
  ReservaDto(
    id: 'r3',
    espacioId: 'e3',
    usuarioId: 'u1',
    actividad: 'Taller',
    inicioIso: '2026-11-08T16:00:00',
    finIso: '2026-11-08T18:00:00',
    asistentes: 10,
    codigoEstado: 'CANC',
    tarifaHoraCentimos: 2000,
    precioTotalCentimos: 4000,
    moneda: 'EUR',
    serviciosContratados: [],
  ),
  ReservaDto(
    id: 'r4',
    espacioId: 'e4',
    usuarioId: 'u2',
    actividad: 'Reunión',
    inicioIso: '2026-11-15T09:00:00',
    finIso: '2026-11-15T12:00:00',
    asistentes: 8,
    codigoEstado: 'CONF',
    tarifaHoraCentimos: 2500,
    precioTotalCentimos: 8500,
    moneda: 'EUR',
    serviciosContratados: [
      ServicioContratadoDto(
        servicioId: 'e4_cafe',
        nombre: 'Pausa café',
        precioCentimos: 1000,
      ),
    ],
  ),
];
final comentariosDemo = <ComentarioDto>[
  ComentarioDto(
    id: 'co1',
    espacioId: 'e1',
    autorId: 'u2',
    puntuacion: 5,
    texto: 'Sala cómoda y luminosa. El contacto nos atendió muy bien.',
    fechaIso: '2026-10-20T18:00:00',
  ),
  ComentarioDto(
    id: 'co2',
    espacioId: 'e1',
    autorId: 'u3',
    puntuacion: 4,
    texto: 'Buen espacio para reuniones; se oye algo de ruido al entrar.',
    fechaIso: '2026-10-21T18:00:00',
  ),
  ComentarioDto(
    id: 'co3',
    espacioId: 'e2',
    autorId: 'u1',
    puntuacion: 4,
    texto: 'Patio amplio y agradable para una celebración.',
    fechaIso: '2026-10-22T18:00:00',
  ),
  ComentarioDto(
    id: 'co4',
    espacioId: 'e3',
    autorId: 'u2',
    puntuacion: 5,
    texto: 'Las mesas móviles facilitan mucho los talleres.',
    fechaIso: '2026-10-23T18:00:00',
  ),
  ComentarioDto(
    id: 'co5',
    espacioId: 'e4',
    autorId: 'u3',
    puntuacion: 3,
    texto: 'Buenas vistas; resulta justo para grupos grandes.',
    fechaIso: '2026-10-24T18:00:00',
  ),
  ComentarioDto(
    id: 'co6',
    espacioId: 'e5',
    autorId: 'u1',
    puntuacion: 5,
    texto: 'El montaje especial nos ahorró mucho trabajo.',
    fechaIso: '2026-10-25T18:00:00',
  ),
];
final fechaReferenciaDemo = DateTime.now();
const diasDisponibilidadDemo = 60;
final disponibilidadDemo = crearDisponibilidadDemo(fechaReferenciaDemo);
List<DisponibilidadDiaDto> crearDisponibilidadDemo(DateTime referencia) {
  final resultado = <DisponibilidadDiaDto>[];
  for (
    var espacioIndex = 0;
    espacioIndex < espaciosDemo.length;
    espacioIndex++
  ) {
    for (var diaIndex = 0; diaIndex < diasDisponibilidadDemo; diaIndex++) {
      final dia = DateTime(
        referencia.year,
        referencia.month,
        referencia.day + diaIndex,
      );
      final franjas = <FranjaDisponibilidadDto>[];
      final horasInicio = [10, 13, 17];
      for (
        var franjaIndex = 0;
        franjaIndex < horasInicio.length;
        franjaIndex++
      ) {
        final hora = horasInicio[franjaIndex];
        franjas.add(
          FranjaDisponibilidadDto(
            inicioIso: DateTime(
              dia.year,
              dia.month,
              dia.day,
              hora,
            ).toIso8601String(),
            finIso: DateTime(
              dia.year,
              dia.month,
              dia.day,
              hora + 2,
            ).toIso8601String(),
            disponible: (espacioIndex + diaIndex + franjaIndex) % 4 != 0,
          ),
        );
      }
      resultado.add(
        DisponibilidadDiaDto(
          espacioId: espaciosDemo[espacioIndex].id,
          fechaIso: dia.toIso8601String(),
          franjas: List.unmodifiable(franjas),
        ),
      );
    }
  }
  return List.unmodifiable(resultado);
}
