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
            backgroundColor: CustomColors.colorFFFFFF,
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
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      10.verticalSpace,
                      CustomText(
                        'thông tin tìm kiếm'.tr.toCapitalized(),
                        fontSize: CustomConsts.title,
                        fontWeight: CustomConsts.bold,
                        textAlign: TextAlign.start,
                      ),
                      10.verticalSpace,
                      CustomTextField(
                        hint: '${'tìm kiếm ở đây'.tr.toCapitalized()}...',
                        controller: controller.searchController,
                        suffixIcon: IconButton(
                          onPressed: () async {
                            await controller.funSearchPost();
                          },
                          icon: Icon(
                            Icons.search,
                            size: 30.sp,
                          ),
                        ),
                        regex: true,
                      ),
                      10.verticalSpace,
                      CustomText(
                        'nội dung tìm kiếm'.tr.toCapitalized(),
                        fontSize: CustomConsts.title,
                        fontWeight: CustomConsts.bold,
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
                15.verticalSpace,
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.sp),
                    child: Obx(() {
                      return _buildNews();
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildNews() {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 5.sp),
      controller: controller.scrollSearchController,
      itemBuilder: (context, index) {
        if (index < controller.forumSearchPosts.length) {
          final post = controller.forumSearchPosts[index];
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: _itemForums(post),
              ),
            ),
          );
        } else {
          return const Center(
            child: SizedBox(),
          );
        }
      },
      separatorBuilder: (context, value) => SizedBox(height: 15.sp),
      itemCount: controller.forumSearchPosts.length + (controller.hasMoreSearch ? 1 : 0),
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
        )?.then((value) async {
          // await controller.funSyncForumPost();
        });
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
