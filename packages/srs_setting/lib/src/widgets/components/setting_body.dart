import 'package:flutter/material.dart';
import 'package:srs_common/srs_common.dart';
import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_setting/srs_setting.dart';

class SettingBody extends GetView<SettingController> {
  const SettingBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.sp),
      child: SingleChildScrollView(
        child: Column(
          children: [
            15.verticalSpace,
            Container(
              width: 160.sp, // bằng 2 * radius
              height: 160.sp,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: CustomColors.colorFFFFFF, // viền màu bạn muốn
                  width: 2, // độ dày viền
                ),
              ),
              child: CircleAvatar(
                backgroundColor: CustomColors.color06b252.withOpacity(.3),
                radius: 80.sp,
                child: ClipOval(
                  // để đảm bảo hình ảnh bo tròn theo avatar
                  child: Image.asset(
                    'assets/images/farmer.png',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
            ),
            15.verticalSpace,
            CustomText(
              (controller.userModel.value.fullName ?? "").toUpperCase(),
              fontSize: CustomConsts.h2,
              fontWeight: CustomConsts.bold,
              textAlign: TextAlign.start,
            ),
            15.verticalSpace,
            GestureDetector(
              onTap: () async {
                await controller.funSignOut();
              },
              child: Container(
                width: 135.sp,
                padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
                decoration: BoxDecoration(
                  color: CustomColors.colorB6DFFF.withOpacity(.8),
                  borderRadius: BorderRadius.circular(8.sp),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.logout,
                      color: CustomColors.color313131,
                    ),
                    10.horizontalSpace,
                    CustomText(
                      'đăng xuất'.tr.toCapitalized(),
                    ),
                  ],
                ),
              ),
            ),
            25.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  'đổi ngôn ngữ'.tr.toCapitalized(),
                  fontSize: CustomConsts.title,
                  fontWeight: CustomConsts.bold,
                  textAlign: TextAlign.start,
                ),
                const SwitchLanguage()
              ],
            ),
            25.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  'trợ giúp'.tr.toCapitalized(),
                  fontSize: CustomConsts.title,
                  fontWeight: CustomConsts.bold,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
            15.verticalSpace,
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _itemHelper(
                  iconData: Icons.person_outline,
                  title: 'thông tin cá nhân'.tr.toCapitalized(),
                  onTap: () {
                    Get.toNamed(AllRoute.updateInfoRoute)?.then((value) async {});
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  _itemHelper({
    String? title,
    Function? onTap,
    IconData? iconData,
  }) {
    double sizeItem = 50.sp;
    return GestureDetector(
      onTap: () {
        onTap?.call();
      },
      child: Container(
        height: sizeItem,
        decoration: BoxDecoration(
          color: CustomColors.colorB6DFFF.withOpacity(.8),
          borderRadius: BorderRadius.circular(10.sp),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // màu bóng
              offset: const Offset(0, 4), // đổ bóng xuống dưới
              blurRadius: 6, // độ mờ của bóng
              spreadRadius: 0, // độ lan rộng
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
        child: Row(
          children: [
            Icon(
              iconData,
              size: 30.sp,
              color: CustomColors.color833162,
            ),
            10.horizontalSpace,
            CustomText(
              title ?? '',
              maxLines: 2,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
