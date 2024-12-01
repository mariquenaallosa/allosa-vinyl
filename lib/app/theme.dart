import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.blue, // Color de fondo del AppBar
      iconTheme: IconThemeData(color: Colors.black), // Iconos en AppBar
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.black), // Reemplaza bodyText1
      bodyMedium: TextStyle(color: Colors.black), // Reemplaza bodyText2
      headlineSmall: TextStyle(color: Colors.black), // Reemplaza headline6
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue, // Fondo del botón
        foregroundColor: Colors.white, // Color del texto
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Bordes redondeados
        ),
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    primarySwatch: Colors.blueGrey,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[900], // Color de fondo del AppBar en el modo oscuro
      iconTheme: IconThemeData(color: Colors.white), // Iconos en AppBar
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.white), // Reemplaza bodyText1
      bodyMedium: TextStyle(color: Colors.white), // Reemplaza bodyText2
      headlineSmall: TextStyle(color: Colors.white), // Reemplaza headline6
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueGrey[800], // Fondo oscuro del botón
        foregroundColor: Colors.white, // Texto blanco en el botón
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Bordes redondeados
        ),
      ),
    ),
  );
}