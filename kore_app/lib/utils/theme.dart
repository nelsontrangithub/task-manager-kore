/*
* Creating a custom palette with the Kore colors
*
* Usage:
* in order to use this theme or the colours in it, you would 
* import this file in the project, anywhere you need it
* import 'path/to/theme.dart';
*/
import 'package:flutter/material.dart';

final ThemeData koreThemeData = ThemeData(
  brightness: Brightness.light,
  primaryColor: KorePrimaryColor
);

const TextStyle THEME_TEXTSTYLE = TextStyle(
  color: Color(0xff1282c5),
  fontFamily: 'Poppins',
);

const KorePrimaryColor = const Color(0x223871);
