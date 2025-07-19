import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../configs/all_route.dart';
import '../models/models.dart';

class DiseaseController extends GetxController {
  final diagnosisHistory = <DiagnosisResult>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadDiagnosisHistory();
  }

  Future<void> loadDiagnosisHistory() async {
    try {
      isLoading.value = true;
      // Giả lập delay load dữ liệu
      await Future.delayed(Duration(seconds: 1));

      diagnosisHistory.value = [
        DiagnosisResult(
          id: '1',
          imagePath: 'assets/images/forum.png',
          diseaseName: 'Bệnh đạo ôn',
          description: 'Bệnh đạo ôn là một trong những bệnh phổ biến nhất trên cây lúa, gây thiệt hại nghiêm trọng về năng suất.',
          confidence: 0.95,
          timestamp: DateTime.now().subtract(Duration(days: 1)),
          biologicalMeasures: [
            'Sử dụng giống lúa kháng bệnh',
            'Cân đối phân bón, tránh bón thừa đạm',
            'Vệ sinh đồng ruộng, tiêu hủy tàn dư cây bệnh'
          ],
          chemicalMeasures: ['Phun thuốc Beam 75WP', 'Sử dụng Filia 525SE', 'Phun Validacin 5L'],
          culturalMeasures: ['Điều chỉnh thời vụ hợp lý', 'Quản lý nước tốt', 'Bón phân cân đối'],
        ),
        DiagnosisResult(
          id: '2',
          imagePath: 'assets/images/forum.png',
          diseaseName: 'Rầy nâu',
          description: 'Rầy nâu là đối tượng gây hại quan trọng trên cây lúa, có khả năng gây hại trực tiếp và truyền bệnh virus.',
          confidence: 0.88,
          timestamp: DateTime.now().subtract(Duration(days: 3)),
          biologicalMeasures: [
            'Sử dụng thiên địch tự nhiên',
            'Trồng giống lúa kháng rầy',
          ],
          chemicalMeasures: [
            'Sử dụng Chess 50WG',
            'Phun Actara 25WG',
          ],
          culturalMeasures: [
            'Vệ sinh đồng ruộng',
            'Điều chỉnh mật độ gieo sạ',
          ],
        ),
        DiagnosisResult(
          id: '3',
          imagePath: 'assets/images/forum.png',
          diseaseName: 'Bệnh khô vằn',
          description: 'Bệnh khô vằn gây hại trên lúa ở các giai đoạn sinh trưởng, đặc biệt là giai đoạn đẻ nhánh và làm đòng.',
          confidence: 0.92,
          timestamp: DateTime.now().subtract(Duration(days: 5)),
          biologicalMeasures: [
            'Sử dụng nấm đối kháng Trichoderma',
            'Bón vôi để giảm độ acid của đất',
          ],
          chemicalMeasures: [
            'Phun Nativo 750WG',
            'Sử dụng Amistar Top 325SC',
          ],
          culturalMeasures: [
            'Giảm mật độ gieo sạ',
            'Tăng cường thoát nước',
          ],
        ),
      ];
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Không thể tải lịch sử chẩn đoán: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> openCamera() async {
    // Implement camera functionality
  }

  Future<void> pickImage() async {
    // Implement image picker functionality
  }

  Future<void> analyzeDiagnosis(String imagePath) async {
    // Implement AI analysis
  }

  void showDiagnosisDetail(DiagnosisResult diagnosis) {
    Get.toNamed(
      AllRouteDisease.diseaseDetailRoute,
      arguments: diagnosis,
    );
  }
}
