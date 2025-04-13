import 'package:flutter/material.dart';
import 'package:srs_common/srs_common.dart';
import 'package:srs_common/srs_common_lib.dart';

class CustomDropdown extends StatelessWidget {
  final Key? dropdownFormKey;
  final AutovalidateMode? autoValidate;
  final List<dynamic>? items;
  final String Function(dynamic)? itemAsString;
  final dynamic selectedItem;
  final void Function(dynamic)? onChanged;
  final bool? required;
  final bool? regex;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final String? title;
  final String? hint;
  final bool Function(dynamic, dynamic)? compareFn;
  final bool? enabled;
  final Widget? suffixIcon;
  final bool Function(dynamic)? popupItemDisabled;
  final double? maxHeight;
  final Future<bool?> Function(dynamic)? onBeforePopupOpening;
  final Color? fillColor;

  const CustomDropdown({
    Key? key,
    this.dropdownFormKey,
    this.autoValidate,
    this.items,
    this.itemAsString,
    this.selectedItem,
    this.onChanged,
    this.required,
    this.regex,
    this.floatingLabelBehavior,
    this.title,
    this.hint,
    this.compareFn,
    this.enabled,
    this.suffixIcon,
    this.popupItemDisabled,
    this.maxHeight,
    this.onBeforePopupOpening,
    this.fillColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<dynamic>(
      key: dropdownFormKey,
      autoValidateMode: autoValidate ?? AutovalidateMode.onUserInteraction,
      popupProps: PopupProps.modalBottomSheet(
        searchDelay: const Duration(milliseconds: 300),
        // Độ trễ tìm kiếm
        constraints: BoxConstraints(maxHeight: maxHeight ?? 350),
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            hintText: '${'nhập từ khoá đề tìm kiếm'.tr.toCapitalized()}...',
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
        ),
        title: Container(
          height: 60.sp,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.sp),
              topRight: Radius.circular(10.sp),
            ),
          ),
          child: Stack(
            children: [
              Container(
                alignment: FractionalOffset.topCenter,
                padding: EdgeInsets.only(top: 5.sp),
                child: Container(
                  height: 3.sp,
                  width: 50.sp,
                  decoration: BoxDecoration(
                    color: CustomColors.color00499B,
                    borderRadius: BorderRadius.all(
                      Radius.circular(3.sp),
                    ),
                  ),
                ),
              ),
              Container(
                alignment: FractionalOffset.center,
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  title ?? hint ?? '',
                  style: GoogleFonts.roboto(
                    color: CustomColors.color7047EB,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                alignment: FractionalOffset.topRight,
                padding: EdgeInsets.only(top: 5.sp, right: 5.sp),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.sp),
                  ),
                  child: Material(
                    color: CustomColors.color00499B,
                    child: SizedBox(
                      height: 25.sp,
                      width: 25.sp,
                      child: IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        style: IconButton.styleFrom(
                          padding: EdgeInsets.zero,
                        ),
                        iconSize: 20.sp,
                        icon: const Icon(
                          Icons.close_rounded,
                          color: CustomColors.colorFFFFFF,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        emptyBuilder: (context, searchEntry) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: const AssetImage("assets/images/empty_data.png"),
                height: 70.sp,
              ),
              const SizedBox(height: 20),
              Text(
                'không tìm thấy dữ liệu!'.tr.toCapitalized(),
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                  color: CustomColors.color434343,
                  letterSpacing: 0.25,
                ),
              ),
            ],
          ),
        ),
        modalBottomSheetProps: ModalBottomSheetProps(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(8.sp),
              topLeft: Radius.circular(8.sp),
            ),
          ),
          elevation: 4.0,
        ),
        showSearchBox: true,
        showSelectedItems: true,
        itemBuilder: _buildRadioSelectorItems,
      ),
      items: items ?? [],
      selectedItem: selectedItem,
      compareFn: compareFn ??
          (dynamic a, dynamic b) {
            return a?.id == b?.id;
          },
      filterFn: (dynamic item, String filter) {
        // Kiểm tra ký tự tìm kiếm ít nhất 1 ký tự
        if (filter.isEmpty) return true;
        return itemAsString!(item).toLowerCase().contains(filter.toLowerCase());
      },
      onChanged: onChanged,
      dropdownBuilder: _customDropDownBuilder,
      enabled: enabled ?? true,
      dropdownDecoratorProps: DropDownDecoratorProps(
        baseStyle: GoogleFonts.roboto(
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.italic,
          color: CustomColors.color182731.withOpacity(0.4),
        ),
        dropdownSearchDecoration: InputDecoration(
          floatingLabelBehavior: floatingLabelBehavior,
          isDense: true,
          hintText: hint,
          label: RichText(
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
          ),
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
      ),
      onBeforePopupOpening: onBeforePopupOpening,
      itemAsString: itemAsString,
      dropdownButtonProps: DropdownButtonProps(
        isVisible: true,
        padding: EdgeInsets.zero,
        icon: suffixIcon ??
            Icon(
              Icons.expand_more_rounded,
              color: enabled ?? true ? fillColor ?? CustomColors.color243DE2.withOpacity(0.5) : CustomColors.color8B8B8B.withOpacity(0.8),
            ),
      ),
      validator: (value) {
        if (required == true) {
          if (value?.name == null) {
            return 'dữ liệu không hợp lệ!'.tr.toCapitalized();
          }
          return null;
        } else if (regex == true) {
          if (value?.name == null) {
            return 'dữ liệu không hợp lệ!'.tr.toCapitalized();
          }
          return null;
        } else {
          return null;
        }
      },
    );
  }

  Widget _customDropDownBuilder(BuildContext context, item) {
    String value = '';
    if (item == null) {
      if (hint == null) {
        return Container();
      } else {
        value = hint!;
      }
    } else {
      value = item.name;
    }
    return Text(
      value,
      style: GoogleFonts.roboto(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: CustomColors.color182731,
      ),
    );
  }

  Widget _buildRadioSelectorItems(BuildContext context, dynamic item, bool isSelected) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Checkbox(
            value: isSelected,
            onChanged: (value) {},
            checkColor: CustomColors.colorFFFFFF,
            activeColor: CustomColors.color7047EB,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          Expanded(
            child: SizedBox(
              width: 1.sw - 64.sp,
              child: RichText(
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                text: TextSpan(
                  text: item?.name ?? '',
                  style: GoogleFonts.roboto(
                    color: Colors.black87,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
