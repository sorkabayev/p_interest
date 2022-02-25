import 'package:logger/logger.dart';

import '../service/servics.dart';

class Log {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(),
  );

  static void d(String message) {
    if(Network.isTester)_logger.d(message);
  }

  static void i(String message) {
    _logger.i(message);
  }

  static void w(String message) {
    if(Network.isTester)_logger.i(message);
  }

  static void e(String message) {
    _logger.i(message);
  }
}
