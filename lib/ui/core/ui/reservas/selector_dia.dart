import 'package:material_ui/material_ui.dart';

import '../../../../config/tema_app.dart';
import '../../formatos.dart';

class SelectorDia extends StatefulWidget {
  const SelectorDia({
    super.key,
    required this.dias,
    required this.seleccionado,
    required this.habilitados,
    required this.alSeleccionar,
    this.referencia,
  });
  final List<DateTime> dias;

  final DateTime? referencia;
  final int seleccionado;
  final List<bool> habilitados;
  final ValueChanged<int> alSeleccionar;

  @override
  State<SelectorDia> createState() => _SelectorDiaState();
}

/// Mantiene visible el día seleccionado, también cuando se elige desde
/// fuera de la tira (por ejemplo, desde el calendario).
class _SelectorDiaState extends State<SelectorDia> {
  static const _anchoCasilla = 64.0;
  static const _separacion = 8.0;
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _mostrarSeleccion(false));
  }

  @override
  void didUpdateWidget(SelectorDia anterior) {
    super.didUpdateWidget(anterior);
    if (anterior.seleccionado != widget.seleccionado) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _mostrarSeleccion(true));
    }
  }

  void _mostrarSeleccion(bool animar) {
    if (!mounted || !_scroll.hasClients) return;
    final posicion = _scroll.position;
    final paso = _anchoCasilla + _separacion;
    final centro =
        widget.seleccionado * paso + _anchoCasilla / 2 - posicion.viewportDimension / 2;
    final destino = centro.clamp(0.0, posicion.maxScrollExtent).toDouble();
    if (animar) {
      _scroll.animateTo(
        destino,
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      );
    } else {
      _scroll.jumpTo(destino);
    }
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    controller: _scroll,
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
        for (var i = 0; i < widget.dias.length; i++)
          Padding(
            padding: const EdgeInsets.only(right: _separacion),
            child: _CasillaDia(
              dia: widget.dias[i],
              seleccionado: i == widget.seleccionado,
              habilitado: widget.habilitados[i],
              alPulsar: () => widget.alSeleccionar(i),
              referencia: widget.referencia,
            ),
          ),
      ],
    ),
  );
}

class _CasillaDia extends StatelessWidget {
  const _CasillaDia({
    required this.dia,
    required this.seleccionado,
    required this.habilitado,
    required this.alPulsar,
    this.referencia,
  });
  final DateTime dia;
  final DateTime? referencia;
  final bool seleccionado;
  final bool habilitado;
  final VoidCallback alPulsar;

  @override
  Widget build(BuildContext context) {
    final color = seleccionado
        ? Colors.white
        : habilitado
        ? TemaApp.tinta
        : TemaApp.textoSecundario.withValues(alpha: 0.5);
    return Material(
      color: seleccionado ? TemaApp.acento : TemaApp.superficie,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TemaApp.radioControl),
        side: BorderSide(
          color: seleccionado ? TemaApp.acento : TemaApp.borde,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(TemaApp.radioControl),
        onTap: habilitado ? alPulsar : null,
        child: SizedBox(
          width: _SelectorDiaState._anchoCasilla,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                Text(
                  referencia == null
                      ? Formatos.diaSemana(dia)
                      : Formatos.diaRelativo(dia, referencia!),
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  Formatos.diaMes(dia),
                  style: TextStyle(fontSize: 12, color: color),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
