import 'package:flutter/foundation.dart';

import '../../../domain/models/reserva.dart';

class ConfirmacionViewModel extends ChangeNotifier {
  ConfirmacionViewModel({required this.reserva});
  final Reserva reserva;
}
