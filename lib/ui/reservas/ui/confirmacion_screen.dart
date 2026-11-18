
import 'package:material_ui/material_ui.dart';

import '../../../config/tema_app.dart';
import '../../../domain/models/reserva.dart';
import '../../core/formatos.dart';
import '../../core/ui/estructura/barra_accion_inferior.dart';
import '../../core/ui/controles/boton_accion.dart';
import '../../core/ui/reservas/indicador_pasos.dart';
import '../../core/ui/controles/insignia_usuario.dart';
import '../../core/ui/estructura/barra_superior.dart';
import '../../core/ui/estructura/scaffold_app.dart';
import '../../core/ui/estructura/panel.dart';
import '../../core/ui/reservas/reserva_tarjeta.dart';
import '../../core/ui/textos/titulo_principal.dart';
import '../view_models/confirmacion_view_model.dart';

class ConfirmacionScreen extends StatefulWidget {
  const ConfirmacionScreen({
    super.key,
    required this.reserva,
    required this.alVolverASeccion,
  });
  final Reserva reserva;

  final ValueChanged<int> alVolverASeccion;
  @override
  State<ConfirmacionScreen> createState() => _ConfirmacionScreenState();
}

class _ConfirmacionScreenState extends State<ConfirmacionScreen> {
  late final ConfirmacionViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ConfirmacionViewModel(reserva: widget.reserva);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void _irAInicio(int seccion) {
    Navigator.of(context).popUntil((ruta) => ruta.isFirst);
    widget.alVolverASeccion(seccion);
  }

  void _verReservas() => _irAInicio(1);

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _viewModel,
    builder: (context, child) => ScaffoldApp(
      titulo: 'Confirmación',
      barra: BarraSuperior(
        alCerrar: () => _irAInicio(0),
        avatar: InsigniaUsuario(
          iniciales: widget.reserva.usuario.iniciales,
          alPulsar: () => _irAInicio(2),
        ),
      ),
      accionInferior: BarraAccionInferior(
        boton: BotonAccion(
          texto: 'Ir a mis reservas',
          icono: Icons.event_note_outlined,
          alPulsar: _verReservas,
        ),
      ),
      hijos: [
        const IndicadorPasos(paso: 3, total: 3),
        const SizedBox(height: 8),
        Center(
          child: Container(
            width: 96,
            height: 96,
            decoration: const BoxDecoration(
              color: TemaApp.acentoSuave,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: CircleAvatar(
                radius: 30,
                backgroundColor: TemaApp.acento,
                child: Icon(Icons.check_rounded, size: 36, color: Colors.white),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const TituloPrincipal(
          '¡Todo listo!',
          centrado: true,
          subtitulo: 'Tu reserva, de un vistazo.',
        ),
        Text(
          Formatos.dinero(
            _viewModel.reserva.precioTotalCentimos,
            _viewModel.reserva.moneda,
          ),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displaySmall,
        ),
        Text(
          'Total con IVA incluido',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 20),
        ReservaTarjeta(reserva: _viewModel.reserva, mostrarDesglose: true),
        Panel(
          color: TemaApp.acentoSuave,
          hijo: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Confirmación de ejemplo',
                style: Theme.of(context).textTheme.titleMedium
                    ?.copyWith(color: TemaApp.acentoTexto),
              ),
              const SizedBox(height: 4),
              Text(
                'Conserva tu selección. Las reservas precargadas permanecen sin cambios.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
