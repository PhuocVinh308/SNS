import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:srs_common/srs_common.dart';
import 'package:srs_common/srs_common_lib.dart';

enum CustomInputType {
  text,
  int,
  double,
  citizenId,
  identifier,
  phone,
  email,
  money,
  username,
  password,
  nonSpecialCharacters,
  nonSpecialCharactersAndNumber,
  nonSpecialCharactersAndVietnamese,
}

class CustomTextField extends StatelessWidget {
  final Key? textFormFieldKey;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final AutovalidateMode? autoValidate;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final CustomInputType? customInputType;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool? enabled;
  final bool? upperCase;
  final bool? required;
  final bool? regex;
  final bool readOnly;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final String? title;
  final bool? titleEnabled;
  final String? hint;
  final Color? cursorColor;
  final Color? fillColor;
  final double? textFieldRadius;
  final Function(String)? onChanged;
  final VoidCallback? onEditingComplete;
  final bool? obscureText;
  final VoidCallback? toggle;

  const CustomTextField({
    Key? key,
    this.textFormFieldKey,
    this.controller,
    this.focusNode,
    this.autoValidate,
    this.textInputAction,
    this.keyboardType,
    this.floatingLabelBehavior,
    this.customInputType,
    this.suffixIcon,
    this.prefixIcon,
    this.enabled,
    this.upperCase,
    this.required,
    this.regex,
    this.readOnly = false,
    this.maxLines,
    this.minLines,
    this.maxLength,
    this.title,
    this.titleEnabled,
    this.hint,
    this.cursorColor,
    this.fillColor,
    this.textFieldRadius,
    this.onEditingComplete,
    this.onChanged,
    this.obscureText,
    this.toggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: textFormFieldKey,
      controller: controller,
      focusNode: focusNode ?? FocusNode(),
      autovalidateMode: autoValidate ?? AutovalidateMode.onUserInteraction,
      onChanged: onChanged,
      onEditingComplete: () {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        if (onEditingComplete != null) {
          onEditingComplete!();
        }
      },
      enabled: enabled ?? true,
      textCapitalization: upperCase ?? false ? TextCapitalization.characters : TextCapitalization.none,
      textInputAction: textInputAction ?? TextInputAction.done,
      cursorColor: cursorColor ?? CustomColors.color182731,
      maxLength: maxLength,
      minLines: minLines,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: GoogleFonts.roboto(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: CustomColors.color182731,
      ),
      decoration: InputDecoration(
        floatingLabelBehavior: floatingLabelBehavior,
        isDense: true,
        hintText: hint,
        label: titleEnabled ?? true
            ? RichText(
                text: TextSpan(
                  text: title ?? hint ?? '',
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w500,
                    fontSize: 12.sp,
                    color: CustomColors.color313131,
                  ),
                  children: required ?? false
                      ? [
                          TextSpan(
                            text: ' *',
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w500,
                              fontSize: 12.sp,
                              color: CustomColors.color313131,
                            ),
                          ),
                        ]
                      : [],
                ),
              )
            : null,
        suffixIcon: suffixIcon ??
            Visibility(
              visible: CustomInputType.password == customInputType,
              child: IconButton(
                onPressed: toggle,
                style: IconButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
                splashRadius: 25,
                padding: EdgeInsets.zero,
                icon: obscureText ?? false
                    ? Icon(
                        Icons.visibility_off,
                        color: CustomColors.color243DE2.withOpacity(0.5),
                      )
                    : Icon(
                        Icons.visibility,
                        color: CustomColors.color243DE2.withOpacity(0.5),
                      ),
              ),
            ),
        prefixIcon: prefixIcon,
        hintStyle: GoogleFonts.roboto(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.italic,
          color: CustomColors.color182731.withOpacity(0.4),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 14.sp),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: CustomColors.color243DE2.withOpacity(1)),
          borderRadius: BorderRadius.all(Radius.circular(8.sp)),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: CustomColors.color8B8B8B.withOpacity(0.5)),
          borderRadius: BorderRadius.all(Radius.circular(8.sp)),
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black12),
          borderRadius: BorderRadius.all(Radius.circular(8.sp)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: CustomColors.color243DE2.withOpacity(0.5)),
          borderRadius: BorderRadius.all(Radius.circular(8.sp)),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: CustomColors.colorFF0033.withOpacity(0.5)),
          borderRadius: BorderRadius.all(Radius.circular(8.sp)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: CustomColors.colorFF0033.withOpacity(0.5)),
          borderRadius: BorderRadius.all(Radius.circular(8.sp)),
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
      readOnly: readOnly,
      obscureText: obscureText ?? false,
      validator: (value) {
        if (required == true) {
          String result = _validateInputText(type: customInputType ?? CustomInputType.text, value: value ?? '');
          if (result != '') return result;
          return null;
        } else if (regex == true) {
          String result = _validateInputText(type: customInputType ?? CustomInputType.text, value: value ?? '');
          if (result != '') return result;
          return null;
        } else {
          return null;
        }
      },
    );
  }

  String _validateInputText({required CustomInputType type, required String value}) {
    String result = '';
    if (value.trim().isEmpty) {
      return 'vui lòng không được để trống!'.tr.toCapitalized();
    }
    switch (type) {
      case CustomInputType.text:
        result = '';
        break;
      case CustomInputType.int:
        if (!StringHelper.intNumber.hasMatch(value)) {
          result = 'chỉ được nhập số nguyên!'.tr.toCapitalized();
        }
        break;
      case CustomInputType.double:
        if (!StringHelper.doubleNumber.hasMatch(value)) {
          result = 'chỉ được nhập số thập phân (phân cách bởi dấu chấm)!'.tr.toCapitalized();
        }
        break;
      case CustomInputType.citizenId:
        if (!StringHelper.citizenIdNumberRegExp.hasMatch(value)) {
          result = 'số cmnd/cccd không hợp lệ!'.tr.toCapitalized();
        }
        break;
      case CustomInputType.identifier:
        if (!StringHelper.identifierRegExp.hasMatch(value)) {
          result = 'mã định danh không hợp lệ!'.tr.toCapitalized();
        }
        break;
      case CustomInputType.phone:
        if (!StringHelper.phoneRegExp.hasMatch(value)) {
          result = 'số điện thoại không hợp lệ!'.tr.toCapitalized();
        }
        break;
      case CustomInputType.email:
        if (!StringHelper.emailRegExp.hasMatch(value)) {
          result = 'địa chỉ email không hợp lệ!'.tr.toCapitalized();
        }
        break;

      case CustomInputType.money:
        final text = value.replaceAll('.', '').replaceAll('₫', '').trim();
        if (int.tryParse(text) == null) {
          return 'số tiền không hợp lệ!'.tr.toCapitalized();
        }
        if (int.parse(text) < 0) {
          return 'số tiền phải lớn hơn hoặc bằng 0!';
        }
        break;
      case CustomInputType.nonSpecialCharacters:
        if (!StringHelper.specialText.hasMatch(value)) {
          result = 'chuỗi chứa ký tự đặt biệt!'.tr.toCapitalized();
        }
        break;
      case CustomInputType.nonSpecialCharactersAndNumber:
        if (!StringHelper.specialTextAndNumber.hasMatch(value)) {
          result = 'chuỗi chứa ký tự đặt biệt hoặc số!'.tr.toCapitalized();
        }
        break;
      case CustomInputType.nonSpecialCharactersAndVietnamese:
        if (!StringHelper.specialTextAndVietnamese.hasMatch(value)) {
          result = 'chuỗi chứa ký tự đặt biệt hoặc tiếng Việt có dấu!'.tr.toCapitalized();
        }
        break;
      case CustomInputType.username:
        if (value.trim().isEmpty) {
          result = 'vui lòng không được để trống!'.tr.toCapitalized();
        }
        break;
      case CustomInputType.password:
        if (!StringHelper.passwordRegExp.hasMatch(value)) {
          result = 'mật khẩu không hợp lệ!'.tr.toCapitalized();
        }
        break;
    }
    if (value.trim().isEmpty && maxLength != null) {
      if (value.length > maxLength!) {
        result = '${'bạn đã nhập quá'.tr.toCapitalized()} $maxLength ${'ký tự'.tr}!';
      }
    }
    return result;
  }
}
