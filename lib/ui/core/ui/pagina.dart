import 'package:material_ui/material_ui.dart';

class Pagina extends StatelessWidget {
  const Pagina({
    super.key,
    required this.titulo,
    required this.hijos,
    this.acciones,
  });
  final String titulo;
  final List<Widget> hijos;
  final List<Widget>? acciones;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(titulo), actions: acciones),
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: ListView(padding: const EdgeInsets.all(20), children: hijos),
        ),
      ),
    ),
  );
}
