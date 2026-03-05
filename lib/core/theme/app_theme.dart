import 'package:flutter/material.dart';

/// 노란색 휴(hue) + 매우 낮은 채도 = 살짝 색감 있는 그레이 (사진 곡선 로직)
Color _gray(double hue, double saturation, double lightness) {
  return HSLColor.fromAHSL(1, hue, saturation.clamp(0, 1), lightness.clamp(0, 1)).toColor();
}

/// 브랜드 색상: 노란색 단일 + 그레이톤(노란 휴, 낮은 채도)
class AppColors {
  AppColors._();

  /// 노란색 휴 (그레이톤에 살짝 스며들게 할 휴)
  static const double yellowHue = 48;

  /// 브랜드 노란색
  static const Color yellow = Color(0xFFFFB300);
  static const Color yellowLight = Color(0xFFFFD54F);
  static const Color yellowDark = Color(0xFFFF8F00);

  /// 그레이톤 (노란 휴 + 낮은 채도): 배경·서페이스
  /// 배경: 전반적으로 약한 그레이톤
  static Color get grayBackground =>
      _gray(yellowHue, 0.04, 0.97);
  static Color get graySurface =>
      _gray(yellowHue, 0.06, 0.96);
  /// 영역 카드용 흰색 (그림자와 함께 사용)
  static const Color cardSurface = Colors.white;
  static Color get graySurfaceVariant =>
      _gray(yellowHue, 0.08, 0.93);
  static Color get grayOutline =>
      _gray(yellowHue, 0.08, 0.85);
  static Color get grayMuted =>
      _gray(yellowHue, 0.08, 0.72);

  /// 그레이톤: 텍스트·아이콘 (어두운 쪽)
  static Color get grayOnSurface =>
      _gray(yellowHue, 0.12, 0.22);
  static Color get grayOnSurfaceVariant =>
      _gray(yellowHue, 0.10, 0.42);

  /// 기존 참조 호환
  static Color get surface => graySurface;
  static Color get surfaceVariant => graySurfaceVariant;
}

/// Pretendard 폰트 패밀리
const String _fontFamily = 'Pretendard';

/// 모바일 웹 전용 앱 테마 (노란색 브랜드 + 노란 톤 그레이)
class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      fontFamily: _fontFamily,
      textTheme: _buildTextTheme(),
      colorScheme: ColorScheme.light(
        primary: AppColors.yellow,
        onPrimary: AppColors.grayOnSurface,
        primaryContainer: AppColors.yellowLight,
        onPrimaryContainer: AppColors.grayOnSurface,
        secondary: AppColors.yellow,
        onSecondary: AppColors.grayOnSurface,
        secondaryContainer: AppColors.yellowLight,
        onSecondaryContainer: AppColors.grayOnSurface,
        surface: AppColors.graySurface,
        onSurface: AppColors.grayOnSurface,
        surfaceContainerHighest: AppColors.graySurfaceVariant,
        onSurfaceVariant: AppColors.grayOnSurfaceVariant,
        outline: AppColors.grayOutline,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.yellow,
        foregroundColor: AppColors.grayOnSurface,
        iconTheme: IconThemeData(color: AppColors.grayOnSurface),
        titleTextStyle: TextStyle(
          fontFamily: _fontFamily,
          color: AppColors.grayOnSurface,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        backgroundColor: AppColors.graySurfaceVariant,
        selectedItemColor: AppColors.yellowDark,
        unselectedItemColor: AppColors.grayMuted,
        selectedLabelStyle: const TextStyle(
          fontFamily: _fontFamily,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: _fontFamily,
          fontWeight: FontWeight.w500,
        ),
      ),
      scaffoldBackgroundColor: AppColors.grayBackground,
      cardTheme: CardThemeData(
        color: AppColors.cardSurface,
        elevation: 6,
        shadowColor: Colors.black.withOpacity(0.08),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.yellow,
          foregroundColor: AppColors.grayOnSurface,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.yellow,
        foregroundColor: Color(0xFF1A1A1A),
      ),
    );
  }

  /// 용도별 Pretendard 굵기 (한 단계씩 올림)
  static TextTheme _buildTextTheme() {
    return TextTheme(
      displayLarge: const TextStyle(fontFamily: _fontFamily, fontWeight: FontWeight.w800, fontSize: 32),
      displayMedium: const TextStyle(fontFamily: _fontFamily, fontWeight: FontWeight.w800, fontSize: 28),
      displaySmall: const TextStyle(fontFamily: _fontFamily, fontWeight: FontWeight.w800, fontSize: 24),
      headlineLarge: const TextStyle(fontFamily: _fontFamily, fontWeight: FontWeight.w800, fontSize: 22),
      headlineMedium: const TextStyle(fontFamily: _fontFamily, fontWeight: FontWeight.w700, fontSize: 20),
      headlineSmall: const TextStyle(fontFamily: _fontFamily, fontWeight: FontWeight.w700, fontSize: 18),
      titleLarge: const TextStyle(fontFamily: _fontFamily, fontWeight: FontWeight.w700, fontSize: 16),
      titleMedium: const TextStyle(fontFamily: _fontFamily, fontWeight: FontWeight.w600, fontSize: 14),
      titleSmall: const TextStyle(fontFamily: _fontFamily, fontWeight: FontWeight.w600, fontSize: 12),
      bodyLarge: const TextStyle(fontFamily: _fontFamily, fontWeight: FontWeight.w500, fontSize: 16),
      bodyMedium: const TextStyle(fontFamily: _fontFamily, fontWeight: FontWeight.w500, fontSize: 14),
      bodySmall: const TextStyle(fontFamily: _fontFamily, fontWeight: FontWeight.w500, fontSize: 12),
      labelLarge: const TextStyle(fontFamily: _fontFamily, fontWeight: FontWeight.w600, fontSize: 14),
      labelMedium: const TextStyle(fontFamily: _fontFamily, fontWeight: FontWeight.w600, fontSize: 12),
      labelSmall: const TextStyle(fontFamily: _fontFamily, fontWeight: FontWeight.w600, fontSize: 10),
    );
  }
}
