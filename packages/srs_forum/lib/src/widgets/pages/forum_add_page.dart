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
          backgroundColor: CustomColors.colorF2F2F2,
          body: Container(
            padding: EdgeInsets.only(bottom: 10.sp),
            height: 1.sh,
            width: 1.sw,
            child: Form(
              key: controller.addNewKey,
              autovalidateMode: controller.validate.value,
              child: Column(
                children: [
                  _appbar(),
                  ForumAddBody(),
                ],
              ),
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
                  'tạo bài đăng'.tr.toCapitalized(),
                  color: CustomColors.colorFFFFFF,
                  fontWeight: CustomConsts.bold,
                  fontSize: CustomConsts.appBar,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                width: 70,
                height: 30,
                child: MaterialButton(
                  onPressed: () {},
                  color: CustomColors.color005AAB,
                  disabledColor: CustomColors.color8B8B8B,
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 5),
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
}
