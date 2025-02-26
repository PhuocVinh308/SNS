import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:srs_common/srs_common.dart';
import 'package:srs_common/srs_common_lib.dart';

class CustomTextAppBar extends Text {
  CustomTextAppBar(
    String text, {
    Key? key,
    Color color = CustomColors.color313131,
    FontWeight fontWeight = CustomConsts.bold,
    double? fontSize,
    TextAlign textAlign = TextAlign.left,
    int maxLines = 1,
  }) : super(
          text,
          key: key,
          style: GoogleFonts.roboto(
            color: color,
            fontWeight: fontWeight,
            fontSize: fontSize ?? CustomConsts.appBar,
          ),
          textAlign: textAlign,
          maxLines: maxLines,
        );
}
