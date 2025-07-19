import 'package:flutter/material.dart';
import 'package:srs_common/srs_common.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? height;
  final double? radius;
  final bool isLoading;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Border? border;
  final EdgeInsetsGeometry? padding;
  final double? width;

  const CustomButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.fontWeight,
    this.height,
    this.radius,
    this.isLoading = false,
    this.prefixIcon,
    this.suffixIcon,
    this.border,
    this.padding,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 45,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? CustomColors.color06b252,
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius ?? 8),
            side: border?.top ?? BorderSide.none,
          ),
          elevation: 0,
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    textColor ?? CustomColors.colorFFFFFF,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (prefixIcon != null) ...[
                    prefixIcon!,
                    const SizedBox(width: 8),
                  ],
                  Flexible(
                    child: CustomText(
                      text,
                      color: textColor ?? CustomColors.colorFFFFFF,
                      fontSize: fontSize ?? CustomConsts.h5,
                      fontWeight: fontWeight ?? CustomConsts.medium,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                    ),
                  ),
                  if (suffixIcon != null) ...[
                    const SizedBox(width: 8),
                    suffixIcon!,
                  ],
                ],
              ),
      ),
    );
  }
}

// Thêm các biến thể của button
class CustomOutlinedButton extends CustomButton {
  CustomOutlinedButton({
    Key? key,
    required VoidCallback? onPressed,
    required String text,
    Color? borderColor,
    Color? textColor,
    double? fontSize,
    FontWeight? fontWeight,
    double? height,
    double? radius,
    bool isLoading = false,
    Widget? prefixIcon,
    Widget? suffixIcon,
    EdgeInsetsGeometry? padding,
    double? width,
  }) : super(
          key: key,
          onPressed: onPressed,
          text: text,
          backgroundColor: CustomColors.colorFFFFFF,
          textColor: textColor ?? CustomColors.color06b252,
          fontSize: fontSize,
          fontWeight: fontWeight,
          height: height,
          radius: radius,
          isLoading: isLoading,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          border: Border.all(
            color: borderColor ?? CustomColors.color06b252,
            width: 1,
          ),
          padding: padding,
          width: width,
        );
}

class CustomTextButton extends CustomButton {
  CustomTextButton({
    Key? key,
    required VoidCallback? onPressed,
    required String text,
    Color? textColor,
    double? fontSize,
    FontWeight? fontWeight,
    bool isLoading = false,
    Widget? prefixIcon,
    Widget? suffixIcon,
    EdgeInsetsGeometry? padding,
    double? width,
  }) : super(
          key: key,
          onPressed: onPressed,
          text: text,
          backgroundColor: Colors.transparent,
          textColor: textColor ?? CustomColors.color06b252,
          fontSize: fontSize,
          fontWeight: fontWeight,
          height: null,
          radius: 0,
          isLoading: isLoading,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          padding: padding,
          width: width,
        );
}
