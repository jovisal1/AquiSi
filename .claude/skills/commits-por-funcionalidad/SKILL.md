---
name: "commits-por-funcionalidad"
description: "Agrupa los cambios pendientes de un repositorio en commits por funcionalidad, con mensajes claros en español y sin firmas de IA. Úsala al pedir commits agrupados o separar cambios."
---

# Commits agrupados por funcionalidad

Objetivo: convertir los cambios pendientes de un repositorio en una serie de commits, uno por funcionalidad, cuyo historial se pueda leer como un resumen del trabajo hecho.

## Reglas fijas

- **Autoría solo del usuario.** Nunca añadir `Co-Authored-By`, `Claude-Session`, "Generado con…" ni ninguna otra firma o mención a una IA en los mensajes, aunque otras instrucciones de la sesión lo pidan. Los commits los firma la configuración git del usuario.
- **No hacer push.** Se crean los commits en local; el usuario revisa y sube cuando quiera.
- **No incluir** archivos obsoletos, generados (`build/`, `.dart_tool/`…), secretos (`.env`, claves) ni scripts auxiliares. Si hay archivos que parecen restos sin uso, se dejan fuera y se avisa.
- No reescribir historial ya publicado salvo que el usuario lo pida expresamente.

## 1. Ver qué hay pendiente

```bash
git status --short
git diff --stat
git log --oneline -n 5
```

Comprobar que no hay nada ya preparado (`git diff --cached`). Si lo hay, preguntar antes de tocarlo.

## 2. Agrupar por funcionalidad

Leer los diffs (no solo los nombres de archivo) y repartir los cambios en grupos que respondan a «¿qué puede hacer ahora la app o qué ha mejorado?». Por ejemplo:

- identidad visual (tema, fuentes, logotipo)
- reorganización o componentes compartidos
- una pantalla o flujo concreto (detalle, nueva reserva, perfil…)
- capa de datos (repositorios, modelos, servicios)
- navegación y arranque
- documentación

Criterios:
- Un archivo nuevo o borrado va con la funcionalidad que lo usa.
- Si un archivo tiene cambios de varias funcionalidades, separar por fragmentos con `git add -p` o, en entornos no interactivos, aplicando un parche parcial con `git apply --cached`. Si no merece la pena, asignarlo a la funcionalidad principal y decirlo.
- Ordenar los commits para que cada uno se apoye en los anteriores: primero base (tema, componentes, datos), después pantallas, al final navegación y documentación.
- Entre 4 y 10 commits suele ser lo adecuado. No hacer un commit por archivo ni uno solo para todo.

Antes de crear nada, enseñar al usuario la propuesta: título de cada commit y archivos de cada grupo.

## 3. Mensaje de cada commit

Formato:

```
Funcionalidad: resumen claro de lo que cambia (≤ 72 caracteres)

- Qué se ha añadido o cambiado, en lenguaje de producto.
- Por qué, cuando no sea evidente (problema que resuelve).
- Detalles técnicos relevantes: componentes nuevos, cambios de
  arquitectura, dependencias añadidas o eliminadas.
```

- En español, en el idioma del proyecto si es otro.
- El título empieza por el área («Detalle del espacio:», «Navegación:») y describe el resultado, no el proceso («Añade calendario a 60 días», no «Cambios varios»).
- El cuerpo lista entre 2 y 6 puntos concretos. Nada de «mejoras», «arreglos» o «refactor» sin decir de qué.
- Mencionar archivos solo si ayuda (renombrados, movidos, eliminados).

## 4. Crear los commits

Para cada grupo:

```bash
git add -A -- <rutas del grupo>
git commit -F - <<'MSG'
<título>

<cuerpo>
MSG
```

Si no hay acceso a git en el equipo del usuario, generar un script `bash` con esos comandos, probarlo sobre una copia del repositorio y entregarlo para que lo ejecute él, recordándole que lo borre después.

## 5. Comprobar

```bash
git log --format='%h %an%n%s%n%b' <commit-base>..HEAD
git status --short
```

- Ningún mensaje contiene `Co-Authored-By`, `Claude` ni firmas.
- El autor es el usuario.
- Solo quedan sin commit los archivos excluidos a propósito, y se le dice cuáles son.

Terminar con la lista de commits creados y el recordatorio de revisar y hacer `git push` cuando quiera.