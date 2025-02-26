import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:srs_common/srs_common.dart';

class CustomTextBody extends Text {
  CustomTextBody(
    String text, {
    Key? key,
    Color color = CustomColors.color313131,
    FontWeight fontWeight = CustomConsts.medium,
    double? fontSize,
    TextAlign textAlign = TextAlign.left,
    int maxLines = 1,
  }) : super(
          text,
          key: key,
          style: GoogleFonts.roboto(
            color: color,
            fontWeight: fontWeight,
            fontSize: fontSize ?? CustomConsts.body,
          ),
          textAlign: textAlign,
          maxLines: maxLines,
        );
}
