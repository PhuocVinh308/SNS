import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:srs_common/srs_common.dart';
import 'package:srs_common/srs_common_lib.dart';

import '../configs/all_route.dart';
import '../models/models.dart';
import '../models/disease_prediction_response.dart';
import '../services/disease_api_service.dart';
import '../widgets/components/disease_result_modal.dart';

class DiseaseController extends GetxController {
  final diagnosisHistory = <DiagnosisResult>[].obs;
  final isLoading = false.obs;
  final isAnalyzing = false.obs;
  
  final DiseaseApiService _apiService = DiseaseApiService();
  final ImagePicker _imagePicker = ImagePicker();

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

             // Tạm thời sử dụng ảnh asset cho dữ liệu mẫu
       // Khi có ảnh thực tế từ API, sẽ được thay thế
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
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 1024,
        maxHeight: 1024,
      );
      
      if (image != null) {
        await _processImage(File(image.path));
      }
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Không thể mở camera: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<void> pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1024,
        maxHeight: 1024,
      );
      
      if (image != null) {
        await _processImage(File(image.path));
      }
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Không thể chọn ảnh: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<void> _processImage(File imageFile) async {
    try {
      isAnalyzing.value = true;
      
      // Hiển thị loading dialog
      Get.dialog(
        Center(
          child: Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(CustomColors.color06b252),
                ),
                15.verticalSpace,
                CustomText(
                  'Đang phân tích ảnh...',
                  fontSize: CustomConsts.h5,
                  fontWeight: CustomConsts.bold,
                ),
              ],
            ),
          ),
        ),
        barrierDismissible: false,
      );

      // Gửi ảnh lên API
      final response = await _apiService.predictDisease(imageFile);
      final predictionResult = DiseasePredictionResponse.fromJson(response);
      
      // Đóng loading dialog
      Get.back();
      
             // Hiển thị kết quả
       if (predictionResult.success) {
         _showResultModal(predictionResult);
         // Thêm vào lịch sử
         await _addToHistory(predictionResult, imageFile.path);
       } else {
        Get.snackbar(
          'Lỗi',
          predictionResult.message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      // Đóng loading dialog
      Get.back();
      
      Get.snackbar(
        'Lỗi',
        'Không thể phân tích ảnh: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isAnalyzing.value = false;
    }
  }

  void _showResultModal(DiseasePredictionResponse result) {
    Get.dialog(
      DiseaseResultModal(
        result: result,
        onClose: () {
          // Có thể thêm logic bổ sung khi đóng modal
        },
      ),
      barrierDismissible: true,
    );
  }

  Future<void> _addToHistory(DiseasePredictionResponse result, String imagePath) async {
    try {
      // Copy ảnh vào thư mục app để có thể hiển thị trong lịch sử
      final savedImagePath = await _saveImageToAppDirectory(imagePath);
      
      // Tạo diagnosis result từ API response
      final diagnosis = DiagnosisResult(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        imagePath: savedImagePath,
        diseaseName: result.diseaseName,
        description: _getDiseaseDescription(result.diseaseName),
        confidence: result.confidence,
        timestamp: DateTime.now(),
        biologicalMeasures: _getBiologicalMeasures(result.diseaseName),
        chemicalMeasures: _getChemicalMeasures(result.diseaseName),
        culturalMeasures: _getCulturalMeasures(result.diseaseName),
      );
      
      // Thêm vào đầu danh sách
      diagnosisHistory.insert(0, diagnosis);
    } catch (e) {
      print('Lỗi khi lưu ảnh: $e');
      // Nếu không lưu được ảnh, vẫn thêm vào lịch sử với ảnh gốc
      final diagnosis = DiagnosisResult(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        imagePath: imagePath,
        diseaseName: result.diseaseName,
        description: _getDiseaseDescription(result.diseaseName),
        confidence: result.confidence,
        timestamp: DateTime.now(),
        biologicalMeasures: _getBiologicalMeasures(result.diseaseName),
        chemicalMeasures: _getChemicalMeasures(result.diseaseName),
        culturalMeasures: _getCulturalMeasures(result.diseaseName),
      );
      diagnosisHistory.insert(0, diagnosis);
    }
  }

  Future<String> _saveImageToAppDirectory(String originalImagePath) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final diseaseImagesDir = Directory('${appDir.path}/disease_images');
      
      // Tạo thư mục nếu chưa tồn tại
      if (!await diseaseImagesDir.exists()) {
        await diseaseImagesDir.create(recursive: true);
      }
      
      // Tạo tên file mới
      final fileName = 'disease_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final newImagePath = '${diseaseImagesDir.path}/$fileName';
      
      // Copy file
      final originalFile = File(originalImagePath);
      await originalFile.copy(newImagePath);
      
      return newImagePath;
    } catch (e) {
      print('Lỗi khi lưu ảnh: $e');
      return originalImagePath;
    }
  }

  String _getDiseaseDescription(String diseaseName) {
    // Map các bệnh với mô tả tương ứng
    final descriptions = {
      'Bacterial Leaf Blight': 'Bệnh cháy bìa lá do vi khuẩn, gây hại nghiêm trọng trên cây lúa, đặc biệt trong điều kiện thời tiết ẩm ướt.',
      'Brown Spot': 'Bệnh đốm nâu, gây hại trên lá và hạt lúa, làm giảm năng suất và chất lượng gạo.',
      'Leaf Blast': 'Bệnh đạo ôn, một trong những bệnh nguy hiểm nhất trên cây lúa, có thể gây mất trắng.',
      'Tungro': 'Bệnh vàng lùn xoắn lá, do virus gây ra, làm cây lúa còi cọc và giảm năng suất.',
    };
    
    return descriptions[diseaseName] ?? 'Bệnh phát hiện trên cây lúa cần được theo dõi và xử lý kịp thời.';
  }

  List<String> _getBiologicalMeasures(String diseaseName) {
    // Map các biện pháp sinh học cho từng bệnh
    final measures = {
      'Bacterial Leaf Blight': [
        'Sử dụng giống lúa kháng bệnh',
        'Cân đối phân bón, tránh bón thừa đạm',
        'Vệ sinh đồng ruộng, tiêu hủy tàn dư cây bệnh'
      ],
      'Brown Spot': [
        'Sử dụng giống lúa kháng bệnh',
        'Bón phân cân đối NPK',
        'Tăng cường bón phân hữu cơ'
      ],
      'Leaf Blast': [
        'Sử dụng giống lúa kháng đạo ôn',
        'Cân đối phân bón, tránh bón thừa đạm',
        'Vệ sinh đồng ruộng, tiêu hủy tàn dư cây bệnh'
      ],
      'Tungro': [
        'Sử dụng giống lúa kháng virus',
        'Diệt trừ rầy xanh - môi giới truyền bệnh',
        'Vệ sinh đồng ruộng'
      ],
    };
    
    return measures[diseaseName] ?? [
      'Sử dụng giống lúa kháng bệnh',
      'Cân đối phân bón',
      'Vệ sinh đồng ruộng'
    ];
  }

  List<String> _getChemicalMeasures(String diseaseName) {
    // Map các biện pháp hóa học cho từng bệnh
    final measures = {
      'Bacterial Leaf Blight': [
        'Phun thuốc Kasumin 2L',
        'Sử dụng Xanthomix 20WP',
        'Phun Streptomycin'
      ],
      'Brown Spot': [
        'Phun thuốc Tilt 250EC',
        'Sử dụng Nativo 750WG',
        'Phun Score 250EC'
      ],
      'Leaf Blast': [
        'Phun thuốc Beam 75WP',
        'Sử dụng Filia 525SE',
        'Phun Validacin 5L'
      ],
      'Tungro': [
        'Phun thuốc diệt rầy Actara 25WG',
        'Sử dụng Chess 50WG',
        'Phun Confidor 100SL'
      ],
    };
    
    return measures[diseaseName] ?? [
      'Phun thuốc bảo vệ thực vật phù hợp',
      'Tuân thủ thời gian cách ly',
      'Sử dụng đúng liều lượng'
    ];
  }

  List<String> _getCulturalMeasures(String diseaseName) {
    // Map các biện pháp canh tác cho từng bệnh
    final measures = {
      'Bacterial Leaf Blight': [
        'Điều chỉnh thời vụ hợp lý',
        'Quản lý nước tốt',
        'Bón phân cân đối'
      ],
      'Brown Spot': [
        'Giảm mật độ gieo sạ',
        'Tăng cường thoát nước',
        'Bón phân cân đối'
      ],
      'Leaf Blast': [
        'Điều chỉnh thời vụ hợp lý',
        'Quản lý nước tốt',
        'Bón phân cân đối'
      ],
      'Tungro': [
        'Điều chỉnh thời vụ tránh rầy',
        'Vệ sinh đồng ruộng',
        'Quản lý nước tốt'
      ],
    };
    
    return measures[diseaseName] ?? [
      'Điều chỉnh thời vụ hợp lý',
      'Quản lý nước tốt',
      'Bón phân cân đối'
    ];
  }

  void showDiagnosisDetail(DiagnosisResult diagnosis) {
    Get.toNamed(
      AllRouteDisease.diseaseDetailRoute,
      arguments: diagnosis,
    );
  }
}
