import "package:flutter/material.dart";

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  textTheme: const TextTheme().apply(bodyColor: const Color.fromARGB(255, 0, 0, 0)),
  iconTheme: const IconThemeData(color: Color.fromARGB(255, 0, 0, 0),),
  colorScheme: const ColorScheme.light(
    surface: Colors.white,
    primary: Color.fromARGB(255, 0, 0, 0),
    secondary: Colors.white,
  )
  
);