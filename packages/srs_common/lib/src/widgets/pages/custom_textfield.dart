import 'package:flutter/material.dart';
import 'package:srs_common/srs_common.dart';
import 'package:srs_common/srs_common_lib.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String name;
  final Icon? prefixIcon;
  final bool obscureText;
  final TextCapitalization textCapitalization;
  final TextInputType inputType;
  final bool? enabled;
  final Color? fillColor;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.name,
    this.prefixIcon,
    this.obscureText = false,
    this.textCapitalization = TextCapitalization.none,
    this.inputType = TextInputType.text,
    this.enabled,
    this.fillColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.sp),
      child: TextField(
        enabled: true,
        controller: controller,
        textCapitalization: textCapitalization,
        // maxLength: 32,
        // maxLines: 1,
        obscureText: obscureText,
        keyboardType: inputType,
        textAlign: TextAlign.start,
        style: GoogleFonts.roboto(
          color: CustomColors.color000000,
          fontSize: 16.sp,
        ),
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          isDense: true,
          labelText: name,
          counterText: "",
          labelStyle: const TextStyle(color: Colors.grey),
          contentPadding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 14.sp),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.green),
            borderRadius: BorderRadius.all(
              Radius.circular(10.sp),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.green),
            borderRadius: BorderRadius.all(
              Radius.circular(10.sp),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.green),
            borderRadius: BorderRadius.all(
              Radius.circular(10.sp),
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: CustomColors.color8B8B8B.withOpacity(0.5),
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(10.sp),
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: CustomColors.colorFF0033.withOpacity(0.5),
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(10.sp),
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: CustomColors.colorFF0033.withOpacity(0.5),
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(10.sp),
            ),
          ),
          filled: true,
          fillColor:
              enabled ?? true ? fillColor ?? CustomColors.colorF2F2F2.withOpacity(0.4).withOpacity(.1) : CustomColors.color8B8B8B.withOpacity(0.4),
          errorStyle: GoogleFonts.roboto(
            fontSize: 11.sp,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.italic,
            color: CustomColors.colorFF0033,
          ),
        ),
      ),
    );
  }
}
