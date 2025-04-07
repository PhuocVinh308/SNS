import 'package:flutter/material.dart';
import 'package:srs_common/srs_common.dart';
import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_forum/src/controllers/forum_init_controller.dart';
import 'package:srs_forum/srs_forum.dart';

class ForumBody extends GetView<ForumController> {
  const ForumBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.sp),
      child: Column(
        children: [
          15.verticalSpace,
          SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildOptionForums(),
                InkWell(
                  onTap: () {
                    CustomReusableMbs(
                      context: context,
                      child: Column(
                        children: [],
                      ),
                    ).showMbs();
                  },
                  child: Container(
                    height: .06.sh.sp,
                    width: 60.sp,
                    decoration: BoxDecoration(
                      color: CustomColors.color06b252,
                      borderRadius: BorderRadius.circular(8.sp),
                    ),
                    alignment: Alignment.center,
                    child: FaIcon(
                      FontAwesomeIcons.filter,
                      color: CustomColors.colorFFFFFF,
                      size: 25.sp,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.toNamed(AllRoute.addRoute);
                  },
                  child: Container(
                    height: .06.sh.sp,
                    width: 60.sp,
                    decoration: BoxDecoration(
                      color: CustomColors.color06b252,
                      borderRadius: BorderRadius.circular(8.sp),
                    ),
                    alignment: Alignment.center,
                    child: FaIcon(
                      FontAwesomeIcons.plus,
                      color: CustomColors.colorFFFFFF,
                      size: 25.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
          15.verticalSpace,
          Expanded(
            child: Obx(() {
              return _buildNews();
            }),
          )
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
                onTap: () async {
                  controller.options.value = true;
                  await controller.funCoreChangeTypePost();
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
                onTap: () async {
                  controller.options.value = false;
                  await controller.funCoreChangeTypePost();
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

  _buildNews() {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 5.sp),
      itemBuilder: (context, index) {
        return AnimationConfiguration.staggeredList(
          position: index,
          duration: const Duration(milliseconds: 375),
          child: SlideAnimation(
            verticalOffset: 50.0,
            child: FadeInAnimation(
              child: _itemForums(controller.forumPostsSorted[index]),
            ),
          ),
        );
      },
      separatorBuilder: (context, value) => SizedBox(height: 15.sp),
      itemCount: controller.forumPostsSorted.length,
    );
  }

  _itemForums(ForumPostModel data) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          AllRoute.contentRoute,
          arguments: [
            {
              'data': data,
              'isBackMain': false,
            },
          ],
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15.sp, horizontal: 5.sp),
        decoration: BoxDecoration(
          color: CustomColors.colorFFFFFF,
          border: Border(
            bottom: BorderSide(
              color: CustomColors.color000000.withOpacity(0.1),
              width: 2.0.sp,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: CustomColors.color06b252.withOpacity(.3),
                      radius: 30.sp,
                      child: Image.asset(
                        'assets/images/farmer.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    10.horizontalSpace,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            (data.title ?? 'đang cập nhật...'.tr).toCapitalized(),
                            fontSize: CustomConsts.title,
                            fontWeight: CustomConsts.semiBold,
                            maxLines: 2,
                            textAlign: TextAlign.start,
                          ),
                          5.verticalSpace,
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                CustomText(
                                  data.fullNameCreated ?? 'đang cập nhật...'.tr.toCapitalized(),
                                  maxLines: 1,
                                  color: CustomColors.color313131.withOpacity(.7),
                                ),
                                CustomText(
                                  ' - ',
                                  maxLines: 1,
                                  color: CustomColors.color313131.withOpacity(.7),
                                ),
                                CustomText(
                                  controller.funGetTimeCreate(data.createdDate),
                                  maxLines: 1,
                                  color: CustomColors.color313131.withOpacity(.7),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                10.verticalSpace,
                CustomText(
                  data.content ?? 'đang cập nhật...'.tr.toCapitalized(),
                  maxLines: 6,
                  color: CustomColors.color313131.withOpacity(.8),
                  textAlign: TextAlign.start,
                ),
                Visibility(
                  visible: data.fileUrl != null && data.fileUrl != '',
                  child: Column(
                    children: [
                      10.verticalSpace,
                      Container(
                        alignment: Alignment.center,
                        child: CachedNetworkImage(
                          imageUrl: data.fileUrl ?? '',
                          placeholder: (context, url) => const CircularProgressIndicator(
                            color: CustomColors.color005AAB,
                          ),
                          errorWidget: (context, url, error) => Icon(
                            Icons.cloud_off,
                            size: 50.sp,
                            color: CustomColors.colorD9D9D9,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            20.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _itemNoteNews(
                  FaIcon(
                    FontAwesomeIcons.message,
                    color: CustomColors.color313131,
                    size: 25.sp,
                  ),
                  data.countCmt.toString(),
                ),
                _itemNoteNews(
                  FaIcon(
                    FontAwesomeIcons.heart,
                    color: CustomColors.color313131,
                    size: 25.sp,
                  ),
                  data.countLike.toString(),
                ),
                _itemNoteNews(
                  FaIcon(
                    FontAwesomeIcons.eye,
                    color: CustomColors.color313131,
                    size: 25.sp,
                  ),
                  data.countSeen.toString(),
                ),
                // _itemNoteNews(
                //   FaIcon(
                //     FontAwesomeIcons.clock,
                //     color: CustomColors.color313131,
                //     size: 25.sp,
                //   ),
                //   '6d',
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _itemNoteNews(Widget? icon, String? title) {
    return Padding(
      padding: EdgeInsets.only(right: 20.sp),
      child: Row(
        children: [
          icon ?? const SizedBox(),
          10.horizontalSpace,
          CustomText(title ?? ""),
        ],
      ),
    );
  }
}
