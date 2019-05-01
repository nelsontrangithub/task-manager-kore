/*
* Creating a custom palette with the Kore colors
*
* Usage:
* in order to use this theme or the colours in it, you would 
* import this file in the project, anywhere you need it
* import 'path/to/theme.dart';
*/
import 'package:flutter/material.dart';

final ThemeData koreThemeData = new ThemeData(
  brightness: Brightness.dark,
  primaryColor: KorePrimaryColor
);

const KorePrimaryColor = const Color(0x203064);
