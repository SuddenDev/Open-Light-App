// TODO: Optimizing Theme Settings

import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  primaryColor: Colors.blueGrey[100],
  accentColor: new Color(0xffFFBE61),
  scaffoldBackgroundColor: Colors.blueGrey[200],
);

final ThemeData darkTheme = ThemeData.dark().copyWith(
  primaryColor: Colors.grey[850],
  accentColor: new Color(0xffFFBE61),
  scaffoldBackgroundColor: Colors.grey[900],
);


final _softUiShadowsDark = [
    BoxShadow(
      color: new Color(0x22000000),
      blurRadius: 12.0, // has the effect of softening the shadow
      spreadRadius: 1.0, // has the effect of extending the shadow
      offset: Offset(
          5.0, // horizontal, move right 10
          5.0 // vertical, move down 10
          ),
    ),
    BoxShadow(
      color: new Color(0x66ffffff),
      blurRadius: 12.0,
      spreadRadius: 1.0,
      offset: Offset(
          -5.0, // horizontal, move right 10
          -5.0 // vertical, move down 10
          ),
    )
  ];

  final _softUiShadowsLight = [
    BoxShadow(
      color: new Color(0x22000000),
      blurRadius: 12.0, // has the effect of softening the shadow
      spreadRadius: 1.0, // has the effect of extending the shadow
      offset: Offset(
          5.0, // horizontal, move right 10
          5.0 // vertical, move down 10
          ),
    ),
    BoxShadow(
      color: new Color(0x66ffffff),
      blurRadius: 12.0,
      spreadRadius: 1.0,
      offset: Offset(
          -5.0, // horizontal, move right 10
          -5.0 // vertical, move down 10
          ),
    )
  ];