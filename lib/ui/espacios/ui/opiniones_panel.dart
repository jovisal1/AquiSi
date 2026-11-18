import 'package:material_ui/material_ui.dart';

import '../../../config/tema_app.dart';
import '../../../domain/models/comentario.dart';
import '../../core/formatos.dart';
import '../../core/ui/controles/boton_accion.dart';
import '../../core/ui/estructura/panel.dart';
import 'puntuacion_estrellas.dart';

class OpinionesPanel extends StatefulWidget {
  const OpinionesPanel({
    super.key,
    required this.comentarios,
    required this.media,
    required this.distribucion,
    required this.referencia,
    required this.alEscribir,
  });
  final List<Comentario> comentarios;
  final double? media;

  final List<int> distribucion;
  final DateTime referencia;
  final VoidCallback alEscribir;

  @override
  State<OpinionesPanel> createState() => _OpinionesPanelState();
}

class _OpinionesPanelState extends State<OpinionesPanel> {
  final _paginas = PageController(viewportFraction: 0.86);
  int _pagina = 0;

  @override
  void didUpdateWidget(OpinionesPanel anterior) {
    super.didUpdateWidget(anterior);
    if (widget.comentarios.length != anterior.comentarios.length &&
        _paginas.hasClients) {
      _paginas.jumpToPage(0);
    }
  }

  @override
  void dispose() {
    _paginas.dispose();
    super.dispose();
  }

  void _verTodas() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: TemaApp.fondo,
      builder: (contextoHoja) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.75,
        maxChildSize: 0.95,
        builder: (contextoHoja, scroll) => ListView(
          controller: scroll,
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          children: [
            Text(
              '${widget.comentarios.length} opiniones',
              style: Theme.of(contextoHoja).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            for (final comentario in widget.comentarios)
              _OpinionCompleta(
                comentario: comentario,
                referencia: widget.referencia,
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final comentarios = widget.comentarios;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Resumen(
          media: widget.media,
          total: comentarios.length,
          distribucion: widget.distribucion,
          alEscribir: widget.alEscribir,
        ),
        if (comentarios.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 4),
            child: Text(
              'Aún nadie ha opinado sobre este espacio. '
              'Cuenta qué tal fue tu encuentro.',
            ),
          )
        else ...[
          const SizedBox(height: 12),
          SizedBox(
            height: 212,
            child: PageView.builder(
              controller: _paginas,
              padEnds: false,
              itemCount: comentarios.length,
              onPageChanged: (pagina) => setState(() => _pagina = pagina),
              itemBuilder: (context, i) => Padding(
                padding: const EdgeInsets.only(right: 12),
                child: _OpinionCita(
                  comentario: comentarios[i],
                  referencia: widget.referencia,
                  fondo: _fondos[i % _fondos.length],
                  alPulsar: _verTodas,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              for (var i = 0; i < comentarios.length && i < 8; i++)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 5),
                  width: i == _pagina ? 18 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: i == _pagina ? TemaApp.acento : TemaApp.borde,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              const Spacer(),
              TextButton(
                onPressed: _verTodas,
                style: TextButton.styleFrom(
                  foregroundColor: TemaApp.acentoTexto,
                  minimumSize: const Size(48, 44),
                ),
                child: Text('Ver todas · ${comentarios.length}'),
              ),
            ],
          ),
        ],
      ],
    );
  }

  static const _fondos = [
    TemaApp.acentoSuave,
    TemaApp.solSuave,
    TemaApp.azulSuave,
  ];
}

class _Resumen extends StatelessWidget {
  const _Resumen({
    required this.media,
    required this.total,
    required this.distribucion,
    required this.alEscribir,
  });
  final double? media;
  final int total;
  final List<int> distribucion;
  final VoidCallback alEscribir;

