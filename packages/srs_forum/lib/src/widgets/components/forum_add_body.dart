import 'package:flutter/material.dart';
import 'package:srs_common/srs_common.dart';
import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_forum/srs_forum.dart';

class ForumAddBody extends GetView<ForumAddController> {
  const ForumAddBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.sp),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              15.verticalSpace,
              Row(
                children: [
                  CustomText(
                    'thông tin bài đăng'.tr.toCapitalized(),
                    fontWeight: CustomConsts.semiBold,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
              10.verticalSpace,
              CustomDropdown(
                itemAsString: (item) {
                  return (item as TypePost).name ?? "chọn loại bài đăng".tr.toCapitalized();
                },
                onChanged: (item) {
                  controller.typePost.value = item;
                },
                items: controller.typePosts,
                selectedItem: controller.typePost.value,
                title: 'loại bài đăng'.tr.toCapitalized(),
                required: true,
              ),
              10.verticalSpace,
              Row(
                children: [
                  CustomText(
                    'chi tiết bài đăng'.tr.toCapitalized(),
                    fontWeight: CustomConsts.semiBold,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
              10.verticalSpace,
              CustomTextField(
                title: 'tiêu đề'.tr.toCapitalized(),
                controller: controller.titleController,
                required: true,
              ),
              10.verticalSpace,
              CustomTextField(
                title: 'nội dung'.tr.toCapitalized(),
                controller: controller.contentController,
                required: true,
              ),
              5.verticalSpace,
              Row(
                children: [
                  CustomText(
                    'ảnh đính kèm (nếu có)'.tr.toCapitalized(),
                    fontWeight: CustomConsts.semiBold,
                    textAlign: TextAlign.start,
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.add_to_photos_rounded,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
// CustomReusableDropdown(
// itemAsString: (item) {
// return (item as ProvinceResponseModel).provinceName ?? 'dropdown_select_province'.tr;
// },
// valueAsString: Globals.getUserInfo.tenTinhThanh,
// dropdownMenuItemList: controller.listProvinceData,
// onChanged: (item) {
// // controller.fetchDistrictData(item);
// //IT5ASXH-5608
// controller.fetchBteAdministrativeUnitData(item, code: BteAdministrativeCode.district);
// controller.changeAddress(controller.villageData.value.villageName, controller.communeData.value.communeName,
// controller.districtData.value.districtName, controller.provideData.value.provinceName);
// //end IT5ASXH-5608
// },
// value: controller.provinceData.value,
// title: 'dropdown_province'.tr,
// hint: 'dropdown_select_province'.tr,
// isRequired: true,
// isIgnore: true,
// ),
}
