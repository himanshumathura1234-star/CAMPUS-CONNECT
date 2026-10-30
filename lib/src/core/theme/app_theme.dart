import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // --- CAMPUS POP COLOR SYSTEM ---
  static const Color warmCream = Color(0xFFFFF8EF);
  static const Color charcoal = Color(0xFF252525);
  static const Color coral = Color(0xFFFF725E);
  static const Color emerald = Color(0xFF16866A);
  static const Color goldenYellow = Color(0xFFFFC857);
  static const Color softLavender = Color(0xFFB9A4F5);
  static const Color peach = Color(0xFFFFD6C7);
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color mutedGrey = Color(0xFF888888);

  // Semantic Aliases & Compatibility mapping
  static const Color primaryIndigo = coral; // Replaced blue with signature Coral
  static const Color secondaryViolet = softLavender;
  static const Color accentCoral = coral;
  static const Color accentMint = emerald;
  static const Color accentAmber = goldenYellow;
  static const Color accentSky = softLavender;

  // Light Theme Surfaces & Text
  static const Color lightBackground = warmCream;
  static const Color lightCard = pureWhite;
  static const Color lightCardBorder = Color(0xFFEFE4D6);
  static const Color mainText = charcoal;
  static const Color secondaryText = Color(0xFF6B6661);

  // Dark Theme Surfaces & Text (Warm Charcoal Theme)
  static const Color darkBackground = Color(0xFF191817);
  static const Color darkSurface = Color(0xFF252321);
  static const Color darkSurfaceElevated = Color(0xFF302C29);
  static const Color darkCardBorder = Color(0xFF3F3B36);
  static const Color darkTextPrimary = Color(0xFFFFF8EF);
  static const Color darkTextSecondary = Color(0xFFAFA79D);

  // --- SIGNATURE GRADIENTS ---
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [coral, Color(0xFFFF8E72)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFFFF634D), Color(0xFFFF8A65), Color(0xFFFFC857)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient coralGradient = LinearGradient(
    colors: [coral, Color(0xFFFF523B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient mintGradient = LinearGradient(
    colors: [emerald, Color(0xFF1EAE8B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient amberGradient = LinearGradient(
    colors: [goldenYellow, Color(0xFFFFAE19)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient lavenderGradient = LinearGradient(
    colors: [softLavender, Color(0xFFA389F1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient peachGradient = LinearGradient(
    colors: [peach, Color(0xFFFFC2AE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    colors: [Color(0xFF2B2825), Color(0xFF211F1D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // --- POP SHADOWS ---
  static List<BoxShadow> softShadow(Color color, {double blur = 16, double spread = 0, Offset offset = const Offset(0, 6)}) {
    return [
      BoxShadow(
        color: color.withValues(alpha: 0.10),
        blurRadius: blur,
        spreadRadius: spread,
        offset: offset,
      )
    ];
  }

  static List<BoxShadow> glowShadow(Color color) {
    return [
      BoxShadow(
        color: color.withValues(alpha: 0.30),
        blurRadius: 20,
        spreadRadius: -2,
        offset: const Offset(0, 8),
      )
    ];
  }
}

class AppTheme {
  static ThemeData get lightTheme {
    final base = ThemeData.light(useMaterial3: true);
    final textTheme = GoogleFonts.interTextTheme(base.textTheme);

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.warmCream,
      colorScheme: const ColorScheme.light(
        primary: AppColors.coral,
        secondary: AppColors.emerald,
        surface: AppColors.pureWhite,
        error: Color(0xFFE53935),
        onPrimary: Colors.white,
        onSurface: AppColors.charcoal,
        outline: AppColors.lightCardBorder,
      ),
      textTheme: textTheme.apply(
        bodyColor: AppColors.charcoal,
        displayColor: AppColors.charcoal,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          color: AppColors.charcoal,
          fontSize: 20,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.3,
        ),
        iconTheme: const IconThemeData(color: AppColors.charcoal),
      ),
      cardTheme: CardThemeData(
        color: AppColors.pureWhite,
        elevation: 0,
        shadowColor: AppColors.charcoal.withValues(alpha: 0.04),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: const BorderSide(color: AppColors.lightCardBorder, width: 1.2),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.warmCream,
        selectedColor: AppColors.coral.withValues(alpha: 0.16),
        side: const BorderSide(color: AppColors.lightCardBorder),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        labelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.charcoal,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.coral,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 2,
          shadowColor: AppColors.coral.withValues(alpha: 0.35),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 14),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.lightCardBorder, width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.lightCardBorder, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.coral, width: 2),
        ),
        hintStyle: GoogleFonts.inter(
          color: AppColors.mutedGrey,
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    final base = ThemeData.dark(useMaterial3: true);
    final textTheme = GoogleFonts.interTextTheme(base.textTheme);

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.coral,
        secondary: AppColors.emerald,
        surface: AppColors.darkSurface,
        error: Color(0xFFEF5350),
        onPrimary: Colors.white,
        onSurface: AppColors.darkTextPrimary,
        outline: AppColors.darkCardBorder,
      ),
      textTheme: textTheme.apply(
        bodyColor: AppColors.darkTextPrimary,
        displayColor: AppColors.darkTextPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          color: AppColors.darkTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.3,
        ),
        iconTheme: const IconThemeData(color: AppColors.darkTextPrimary),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkSurface,
        elevation: 0,
        shadowColor: Colors.black.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: const BorderSide(color: AppColors.darkCardBorder, width: 1.2),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.darkSurfaceElevated,
        selectedColor: AppColors.coral.withValues(alpha: 0.25),
        side: const BorderSide(color: AppColors.darkCardBorder),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        labelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.darkTextPrimary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.coral,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 2,
          shadowColor: AppColors.coral.withValues(alpha: 0.4),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 14),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.darkCardBorder, width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.darkCardBorder, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.coral, width: 2),
        ),
        hintStyle: GoogleFonts.inter(
          color: AppColors.darkTextSecondary,
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
