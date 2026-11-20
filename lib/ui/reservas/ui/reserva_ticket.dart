import 'package:material_ui/material_ui.dart';

import '../../../config/tema_app.dart';
import '../../../domain/models/reserva.dart';
import '../../core/formatos.dart';
import '../../core/ui/textos/dato_icono.dart';
import '../../core/ui/reservas/reserva_tarjeta.dart';

class ReservaTicket extends StatelessWidget {
  const ReservaTicket({
    super.key,
    required this.reserva,
    required this.desplegada,
    required this.alPulsar,
    this.atenuada = false,
  });
  final Reserva reserva;
  final bool desplegada;
  final VoidCallback alPulsar;

  final bool atenuada;

  static const _anchoFecha = 76.0;
  static const _muesca = 18.0;

  @override
  Widget build(BuildContext context) {
    final temaTexto = Theme.of(context).textTheme;
    final r = reserva;
    final colorEstadoReserva = colorEstado(r.estado);

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: alPulsar,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _BloqueFecha(
                          fecha: r.inicio,
                          ancho: _anchoFecha,
                          atenuada: atenuada,
                        ),
                        const _LineaPerforada(),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                              14,
                              14,
                              16,
                              14,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 7,
                                      height: 7,
                                      decoration: BoxDecoration(
                                        color: colorEstadoReserva,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      etiquetaEstado(r.estado).toUpperCase(),
                                      style: temaTexto.labelSmall?.copyWith(
                                        color: colorEstadoReserva,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  r.espacio.nombre,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: temaTexto.titleMedium?.copyWith(
                                    fontSize: 17,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${_horario(r)} · ${r.actividad}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: temaTexto.bodySmall,
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${r.asistentes} asistentes',
                                        style: temaTexto.bodySmall,
                                      ),
                                    ),
                                    Text(
                                      Formatos.dinero(
                                        r.precioTotalCentimos,
                                        r.moneda,
                                      ),
                                      style: temaTexto.titleMedium,
                                    ),
                                    const SizedBox(width: 4),
                                    AnimatedRotation(
                                      turns: desplegada ? 0.5 : 0,
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      child: const Icon(
                                        Icons.expand_more_rounded,
                                        size: 20,
                                        color: TemaApp.textoSecundario,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOutCubic,
                    alignment: Alignment.topCenter,
                    child: desplegada
                        ? _Detalle(reserva: r)
                        : const SizedBox(width: double.infinity),
                  ),
                ],
              ),
              const Positioned(
                left: _anchoFecha - _muesca / 2,
                top: -_muesca / 2,
                child: _Muesca(diametro: _muesca),
              ),
              if (!desplegada)
                const Positioned(
                  left: _anchoFecha - _muesca / 2,
                  bottom: -_muesca / 2,
                  child: _Muesca(diametro: _muesca),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BloqueFecha extends StatelessWidget {
  const _BloqueFecha({
    required this.fecha,
    required this.ancho,
    required this.atenuada,
  });
  final DateTime fecha;
  final double ancho;
  final bool atenuada;

  @override
  Widget build(BuildContext context) {
    final color = atenuada ? TemaApp.textoSecundario : TemaApp.acentoTexto;
    return Container(
      width: ancho,
      color: atenuada ? TemaApp.superficieAtenuada : TemaApp.acentoSuave,
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            Formatos.mesCorto(fecha),
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
              color: color,
            ),
          ),
          Text(
            '${fecha.day}',
            style: TextStyle(
              fontSize: 30,
              height: 1.1,
              fontWeight: FontWeight.w700,
              color: atenuada ? TemaApp.textoSecundario : TemaApp.tinta,
            ),
          ),
          Text(
            Formatos.diaSemana(fecha),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _LineaPerforada extends StatelessWidget {
  const _LineaPerforada();

  @override
  Widget build(BuildContext context) =>
      const CustomPaint(size: Size(1, 0), painter: _TrazosPainter());
}

class _TrazosPainter extends CustomPainter {
  const _TrazosPainter();

  @override
  void paint(Canvas canvas, Size size) {
    const trazo = 5.0;
    const hueco = 4.0;
    final pincel = Paint()
      ..color = TemaApp.borde
      ..strokeWidth = 1;
    for (var y = 12.0; y < size.height - 12; y += trazo + hueco) {
      canvas.drawLine(Offset(0.5, y), Offset(0.5, y + trazo), pincel);
    }
  }

  @override
  bool shouldRepaint(_TrazosPainter oldDelegate) => false;
}

class _Muesca extends StatelessWidget {
  const _Muesca({required this.diametro});
  final double diametro;

  @override
  Widget build(BuildContext context) => Container(
    width: diametro,
    height: diametro,
    decoration: const BoxDecoration(
      color: TemaApp.fondo,
      shape: BoxShape.circle,
    ),
  );
}

class _Detalle extends StatelessWidget {
  const _Detalle({required this.reserva});
  final Reserva reserva;

  @override
  Widget build(BuildContext context) {
    final temaTexto = Theme.of(context).textTheme;
    final r = reserva;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(height: 1),
          const SizedBox(height: 10),
          Text(
            Formatos.cuando(r.modalidad, r.tramos),
            style: temaTexto.bodySmall,
          ),
          const SizedBox(height: 4),
          Text(
            r.serviciosContratados.isEmpty
                ? 'Sin extras · IVA incluido'
                : 'Extras: ${r.serviciosContratados.map((s) => s.nombre).join(', ')} · IVA incluido',
            style: temaTexto.bodySmall,
          ),
          const SizedBox(height: 6),
          DatoIcono(
            icono: Icons.person_outline,
            texto: '${r.espacio.contacto.nombre} · ${r.espacio.contacto.telefono}',
          ),
          DatoIcono(
            icono: Icons.mail_outline,
            texto: r.espacio.contacto.correo,
          ),
        ],
      ),
    );
  }
}

String _horario(Reserva r) => r.modalidad == ModalidadReserva.porDias
    ? Formatos.cantidad(r.dias, 'día', 'días')
    : r.tramos.map((t) => Formatos.intervalo(t.inicio, t.fin)).join(', ');
