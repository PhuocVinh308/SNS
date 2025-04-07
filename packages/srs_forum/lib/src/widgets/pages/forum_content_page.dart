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
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15.sp),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.sp),
                    topRight: Radius.circular(8.sp),
                  ),
                ),
                child: Column(
                  children: [
                    CustomTextField(
                      prefixIcon: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.add_photo_alternate_rounded,
                          size: 30.sp,
                          color: CustomColors.color06b252,
                        ),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.send,
                          size: 30.sp,
                          color: CustomColors.color06b252,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5.sp),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: CustomText('file.png')),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.cancel,
                              color: CustomColors.color06b252,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
