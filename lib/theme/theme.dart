import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color.fromARGB(255, 58, 49, 222);
  static const Color primaryLight = Color.fromARGB(255, 96, 91, 196);
  static const Color primaryDark = Color.fromARGB(255, 11, 10, 30);

  static const Color secondaryColor = Color.fromARGB(255, 244, 7, 7);
  static const Color tertiaryColor = Color.fromARGB(255, 11, 210, 84);

  static const List<Color> primaryGradient = [primaryColor, Color(0xFF6366F1)
  
  ];


  static const Color backgroundColor = Color.fromARGB(255, 236, 235, 241);
  static const Color surfaceColor = Color(0xFFFF8FAFC);
  static const Color textPrimary = Color(0xFF1E2938);
  static const Color textsecandery = Color(0xFF647488);


  static const Color success= Color(0xFF22C55E);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);




  static ThemeData get lightTheme {
return
ThemeData(
  primaryColor:primaryColor,
  scaffoldBackgroundColor: backgroundColor,
  colorScheme: const ColorScheme.light(
    primary: primaryColor,
    secondary: secondaryColor,
    tertiary: tertiaryColor,
    surface: surfaceColor,
    error: error  ),
    fontFamily: 'Poppis',
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: textPrimary,
        fontSize: 32,
        fontWeight: FontWeight.bold ,    ),

    displayMedium: TextStyle(
        color: textPrimary,
        fontSize: 24,
        fontWeight: FontWeight.bold ,    ),
         
         
         bodyLarge: TextStyle(
        color: textPrimary,
        fontSize: 16,
           ), 
            bodyMedium: TextStyle(
        color: textPrimary,
        fontSize: 14,
        ),    
        ), 
);  
  }




}
