import 'package:material_ui/material_ui.dart';

import 'config/tema_app.dart';

class EspaiReservaApp extends StatelessWidget {
  const EspaiReservaApp({super.key, required this.pantallaInicial});

  final Widget pantallaInicial;

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'EspaiReserva',
    debugShowCheckedModeBanner: false,
    theme: TemaApp.crear(),
    locale: const Locale('es', 'ES'),
    supportedLocales: const [Locale('es', 'ES')],
    localizationsDelegates: GlobalMaterialLocalizations.delegates,
    home: pantallaInicial,
  );
}
