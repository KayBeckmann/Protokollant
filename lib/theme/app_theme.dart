import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

const kPrimary = Color(0xFF003461);
const kOnPrimary = Colors.white;
const kPrimaryContainer = Color(0xFF004b87);
const kOnPrimaryContainer = Color(0xFF8abcff);
const kSecondary = Color(0xFF48626e);
const kOnSecondary = Colors.white;
const kSecondaryContainer = Color(0xFFcbe7f5);
const kOnSecondaryContainer = Color(0xFF4e6874);
const kError = Color(0xFFba1a1a);
const kErrorContainer = Color(0xFFffdad6);
const kOnErrorContainer = Color(0xFF93000a);
const kSurface = Color(0xFFf4faff);
const kOnSurface = Color(0xFF111d23);
const kSurfaceContainerLowest = Colors.white;
const kSurfaceContainerLow = Color(0xFFe9f6fd);
const kSurfaceContainer = Color(0xFFe3f0f8);
const kSurfaceContainerHigh = Color(0xFFddeaf2);
const kSurfaceVariant = Color(0xFFd7e4ec);
const kOnSurfaceVariant = Color(0xFF424750);
const kOutline = Color(0xFF727781);
const kOutlineVariant = Color(0xFFc2c6d1);
const kSuccess = Color(0xFF008a00);
const kOnSuccess = Colors.white;

class AppTheme {
  static ThemeData light() {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: kPrimary,
      onPrimary: Colors.white,
      primaryContainer: kPrimaryContainer,
      onPrimaryContainer: kOnPrimaryContainer,
      secondary: kSecondary,
      onSecondary: Colors.white,
      secondaryContainer: kSecondaryContainer,
      onSecondaryContainer: kOnSecondaryContainer,
      error: kError,
      onError: Colors.white,
      errorContainer: kErrorContainer,
      onErrorContainer: kOnErrorContainer,
      surface: kSurface,
      onSurface: kOnSurface,
      surfaceContainerHighest: kSurfaceVariant,
      onSurfaceVariant: kOnSurfaceVariant,
      outline: kOutline,
      outlineVariant: kOutlineVariant,
      inverseSurface: Color(0xFF263238),
      onInverseSurface: Color(0xFFe6f3fb),
      inversePrimary: Color(0xFFa3c9ff),
    );

    final baseText = GoogleFonts.ibmPlexSansTextTheme();

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: kSurface,
      textTheme: baseText,
      appBarTheme: AppBarTheme(
        backgroundColor: kSurface,
        foregroundColor: kPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.ibmPlexSans(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: kPrimary,
        ),
        iconTheme: const IconThemeData(color: kPrimary),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: kSurface,
        indicatorColor: kSecondaryContainer,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.transparent,
        labelTextStyle: WidgetStateProperty.all(
          GoogleFonts.ibmPlexSans(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ),
      dividerColor: kOutlineVariant,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: kOutlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: kOutlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: kPrimary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          textStyle: GoogleFonts.ibmPlexSans(fontSize: 16, fontWeight: FontWeight.w600),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: kPrimary,
          minimumSize: const Size(double.infinity, 48),
          side: const BorderSide(color: kOutlineVariant),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          textStyle: GoogleFonts.ibmPlexSans(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: kPrimary,
        foregroundColor: Colors.white,
        shape: CircleBorder(),
        elevation: 4,
      ),
      cardTheme: const CardThemeData(
        color: Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    );
  }
}
