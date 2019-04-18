/*
* Creating a custom palette with the Kore colors
*
* Usage:
* in order to use this theme or the colours in it, you would 
* import this file in the project, anywhere you need it
* import 'path/to/theme.dart';
*/

import 'package:flutter/material.dart';

final ThemeData KoreThemeData = new ThemeData(
  brightness: Brightness.light,
  accentColor: CompanyColors.blue[500]
);

class CompanyColors {
  CompanyColors._();
  static const Map <int, Color> blue = const <int, Color> {
     50: const Color.fromARGB(18,130,197,1),
    100: const Color.fromARGB(18,130,197,1),
    200: const Color.fromARGB(18,130,197,1),
    300: const Color.fromARGB(18,130,197,1),
    400: const Color.fromARGB(18,130,197,1),
    500: const Color.fromARGB(18,130,197,1),
    600: const Color.fromARGB(18,130,197,1),
    700: const Color.fromARGB(18,130,197,1),
    800: const Color.fromARGB(18,130,197,1),
    900: const Color.fromARGB(18,130,197,1),
  };
}
