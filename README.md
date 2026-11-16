# EspaiReserva

Aplicación Flutter de reserva de espacios para el proyecto integrador de PMDM. Implementa la **primera entrega**, con los criterios adicionales de arquitectura y ViewModels del prompt de corrección proporcionado. No implementa la segunda entrega con `go_router`, autenticación o creación de reservas persistentes.

## Ejecutar

Entorno utilizado: **Flutter 3.50.0 stable**, **Dart 3.14.0**. El proyecto requiere Dart 3.14 o posterior. Se conservan `pubspec.lock` y las reglas de `flutter_lints`.

```bash
flutter pub get
flutter run -d chrome
```

Para Android, inicia un emulador o conecta un dispositivo con depuración USB y ejecuta `flutter run`. Plataformas incluidas: Android y web.

```bash
flutter analyze lib
flutter build web --release
flutter build apk --debug
```

La plantilla de Flutter 3.50 utiliza `material_ui`, por lo que los componentes Material se importan desde ese paquete. Las primitivas de Flutter, `ChangeNotifier` y los gestos siguen usando el SDK. No se necesitan paquetes de gestión de estado, red, navegación ni inyección de dependencias.

## Recorrido

1. Login: correo y contraseña precargados; Entrar, Google y Apple abren el catálogo con el mismo usuario ficticio. El registro permite volver al login y no almacena contraseñas.
2. Catálogo: seis espacios desplazables y búsqueda funcional por nombre o ubicación. Cada tarjeta abre su propio detalle, incluida la última.
3. Detalle: tres fotografías locales, indicador y controles de galería, ubicación, aforo, actividades, equipamiento, tarifa, contacto, condiciones, horario y web opcional. Disponibilidad de hoy y seis días siguientes. Opiniones, media y alta local.
4. Nueva reserva: propuesta de actividad, fecha, horario y asistentes coherentes con el espacio. Esos controles son de lectura; los extras se pueden seleccionar y desmarcar.
5. Confirmación: mantiene el espacio, usuario, fecha, actividad, asistentes, extras contratados y desglose. El botón de continuación abre Mis reservas.
6. Mis reservas: tres reservas del usuario `u1`, con estados confirmada, pendiente y cancelada, extras, importes y contacto del local.
7. Perfil: usuario coherente con acceso y opiniones, preferencia de recordatorios, información de versión y cierre de sesión.

La barra inferior conecta Espacios, Mis reservas y Perfil. El acceso y el cierre de sesión usan `pushAndRemoveUntil` para limpiar rutas. Detalle y solicitud permiten volver. La confirmación sustituye la solicitud; continuar limpia el recorrido anterior y abre Mis reservas.

## Arquitectura

```text
lib/
  main.dart                         # arranque y creación del servicio y repositorios
  app.dart                          # configuración de MaterialApp
  config/                           # TemaApp
  domain/models/                    # nueve modelos independientes de Flutter
  data/
    models/                         # nueve DTO de la fuente
    services/                       # datos de ejemplo y servicio local
    repositories/                   # consultas, conversión y coherencia
  ui/
    core/formatos.dart              # formatos comunes de importes y fechas
    core/ui/                        # un archivo por componente compartido
    acceso/{ui,view_models}/
    espacios/{ui,view_models}/
    reservas/{ui,view_models}/
    perfil/{ui,view_models}/
    navegacion/ui/                  # pantalla de las secciones principales
assets/images/                      # 18 fotografías locales
```

El flujo es **servicio → repositorio → ViewModel → vista → componentes**. `main.dart` crea el servicio y los repositorios una sola vez, construye `LoginScreen` con esos repositorios y se la pasa como pantalla inicial a `EspaiReservaApp`. No hay un contenedor de dependencias. `TemaApp` contiene los estilos. `MaterialApp` muestra el login mediante `home`. Las pantallas reciben los repositorios explícitamente por constructor y crean sus ViewModels en `initState`. Al abrir otra pantalla pasan las mismas referencias, sin recrear la fuente de datos. La representación no consulta repositorios ni DTO. La navegación se escribe en cada pantalla con `Navigator.of(context)` y `MaterialPageRoute`, como en los apuntes, sin coordinador ni clave global. Cada pantalla es propietaria de su ViewModel: lo crea en `initState`, escucha con `ListenableBuilder` y llama a `dispose` al desmontarse. No se utiliza una clase base ni un contenedor genérico para ese ciclo de vida. Las secciones conservan su estado mediante `IndexedStack`.

Los ViewModels obtienen los datos y mantienen búsqueda, selección de extras, página de galería, opiniones y preferencias. Preparan medias y precios; no construyen widgets ni reciben `BuildContext`. La posición técnica del `PageController` pertenece al componente de galería, que libera ese recurso al cerrarse.

Cada componente tiene su propio archivo en `ui/core/ui/`. `Formatos` reúne los métodos estáticos de formato de dinero, fecha y hora; los cálculos de selección y precios corresponden al ViewModel y los importes históricos al modelo de reserva. Los componentes reciben contenido y acciones: `EspacioTarjeta`, `ReservaTarjeta`, `BotonAccion`, `CampoTexto`, `TituloSeccion`, `DatoIcono`, `Etiqueta`, `ContactoPanel`, `FilaImporte` y `Panel`. Galería, opiniones y disponibilidad se ubican en la funcionalidad de espacios. Las etiquetas informativas no son controles de selección.

