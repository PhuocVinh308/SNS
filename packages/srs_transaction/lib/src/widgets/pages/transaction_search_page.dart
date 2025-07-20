import 'package:flutter/material.dart';
import 'package:srs_common/srs_common.dart';
import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_transaction/srs_transaction.dart';

class TransactionSearchPage extends GetView<TransactionController> {
  TransactionSearchPage({Key? key}) : super(key: key);
  final negotiateFormKey = GlobalKey<FormState>();

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
                  child: Obx(() {
                    return _buildTransactions(context);
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildTransactions(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 5.sp),
      controller: controller.scrollSearchController,
      itemBuilder: (context, index) {
        if (index < controller.itemSearchPosts.length) {
          final post = controller.itemSearchPosts[index];
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: _buildTransactionItem(post, context),
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
      itemCount: controller.itemSearchPosts.length + (controller.hasMoreSearch ? 1 : 0),
    );
  }

  Widget _buildTransactionItem(TransactionModel data, BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with status
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade100,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: CustomColors.color06b252.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: CustomText(
                        controller.getTrangThaiPostToName(data.trangThai ?? ""),
                        fontSize: CustomConsts.h7,
                        color: CustomColors.color06b252,
                        fontWeight: CustomConsts.bold,
                      ),
                    ),
                    8.horizontalSpace,
                    Icon(
                      (data.isVerified == null || data.isVerified == false) ? Icons.cancel_rounded : Icons.verified_rounded,
                      color: (data.isVerified == null || data.isVerified == false) ? CustomColors.colorFF0000 : CustomColors.color06b252,
                      size: 16.w,
                    ),
                    4.horizontalSpace,
                    CustomText(
                      (data.isVerified == null || data.isVerified == false) ? 'chưa xác thực'.tr.toCapitalized() : 'đã xác thực'.tr.toCapitalized(),
                      fontSize: CustomConsts.h7,
                      color: (data.isVerified == null || data.isVerified == false) ? CustomColors.colorFF0000 : CustomColors.color06b252,
                    ),
                  ],
                ),
                CustomText(
                  StringHelper.changeToTimeAgo(data.createdDate),
                  fontSize: CustomConsts.h7,
                  color: CustomColors.color313131.withOpacity(0.5),
                ),
              ],
            ),
          ),
          // Content
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: data.fileUrl?.isNotEmpty == true
                        ? CachedNetworkImage(
                            width: 100.w,
                            height: 100.w,
                            fit: BoxFit.cover,
                            imageUrl: data.fileUrl ?? '',
                            placeholder: (context, url) => const CircularProgressIndicator(
                              color: CustomColors.color005AAB,
                            ),
                            errorWidget: (context, url, error) => Icon(
                              Icons.cloud_off,
                              size: 50.sp,
                              color: CustomColors.colorD9D9D9,
                            ),
                          )
                        : Icon(
                            Icons.cloud_off,
                            size: 100.w,
                            color: CustomColors.colorD9D9D9,
                          )),
                12.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        data.title ?? '${'đang cập nhật'.tr.toCapitalized()}...',
                        fontSize: CustomConsts.h5,
                        fontWeight: CustomConsts.bold,
                        maxLines: 2,
                      ),
                      8.verticalSpace,
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: Colors.grey,
                            size: 16.w,
                          ),
                          4.horizontalSpace,
                          Expanded(
                            child: CustomText(
                              data.diaDiem ?? '${'đang cập nhật'.tr.toCapitalized()}...',
                              fontSize: CustomConsts.h7,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      8.verticalSpace,
                      Row(
                        children: [
                          Icon(
                            Icons.straighten,
                            color: Colors.grey,
                            size: 16.w,
                          ),
                          4.horizontalSpace,
                          CustomText(
                            '${'diện tích'.tr.toCapitalized()}: ${data.dienTich ?? 0} hecta',
                            fontSize: CustomConsts.h7,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                      8.verticalSpace,
                      Row(
                        mainAxisAlignment:
                            (controller.trangThaiPosts.last == data.trangThai) ? MainAxisAlignment.start : MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            '${data.gia ?? 0} đ/kg',
                            fontSize: CustomConsts.h5,
                            fontWeight: CustomConsts.bold,
                            color: CustomColors.color06b252,
                          ),
                          if (controller.trangThaiPosts.last != data.trangThai)
                            ElevatedButton(
                              onPressed: () {
                                _showNegotiateDialog(data);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: CustomColors.color06b252,
                                elevation: 0,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 8.h,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                              child: CustomText(
                                'thương lượng'.tr.toCapitalized(),
                                fontSize: CustomConsts.h7,
                                color: Colors.white,
                                fontWeight: CustomConsts.bold,
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
        ],
      ),
    );
  }

  void _showNegotiateDialog(TransactionModel data) async {
    List<NegotiateModel> list = [];
    list = await controller.fetchNegotiateList(data.documentId);
    controller.userModel.value.userRole == "NONG_DAN"
        ? CustomReusableMbs(
            context: Get.context!,
            title: 'thương lượng giá'.tr.toCapitalized(),
            height: list.isEmpty ? (.3.sh) : (.5.sh),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 15.sp),
              child: SingleChildScrollView(
                child: list.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/empty_data.png',
                            height: 110.sp,
                            width: 110.sp,
                            fit: BoxFit.cover,
                          ),
                        ],
                      )
                    : Column(
                        children: list.map((item) => _itemNegotiate(data.documentId, item)).toList(),
                      ),
              ),
            ),
          ).showMbs()
        : CustomReusableMbs(
            context: Get.context!,
            title: 'thương lượng giá'.tr.toCapitalized(),
            height: .5.sh,
            child: Form(
              key: negotiateFormKey,
              autovalidateMode: controller.autoValid,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 15.sp),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CustomTextField(
                        title: 'giá đề xuất (đ/kg)'.tr.toCapitalized(),
                        hint: 'nhập giá đề xuất (đ/kg)'.tr.toCapitalized(),
                        controller: controller.negotiatePriceController,
                        customInputType: CustomInputType.money,
                        required: true,
                        textInputAction: TextInputAction.done,
                      ),
                      15.verticalSpace,
                      CustomTextField(
                        title: 'ghi chú'.tr.toCapitalized(),
                        hint: 'nhập ghi chú'.tr.toCapitalized(),
                        controller: controller.negotiateNoteController,
                        customInputType: CustomInputType.text,
                        minLines: 5,
                        textInputAction: TextInputAction.done,
                      ),
                      15.verticalSpace,
                      MaterialButton(
                        onPressed: () async {
                          if (negotiateFormKey.currentState?.validate() == true) {
                            await controller.funPostNegotiate(data.documentId);
                          } else {
                            DialogUtil.catchException(msg: "chưa nhập đầy đủ thông tin".tr.toCapitalized());
                          }
                        },
                        color: CustomColors.colorFC6B68,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.sp),
                        ),
                        child: CustomText(
                          'thương lượng'.tr.toCapitalized(),
                          color: CustomColors.colorFFFFFF,
                          fontSize: CustomConsts.h4,
                          fontWeight: CustomConsts.medium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ).showMbs();
  }

  Widget _itemNegotiate(String? parent, NegotiateModel data) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with status
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade100,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: CustomColors.color06b252.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: CustomText(
                    "Email: ${data.email ?? ""}",
                    fontSize: CustomConsts.h7,
                    color: CustomColors.color06b252,
                    fontWeight: CustomConsts.bold,
                  ),
                ),
                CustomText(
                  StringHelper.changeToTimeAgo(data.createdDate),
                  fontSize: CustomConsts.h7,
                  color: CustomColors.color313131.withOpacity(0.5),
                ),
              ],
            ),
          ),
          // Content
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  '${'giá'.tr.toCapitalized()}: ${data.gia ?? 0} đ/kg',
                  fontSize: CustomConsts.h5,
                  fontWeight: CustomConsts.bold,
                  color: CustomColors.color06b252,
                ),
                8.verticalSpace,
                CustomText(
                  "${'ghi chú'.tr.toCapitalized()}: ${data.note ?? ""}",
                  fontSize: CustomConsts.h7,
                  color: Colors.grey,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await controller.funCoreNegotiateDone(parent, data.documentId);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CustomColors.color06b252,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: CustomText(
                        'chốt giá'.tr.toCapitalized(),
                        fontSize: CustomConsts.h7,
                        color: Colors.white,
                        fontWeight: CustomConsts.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
