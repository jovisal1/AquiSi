# Guía de diseño y disposición visual

Referencia: diseño de Figma «Encuentro · Rediseño de reserva de espacios» (11 pantallas). Se adopta su **lenguaje visual**, no su modelo de datos: EspaiReserva sigue trabajando con espacios, tarifa por hora y extras, tal como exige la primera entrega.

## Lenguaje visual

| Elemento | Criterio | Dónde se fija |
|---|---|---|
| Fondo | Blanco en todas las pantallas | `TemaApp.fondo` |
| Acento | Morado `#7C1CE6` solo para selección, enlaces, estrellas y navegación activa | `TemaApp.acento` |
| Acción principal | Botón negro relleno, 52 px de alto, radio 12. **Una por pantalla** | `BotonAccion` |
| Acción secundaria | Botón gris de superficie, mismo tamaño | `BotonAccion(secundario: true)` |
| Acción terciaria | Enlace morado con «→» | `EnlaceAccion` |
| Agrupaciones | Superficie gris `#F4F4F6`, radio 14, sin borde ni sombra | `Panel` / `cardTheme` |
| Selección | Fondo lavanda + borde morado (extras), relleno morado (filtros) | `OpcionExtra`, `SelectorSegmentado` |
| Estados de reserva | Versalitas de color + texto (Confirmada, Pendiente, Cancelada) | `ReservaTarjeta` |
| Titular de pantalla | 26–30 px, negrita, interletraje negativo | `TituloPrincipal` |
| Título de sección | 17 px, negrita, subtítulo gris 12,5 px | `TituloSeccion` |
| Texto secundario | Gris `#6B6B73`, 12,5 px | `bodySmall` |
| Márgenes | 20 px laterales; separaciones 8 / 12 / 16 / 24 | `Pagina` |

## Disposición por pantalla

1. **Acceso** — Ilustración arriba → titular en dos líneas → campos → botón negro «Entrar con correo» → Google y Apple **en una misma fila** (dos `Expanded`) → enlace de registro. Así la acción principal queda clara y las alternativas no compiten con ella.
2. **Registro** — Misma estructura que el acceso; sustituir el segundo botón por un enlace «¿Ya tienes cuenta?» evita dos botones del mismo peso.
3. **Espacios (Explorar)** — Marca a la izquierda e iniciales del usuario a la derecha → titular → buscador → filtros por actividad en una fila desplazable → «Cerca de ti» con el recuento → tarjetas con imagen 16:9, nombre y precio en la **misma línea base**, metadatos en gris y enlace «Ver espacio →».
4. **Detalle** — Galería 4:3 con contador superpuesto y flechas dentro de la imagen → ubicación como antetítulo, nombre como titular, descripción → actividades (morado) y equipamiento (gris) como etiquetas → «Antes de venir» → contacto → disponibilidad → opiniones. La reserva pasa a una **barra inferior fija** con la tarifa: el usuario no tiene que volver arriba ni ver el botón repetido.
5. **Disponibilidad** — Cada día en una fila con sus tres franjas como casillas de igual ancho (`Expanded`). Libre: lavanda con borde; ocupada: gris atenuado. El estado se lee también como texto.
6. **Nueva reserva** — Pasos como antetítulo → propuesta en un panel de solo lectura (no en campos deshabilitados, que parecen editables) → extras como tarjetas seleccionables completas → resumen → contacto. Barra inferior fija con el **total actualizado** y «Confirmar reserva».
7. **Confirmación** — Icono de éxito en círculo lavanda → «¡Todo listo!» → tarjeta con desglose → aviso en panel lavanda. «Ir a mis reservas» en la barra inferior.
8. **Mis reservas** — Tarjetas grises: estado en versalitas, nombre, actividad y asistentes, fecha y horario a la izquierda con el importe alineado a la derecha, contacto al pie.
9. **Perfil** — Insignia morada con iniciales → nombre como titular y correo como subtítulo → preferencias → información → «Cerrar sesión» como acción secundaria (no destructiva visualmente).

## Reglas de composición que conviene mantener

- **Una sola acción negra por pantalla.** El resto, grises o enlaces.
- **Acción principal abajo y fija** cuando la pantalla es larga (detalle, nueva reserva, confirmación).
- **Importes alineados a la derecha** y etiquetas a la izquierda con `Expanded`, para que los textos largos se ajusten sin desbordar a 360 px.
- **No repetir el nombre** del espacio en la barra y en el titular: la barra dice «El espacio» y el contenido dice cuál.
- **Etiquetas informativas ≠ controles**: las etiquetas no tienen efecto al pulsarlas; los filtros y extras sí, y se distinguen por el relleno morado o el borde.
- **Color siempre con texto**: libre/ocupada y estados de reserva nunca dependen solo del color.
- **Nuevos estilos en el tema o en un componente**, no en la pantalla: si una pantalla necesita un `TextStyle` propio, probablemente falta una variante de un componente.

## Componentes nuevos

`TituloPrincipal`, `EnlaceAccion`, `SelectorSegmentado`, `InsigniaUsuario`, `BarraAccionInferior` (compartidos, en `ui/core/ui/`), `FranjaCasilla` (espacios) y `OpcionExtra` (reservas). `Pagina` admite ahora `accionInferior`; `Panel`, un color opcional; `PuntuacionEstrellas`, selección al pulsar.

## Cambios de comportamiento

- Filtro por actividad en Explorar, gestionado por `EspaciosViewModel` (`actividades`, `actividad`, `filtrarPorActividad`).
- Las iniciales se calculan en `Usuario.iniciales` y las exponen los ViewModels de Espacios y Perfil.
- La puntuación de una opinión se elige pulsando estrellas en lugar de un desplegable.
