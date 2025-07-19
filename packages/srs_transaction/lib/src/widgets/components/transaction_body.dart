import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:srs_common/srs_common.dart';
import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_transaction/srs_transaction.dart';

class TransactionBody extends GetView<TransactionController> {
  TransactionBody({Key? key}) : super(key: key);

  final addFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          _buildSearchBar(),
          Expanded(
            child: CustomScrollView(
              slivers: [
                _buildTransactionList(),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAdd(context),
        backgroundColor: CustomColors.color06b252,
        child: const Icon(Icons.add, color: Colors.white),
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
          Row(
            children: [
              _buildStatCard(
                'đang chờ xử lý'.tr.toCapitalized(),
                '05',
                Icons.pending_outlined,
                Colors.orange,
              ),
              10.horizontalSpace,
              _buildStatCard(
                'đã hoàn thành'.tr.toCapitalized(),
                '12',
                Icons.check_circle_outline,
                CustomColors.color06b252,
              ),
            ],
          ),
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

  Widget _buildSearchBar() {
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
      child: CustomTextField(
        titleEnabled: false,
        hint: '${'tìm kiếm nông sản'.tr.toCapitalized()}...',
        prefixIcon: Icon(
          Icons.search,
          color: CustomColors.color313131.withOpacity(0.5),
        ),
        suffixIcon: IconButton(
          onPressed: () => _showFilterDialog(),
          icon: const Icon(
            Icons.filter_list,
            color: CustomColors.color06b252,
          ),
        ),
        controller: controller.searchController,
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

  Widget _buildTransactionList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => _buildTransactionItem(),
        childCount: 10,
      ),
    );
  }

  Widget _buildTransactionItem() {
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
                        'đang bán'.tr.toCapitalized(),
                        fontSize: CustomConsts.h7,
                        color: CustomColors.color06b252,
                        fontWeight: CustomConsts.bold,
                      ),
                    ),
                    8.horizontalSpace,
                    Icon(
                      Icons.verified,
                      color: CustomColors.color06b252,
                      size: 16.w,
                    ),
                    4.horizontalSpace,
                    CustomText(
                      'đã xác thực'.tr.toCapitalized(),
                      fontSize: CustomConsts.h7,
                      color: CustomColors.color06b252,
                    ),
                  ],
                ),
                CustomText(
                  StringHelper.changeToTimeAgo("2025-07-18 23:16:42:953"),
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
                  child: Image.network(
                    'https://example.com/rice.jpg',
                    width: 100.w,
                    height: 100.w,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 100.w,
                        height: 100.w,
                        color: Colors.grey.shade200,
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
                12.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        'Lúa ST25 - Đặc sản Sóc Trăng',
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
                              'Huyện Mỹ Xuyên, Sóc Trăng',
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
                            'Diện tích: 2 hecta',
                            fontSize: CustomConsts.h7,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                      8.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            '6.500đ/kg',
                            fontSize: CustomConsts.h5,
                            fontWeight: CustomConsts.bold,
                            color: CustomColors.color06b252,
                          ),
                          ElevatedButton(
                            onPressed: () => _showNegotiateDialog(),
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
                              'Thương lượng',
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

  void _showFilterDialog() {
    final minPriceController = TextEditingController();
    final maxPriceController = TextEditingController();
    String? selectedLocation;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Container(
          width: Get.width * 0.9,
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    'lọc kết quả'.tr.toCapitalized(),
                    fontSize: CustomConsts.h4,
                    fontWeight: CustomConsts.bold,
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              20.verticalSpace,
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: minPriceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'giá từ'.tr.toCapitalized(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                  ),
                  10.horizontalSpace,
                  Expanded(
                    child: TextField(
                      controller: maxPriceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'đến'.tr.toCapitalized(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              15.verticalSpace,
              DropdownButtonFormField<String>(
                value: selectedLocation,
                decoration: InputDecoration(
                  labelText: 'khu vực'.tr.toCapitalized(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                items: [
                  DropdownMenuItem(
                    value: null,
                    child: Text('tất cả'.tr.toCapitalized()),
                  ),
                  // Add more locations
                ],
                onChanged: (value) {
                  selectedLocation = value;
                },
              ),
              20.verticalSpace,
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        controller.clearFilters();
                        Get.back();
                      },
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: CustomText('đặt lại'.tr.toCapitalized()),
                    ),
                  ),
                  10.horizontalSpace,
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        controller.setPriceRange(
                          double.tryParse(minPriceController.text),
                          double.tryParse(maxPriceController.text),
                        );
                        controller.setLocation(selectedLocation);
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CustomColors.color06b252,
                        padding: EdgeInsets.symmetric(vertical: 15.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: CustomText(
                        'áp dụng'.tr.toCapitalized(),
                        color: Colors.white,
                        fontWeight: CustomConsts.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showNegotiateDialog() {
    final priceController = TextEditingController();
    final noteController = TextEditingController();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Container(
          width: Get.width * 0.9,
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    'thương lượng giá'.tr.toCapitalized(),
                    fontSize: CustomConsts.h4,
                    fontWeight: CustomConsts.bold,
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              20.verticalSpace,
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'giá đề xuất (đ/kg)'.tr.toCapitalized(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
              15.verticalSpace,
              TextField(
                controller: noteController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'ghi chú'.tr.toCapitalized(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
              20.verticalSpace,
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (priceController.text.isNotEmpty) {
                      controller.sendNegotiation(
                        'transactionId', // Replace with actual ID
                        double.parse(priceController.text),
                        noteController.text,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.color06b252,
                    padding: EdgeInsets.symmetric(vertical: 15.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: CustomText(
                    'gửi đề xuất',
                    color: Colors.white,
                    fontWeight: CustomConsts.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
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
}
