// TODO: Optimizing Theme Settings

import 'package:flutter/material.dart';

final Color _baseColorLight = Colors.blueGrey[100];
final Color _shadowColorLightBright = Colors.blueGrey[50];
final Color _shadowColorLightDark = Colors.blueGrey[400];

final Color _baseColorDark = Colors.blueGrey[800];
final Color _shadowColorDarkBright = Colors.blueGrey[700];
final Color _shadowColorDarkDark = Colors.blueGrey[900];

final Color _accentColor = new Color(0xffFFBE61);


/// Light Theme
final ThemeData lightTheme = ThemeData(
  primaryColor: _baseColorLight,
  primaryColorLight: _shadowColorLightBright,
  primaryColorDark: _shadowColorLightDark,
  accentColor: _accentColor,
  scaffoldBackgroundColor: _baseColorLight,
  dialogBackgroundColor: _baseColorLight,
  fontFamily: 'Poppins',
  textTheme: TextTheme(
    title: TextStyle(color: _shadowColorLightDark),
  )
);

/// Dark Theme
final ThemeData darkTheme = ThemeData.dark().copyWith(
  primaryColor: _baseColorDark,
  primaryColorLight: _shadowColorDarkBright,
  primaryColorDark: _shadowColorDarkDark,
  accentColor: _accentColor,
  scaffoldBackgroundColor: _baseColorDark,
  dialogBackgroundColor: _baseColorDark,
);


final List<BoxShadow> softUiShadowsLight = [
    BoxShadow(
      color: _shadowColorLightDark,
      blurRadius: 12.0, // has the effect of softening the shadow
      spreadRadius: 1.0, // has the effect of extending the shadow
      offset: Offset(
          5.0, // horizontal, move right 10
          5.0 // vertical, move down 10
          ),
    ),
    BoxShadow(
      color: _shadowColorLightBright,
      blurRadius: 12.0,
      spreadRadius: 1.0,
      offset: Offset(
          -5.0, // horizontal, move right 10
          -5.0 // vertical, move down 10
          ),
    )
  ];

  final List<BoxShadow> softUiShadowsDark = [
    BoxShadow(
      color:  _shadowColorDarkDark,
      blurRadius: 12.0, // has the effect of softening the shadow
      spreadRadius: 1.0, // has the effect of extending the shadow
      offset: Offset(
          5.0, // horizontal, move right 10
          5.0 // vertical, move down 10
          ),
    ),
    BoxShadow(
      color: _shadowColorDarkBright,
      blurRadius: 12.0,
      spreadRadius: 1.0,
      offset: Offset(
          -5.0, // horizontal, move right 10
          -5.0 // vertical, move down 10
          ),
    )
  ];