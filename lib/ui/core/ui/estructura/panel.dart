import 'package:material_ui/material_ui.dart';

class Panel extends StatelessWidget {
  const Panel({super.key, required this.hijo, this.color});
  final Widget hijo;
  final Color? color;

  @override
  Widget build(BuildContext context) => Card(
    color: color,
    child: Padding(padding: const EdgeInsets.all(16), child: hijo),
  );
}
