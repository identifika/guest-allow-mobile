// ignore_for_file: non_constant_identifier_names

import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvirontmentConstant {
  EnvirontmentConstant._();
  // get IDENTIFIKA_API_KEY => dotenv.env['IDENTIFIKA_API_KEY']!;
  static String get IDENTIFIKA_API_KEY => dotenv.env['IDENTIFIKA_API_KEY']!;
}