## Datos y coherencia

Se utiliza el conjunto de datos de los apuntes, adaptando ortografía y rutas de imágenes: Sala Ágora, Patio Llum, Aula Crea, Sala Mirador, Salón Nexo y Jardín Brisa. Hay tres usuarios, tres contactos y cuatro reservas en la fuente; el usuario de acceso es **Alex López** (`u1`, `alex@example.com`). Solo sus tres reservas se muestran en Mis reservas. No se contrastan credenciales.

Los DTO mantienen referencias por identificador, fechas ISO y códigos `CONF/PEND/CANC`. Los repositorios convierten a relaciones `Espacio`/`Usuario`, `DateTime` y `EstadoReserva`, conservando el resto de campos. Comprueban identificadores vacíos o duplicados, referencias, aforo, actividades, moneda, importes no negativos, extras propios sin duplicados, intervalos de horas completas, total de reservas, opiniones de 1–5 y franjas del mismo día sin solapamientos. Una semana incompleta provoca un error de fuente; no se inventan días libres.

Todos los importes son enteros en céntimos, en EUR y con IVA incluido. Los extras se cobran una vez por reserva. La tarifa histórica y los servicios contratados se conservan en la reserva, independientemente de la oferta actual. Las listas expuestas por modelos, DTO, repositorios y ViewModels se protegen mediante `List.unmodifiable`.

La disponibilidad se genera una vez al arrancar, usando una fecha local común. Cada espacio dispone de tres franjas por día y su propio patrón libre/ocupado. Las reservas precargadas tienen fechas fijas de noviembre de 2026.

## Alcance de las simulaciones

- Acceso y registro sin servidor, cuentas externas ni almacenamiento de contraseñas.
- Confirmación de una propuesta, sin cobro ni inserción en la fuente. Mis reservas sigue mostrando los ejemplos precargados.
- Disponibilidad independiente de las reservas; confirmar no bloquea franjas.
- Las opiniones añadidas viven exclusivamente en el ViewModel del detalle y desaparecen al cerrarlo.
- Las preferencias duran mientras permanezca la sesión de navegación.
- Las fotografías ilustran locales ficticios. Las webs y los contactos son de ejemplo; la web se muestra como texto.
- Sin persistencia ni validación completa de formularios, de acuerdo con el alcance del corrector.

## Criterios visuales

Identidad EspaiReserva, verde principal, fondo marfil, tarjetas blancas y colores de estado acompañados siempre de texto. Jerarquía Material con titulares, títulos de sección y cuerpo de 14–16 píxeles lógicos. Espaciados de 8/16/24 y margen de pantalla de 20. Tarjetas de 20 de radio, campos de 12, acciones principales rellenas y secundarias con borde. El tema y los componentes compartidos fijan las equivalencias.

Una única lista vertical por pantalla permite desplazar formularios y contenido largo. Las filas con texto usan espacio flexible y las etiquetas se distribuyen con `Wrap`. El contenido se limita a 800 píxeles en pantallas amplias. Se ha inspeccionado la web a **360 × 800 píxeles lógicos**. Las capturas representan la parte visible de cada pantalla, no todo su contenido desplazable.

## Comprobaciones y entrega

Consulta [VERIFICACION.md](docs/VERIFICACION.md), las [capturas](docs/capturas/) y las [fuentes de imágenes](docs/RECURSOS.md).

La revisión se refiere al directorio de trabajo. Este entorno no contiene un repositorio Git inicializado utilizable. Para la entrega docente queda pendiente publicar el proyecto en un repositorio accesible e indicar el hash completo del commit evaluado. No se inventa un hash ni una calificación.

No incluyas `.dart_tool/`, `build/`, `.idea/` ni `android/local.properties` en la entrega. Están excluidos mediante `.gitignore`; Flutter recrea los artefactos al ejecutar los comandos anteriores.

## Fuentes

- [Proyecto integrador](https://jovisal1.github.io/ApuntesPMDM/proyecto-integrador/)
- [Primera entrega](https://jovisal1.github.io/ApuntesPMDM/proyecto-integrador/entrega-1/)
- [Dominio](https://jovisal1.github.io/ApuntesPMDM/proyecto-integrador/entrega-1/dominio/), [datos](https://jovisal1.github.io/ApuntesPMDM/proyecto-integrador/entrega-1/datos/), [presentación](https://jovisal1.github.io/ApuntesPMDM/proyecto-integrador/entrega-1/presentacion/), [datos ficticios](https://jovisal1.github.io/ApuntesPMDM/proyecto-integrador/entrega-1/datos-ficticios/).
- [ViewModel y pantalla del curso](https://jovisal1.github.io/ApuntesPMDM/widgets/ejemplo-con-datos/pantalla-y-estado/)
- [Guía oficial de arquitectura Flutter](https://docs.flutter.dev/app-architecture/guide)
- Prompt local de corrección `Prompt_corrector_entrega_1`, aportado por el usuario: se aplican sus criterios de calidad y prevalencia docente. Sus instrucciones de redactar un informe sin modificar código corresponden a una revisión y no sustituyen la petición de implementar esta aplicación.
