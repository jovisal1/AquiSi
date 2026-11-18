---
name: "pantallas-espaireserva"
description: "Criterios para crear o modificar pantallas y componentes de la app Flutter EspaiReserva (AquiSi): arquitectura, componentes, estilos y simplicidad del código."
---

# Pantallas y componentes de EspaiReserva

Proyecto docente del módulo PMDM (Flutter 3.50, `package:material_ui`, Dart 3.14). El código lo leen alumnos: debe ser **simple, legible y sin piezas que no aporten**. Ante la duda entre algo ingenioso y algo obvio, lo obvio.

Antes de escribir, leer la pantalla o componente más parecido que ya exista y seguir su forma.

## 1. Arquitectura (obligatoria por la rúbrica)

```
lib/
  main.dart                  arranque y creación de repositorios y pantallas raíz
  app.dart                   MaterialApp (tema, locale es_ES)
  config/tema_app.dart       tokens de diseño (TemaApp)
  domain/models/             modelos de la app (sin widgets ni colores)
  data/models/               DTO de la fuente
  data/services/             acceso al origen (DatosSimuladosService)
  data/repositories/         consulta, comprobación y conversión DTO → modelo
  ui/<funcionalidad>/ui/            pantallas (*_screen.dart) y componentes propios
  ui/<funcionalidad>/view_models/   *_view_model.dart (ChangeNotifier)
  ui/core/ui/<categoría>/    componentes compartidos
  ui/core/formatos.dart      formato de dinero, fechas, horas
```

- Flujo: servicio → repositorio → ViewModel → vista. Las vistas **nunca** leen servicios ni repositorios directamente; solo el ViewModel.
- ViewModel: `ChangeNotifier`, recibe los repositorios **por constructor**, expone getters y métodos; la vista usa `ListenableBuilder`. Sin paquetes de gestión de estado (Provider, Riverpod, Bloc…).
- Una pantalla recibe **solo los repositorios que usa su ViewModel o las pantallas que abre**. Nada de pasar repositorios "por si acaso". Para volver al inicio o cerrar sesión se usan callbacks (`alVolverASeccion`, `alCerrarSesion`), no se reconstruyen pantallas raíz.
- Los datos nuevos (reservas, etc.) se registran en el repositorio, que es la única fuente de verdad; no copias paralelas en el ViewModel.
- Componentes visuales: reciben datos y callbacks por parámetros; no consultan repositorios ni tienen ViewModel propio.

## 2. Componentes

Compartidos en `ui/core/ui/` agrupados por categoría:

| Carpeta | Contenido |
|---|---|
| `estructura/` | `ScaffoldApp`, `BarraSuperior`, `BarraAccionInferior`, `BarraNavegacion`, `MarcaApp` |
| `textos/` | `TituloPrincipal`, `TituloSeccion`, `Etiqueta`, `DatoIcono`, `FilaInformacion` |
| `controles/` | `BotonAccion`, `EnlaceAccion`, `CampoTexto`, `SelectorSegmentado`, `InsigniaUsuario` |
| `espacios/`, `reservas/`, `perfil/` | componentes de esos dominios usados en más de una pantalla |

Un componente específico de una sola funcionalidad va en `ui/<funcionalidad>/ui/`.

Reglas:
- Crear un componente solo si se repite, tiene una responsabilidad clara o simplifica de verdad la pantalla. **No** crear envoltorios triviales (p. ej. un `Panel` que solo es `Card` + `Padding`: escribir `Card(child: Padding(padding: const EdgeInsets.all(16), child: …))`).
- **Usar antes el widget de Flutter si existe**: `CalendarDatePicker`, `PageView`, `SliverAppBar`, `SegmentedButton`, `Card`, `ListTile`, `showModalBottomSheet`, `Hero`… Solo construir a mano lo que Flutter no ofrece.
- Evitar widgets privados (`_Algo`) salvo piezas pequeñas internas de un solo archivo; nunca "monstruos" con muchos widgets privados y parámetros opcionales. Mejor varios widgets públicos simples.
- Parámetros con nombres en español, `required` cuando son obligatorios, callbacks con prefijo `al` (`alPulsar`, `alCambiar`, `alSeleccionar`).
- Quitar parámetros, ramas y modos que ninguna pantalla use.

## 3. Estructura de una pantalla