  @override
  Widget build(BuildContext context) {
    final temaTexto = Theme.of(context).textTheme;
    final valor = media;
    final maximo = distribucion.fold<int>(0, (m, n) => n > m ? n : m);
    return Panel(
      hijo: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    valor == null
                        ? '–'
                        : valor.toStringAsFixed(1).replaceAll('.', ','),
                    style: temaTexto.displaySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: TemaApp.tinta,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  PuntuacionEstrellas(puntuacion: valor ?? 0, tamano: 14),
                  const SizedBox(height: 4),
                  Text(
                    total == 0
                        ? 'Sin opiniones'
                        : '$total ${total == 1 ? 'opinión' : 'opiniones'}',
                    style: temaTexto.bodySmall,
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  children: [
                    for (var i = 0; i < distribucion.length; i++)
                      _BarraReparto(
                        estrellas: 5 - i,
                        cantidad: distribucion[i],
                        proporcion: maximo == 0
                            ? 0.0
                            : distribucion[i] / maximo,
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          BotonAccion(
            texto: 'Escribir una opinión',
            icono: Icons.edit_rounded,
            secundario: true,
            alPulsar: alEscribir,
          ),
        ],
      ),
    );
  }
}

class _BarraReparto extends StatelessWidget {
  const _BarraReparto({
    required this.estrellas,
    required this.cantidad,
    required this.proporcion,
  });
  final int estrellas;
  final int cantidad;
  final double proporcion;

  @override
  Widget build(BuildContext context) => Semantics(
    label: '$estrellas estrellas: $cantidad',
    excludeSemantics: true,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: Row(
        children: [
          SizedBox(
            width: 12,
            child: Text(
              '$estrellas',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: TemaApp.textoSecundario,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Stack(
                children: [
                  Container(height: 7, color: TemaApp.superficieAtenuada),
                  FractionallySizedBox(
                    widthFactor: proporcion,
                    child: Container(height: 7, color: TemaApp.acento),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 16,
            child: Text(
              '$cantidad',
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 12,
                color: TemaApp.textoSecundario,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _OpinionCita extends StatelessWidget {
  const _OpinionCita({
    required this.comentario,
    required this.referencia,
    required this.fondo,
    required this.alPulsar,
  });
  final Comentario comentario;
  final DateTime referencia;
  final Color fondo;
  final VoidCallback alPulsar;

  @override
  Widget build(BuildContext context) => Material(
    color: fondo,
    borderRadius: BorderRadius.circular(TemaApp.radio),
    child: InkWell(
      borderRadius: BorderRadius.circular(TemaApp.radio),
      onTap: alPulsar,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ExcludeSemantics(
                  child: Text(
                    '“',
                    style: TextStyle(
                      fontSize: 52,
                      height: 1,
                      fontWeight: FontWeight.w700,
                      color: TemaApp.acento,
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: PuntuacionEstrellas(
                    puntuacion: comentario.puntuacion,
                    tamano: 14,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Text(
                comentario.texto,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                  color: TemaApp.tinta,
                ),
              ),
            ),
            _Autor(comentario: comentario, referencia: referencia),
          ],
        ),
      ),
    ),
  );
}

class _OpinionCompleta extends StatelessWidget {
  const _OpinionCompleta({required this.comentario, required this.referencia});
  final Comentario comentario;
  final DateTime referencia;

  @override
  Widget build(BuildContext context) => Panel(
    hijo: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _Autor(comentario: comentario, referencia: referencia),
            ),
            PuntuacionEstrellas(puntuacion: comentario.puntuacion, tamano: 14),
          ],
        ),
        const SizedBox(height: 10),
        Text(comentario.texto),
      ],
    ),
  );
}

class _Autor extends StatelessWidget {
  const _Autor({required this.comentario, required this.referencia});
  final Comentario comentario;
  final DateTime referencia;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      CircleAvatar(
        radius: 16,
        backgroundColor: TemaApp.tinta,
        child: Text(
          comentario.autor.iniciales,
          style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              comentario.autor.nombre,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: TemaApp.tinta,
              ),
            ),
            Text(
              Formatos.hace(comentario.fecha, referencia),
              style: const TextStyle(
                fontSize: 12,
                color: TemaApp.textoSecundario,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
