import 'package:flutter/material.dart';


class AppColors {
  AppColors._();

  //primary
  static const Color primary = Color(0xFF8B4A3B);       // deep terracotta — buttons, headings, primary bars
  static const Color primaryLight = Color(0xFFA0604E);   // lighter terracotta — gradients, pressed states
  static const Color primaryDark = Color(0xFF6B3529);    // darker terracotta — text on light bg, emphasis

  //Accent
  static const Color accent = Color(0xFFE07A3F);         // warm orange — highlights, top-cuisine bar, badges
  static const Color accentLight = Color(0xFFF0A868);    // lighter accent for gradients

  //Backgrounds
  static const Color scaffoldBackground = Color(0xFFFDF3EF); // main app background (soft peach)
  static const Color cardBackground = Color(0xFFFCE9E2);     // card / container background
  static const Color statChipBackground = Color(0xFFF3DED7); // stat pill background (Total Views etc.)
  static const Color surfaceWhite = Color(0xFFFFFFFF);       // buttons, sheets, elevated surfaces

  //Text
  static const Color textPrimary = Color(0xFF2B211E);    // main body/headline text (near-black, warm tint)
  static const Color textSecondary = Color(0xFF6B6260);  // subtitles, captions, muted text
  static const Color textOnPrimary = Color(0xFFFFFFFF);  // text/icons on primary-colored surfaces
  static const Color textHint = Color(0xFF9A908D);       // placeholder / disabled text

  //Borders / Dividers
  static const Color border = Color(0xFFE5D6CF);
  static const Color divider = Color(0xFFEFE2DC);

  //Status
  static const Color success = Color(0xFF3D8B5F);
  static const Color error = Color(0xFFD64545);
  static const Color warning = Color(0xFFE0A83F);
  static const Color info = Color(0xFF3F7FE0);

  //Chart-specific
  static const Color chartBarDefault = primary;
  static const Color chartBarHighlight = accent;         // top-value bar
  static const Color chartGridLine = Color(0xFFE8DAD3);
  static const Color chartBackgroundTrack = Color(0x0F000000); // faint bar track, ~6% opacity black

  //(sign-in button)
  static const Color googleBlue = Color(0xFF4285F4);
  static const Color googleGreen = Color(0xFF34A853);
  static const Color googleYellow = Color(0xFFFBBC05);
  static const Color googleRed = Color(0xFFEA4335);

  //Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primary, primaryLight],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [accent, accentLight],
  );
}