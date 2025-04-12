import 'package:flutter/material.dart';
import 'package:srs_common/srs_common.dart';
import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_forum/srs_forum.dart';

class ForumSearchPage extends GetView<ForumController> {
  const ForumSearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: SafeArea(
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
                              Get.back();
                            },
                            icon: const FaIcon(
                              FontAwesomeIcons.angleLeft,
                              color: CustomColors.colorFFFFFF,
                            ),
                          ),
                          Expanded(
                            child: CustomText(
                              'tìm kiếm'.tr.toCapitalized(),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
