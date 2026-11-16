/// Formatos de presentación comunes. No depende de widgets ni accede a datos.
abstract final class Formatos {
  static String dinero(int centimos, [String moneda = 'EUR']) =>
      '${(centimos / 100).toStringAsFixed(2).replaceAll('.', ',')} ${moneda == 'EUR' ? '€' : moneda}';
  static String fecha(DateTime valor) =>
      '${valor.day.toString().padLeft(2, '0')}/${valor.month.toString().padLeft(2, '0')}/${valor.year}';
  static String hora(DateTime valor) =>
      '${valor.hour.toString().padLeft(2, '0')}:${valor.minute.toString().padLeft(2, '0')}';
}
