import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:srs_common/srs_common.dart';
import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_disease/srs_disease.dart';

class DiseaseBody extends GetView<DiseaseController> {
  const DiseaseBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => controller.loadDiagnosisHistory(),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              _buildHeader(),
              _buildContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            CustomColors.color06b252,
            CustomColors.color06b252.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
        boxShadow: [
          BoxShadow(
            color: CustomColors.color06b252.withOpacity(0.2),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderTop(),
            20.verticalSpace,
            _buildHeaderInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderTop() {
    return Row(
      children: [
        IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 20.w,
          ),
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
        ),
        12.horizontalSpace,
        _buildHeaderIcon(),
        12.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                'AI Nông Nghiệp',
                fontSize: CustomConsts.h6,
                color: Colors.white.withOpacity(0.9),
              ),
              CustomText(
                'Chẩn đoán Bệnh Lúa',
                fontSize: CustomConsts.h3,
                fontWeight: CustomConsts.bold,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderIcon() {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Icon(
        Icons.agriculture_outlined,
        color: Colors.white,
        size: 24.w,
      ),
    );
  }

  Widget _buildHeaderInfo() {
    return Container(
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: Colors.white,
            size: 20.w,
          ),
          10.horizontalSpace,
          Expanded(
            child: CustomText(
              'Chụp ảnh hoặc tải lên hình ảnh lá lúa để phân tích',
              fontSize: CustomConsts.h6,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Column(
        children: [
          _buildMainActions(),
          20.verticalSpace,
          _buildHistory(),
        ],
      ),
    );
  }

  Widget _buildMainActions() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _ActionButton(
            icon: Icons.camera_alt,
            title: 'Chụp ảnh lá lúa',
            subtitle: 'Mở camera để chụp ảnh',
            onTap: () => controller.openCamera(),
            showBorder: true,
          ),
          _ActionButton(
            icon: Icons.photo_library,
            title: 'Tải ảnh lên',
            subtitle: 'Chọn ảnh từ thư viện',
            onTap: () => controller.pickImage(),
            showBorder: false,
          ),
        ],
      ),
    );
  }

  Widget _buildHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHistoryHeader(),
        15.verticalSpace,
        Obx(() {
          if (controller.diagnosisHistory.isEmpty) {
            return _buildEmptyHistory();
          }
          return _buildHistoryList();
        }),
      ],
    );
  }

  Widget _buildHistoryHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: CustomColors.color06b252.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.history,
              color: CustomColors.color06b252,
              size: 20.w,
            ),
          ),
          10.horizontalSpace,
          CustomText(
            'Lịch sử chẩn đoán',
            fontSize: CustomConsts.h4,
            fontWeight: CustomConsts.bold,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyHistory() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(30.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.history,
            size: 64.w,
            color: CustomColors.color313131.withOpacity(0.2),
          ),
          10.verticalSpace,
          CustomText(
            'Chưa có lịch sử chẩn đoán',
            fontSize: CustomConsts.h5,
            color: CustomColors.color313131.withOpacity(0.5),
          ),
          5.verticalSpace,
          CustomText(
            'Hãy chụp ảnh hoặc tải lên hình ảnh để bắt đầu',
            fontSize: CustomConsts.h6,
            color: CustomColors.color313131.withOpacity(0.3),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: controller.diagnosisHistory.length,
      itemBuilder: (context, index) {
        final diagnosis = controller.diagnosisHistory[index];
        return _buildHistoryItem(diagnosis);
      },
    );
  }

  Widget _buildHistoryItem(DiagnosisResult diagnosis) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 5.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => controller.showDiagnosisDetail(diagnosis),
        borderRadius: BorderRadius.circular(15.r),
        child: Padding(
          padding: EdgeInsets.all(15.w),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Image.asset(
                    diagnosis.imagePath,
                    width: 70.w,
                    height: 70.w,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              15.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                            '${(diagnosis.confidence * 100).toStringAsFixed(0)}%',
                            fontSize: CustomConsts.h7,
                            color: CustomColors.color06b252,
                            fontWeight: CustomConsts.bold,
                          ),
                        ),
                        8.horizontalSpace,
                        Expanded(
                          child: CustomText(
                            diagnosis.diseaseName,
                            fontSize: CustomConsts.h5,
                            fontWeight: CustomConsts.bold,
                          ),
                        ),
                      ],
                    ),
                    8.verticalSpace,
                    CustomText(
                      diagnosis.description,
                      fontSize: CustomConsts.h6,
                      color: CustomColors.color313131.withOpacity(0.7),
                      maxLines: 2,
                    ),
                    8.verticalSpace,
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14.w,
                          color: CustomColors.color313131.withOpacity(0.5),
                        ),
                        5.horizontalSpace,
                        CustomText(
                          DateFormat('dd/MM/yyyy HH:mm').format(diagnosis.timestamp),
                          fontSize: CustomConsts.h7,
                          color: CustomColors.color313131.withOpacity(0.5),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: CustomColors.color06b252.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.arrow_forward,
                  color: CustomColors.color06b252,
                  size: 16.w,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool showBorder;

  const _ActionButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.showBorder,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          border: showBorder
              ? Border(
                  bottom: BorderSide(
                    color: Colors.grey.withOpacity(0.1),
                    width: 1,
                  ),
                )
              : null,
        ),
        child: Row(
          children: [
            _buildIcon(),
            15.horizontalSpace,
            _buildContent(),
            _buildArrow(),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: CustomColors.color06b252.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Icon(
        icon,
        color: CustomColors.color06b252,
        size: 24.w,
      ),
    );
  }

  Widget _buildContent() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            title,
            fontSize: CustomConsts.h4,
            fontWeight: CustomConsts.bold,
          ),
          5.verticalSpace,
          CustomText(
            subtitle,
            fontSize: CustomConsts.h6,
            color: CustomColors.color313131.withOpacity(0.7),
          ),
        ],
      ),
    );
  }

  Widget _buildArrow() {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: CustomColors.color06b252.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Icon(
        Icons.arrow_forward,
        color: CustomColors.color06b252,
        size: 16.w,
      ),
    );
  }
}
