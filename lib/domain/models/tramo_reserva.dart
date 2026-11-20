class TramoReserva {
  const TramoReserva({required this.inicio, required this.fin});
  final DateTime inicio;
  final DateTime fin;
  int get horas => fin.difference(inicio).inHours;
}
