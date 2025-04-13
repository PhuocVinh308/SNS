import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_asxh/module/common/common.dart';
import 'package:flutter_asxh/module/dashboard_hgi/dashboard_hgi.dart';
import 'package:flutter_asxh/module/ho_trung_binh_hgi/ho_trung_binh_hgi.dart';
import 'package:flutter_asxh/module/notification_hgi/notification_hgi.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class NotificationHgiPage extends GetView<NotificationHgiController> {
  final notificationController = Get.put(NotificationHgiController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.color_FFFFFF,
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(Get.height * .1),
        child: Container(
          decoration: BoxDecoration(color: CustomColors.color_005AAB, boxShadow: [
            BoxShadow(
              color: CustomColors.color_005AAB,
              offset: Offset(0, 4),
            ),
          ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Text(
                        'Thông báo'.tr.toUpperCase(),
                        style: GoogleFonts.roboto(
                          color: CustomColors.color_FFFFFF,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) => Obx(() {
          return Column(
            children: [
              _widgetBody(orientation),
            ],
          );
        }),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     notificationController.nguoiDanSendToSelf(
      //       tieuDe: "Phiếu đề nghị Hộ có mức sống trung bình".tr,
      //       noiDung: "Phiếu đề nghị được tạo lại thành công!".tr,
      //       listUuidNguoiDan: DashboardHgiUtil.getHgiUserInfo.uuidNguoiDung,
      //       huyenTao: DashboardHgiUtil.getHgiUserInfo.maHuyenDk,
      //       xaTao: DashboardHgiUtil.getHgiUserInfo.maXaDk,
      //       apTao: DashboardHgiUtil.getHgiUserInfo.maThonDk,
      //       // huyenThuongTru: controller.dataCopy.value.maHuyen,
      //       // xaThuongTru: controller.dataCopy.value.maXa,
      //       // apThuongTru: controller.dataCopy.value.maThon,
      //     );
      //   },
      // ),
    );
  }

  Widget _widgetBody(Orientation orientation) {
    return Expanded(
      child: DataLoadingCheckPage(
        isLoading: controller.isLoadingPage.value,
        isLoadedFailed: controller.isLoadedFailed.value,
        onPressed: () {
          controller.onInit();
        },
        child: controller.documentSnapshotListData.isEmpty
            ? EmptyData()
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: RefreshIndicator(
                  onRefresh: () async => await controller.onRefresh(),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: controller.documentSnapshotListData.length,
                    itemBuilder: (context, index) {
                      final data = controller.documentSnapshotListData[index];
                      return _itemNotification(data);
                    },
                    separatorBuilder: (BuildContext context, int index) => SizedBox(height: 20),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _itemNotification(DocumentSnapshot<Object?> data) {
    return Container(
      decoration: BoxDecoration(
        color: CustomColors.color_FFFFFF,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: CustomColors.color_313131.withOpacity(.3),
            blurRadius: 4,
            offset: Offset(0, 0),
          ),
        ],
        border: Border.all(
          color: CustomColors.color_313131.withOpacity(.3),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: CustomColors.color_005AAB.withOpacity(.3),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/hgi_htb_notification.png',
                        height: 30,
                        width: 30,
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          'Thông báo'.tr,
                          style: GoogleFonts.roboto(
                            color: CustomColors.color_000000,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                    ],
                  ),
                ),
                SizedBox(width: 5),
              ],
            ),
          ),
          Column(
            children: [
              SizedBox(height: 5),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.edit_notifications_outlined,
                      size: 25,
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        'Tiêu đề'.tr + ': ' + (data['tieuDe'] ?? 'Đang cập nhật'.tr),
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.content_paste_rounded,
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        'Nội dung'.tr + ': ' + (data['noiDung'] ?? 'Đang cập nhật'.tr),
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.date_range_rounded,
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        'Ngày gửi'.tr + ': ' + (_formatDate(data['ngayTao'] ?? null)),
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
            ],
          )
        ],
      ),
    );
  }

  String _formatDate(dynamic birthday) {
    if (birthday == null) return 'Đang cập nhật'.tr;
    if (GetUtils.isNumericOnly(birthday)) {
      return '01-01-$birthday';
    } else if (!GetUtils.isNumericOnly(birthday) && birthday.isNotEmpty) {
      if (birthday.trim().length <= 7) return '$birthday';
      return DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.parse(birthday));
    } else {
      return 'Đang cập nhật'.tr;
    }
  }
}
