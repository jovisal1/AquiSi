import 'package:material_ui/material_ui.dart';

import '../../../../config/tema_app.dart';

class IndicadorPasos extends StatelessWidget {
  const IndicadorPasos({super.key, required this.paso, required this.total});
  final int paso;
  final int total;

  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Paso $paso de $total',
    excludeSemantics: true,
    child: Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: TweenAnimationBuilder<double>(
                tween: Tween(end: paso / total),
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOutCubic,
                builder: (context, valor, child) => LinearProgressIndicator(
                  value: valor,
                  minHeight: 6,
                  color: TemaApp.acento,
                  backgroundColor: TemaApp.superficieAtenuada,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '$paso/$total',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    ),
  );
}
