import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// 소셜 버튼 상수 (모바일 터치 최소 44pt 권장 → 52pt 적용)
const double kSocialButtonHeight = 52;
const double kSocialButtonRadius = 12;
const double kSocialButtonPaddingH = 20;
const double kSocialButtonGap = 12;
const double kSocialIconSize = 22;
const double kMobileBreakpoint = 400;

const String svgKakao = r'''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path fill="#000000" d="M12 3c-4.97 0-9 3.185-9 7.115 0 2.558 1.707 4.8 4.319 6.098l-1.087 4.004c-.074.273.238.485.461.334l4.743-3.155c.186.014.373.021.564.021 4.97 0 9-3.185 9-7.115S16.97 3 12 3z"/></svg>''';

class SocialLoginButton extends StatelessWidget {
  const SocialLoginButton({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.svgData,
    required this.onPressed,
    this.textColor,
  });

  final String label;
  final Color backgroundColor;
  final String svgData;
  final VoidCallback? onPressed;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final effectiveTextColor = textColor ?? Colors.black87;

    return SizedBox(
      height: kSocialButtonHeight,
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(kSocialButtonRadius),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(kSocialButtonRadius),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kSocialButtonPaddingH),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.string(
                  svgData,
                  width: kSocialIconSize,
                  height: kSocialIconSize,
                  colorFilter: effectiveTextColor == Colors.black87 || effectiveTextColor == Colors.black
                      ? null
                      : ColorFilter.mode(effectiveTextColor, BlendMode.srcIn),
                ),
                const SizedBox(width: kSocialButtonGap),
                Text(
                  label,
                  style: TextStyle(
                    color: effectiveTextColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
