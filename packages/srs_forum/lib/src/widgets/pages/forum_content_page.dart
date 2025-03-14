import 'package:flutter/material.dart';
import 'package:srs_common/srs_common.dart';
import 'package:srs_common/srs_common_lib.dart';
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
          body: Container(
            padding: EdgeInsets.only(bottom: 10.sp),
            height: 1.sh,
            width: 1.sw,
            child: Stack(
              children: [
                Column(
                  children: [
                    const ForumContentAppBar(),
                    const Expanded(
                      child: ForumContentBody(),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
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
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
