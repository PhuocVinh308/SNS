import 'package:flutter/material.dart';
import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_common/srs_common.dart';
import 'package:srs_forum/srs_forum.dart';

class ForumPage extends GetView<ForumController> {
  const ForumPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: SafeArea(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: CustomColors.colorFFFFFF,
            body: Container(
              padding: EdgeInsets.only(bottom: 10.sp),
              height: 1.sh,
              width: 1.sw,
              child: const Column(
                children: [
                  ForumAppBar(),
                  Expanded(
                    child: ForumBody(),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: const CustomBottomAppBar(
              index: 2,
            ),
          ),
        ),
      ),
    );
  }
}
