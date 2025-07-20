import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:srs_common/srs_common.dart';
import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_transaction/srs_transaction.dart';

class TransactionBody extends GetView<TransactionController> {
  TransactionBody({Key? key}) : super(key: key);

  final addFormKey = GlobalKey<FormState>();
  final negotiateFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          _buildSearchBar(context),
          Expanded(
            child: Obx(() {
              return _buildTransactions(context);
            }),
          )
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    'sàn giao dịch nông sản'.tr.toCapitalized(),
                    fontSize: CustomConsts.h3,
                    fontWeight: CustomConsts.bold,
                  ),
                  5.verticalSpace,
                  CustomText(
                    'kết nối nông dân và thương lái'.tr.toCapitalized(),
                    fontSize: CustomConsts.h6,
                    color: CustomColors.color313131.withOpacity(0.7),
                  ),
                ],
              ),
            ],
          ),
          15.verticalSpace,
          Obx(() {
            return Row(
              children: [
                _buildStatCard(
                  'đang chờ xử lý'.tr.toCapitalized(),
                  (controller.counts[controller.trangThaiPosts.first] ?? 0).toString(),
                  Icons.pending_outlined,
                  Colors.orange,
                ),
                10.horizontalSpace,
                _buildStatCard(
                  'đã hoàn thành'.tr.toCapitalized(),
                  (controller.counts[controller.trangThaiPosts.last] ?? 0).toString(),
                  Icons.check_circle_outline,
                  CustomColors.color06b252,
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String count, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(15.w),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(icon, color: color, size: 20.w),
            ),
            10.horizontalSpace,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  title,
                  fontSize: CustomConsts.h7,
                  color: color,
                ),
                5.verticalSpace,
                CustomText(
                  count,
                  fontSize: CustomConsts.h4,
                  fontWeight: CustomConsts.bold,
                  color: color,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: CustomTextField(
              titleEnabled: false,
              hint: '${'tìm kiếm nông sản'.tr.toCapitalized()}...',
              prefixIcon: Icon(
                Icons.search,
                color: CustomColors.color313131.withOpacity(0.5),
              ),
              suffixIcon: IconButton(
                onPressed: () async {
                  Get.toNamed(AllRoute.searchRoute)?.then((value) async {});
                },
                icon: const Icon(
                  Icons.content_paste_search_rounded,
                  color: CustomColors.color06b252,
                ),
              ),
              controller: controller.searchController,
            ),
          ),
          Obx(() {
            //Chỉ hiển thị FAB nếu user là nông dân
            if (controller.userModel.value.userRole == "NONG_DAN") {
              return Row(
                children: [
                  5.horizontalSpace,
                  ElevatedButton(
                    onPressed: () => _showAdd(context),
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
                      'đăng tin'.tr.toCapitalized(),
                      color: Colors.white,
                      fontSize: CustomConsts.h6,
                      fontWeight: CustomConsts.bold,
                    ),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          })
        ],
      ),
    );
  }

  void _showAdd(BuildContext context) {
    CustomReusableMbs(
      context: context,
      title: 'đăng tin bán nông sản'.tr.toCapitalized(),
      height: .8.sh,
      child: Form(
        key: addFormKey,
        autovalidateMode: controller.autoValid,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 15.sp),
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomTextField(
                  title: 'tiêu đề'.tr.toCapitalized(),
                  hint: 'nhập tiêu đề'.tr.toCapitalized(),
                  controller: controller.addTitleController,
                  customInputType: CustomInputType.text,
                  required: true,
                  textInputAction: TextInputAction.done,
                ),
                15.verticalSpace,
                CustomTextField(
                  title: 'mô tả chi tiết'.tr.toCapitalized(),
                  hint: 'nhập mô tả chi tiết'.tr.toCapitalized(),
                  controller: controller.addDescriptionController,
                  customInputType: CustomInputType.text,
                  required: true,
                  textInputAction: TextInputAction.done,
                ),
                15.verticalSpace,
                CustomTextField(
                  title: 'diện tích (ha)'.tr.toCapitalized(),
                  hint: 'nhập diện tích (ha)'.tr.toCapitalized(),
                  controller: controller.addAreaController,
                  customInputType: CustomInputType.double,
                  required: true,
                  textInputAction: TextInputAction.done,
                ),
                15.verticalSpace,
                CustomTextField(
                  title: 'giá (đ/kg)'.tr.toCapitalized(),
                  hint: 'nhập giá'.tr.toCapitalized(),
                  controller: controller.addPriceController,
                  customInputType: CustomInputType.money,
                  required: true,
                  textInputAction: TextInputAction.done,
                ),
                15.verticalSpace,
                CustomTextField(
                  title: 'giống lúa'.tr.toCapitalized(),
                  hint: 'nhập giống lúa'.tr.toCapitalized(),
                  controller: controller.addRiceTypeController,
                  customInputType: CustomInputType.text,
                  required: true,
                  textInputAction: TextInputAction.done,
                ),
                15.verticalSpace,
                CustomTextField(
                  title: 'địa điểm'.tr.toCapitalized(),
                  hint: 'nhập địa điểm'.tr.toCapitalized(),
                  controller: controller.addLocationController,
                  customInputType: CustomInputType.text,
                  required: true,
                  textInputAction: TextInputAction.done,
                ),
                15.verticalSpace,
                CustomTextField(
                  title: 'ngày gieo sạ'.tr.toCapitalized(),
                  hint: 'chọn ngày gieo sạ'.tr.toCapitalized(),
                  readOnly: true,
                  required: true,
                  controller: controller.addSowingDateController,
                  customInputType: CustomInputType.text,
                  prefixIcon: const Icon(Icons.calendar_month_rounded),
                  suffixIcon: IconButton(
                    onPressed: () => _selectDate(typeDate: "GIEO_SA"),
                    icon: const Icon(
                      Icons.expand_more_rounded,
                      color: CustomColors.color06b252,
                    ),
                  ),
                  textInputAction: TextInputAction.done,
                ),
                15.verticalSpace,
                CustomTextField(
                  title: 'ngày thu hoạch'.tr.toCapitalized(),
                  hint: 'chọn ngày thu hoạch'.tr.toCapitalized(),
                  readOnly: true,
                  required: true,
                  controller: controller.addHarvestDateController,
                  customInputType: CustomInputType.text,
                  prefixIcon: const Icon(Icons.calendar_month_rounded),
                  suffixIcon: IconButton(
                    onPressed: () => _selectDate(typeDate: "THU_HOACH"),
                    icon: const Icon(
                      Icons.expand_more_rounded,
                      color: CustomColors.color06b252,
                    ),
                  ),
                  textInputAction: TextInputAction.done,
                ),
                15.verticalSpace,
                MaterialButton(
                  onPressed: () {
                    _bottomSheetShowCameraOrGallery(context, onTapCamera: () async {
                      await controller.funPickImage(ImageSource.camera).then((value) {
                        Get.back();
                      });
                    }, onTapGallery: () async {
                      await controller.funPickImage(ImageSource.gallery).then((value) {
                        Get.back();
                      });
                    });
                  },
                  color: CustomColors.color06b252,
                  disabledColor: CustomColors.color8B8B8B,
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.sp),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 5.sp),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.add,
                        color: CustomColors.colorFFFFFF,
                      ),
                      5.horizontalSpace,
                      CustomText(
                        'thêm hình ảnh'.tr.toCapitalized(),
                        color: CustomColors.colorFFFFFF,
                        fontWeight: CustomConsts.bold,
                      ),
                    ],
                  ),
                ),
                15.verticalSpace,
                Obx(() {
                  if (controller.imageOriginalBytes.value != null) {
                    return Container(
                      padding: EdgeInsets.only(top: 5.sp),
                      child: Stack(
                        children: [
                          Container(
                            padding: EdgeInsets.all(5.sp),
                            child: Image.memory(
                              controller.imageOriginalBytes.value!,
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton(
                              onPressed: () {
                                controller.funRefreshSelect();
                              },
                              icon: const FaIcon(
                                FontAwesomeIcons.circleXmark,
                                color: CustomColors.colorFFFFFF,
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                }),
                MaterialButton(
                  onPressed: () async {
                    if (addFormKey.currentState?.validate() == true) {
                      await controller.funPostItem();
                    } else {
                      DialogUtil.catchException(msg: "chưa nhập đầy đủ thông tin".tr.toCapitalized());
                    }
                  },
                  color: CustomColors.colorFC6B68,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.sp),
                  ),
                  child: CustomText(
                    'đăng tin'.tr.toCapitalized(),
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

  Widget _buildTransactions(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 5.sp),
      controller: controller.scrollController,
      itemBuilder: (context, index) {
        if (index < controller.transactions.length) {
          final post = controller.transactions[index];
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
      itemCount: controller.transactions.length + (controller.hasMore ? 1 : 0),
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
                            imageUrl: data.fileUrl!,
                            width: 100.w,
                            height: 100.w,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
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

  _selectDate({required String typeDate}) async {
    RxString initDate = DateFormat('dd-MM-yyyy').format(DateTime.now()).obs;

    switch (typeDate) {
      case "GIEO_SA":
        if (controller.addSowingDateController.text.isNotEmpty) {
          initDate.value = controller.addSowingDateController.text;
        }

        DateTime? pickedDate = await showDatePicker(
            initialEntryMode: DatePickerEntryMode.calendar,
            errorFormatText: 'định dạng ngày dd/MM/yyyy'.tr.toCapitalized(),
            errorInvalidText: "ngày phải là số".tr.toCapitalized(),
            fieldLabelText: "nhập ngày".tr.toCapitalized(),
            confirmText: "đồng ý".tr.toCapitalized(),
            cancelText: "huỷ".tr.toCapitalized(),
            helpText: "chọn ngày".tr.toCapitalized(),
            context: Get.context!,
            initialDate: DateFormat('dd-MM-yyyy').parse(initDate.value),
            firstDate: DateTime(1900),
            locale: const Locale('vi', 'VN'),
            fieldHintText: 'dd/mm/yyyy',
            lastDate: DateTime.now());

        if (pickedDate != null) {
          String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
          controller.addSowingDateController.text = formattedDate;
          controller.addSowingDateString.value = DateFormat("yyyy-MM-dd HH:mm:ss:SSS").format(pickedDate);
        }
        break;
      case "THU_HOACH":
        if (controller.addHarvestDateController.text.isNotEmpty) {
          initDate.value = controller.addHarvestDateController.text;
        }

        DateTime? pickedDate = await showDatePicker(
            initialEntryMode: DatePickerEntryMode.calendar,
            errorFormatText: 'định dạng ngày dd/MM/yyyy'.tr.toCapitalized(),
            errorInvalidText: "ngày phải là số".tr.toCapitalized(),
            fieldLabelText: "nhập ngày".tr.toCapitalized(),
            confirmText: "đồng ý".tr.toCapitalized(),
            cancelText: "huỷ".tr.toCapitalized(),
            helpText: "chọn ngày".tr.toCapitalized(),
            context: Get.context!,
            initialDate: DateFormat('dd-MM-yyyy').parse(initDate.value),
            firstDate: DateTime(1900),
            locale: const Locale('vi', 'VN'),
            fieldHintText: 'dd/mm/yyyy',
            lastDate: DateTime(DateTime.now().year + 100));

        if (pickedDate != null) {
          String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
          controller.addHarvestDateController.text = formattedDate;
          controller.addHarvestDateString.value = DateFormat("yyyy-MM-dd HH:mm:ss:SSS").format(pickedDate);
        }
        break;
    }
  }

  _bottomSheetShowCameraOrGallery(
    BuildContext context, {
    Function? onTapCamera,
    Function? onTapGallery,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10),
          topLeft: Radius.circular(10),
        ),
      ),
      isScrollControlled: true,
      enableDrag: true,
      useSafeArea: true,
      builder: (c) {
        return Container(
          height: 100.sp,
          width: 1.sw,
          margin: EdgeInsets.all(20.sp),
          child: Column(
            children: [
              Text(
                'chọn hình ảnh'.tr.toCapitalized(),
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: CustomColors.color005AAB,
                ),
              ),
              SizedBox(height: 5.sp),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () async {
                        await onTapCamera?.call();
                      },
                      icon: Row(
                        children: [
                          Icon(
                            Icons.camera_alt_rounded,
                            size: 25.sp,
                          ),
                          5.horizontalSpace,
                          Text(
                            'máy ảnh'.tr.toCapitalized(),
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        await onTapGallery?.call();
                      },
                      icon: Row(
                        children: [
                          Icon(
                            Icons.image,
                            size: 25.sp,
                          ),
                          5.horizontalSpace,
                          Text(
                            'thư viện'.tr.toCapitalized(),
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
