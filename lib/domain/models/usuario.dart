class Usuario {
  const Usuario({required this.id, required this.nombre, required this.correo});
  final String id;
  final String nombre;
  final String correo;

  String get iniciales => nombre
      .trim()
      .split(RegExp(r'\s+'))
      .where((parte) => parte.isNotEmpty)
      .map((parte) => parte[0])
      .take(2)
      .join()
      .toUpperCase();
}
