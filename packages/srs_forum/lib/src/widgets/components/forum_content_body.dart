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
            _buildReplies(),
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
                  'vat tu',
                  color: CustomColors.colorFFFFFF,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
                margin: EdgeInsets.only(right: 10.sp),
                decoration: BoxDecoration(
                  color: CustomColors.color2A5ACF,
                  borderRadius: BorderRadius.circular(8.sp),
                ),
                child: CustomText(
                  'vat tu',
                  color: CustomColors.colorFFFFFF,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  _buildReplies() {
    return Column(
      children: [
        _itemReplies(),
        _itemReplies(),
        _itemReplies(),
        _itemReplies(),
      ],
    );
  }

  _itemReplies() {
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
                      'Nguyen van A',
                      fontSize: CustomConsts.title,
                      fontWeight: CustomConsts.semiBold,
                      maxLines: 1,
                      textAlign: TextAlign.start,
                    ),
                    5.verticalSpace,
                    CustomText(
                      '1h ago',
                      maxLines: 1,
                      color: CustomColors.color313131.withOpacity(.7),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
            ],
          ),
          15.verticalSpace,
          CustomText(
            'Glowrose-Mobile-App-Topics/attachments/1344796?mode=media ',
            color: CustomColors.color313131.withOpacity(.8),
            maxLines: 100,
          ),
          15.verticalSpace,
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.favorite_border,
                ),
              ),
              5.horizontalSpace,
              CustomText("120"),
            ],
          ),
        ],
      ),
    );
  }
}
