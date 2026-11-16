import 'package:material_ui/material_ui.dart';

class Panel extends StatelessWidget {
  const Panel({super.key, required this.hijo});
  final Widget hijo;
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(padding: const EdgeInsets.all(16), child: hijo),
  );
}
