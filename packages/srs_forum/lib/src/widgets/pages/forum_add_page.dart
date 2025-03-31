import 'package:flutter/material.dart';
import 'package:srs_common/srs_common.dart';
import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_forum/srs_forum.dart';

class ForumAddPage extends GetView<ForumAddController> {
  const ForumAddPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: CustomColors.colorFFFFFF,
          body: Form(
            key: controller.addNewKey,
            autovalidateMode: controller.validate.value,
            child: Column(
              children: [
                _appbar(),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15.sp),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 15.sp),
                            child: Row(
                              children: [
                                CustomText(
                                  "${'loại diễn đàn'.tr.toCapitalized()} (*)",
                                  fontWeight: CustomConsts.semiBold,
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                          ),
                          _buildOptionForums(),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 15.sp),
                            child: Row(
                              children: [
                                CustomText(
                                  "${'tiêu đề'.tr.toCapitalized()} (*)",
                                  fontWeight: CustomConsts.semiBold,
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                          ),
                          CustomTextField(
                            controller: controller.titleController,
                            autoValidate: controller.validate.value,
                            regex: true,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 15.sp),
                            child: Row(
                              children: [
                                CustomText(
                                  "${'nội dung'.tr.toCapitalized()} (*)",
                                  fontWeight: CustomConsts.semiBold,
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                          ),
                          CustomTextField(
                            controller: controller.contentController,
                            autoValidate: controller.validate.value,
                            minLines: 6,
                            regex: true,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 15.sp),
                            child: Row(
                              children: [
                                CustomText(
                                  'ảnh đính kèm (nếu có)'.tr.toCapitalized(),
                                  fontWeight: CustomConsts.semiBold,
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                          ),
                          MaterialButton(
                            onPressed: () {
                              _bottomSheetShowCameraOrGallery(context, onTapCamera: () async {
                                await controller.corePickImage(ImageSource.camera).then((value) {
                                  Get.back();
                                });
                              }, onTapGallery: () async {
                                await controller.corePickImage(ImageSource.gallery).then((value) {
                                  Get.back();
                                });
                              });
                            },
                            color: CustomColors.color06b252,
                            disabledColor: CustomColors.color8B8B8B,
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.sp),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 5.sp),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.add,
                                  color: CustomColors.colorFFFFFF,
                                ),
                                5.horizontalSpace,
                                CustomText(
                                  'thêm hình ảnh'.tr.toCapitalized(),
                                  color: CustomColors.colorFFFFFF,
                                  fontWeight: CustomConsts.bold,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _appbar() {
    return Container(
      height: kToolbarHeight,
      width: 1.sw.spMax,
      padding: EdgeInsets.symmetric(horizontal: 15.sp),
      decoration: BoxDecoration(
        color: CustomColors.color06b252,
        shape: BoxShape.rectangle,
        border: Border.all(color: Colors.black12),
        boxShadow: [
          BoxShadow(
            color: CustomColors.color000000.withOpacity(0.1), // Màu bóng
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const FaIcon(
                  FontAwesomeIcons.angleLeft,
                  color: CustomColors.colorFFFFFF,
                ),
              ),
              Expanded(
                child: CustomText(
                  'tạo bài viết'.tr.toCapitalized(),
                  color: CustomColors.colorFFFFFF,
                  fontWeight: CustomConsts.bold,
                  fontSize: CustomConsts.appBar,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                width: 70.sp,
                height: 30.sp,
                child: MaterialButton(
                  onPressed: () async {
                    await controller.funPostForum();
                  },
                  color: CustomColors.color005AAB,
                  disabledColor: CustomColors.color8B8B8B,
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.sp),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 5.sp),
                  child: CustomText(
                    'đăng'.tr.toCapitalized(),
                    color: CustomColors.colorFFFFFF,
                    fontWeight: CustomConsts.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _buildOptionForums() {
    double swLangHeight = .06.sh.sp;
    double swLangWidth = .3.sw.sp;
    double swLangRadius = 20.sp;
    return Obx(() {
      return Container(
        width: swLangWidth * 2,
        height: swLangHeight + 5.sp,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(swLangRadius),
          color: CustomColors.colorEDEDFE,
        ),
        child: Stack(
          children: [
            // Nền trượt động
            AnimatedAlign(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment: controller.options.value ? Alignment.centerLeft : Alignment.centerRight,
              child: Container(
                width: swLangWidth,
                height: swLangHeight,
                decoration: BoxDecoration(
                  color: CustomColors.color06b252,
                  borderRadius: BorderRadius.circular(swLangRadius),
                  boxShadow: [
                    BoxShadow(
                      color: CustomColors.color000000.withOpacity(.04),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
            // Nút chọn VN
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {
                  controller.options.value = true;
                  // controller.funChangeLanguage(true);
                },
                child: Container(
                  width: swLangWidth,
                  height: swLangHeight,
                  alignment: Alignment.center,
                  child: CustomText(
                    'nông dân'.tr.toCapitalized(),
                    fontWeight: CustomConsts.semiBold,
                    color: !controller.options.value ? CustomColors.color5B596D : CustomColors.colorFFFFFF,
                  ),
                ),
              ),
            ),
            // Nút chọn US
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  controller.options.value = false;
                  // controller.funChangeLanguage(false);
                },
                child: Container(
                  width: swLangWidth,
                  height: swLangHeight,
                  alignment: Alignment.center,
                  child: CustomText(
                    'vật tư'.tr.toCapitalized(),
                    fontWeight: CustomConsts.semiBold,
                    color: controller.options.value ? CustomColors.color5B596D : CustomColors.colorFFFFFF,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  _bottomSheetShowCameraOrGallery(
    BuildContext context, {
    Function? onTapCamera,
    Function? onTapGallery,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10),
          topLeft: Radius.circular(10),
        ),
      ),
      isScrollControlled: true,
      enableDrag: true,
      useSafeArea: true,
      builder: (c) {
        return Container(
          height: 100.sp,
          width: 1.sw,
          margin: EdgeInsets.all(20.sp),
          child: Column(
            children: [
              Text(
                'chọn hình ảnh'.tr.toCapitalized(),
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: CustomColors.color005AAB,
                ),
              ),
              SizedBox(height: 5.sp),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () async {
                        await onTapCamera?.call();
                      },
                      icon: Row(
                        children: [
                          Icon(
                            Icons.camera_alt_rounded,
                            size: 25.sp,
                          ),
                          5.horizontalSpace,
                          Text(
                            'máy ảnh'.tr.toCapitalized(),
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        await onTapGallery?.call();
                      },
                      icon: Row(
                        children: [
                          Icon(
                            Icons.image,
                            size: 25.sp,
                          ),
                          5.horizontalSpace,
                          Text(
                            'thư viện'.tr.toCapitalized(),
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
