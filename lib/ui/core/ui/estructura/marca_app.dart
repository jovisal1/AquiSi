import 'package:material_ui/material_ui.dart';

import '../../../../config/tema_app.dart';

class MarcaApp extends StatelessWidget {
  const MarcaApp({super.key, this.tamano = 20});

  final double tamano;

  @override
  Widget build(BuildContext context) => Semantics(
    label: 'EspaiReserva',
    excludeSemantics: true,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SimboloMarca(tamano: tamano * 1.4),
        SizedBox(width: tamano * 0.4),
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(text: 'espai'),
              TextSpan(
                text: 'reserva',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: TemaApp.tinta.withValues(alpha: 0.72),
                ),
              ),
            ],
          ),
          style: TextStyle(
            fontSize: tamano,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            color: TemaApp.tinta,
          ),
        ),
      ],
    ),
  );
}

class SimboloMarca extends StatelessWidget {
  const SimboloMarca({super.key, this.tamano = 28});
  final double tamano;

  @override
  Widget build(BuildContext context) => Container(
    width: tamano,
    height: tamano,
    decoration: BoxDecoration(
      color: TemaApp.acento,
      borderRadius: BorderRadius.circular(tamano * 0.3),
    ),
    child: CustomPaint(painter: _ArcoPainter()),
  );
}

class _ArcoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final ancho = size.width * 0.44;
    final alto = size.height * 0.56;
    final izquierda = (size.width - ancho) / 2;
    final abajo = size.height * 0.78;
    final arco = RRect.fromLTRBAndCorners(
      izquierda,
      abajo - alto,
      izquierda + ancho,
      abajo,
      topLeft: Radius.circular(ancho / 2),
      topRight: Radius.circular(ancho / 2),
    );
    canvas.drawRRect(arco, Paint()..color = Colors.white);
    canvas.drawCircle(
      Offset(izquierda + ancho * 0.72, abajo - alto * 0.38),
      size.width * 0.045,
      Paint()..color = TemaApp.acento,
    );
  }

  @override
  bool shouldRepaint(_ArcoPainter oldDelegate) => false;
}
