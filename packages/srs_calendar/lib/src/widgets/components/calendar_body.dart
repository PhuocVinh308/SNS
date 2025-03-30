import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:srs_common/srs_common.dart';
import 'package:srs_common/srs_common_lib.dart';
import '../../controllers/calendar_controller.dart';

class CalendarBody extends GetView<CalendarController> {
  const CalendarBody({Key? key}) : super(key: key);

@override
Widget build(BuildContext context) {
  return Stack(
    children: [
      Obx(() => controller.timelineEvents.isEmpty
          ? _buildEmptyState()
          : controller.showTimeline.value
              ? _buildTimelineView()
              : _buildSetupView(),
      ),
    ],
  );
}



  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 80.w,
            color: CustomColors.color06b252.withOpacity(0.5),
          ),
          20.verticalSpace,
          CustomText(
            'Chưa có lịch thời vụ, vui lòng cấu hình thông tin giống lúa'.tr,
            textAlign: TextAlign.center,
            fontSize: CustomConsts.h5,
            color: CustomColors.color313131.withOpacity(0.7),
          ),
          30.verticalSpace,
       ElevatedButton.icon(
  onPressed: () => controller.showTimeline.value = false,
  icon: Icon(Icons.add_circle_outline, color: Colors.white),
  label: Text('Thiết lập lịch thời vụ'.tr),
  style: ElevatedButton.styleFrom(
    backgroundColor: Color(0xFF06B252), // Màu xanh lá
    foregroundColor: Colors.white, // Màu chữ
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  ),
)

        ],
      ),
    );
  }

  Widget _buildSetupView() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          20.verticalSpace,      
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: CustomColors.colorFFFFFF,
              borderRadius: BorderRadius.circular(15.r),
              boxShadow: [
                BoxShadow(
                  color: CustomColors.color000000.withOpacity(0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.grass_outlined,
                      color: CustomColors.color06b252,
                      size: 24.w,
                    ),
                    10.horizontalSpace,
                    CustomText(
                      'Chọn giống lúa'.tr,
                      fontSize: CustomConsts.h5,
                      fontWeight: CustomConsts.bold,
                    ),
                  ],
                ),
                15.verticalSpace,
                _buildRiceVarietyDropdown(),
                25.verticalSpace,
                Row(
                  children: [
                    Icon(
                      Icons.event_outlined,
                      color: CustomColors.color06b252,
                      size: 24.w,
                    ),
                    10.horizontalSpace,
                    CustomText(
                      'Ngày gieo sạ'.tr,
                      fontSize: CustomConsts.h5,
                      fontWeight: CustomConsts.bold,
                    ),
                  ],
                ),
                15.verticalSpace,
                _buildDatePicker(),
                30.verticalSpace,
                SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed: () {
                      controller.createTimeline();
                      controller.showTimeline.value = true;
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColors.color06b252,
                      foregroundColor: CustomColors.colorFFFFFF,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.timeline_outlined, size: 24.w),
                        10.horizontalSpace,
                        Text(
                          'Tạo lịch thời vụ'.tr,
                          style: TextStyle(
                            fontSize: CustomConsts.h5,
                            fontWeight: CustomConsts.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineView() {
    return CustomScrollView(
      physics: BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            margin: EdgeInsets.all(20.w),
            padding: EdgeInsets.all(15.w),
            decoration: BoxDecoration(
              color: CustomColors.colorFFFFFF,
              borderRadius: BorderRadius.circular(15.r),
              boxShadow: [
                BoxShadow(
                  color: CustomColors.color000000.withOpacity(0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: CustomColors.color06b252.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Icons.eco_outlined,
                        color: CustomColors.color06b252,
                        size: 24.w,
                      ),
                    ),
                    15.horizontalSpace,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            controller.selectedVariety.value ?? '',
                            fontSize: CustomConsts.h4,
                            fontWeight: CustomConsts.bold,
                          ),
                          5.verticalSpace,
                          CustomText(
                            'Giống lúa đang canh tác'.tr,
                            fontSize: CustomConsts.h6,
                            color: CustomColors.color313131.withOpacity(0.7),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () => controller.showTimeline.value = false,
                      borderRadius: BorderRadius.circular(12.r),
                      child: Container(
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          color: CustomColors.color06b252.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(
                          Icons.settings_outlined,
                          color: CustomColors.color06b252,
                          size: 24.w,
                        ),
                      ),
                    ),
                  ],
                ),
                15.verticalSpace,
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: CustomColors.color06b252.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: CustomColors.color06b252.withOpacity(0.1),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        color: CustomColors.color06b252,
                        size: 20.w,
                      ),
                      10.horizontalSpace,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            'Ngày gieo sạ'.tr,
                            fontSize: CustomConsts.h7,
                            color: CustomColors.color313131.withOpacity(0.7),
                          ),
                          3.verticalSpace,
                          CustomText(
                            DateFormat('dd/MM/yyyy').format(controller.sowingDate.value),
                            fontSize: CustomConsts.h6,
                            fontWeight: CustomConsts.bold,
                            color: CustomColors.color06b252,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: [
                Container(
                  width: 4.w,
                  height: 20.h,
                  decoration: BoxDecoration(
                    color: CustomColors.color06b252,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                10.horizontalSpace,
                CustomText(
                  'Các giai đoạn'.tr,
                  fontSize: CustomConsts.h5,
                  fontWeight: CustomConsts.bold,
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final event = controller.timelineEvents[index];
                final isCurrentEvent = controller.isCurrentEvent(event['date']);
                if (index != controller.timelineEvents.length - 1) {
                  return Column(
                    children: [
                      _buildTimelineItem(event, isCurrentEvent),
                      Container(
                        margin: EdgeInsets.only(left: 30.w),
                        height: 30.h,
                        width: 2.w,
                        color: CustomColors.color06b252.withOpacity(0.3),
                      ),
                    ],
                  );
                }
                return _buildTimelineItem(event, isCurrentEvent);
              },
              childCount: controller.timelineEvents.length,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRiceVarietyDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      decoration: BoxDecoration(
        border: Border.all(color: CustomColors.color06b252),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Obx(() => DropdownButton<String>(
        value: controller.selectedVariety.value,
        isExpanded: true,
        underline: const SizedBox(),
        hint: Text('Chọn giống lúa'.tr),
        items: controller.riceVarieties.map((String variety) {
          return DropdownMenuItem<String>(
            value: variety,
            child: Text(variety),
          );
        }).toList(),
        onChanged: (value) {
          controller.onVarietySelected(value);
        },
      )),
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: Get.context!,
          initialDate: controller.sowingDate.value,
          firstDate: DateTime.now().subtract(const Duration(days: 90)),
          lastDate: DateTime.now().add(const Duration(days: 90)),
        );
        if (date != null) {
          controller.onDateSelected(date);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
        decoration: BoxDecoration(
          border: Border.all(color: CustomColors.color06b252),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            Obx(() => Text(
              DateFormat('dd/MM/yyyy').format(controller.sowingDate.value),
              style: TextStyle(fontSize: CustomConsts.h5),
            )),
            const Spacer(),
            Icon(
              Icons.calendar_today,
              color: CustomColors.color06b252,
              size: 20.w,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem(Map<String, dynamic> event, bool isCurrentEvent) {
    final isPastEvent = controller.isPastEvent(event['date']);
    final isFutureEvent = controller.isFutureEvent(event['date']);
    
    return InkWell(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.w),
        child: Stack(
          children: [
            // Dot indicator
            Positioned(
              left: 5.w,
              top: 10.h,
              child: Container(
                width: 20.w,
                height: 20.w,
                decoration: BoxDecoration(
                  color: isCurrentEvent 
                    ? CustomColors.color06b252
                    : isPastEvent
                      ? CustomColors.color313131.withOpacity(0.5)
                      : CustomColors.colorFFFFFF,
                  border: Border.all(
                    color: isCurrentEvent 
                      ? CustomColors.color06b252
                      : CustomColors.color06b252.withOpacity(0.5),
                    width: 2,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    if (isCurrentEvent)
                      BoxShadow(
                        color: CustomColors.color06b252.withOpacity(0.2),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                  ],
                ),
                child: isPastEvent
                  ? Icon(Icons.check, color: CustomColors.colorFFFFFF, size: 14.w)
                  : null,
              ),
            ),
            // Content card
            Container(
              margin: EdgeInsets.only(left: 40.w),
              child: Hero(
                tag: 'timeline_${event['stage']}',
                child: Material(
                  color: Colors.transparent,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: EdgeInsets.all(15.w),
                    decoration: BoxDecoration(
                      color: isCurrentEvent
                        ? CustomColors.color06b252.withOpacity(0.15)
                        : CustomColors.colorFFFFFF,
                      border: Border.all(
                        color: isCurrentEvent
                          ? CustomColors.color06b252
                          : CustomColors.color06b252.withOpacity(0.3),
                        width: isCurrentEvent ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: CustomColors.color000000.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                              decoration: BoxDecoration(
                                color: isCurrentEvent
                                  ? CustomColors.color06b252
                                  : CustomColors.color06b252.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (isPastEvent) Icon(
                                    Icons.check_circle,
                                    color: isCurrentEvent ? CustomColors.colorFFFFFF : CustomColors.color06b252,
                                    size: 16.w,
                                  ),
                                  if (isFutureEvent) Icon(
                                    Icons.schedule,
                                    color: isCurrentEvent ? CustomColors.colorFFFFFF : CustomColors.color06b252,
                                    size: 16.w,
                                  ),
                                  5.horizontalSpace,
                                  CustomText(
                                    event['stage'],
                                    color: isCurrentEvent ? CustomColors.colorFFFFFF : CustomColors.color06b252,
                                    fontSize: CustomConsts.h6,
                                    fontWeight: CustomConsts.bold,
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            CustomText(
                              event['date'],
                              color: isCurrentEvent ? CustomColors.color06b252 : CustomColors.color313131,
                              fontSize: CustomConsts.h6,
                              fontWeight: isCurrentEvent ? CustomConsts.bold : CustomConsts.medium,
                            ),
                          ],
                        ),
                        12.verticalSpace,
                        CustomText(
                          event['description'],
                          color: CustomColors.color313131,
                          fontSize: CustomConsts.h6,
                        ),
                        if (event['fertilizers'] != null) ...[
                          10.verticalSpace,
                          Container(
                            padding: EdgeInsets.all(10.w),
                            decoration: BoxDecoration(
                              color: CustomColors.color06b252.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.science_outlined,
                                      size: 16.w,
                                      color: CustomColors.color06b252,
                                    ),
                                    5.horizontalSpace,
                                    CustomText(
                                      'Phân bón'.tr,
                                      fontSize: CustomConsts.h7,
                                      color: CustomColors.color06b252,
                                      fontWeight: CustomConsts.medium,
                                    ),
                                  ],
                                ),
                                8.verticalSpace,
                                ...event['fertilizers'].map((fert) => Padding(
                                  padding: EdgeInsets.only(left: 5.w, bottom: 5.h),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.circle,
                                        size: 6.w,
                                        color: CustomColors.color313131.withOpacity(0.6),
                                      ),
                                      8.horizontalSpace,
                                      CustomText(
                                        '${fert['name']}: ${fert['amount']} ${fert['unit']}',
                                        color: CustomColors.color313131.withOpacity(0.8),
                                        fontSize: CustomConsts.h6,
                                      ),
                                    ],
                                  ),
                                )),
                              ],
                            ),
                          ),
                        ],
                        10.verticalSpace,
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => _showDetailDialog(event),
                            borderRadius: BorderRadius.circular(20.r),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 8.h,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  CustomText(
                                    'Xem chi tiết'.tr,
                                    fontSize: CustomConsts.h7,
                                    color: CustomColors.color06b252,
                                    fontWeight: CustomConsts.medium,
                                  ),
                                  5.horizontalSpace,
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 14.w,
                                    color: CustomColors.color06b252,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetailDialog(Map<String, dynamic> event) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Container(
          width: Get.width * 0.9,
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: CustomColors.color06b252.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.eco_outlined,
                                color: CustomColors.color06b252,
                                size: 16.w,
                              ),
                              5.horizontalSpace,
                              CustomText(
                                event['stage'],
                                color: CustomColors.color06b252,
                                fontSize: CustomConsts.h6,
                                fontWeight: CustomConsts.bold,
                              ),
                            ],
                          ),
                        ),
                        10.verticalSpace,
                        CustomText(
                          event['date'],
                          fontSize: CustomConsts.h6,
                          color: CustomColors.color313131.withOpacity(0.7),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(
                      Icons.close,
                      color: CustomColors.color313131.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
              15.verticalSpace,
              Divider(),
              15.verticalSpace,
              CustomText(
                'Mô tả'.tr,
                fontSize: CustomConsts.h5,
                fontWeight: CustomConsts.bold,
              ),
              10.verticalSpace,
              CustomText(
                event['description'],
                fontSize: CustomConsts.h6,
                color: CustomColors.color313131,
              ),
              if (event['fertilizers'] != null) ...[
                15.verticalSpace,
                CustomText(
                  'Phân bón khuyến nghị'.tr,
                  fontSize: CustomConsts.h5,
                  fontWeight: CustomConsts.bold,
                ),
                10.verticalSpace,
                Container(
                  padding: EdgeInsets.all(15.w),
                  decoration: BoxDecoration(
                    color: CustomColors.color06b252.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: CustomColors.color06b252.withOpacity(0.1),
                    ),
                  ),
                  child: Column(
                    children: [
                      ...event['fertilizers'].map((fert) => Padding(
                        padding: EdgeInsets.only(bottom: 8.h),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8.w),
                              decoration: BoxDecoration(
                                color: CustomColors.color06b252.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Icon(
                                Icons.science_outlined,
                                size: 16.w,
                                color: CustomColors.color06b252,
                              ),
                            ),
                            15.horizontalSpace,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    fert['name'],
                                    fontSize: CustomConsts.h6,
                                    fontWeight: CustomConsts.bold,
                                  ),
                                  5.verticalSpace,
                                  CustomText(
                                    '${fert['amount']} ${fert['unit']}',
                                    fontSize: CustomConsts.h6,
                                    color: CustomColors.color313131.withOpacity(0.7),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                    ],
                  ),
                ),
              ],
              20.verticalSpace,
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.color06b252,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: CustomText(
                    'Đóng'.tr,
                    fontSize: CustomConsts.h5,
                    fontWeight: CustomConsts.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

}
