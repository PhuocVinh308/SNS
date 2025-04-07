import 'package:flutter/material.dart';
import 'package:srs_common/srs_common.dart';
import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_landing/srs_landing.dart' as srs_landing;
import 'package:srs_forum/src/widgets/components/forum_content_body.dart';
import 'package:srs_forum/srs_forum.dart';

class ForumContentPage extends GetView<ForumContentController> {
  const ForumContentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: CustomColors.colorF2F2F2,
          body: Column(
            children: [
              Container(
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
                      children: [
                        IconButton(
                          onPressed: () {
                            if (controller.isBackMain) {
                              Get.offAndToNamed(
                                srs_landing.AllRoute.mainRoute,
                                arguments: [{}],
                              );
                            } else {
                              Get.back();
                            }
                          },
                          icon: const FaIcon(
                            FontAwesomeIcons.angleLeft,
                            color: CustomColors.colorFFFFFF,
                          ),
                        ),
                        Expanded(
                          child: CustomText(
                            'chi tiết'.tr.toCapitalized(),
                            color: CustomColors.colorFFFFFF,
                            fontWeight: CustomConsts.bold,
                            fontSize: CustomConsts.appBar,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Expanded(
                child: ForumContentBody(),
              ),
              Obx(() {
                return Form(
                  key: controller.replyKey,
                  autovalidateMode: controller.validate.value,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 5.sp),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.sp),
                        topRight: Radius.circular(8.sp),
                      ),
                    ),
                    child: Column(
                      children: [
                        CustomTextField(
                          autoValidate: controller.validate.value,
                          controller: controller.replyController,
                          prefixIcon: IconButton(
                            onPressed: () {
                              _bottomSheetShowCameraOrGallery(context, onTapCamera: () async {
                                await controller.funPickImage(ImageSource.camera).then((value) {
                                  Get.back();
                                });
                              }, onTapGallery: () async {
                                await controller.funPickImage(ImageSource.gallery).then((value) {
                                  Get.back();
                                });
                              });
                            },
                            icon: Icon(
                              Icons.add_photo_alternate_rounded,
                              size: 30.sp,
                              color: CustomColors.color06b252,
                            ),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () async {
                              await controller.funPostReply();
                            },
                            icon: Icon(
                              Icons.send,
                              size: 30.sp,
                              color: CustomColors.color06b252,
                            ),
                          ),
                        ),
                        if (controller.imageOriginalBytes.value != null)
                          Container(
                            height: .5.sh - 50,
                            padding: EdgeInsets.only(top: 5.sp),
                            child: Stack(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(5.sp),
                                  child: Image.memory(
                                    controller.imageOriginalBytes.value!,
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: IconButton(
                                    onPressed: () {
                                      controller.funRefreshSelect();
                                    },
                                    icon: const FaIcon(
                                      FontAwesomeIcons.circleXmark,
                                      color: CustomColors.colorFFFFFF,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
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
