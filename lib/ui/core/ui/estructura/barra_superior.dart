import 'package:material_ui/material_ui.dart';

import '../../../../config/tema_app.dart';
import 'marca_app.dart';

class BarraSuperior extends StatelessWidget implements PreferredSizeWidget {
  const BarraSuperior({super.key, this.avatar, this.alCerrar});

  final Widget? avatar;

  final VoidCallback? alCerrar;

  static const double _altoBorde = 3;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + _altoBorde);

  @override
  Widget build(BuildContext context) {
    final cerrar = alCerrar;
    final conBoton = cerrar != null || Navigator.of(context).canPop();

    return AppBar(
      automaticallyImplyLeading: false,
      leadingWidth: conBoton ? 64 : null,
      titleSpacing: conBoton ? 0 : 20,
      leading: conBoton
          ? Center(
              child: IconButton(
                tooltip: cerrar != null ? 'Cerrar' : 'Volver',
                onPressed: cerrar ?? () => Navigator.of(context).maybePop(),
                style: IconButton.styleFrom(
                  backgroundColor: TemaApp.superficie,
                  foregroundColor: TemaApp.tinta,
                  side: const BorderSide(color: TemaApp.borde),
                ),
                icon: Icon(
                  cerrar != null ? Icons.close_rounded : Icons.chevron_left,
                ),
              ),
            )
          : null,
      title: const MarcaApp(),
      actions: [
        if (avatar != null)
          Padding(padding: const EdgeInsets.only(right: 12), child: avatar),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(_altoBorde),
        child: Container(
          height: _altoBorde,
          alignment: Alignment.topCenter,
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: TemaApp.borde)),
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            padding: const EdgeInsets.only(left: 20),
            alignment: Alignment.topLeft,
            child: Container(
              width: 28,
              height: _altoBorde - 1,
              decoration: BoxDecoration(
                color: TemaApp.acento,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