```dart
class NombreScreen extends StatefulWidget {      // Stateful solo para crear/liberar el ViewModel
  const NombreScreen({super.key, required this.xRepository, ...});
  ...
}

class _NombreScreenState extends State<NombreScreen> {
  late final NombreViewModel _viewModel;
  @override void initState() { super.initState(); _viewModel = NombreViewModel(...); }
  @override void dispose() { _viewModel.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _viewModel,
    builder: (context, child) => ScaffoldApp(
      titulo: 'Nombre',                          // pestaña del navegador
      barra: BarraSuperior(avatar: InsigniaUsuario(...)),
      accionInferior: BarraAccionInferior(...),  // si hay acción principal fija
      hijos: [ TituloPrincipal(...), ... ],
    ),
  );
}
```

- `ScaffoldApp` para listas normales (ancho máx. 800, márgenes 20). Solo si hace falta cabecera plegable, `Scaffold` + `CustomScrollView` + `SliverAppBar` + `SliverToBoxAdapter` (como el detalle del espacio).
- Login sin barra superior; el resto con `BarraSuperior`.
- Una sola acción principal por pantalla; si es la acción del flujo, fija abajo con `BarraAccionInferior` y botón compacto.
- Mantener el `build` legible: si supera ~10 niveles de anidación, extraer un método `_seccion()` o un componente.
- Textos estáticos de interfaz pueden quedarse en la vista; los datos vienen del ViewModel.
- No hace falta validación de formularios ni avisos de "demo".

## 4. Estilos

Usar siempre los tokens de `TemaApp`, nunca colores o radios sueltos. Si falta un valor, añadirlo una vez a `TemaApp`.

- Colores: `fondo` (crema), `superficie` (blanco), `superficieAtenuada`, `tinta` (texto), `textoSecundario`, `borde`, `acento` (coral), `acentoTexto` (coral oscuro para texto sobre claro), `acentoSuave`, `sol`/`solSuave`, `azul`/`azulSuave`, `exito`, `aviso`, `error`, `sombra`.
- Radios: `TemaApp.radio` (20) para tarjetas, `TemaApp.radioControl` (16) para controles. Avatares y detalles pequeños, redondos.
- Tipografía Montserrat (incluida en `assets/fonts`, declarada como una familia en `pubspec.yaml`); jerarquía mediante `Theme.of(context).textTheme`.
- Contraste mínimo 4,5:1: texto coral sobre fondos claros con `acentoTexto`, no con `acento`.
- Estados (libre, ocupada, cancelada…) siempre con texto, no solo color.
- Espaciados 8/12/16/20/24. Zonas táctiles de al menos 44×44.
- Imágenes en `assets/images/`, declaradas en `pubspec.yaml` y acreditadas en `docs/RECURSOS.md`.
- Fechas y textos de Material en español (`locale: Locale('es', 'ES')` con `GlobalMaterialLocalizations.delegates`); formatos propios en `Formatos`.

## 5. Simplicidad del código

- **Comentarios**: solo los que explican algo no evidente (una restricción de layout, un truco necesario, una decisión de arquitectura). Sin comentarios que repitan el código ni `///` en cada clase.
- **Sin `Semantics`, `ExcludeSemantics` ni `semanticLabel`**: cargan el código y no los pide la rúbrica.
- Nombres en español, `lowerCamelCase` para variables y métodos, `UpperCamelCase` para clases, archivos en `snake_case`; pantallas `*_screen.dart` / `*Screen`, ViewModels `*_view_model.dart` / `*ViewModel`.
- **Nunca** parámetros nombrados privados (`required this._campo`): usar `required Tipo campo` y `: _campo = campo`.
- Cuidado con `num` frente a `double`: `cond ? x : 0` o `clamp()` devuelven `num`; usar `0.0`, `.toDouble()` o declarar `final double`.
- Sin dependencias nuevas salvo que el usuario las pida.

## 6. Comprobar antes de terminar

1. `dart format lib` y `flutter analyze lib` sin errores.
2. Sin archivos obsoletos ni imports sin uso (borrar o avisar de lo que sobre).
3. Probar a **360 px** de ancho: sin desbordamientos, textos largos con `maxLines`/`Expanded`, contenido no tapado por barras.
4. Recorridos completos: login → espacios → detalle → nueva reserva → confirmación → mis reservas / perfil, y volver.
5. No decir que algo está comprobado si solo se ha leído el código.
6. En commits y documentación, ninguna firma ni mención a la IA.