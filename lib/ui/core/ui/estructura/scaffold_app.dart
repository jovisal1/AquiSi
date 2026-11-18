import 'package:material_ui/material_ui.dart';

import '../../../../config/tema_app.dart';

class ScaffoldApp extends StatelessWidget {
  const ScaffoldApp({
    super.key,
    required this.titulo,
    required this.hijos,
    this.barra,
    this.accionInferior,
  });
  final String titulo;
  final List<Widget> hijos;
  final PreferredSizeWidget? barra;
  final Widget? accionInferior;

  @override
  Widget build(BuildContext context) => Title(
    title: '$titulo · espaireserva',
    color: TemaApp.acento,
    child: Scaffold(
      appBar: barra,
      body: SafeArea(
        // El margen inferior va dentro de la lista para que el contenido
        // pueda pasar por detrás de la barra de navegación flotante.
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                20,
                8,
                20,
                32 + MediaQuery.paddingOf(context).bottom,
              ),
              children: hijos,
            ),
          ),
        ),
      ),
      bottomNavigationBar: accionInferior,
    ),
  );
}
