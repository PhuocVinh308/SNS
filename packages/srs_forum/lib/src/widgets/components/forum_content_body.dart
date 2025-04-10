import 'package:flutter/material.dart';
import 'package:srs_common/srs_common.dart';
import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_forum/srs_forum.dart';

class ForumContentBody extends GetView<ForumContentController> {
  const ForumContentBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.sp),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            15.verticalSpace,
            _buildMainPost(),
            15.verticalSpace,
            CustomText(
              'trả lời'.tr.toCapitalized(),
              fontSize: CustomConsts.title,
              fontWeight: CustomConsts.bold,
              textAlign: TextAlign.start,
            ),
            15.verticalSpace,
            Obx(() {
              return Column(
                children: _buildReplies().isNotEmpty
                    ? _buildReplies()
                    : [
                        Center(
                          child: Image.asset(
                            'assets/images/empty_data.png',
                            width: .5.sw,
                            height: .5.sh,
                          ),
                        ),
                      ],
              );
            }),
          ],
        ),
      ),
    );
  }

  _buildMainPost() {
    return Container(
      padding: EdgeInsets.all(15.sp),
      decoration: BoxDecoration(
        color: CustomColors.colorFFFFFF,
        borderRadius: BorderRadius.circular(15.sp),
      ),
      child: Column(
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
                      controller.data.fullNameCreated ?? 'đang cập nhật...'.tr.toCapitalized(),
                      fontSize: CustomConsts.title,
                      fontWeight: CustomConsts.semiBold,
                      maxLines: 1,
                      textAlign: TextAlign.start,
                    ),
                    5.verticalSpace,
                    CustomText(
                      controller.funGetTimeCreate(controller.data.createdDate),
                      maxLines: 1,
                      color: CustomColors.color313131.withOpacity(.7),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.favorite_border,
                  color: CustomColors.color833162,
                  size: 35.sp,
                ),
              ),
            ],
          ),
          15.verticalSpace,
          CustomText(
            (controller.data.title ?? 'đang cập nhật...'.tr).toCapitalized(),
            fontSize: CustomConsts.h2,
            fontWeight: CustomConsts.semiBold,
            textAlign: TextAlign.start,
            maxLines: 20,
          ),
          15.verticalSpace,
          CustomText(
            controller.data.content ?? 'đang cập nhật...'.tr.toCapitalized(),
            color: CustomColors.color313131.withOpacity(.8),
            maxLines: 100,
          ),
          Visibility(
            visible: controller.data.fileUrl != null && controller.data.fileUrl != '',
            child: Column(
              children: [
                15.verticalSpace,
                Container(
                  alignment: Alignment.center,
                  child: CachedNetworkImage(
                    imageUrl: controller.data.fileUrl ?? '',
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
          ),
          15.verticalSpace,
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
                margin: EdgeInsets.only(right: 10.sp),
                decoration: BoxDecoration(
                  color: CustomColors.color2A5ACF,
                  borderRadius: BorderRadius.circular(8.sp),
                ),
                child: CustomText(
                  controller.funGetTagPost(),
                  color: CustomColors.colorFFFFFF,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  List<Widget> _buildReplies() {
    List<Widget> list = [];
    for (var data in controller.postCmts) {
      var item = _itemReplies(data);
      list.add(item);
    }
    return list;
  }

  _itemReplies(ForumPostChildModel data) {
    return Container(
      padding: EdgeInsets.all(15.sp),
      margin: EdgeInsets.only(bottom: 10.sp),
      decoration: BoxDecoration(
        color: CustomColors.colorFFFFFF,
        borderRadius: BorderRadius.circular(15.sp),
      ),
      child: Column(
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
                      data.fullNameCreated ?? 'đang cập nhật...'.tr.toCapitalized(),
                      fontSize: CustomConsts.title,
                      fontWeight: CustomConsts.semiBold,
                      maxLines: 1,
                      textAlign: TextAlign.start,
                    ),
                    5.verticalSpace,
                    CustomText(
                      controller.funGetTimeCreate(data.createdDate),
                      maxLines: 1,
                      color: CustomColors.color313131.withOpacity(.7),
                      textAlign: TextAlign.start,
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
          ),
          10.verticalSpace,
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.favorite_border,
                ),
              ),
              5.horizontalSpace,
              CustomText(
                data.countLike.toString(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
