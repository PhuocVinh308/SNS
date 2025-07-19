import 'package:flutter/material.dart';
import 'package:srs_common/srs_common.dart';
import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_disease/srs_disease.dart';

class DiseasePage extends GetView<DiseaseController> {
  const DiseasePage({Key? key}) : super(key: key);

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
                  Expanded(
                    child: DiseaseBody(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
