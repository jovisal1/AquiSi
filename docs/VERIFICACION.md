# Comprobaciones de la primera entrega

Fecha: 13 de noviembre de 2026. Estado evaluado: directorio de trabajo, sin commit publicado. Referencia: enunciado de la entrega 1 y criterios del corrector aportado. Este documento recoge comprobaciones técnicas y manuales; no asigna una nota ni garantiza el resultado de una revisión docente.

## Calidad y responsabilidades

- DTO y dominio separados, nueve modelos por capa, colecciones protegidas y relaciones por objetos en el dominio.
- Servicio local único; repositorios que convierten, comprueban y conservan datos, sin consultas desde componentes o pantallas.
- Dependencias recibidas por constructor; cada pantalla crea su ViewModel en `initState`, lo libera en `dispose` y escucha sus cambios mediante `ListenableBuilder`.
- Componentes compartidos reutilizados y separados en archivos propios. `componentes.dart` y `vista_modelo.dart` se han eliminado a petición del usuario.
- `main.dart` limitado al arranque. Servicio y repositorios creados explícitamente en `main.dart`, pasados mediante constructores normales, sin contenedor de dependencias. Estilos en `TemaApp`. `EspaiReservaApp` recibe `LoginScreen` como pantalla inicial y la muestra con `home`. La navegación está en las pantallas y usa `Navigator.of(context)` y `MaterialPageRoute`, sin coordinador ni clave global.
- `Formatos` centraliza la representación de importes, fechas y horas. Los cálculos y selecciones de reserva permanecen en su ViewModel.

## Verificación técnica

- `dart format lib`: aplicado.
- `flutter analyze lib`: sin incidencias.
- `flutter build web --release`: compilación correcta.
- `flutter build apk --debug`: compilación Android correcta; APK en `build/app/outputs/flutter-apk/app-debug.apk`.
- Los 18 recursos de las galerías existen en `assets/images/` y están declarados en `pubspec.yaml`.

## Recorridos observados en web a 360 × 800

- Registro desde login y regreso mediante el enlace de inicio de sesión.
- Acceso normal y acceso con el botón Google al mismo catálogo.
- Las tres secciones principales y el cierre de sesión con regreso al acceso.
- Catálogo de seis espacios, desplazamiento hasta Jardín Brisa y apertura de ese último espacio.
- Detalles diferentes para Sala Ágora y Jardín Brisa: identidad, descripción, tarifa, contacto y web opcional.
- Solicitud y confirmación de Sala Ágora. Totales observados: 60 € sin extras, 75 € con limpieza, 87 € con limpieza y café, 72 € después de desmarcar limpieza. La confirmación mantiene solo café, dos horas, alquiler de 60 €, extras de 12 € y total de 72 €.
- Continuación a Mis reservas, donde permanecen los tres ejemplos precargados y sus distintos estados.
- Semana de disponibilidad de siete días y tres franjas por día.
- Jardín Brisa comienza sin valoraciones. Publicar una opinión muestra autor, fecha, texto, cinco estrellas y media de 5. Al salir y reabrir el detalle vuelve a «Sin valoraciones».
- Se detectó un recorte de la segunda línea en las etiquetas de disponibilidad y se sustituyeron por `Etiqueta`, un componente informativo que permite varias líneas. Se añadieron controles anterior/siguiente a la galería.

## Capturas

Las imágenes de `capturas/` corresponden a las siete pantallas mínimas, confirmación y una opinión local. Son vistas de 360 × 800 y muestran solo una parte del contenido desplazable. Las fechas de disponibilidad se regeneran al arrancar, de modo que cambiarán en futuras ejecuciones.

## Límites y entrega pendiente

La inspección manual se ha realizado en la versión web; no se ha recorrido la aplicación en un dispositivo Android ni se ha comprobado el teclado virtual de un móvil. El APK se ha compilado. La limpieza de rutas se implementa con Navigator y eliminación de las rutas anteriores; conviene comprobar también el botón Atrás físico en el dispositivo de entrega.

No hay publicación remota ni hash de commit evaluable. La carpeta `.git` disponible está vacía y es de solo lectura. El usuario debe indicar el repositorio de entrega y el commit completo al presentar el trabajo.

La segunda entrega, con `go_router`, formularios completos y creación de reservas en memoria, queda fuera del alcance acordado con el corrector de la primera entrega. Fuentes y limitaciones funcionales se detallan en el README.
