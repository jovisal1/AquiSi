import '../../domain/models/reserva.dart';
import '../../domain/models/tramo_reserva.dart';

abstract final class Formatos {
  static const _diasSemana = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];

  static String dinero(int centimos, [String moneda = 'EUR']) =>
      '${(centimos / 100).toStringAsFixed(2).replaceAll('.', ',')} ${moneda == 'EUR' ? '€' : moneda}';
  static String fecha(DateTime valor) =>
      '${valor.day.toString().padLeft(2, '0')}/${valor.month.toString().padLeft(2, '0')}/${valor.year}';
  static String hora(DateTime valor) =>
      '${valor.hour.toString().padLeft(2, '0')}:${valor.minute.toString().padLeft(2, '0')}';

  static String dineroCorto(int centimos, [String moneda = 'EUR']) =>
      centimos % 100 == 0
      ? '${centimos ~/ 100} ${moneda == 'EUR' ? '€' : moneda}'
      : dinero(centimos, moneda);

  static const _meses = [
    'ENE', 'FEB', 'MAR', 'ABR', 'MAY', 'JUN',
    'JUL', 'AGO', 'SEP', 'OCT', 'NOV', 'DIC',
  ];

  static const _mesesLargos = [
    'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio', 'julio',
    'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre',
  ];

  static String mesAnyo(DateTime valor) {
    final mes = _mesesLargos[valor.month - 1];
    return '${mes[0].toUpperCase()}${mes.substring(1)} ${valor.year}';
  }

  static String mesCorto(DateTime valor) => _meses[valor.month - 1];

  static String diaRelativo(DateTime valor, DateTime referencia) {
    final dia = DateTime(valor.year, valor.month, valor.day);
    final hoy = DateTime(referencia.year, referencia.month, referencia.day);
    return switch (dia.difference(hoy).inDays) {
      0 => 'Hoy',
      1 => 'Mañana',
      _ => diaSemana(valor),
    };
  }

  static String hace(DateTime valor, DateTime referencia) {
    final dias = DateTime(referencia.year, referencia.month, referencia.day)
        .difference(DateTime(valor.year, valor.month, valor.day))
        .inDays;
    String plural(int n, String uno, String varios) =>
        'Hace $n ${n == 1 ? uno : varios}';
    if (dias <= 0) return 'Hoy';
    if (dias == 1) return 'Ayer';
    if (dias < 7) return plural(dias, 'día', 'días');
    if (dias < 30) return plural(dias ~/ 7, 'semana', 'semanas');
    if (dias < 365) return plural(dias ~/ 30, 'mes', 'meses');
    return fecha(valor);
  }

  static String diaSemana(DateTime valor) => _diasSemana[valor.weekday - 1];

  static String diaMes(DateTime valor) =>
      '${valor.day.toString().padLeft(2, '0')}/${valor.month.toString().padLeft(2, '0')}';

  static String diaCorto(DateTime valor) =>
      '${diaSemana(valor)} ${diaMes(valor)}';

  static String intervalo(DateTime inicio, DateTime fin) =>
      '${hora(inicio)}–${hora(fin)}';

  static String cantidad(int n, String uno, String varios) =>
      '$n ${n == 1 ? uno : varios}';

  static String periodo(DateTime desde, DateTime hasta) {
    final dias = DateTime(hasta.year, hasta.month, hasta.day)
            .difference(DateTime(desde.year, desde.month, desde.day))
            .inDays +
        1;
    final fechas = dias == 1
        ? diaCorto(desde)
        : '${diaCorto(desde)} – ${diaCorto(hasta)}';
    return '$fechas · ${cantidad(dias, 'día', 'días')}';
  }

  static String cuando(ModalidadReserva modalidad, List<TramoReserva> tramos) =>
      modalidad == ModalidadReserva.porDias
      ? periodo(tramos.first.inicio, tramos.last.fin)
      : '${diaCorto(tramos.first.inicio)} · '
            '${tramos.map((t) => intervalo(t.inicio, t.fin)).join(', ')}';
}
