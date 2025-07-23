import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CalendarController extends GetxController {
  final Rx<DateTime> sowingDate = DateTime.now().obs;
  final Rx<String?> selectedVariety = Rx<String?>(null);
  final RxList<Map<String, dynamic>> timelineEvents = <Map<String, dynamic>>[].obs;
  final RxBool showTimeline = false.obs;
  final Map<String, Map<String, dynamic>> riceVarietiesInfo = {
    'OM 5451': {
      'growthDuration': 90,
      'description': 'Giống lúa ngắn ngày, năng suất cao',
      'suitableSoil': 'Đất phù sa, đất phèn nhẹ',
      'stages': {
        'Mạ': 1,
        'Đẻ nhánh': 13,
        'Làm đòng': 35,
        'Trổ bông': 57,
        'Chín': 66,
      }
    },
    'OM 18': {
      'growthDuration': 90,
      'description': 'Giống lúa chất lượng cao, cứng cây',
      'suitableSoil': 'Đất phù sa, thích nghi rộng',
      'stages': {
        'Mạ': 1,
        'Đẻ nhánh': 13,
        'Làm đòng': 36,
        'Trổ bông': 57,
        'Chín': 66,
      }
    },
    'OM 6976': {
      'growthDuration': 95,
      'description': 'Giống lúa thơm, chất lượng gạo cao',
      'suitableSoil': 'Đất phù sa, đất giồng',
      'stages': {
        'Mạ': 1,
        'Đẻ nhánh': 14,
        'Làm đòng': 37,
        'Trổ bông': 61,
        'Chín': 71,
      }
    },
    'OM 4900': {
      'growthDuration': 100,
      'description': 'Giống lúa thơm, chống đổ ngã tốt',
      'suitableSoil': 'Đất phù sa, đất giồng cát',
      'stages': {
        'Mạ': 1,
        'Đẻ nhánh': 15,
        'Làm đòng': 40,
        'Trổ bông': 66,
        'Chín': 76,
      }
    },
    'Đài Thơm 8': {
      'growthDuration': 95,
      'description': 'Giống lúa thơm, chống đổ ngã tốt',
      'suitableSoil': 'Đất phù sa, đất giồng cát',
      'stages': {
        'Mạ': 1,
        'Đẻ nhánh': 14,
        'Làm đòng': 37,
        'Trổ bông': 61,
        'Chín': 71,
      }
    },
  };

  List<String> get riceVarieties => riceVarietiesInfo.keys.toList();

  @override
  void onInit() {
    super.onInit();
    // _generateSampleTimeline();
    selectedVariety.value = riceVarieties.first;
  }

  void _generateSampleTimeline() {
    timelineEvents.value = [
      {
        'stage': 'Gieo sạ',
        'date': '15/03/2024',
        'description': 'Bón lót trước khi gieo sạ',
        'fertilizers': [
          {'name': 'Phân hữu cơ', 'amount': '150', 'unit': 'kg/ha'},
          {'name': 'Super Lân', 'amount': '50', 'unit': 'kg/ha'},
        ],
      },
      {
        'stage': 'Đẻ nhánh',
        'date': '04/04/2024',
        'description': 'Thúc phân đợt 1',
        'fertilizers': [
          {'name': 'Đạm Urê', 'amount': '50', 'unit': 'kg/ha'},
          {'name': 'Kali Clorua', 'amount': '50', 'unit': 'kg/ha'},
        ],
      },
      {
        'stage': 'Làm đòng',
        'date': '14/04/2024',
        'description': 'Đón đòng',
        'fertilizers': [
          {'name': 'NPK 18-4-22', 'amount': '150', 'unit': 'kg/ha'},
        ],
      },
      {
        'stage': 'Trổ bông',
        'date': '09/05/2024',
        'description': 'Bón nuôi hạt',
        'fertilizers': [
          {'name': 'NPK 7-5-44 + TE', 'amount': '50', 'unit': 'kg/ha'},
        ],
      },
    ];
  }

  void onVarietySelected(String? variety) {
    selectedVariety.value = variety;
  }

  void onDateSelected(DateTime date) {
    sowingDate.value = date;
  }

  bool isCurrentEvent(String dateStr) {
    try {
      final eventDate = DateFormat('dd/MM/yyyy').parse(dateStr);
      final now = DateTime.now();
      return eventDate.difference(now).inDays.abs() <= 3;
    } catch (e) {
      return false;
    }
  }

  bool isPastEvent(String dateStr) {
    try {
      final eventDate = DateFormat('dd/MM/yyyy').parse(dateStr);
      return eventDate.isBefore(DateTime.now());
    } catch (e) {
      return false;
    }
  }

  bool isFutureEvent(String dateStr) {
    try {
      final eventDate = DateFormat('dd/MM/yyyy').parse(dateStr);
      return eventDate.isAfter(DateTime.now());
    } catch (e) {
      return false;
    }
  }

  void createTimeline() {
    if (selectedVariety.value == null) {
      Get.snackbar(
        'Lỗi', // Title (bắt buộc)
        'Vui lòng chọn giống lúa'.tr, // Message
        snackPosition: SnackPosition.TOP, // Tùy chọn hiển thị
      );
      return;
    }

    switch (selectedVariety.value) {
      case 'OM 5451':
        final variety = riceVarietiesInfo[selectedVariety.value!]!;
        final stages = variety['stages'] as Map<String, dynamic>;
        final formatter = DateFormat('dd/MM/yyyy');

        final events = <Map<String, dynamic>>[];

        // Giai đoạn mạ
        events.add({
          'stage': 'Giai đoạn mạ',
          'date': formatter.format(sowingDate.value),
          'description': 'Bón lót trước khi gieo sạ',
          'fertilizers': [
            {'name': 'Phân hữu cơ', 'amount': '500', 'unit': 'kg/ha'},
            {'name': 'Super Lân', 'amount': '30', 'unit': 'kg/ha'},
          ],
        });

        // Giai đoạn đẻ nhánh
        events.add({
          'stage': 'Giai đoạn đẻ nhánh ',
          'date': formatter.format(sowingDate.value.add(Duration(days: stages['Đẻ nhánh'] as int))),
          'description': 'Thúc phân đợt 1',
          'fertilizers': [
            {'name': 'Urê', 'amount': '40', 'unit': 'kg/ha'},
            {'name': 'Kali Clorua', 'amount': '15', 'unit': 'kg/ha'},
            {'name': 'NPK 16-16-8', 'amount': '30', 'unit': 'kg/ha'},
          ],
        });

        // Giai đoạn làm đòng
        events.add({
          'stage': 'Giai đoạn làm đòng',
          'date': formatter.format(sowingDate.value.add(Duration(days: stages['Làm đòng'] as int))),
          'description': 'Đón đòng',
          'fertilizers': [
            {'name': 'Urê', 'amount': '30', 'unit': 'kg/ha'},
            {'name': 'Kali', 'amount': '20', 'unit': 'kg/ha'},
            {'name': 'Canxi-Bo', 'amount': '5', 'unit': 'kg/ha'},
          ],
        });

        // Giai đoạn trổ bông
        events.add({
          'stage': 'Giai đoạn trổ bông ',
          'date': formatter.format(sowingDate.value.add(Duration(days: stages['Trổ bông'] as int))),
          'description': 'Bón nuôi hạt',
          'fertilizers': [
            {'name': 'Kali', 'amount': '20', 'unit': 'kg/ha'},
            {'name': 'Silic', 'amount': '5', 'unit': 'kg/ha'},
          ],
        });

        // Giai đoạn chín
        events.add({
          'stage': 'Giai đoạn chín ',
          'date': formatter.format(sowingDate.value.add(Duration(days: stages['Chín'] as int))),
          'description': 'Thu hoạch lúa',
          'fertilizers': [
            {'name': 'Kali', 'amount': '10', 'unit': 'kg/ha'},
          ],
          'notes': 'Kiểm tra độ ẩm hạt trước khi thu hoạch',
        });

        timelineEvents.value = events;
        break;

      case 'OM 18':
        final variety = riceVarietiesInfo[selectedVariety.value!]!;
        final stages = variety['stages'] as Map<String, dynamic>;
        final formatter = DateFormat('dd/MM/yyyy');

        final events = <Map<String, dynamic>>[];

        // Giai đoạn mạ
        events.add({
          'stage': 'Giai đoạn mạ',
          'date': formatter.format(sowingDate.value),
          'description': 'Bón lót trước khi gieo sạ',
          'fertilizers': [
            {'name': 'Phân hữu cơ', 'amount': '500', 'unit': 'kg/ha'},
            {'name': 'Super Lân', 'amount': '30', 'unit': 'kg/ha'},
          ],
        });

        // Giai đoạn đẻ nhánh
        events.add({
          'stage': 'Giai đoạn đẻ nhánh ',
          'date': formatter.format(sowingDate.value.add(Duration(days: stages['Đẻ nhánh'] as int))),
          'description': 'Thúc phân đợt 1',
          'fertilizers': [
            {'name': 'Urê', 'amount': '42', 'unit': 'kg/ha'},
            {'name': 'Kali Clorua', 'amount': '17', 'unit': 'kg/ha'},
            {'name': 'NPK 16-16-8', 'amount': '32', 'unit': 'kg/ha'},
          ],
        });

        // Giai đoạn làm đòng
        events.add({
          'stage': 'Giai đoạn làm đòng',
          'date': formatter.format(sowingDate.value.add(Duration(days: stages['Làm đòng'] as int))),
          'description': 'Đón đòng',
          'fertilizers': [
            {'name': 'Urê', 'amount': '32', 'unit': 'kg/ha'},
            {'name': 'Kali', 'amount': '22', 'unit': 'kg/ha'},
            {'name': 'Canxi-Bo', 'amount': '6', 'unit': 'kg/ha'},
          ],
        });

        // Giai đoạn trổ bông
        events.add({
          'stage': 'Giai đoạn trổ bông ',
          'date': formatter.format(sowingDate.value.add(Duration(days: stages['Trổ bông'] as int))),
          'description': 'Bón nuôi hạt',
          'fertilizers': [
            {'name': 'Kali', 'amount': '22', 'unit': 'kg/ha'},
            {'name': 'Silic', 'amount': '6', 'unit': 'kg/ha'},
            {'name': 'Bo', 'amount': '3', 'unit': 'kg/ha'},
          ],
        });

        // Giai đoạn chín
        events.add({
          'stage': 'Giai đoạn chín ',
          'date': formatter.format(sowingDate.value.add(Duration(days: stages['Chín'] as int))),
          'description': 'Thu hoạch lúa',
          'fertilizers': [
            {'name': 'Kali', 'amount': '12', 'unit': 'kg/ha'},
          ],
          'notes': 'Kiểm tra độ ẩm hạt trước khi thu hoạch',
        });

        timelineEvents.value = events;
        break;

      case 'OM 6976':
        final variety = riceVarietiesInfo[selectedVariety.value!]!;
        final stages = variety['stages'] as Map<String, dynamic>;
        final formatter = DateFormat('dd/MM/yyyy');

        final events = <Map<String, dynamic>>[];

        // Giai đoạn mạ
        events.add({
          'stage': 'Giai đoạn mạ',
          'date': formatter.format(sowingDate.value),
          'description': 'Bón lót trước khi gieo sạ',
          'fertilizers': [
            {'name': 'Phân hữu cơ', 'amount': '520', 'unit': 'kg/ha'},
            {'name': 'Super Lân', 'amount': '32', 'unit': 'kg/ha'},
          ],
        });

        // Giai đoạn đẻ nhánh
        events.add({
          'stage': 'Giai đoạn đẻ nhánh ',
          'date': formatter.format(sowingDate.value.add(Duration(days: stages['Đẻ nhánh'] as int))),
          'description': 'Thúc phân đợt 1',
          'fertilizers': [
            {'name': 'Urê', 'amount': '43', 'unit': 'kg/ha'},
            {'name': 'Kali Clorua', 'amount': '18', 'unit': 'kg/ha'},
            {'name': 'NPK 16-16-8', 'amount': '33', 'unit': 'kg/ha'},
          ],
        });

        // Giai đoạn làm đòng
        events.add({
          'stage': 'Giai đoạn làm đòng',
          'date': formatter.format(sowingDate.value.add(Duration(days: stages['Làm đòng'] as int))),
          'description': 'Đón đòng',
          'fertilizers': [
            {'name': 'Urê', 'amount': '33', 'unit': 'kg/ha'},
            {'name': 'Kali', 'amount': '23', 'unit': 'kg/ha'},
            {'name': 'Canxi-Bo', 'amount': '7', 'unit': 'kg/ha'},
          ],
        });

        // Giai đoạn trổ bông
        events.add({
          'stage': 'Giai đoạn trổ bông ',
          'date': formatter.format(sowingDate.value.add(Duration(days: stages['Trổ bông'] as int))),
          'description': 'Bón nuôi hạt',
          'fertilizers': [
            {'name': 'Kali', 'amount': '23', 'unit': 'kg/ha'},
            {'name': 'Silic', 'amount': '7', 'unit': 'kg/ha'},
            {'name': 'Bo', 'amount': '3', 'unit': 'kg/ha'},
          ],
        });

        // Giai đoạn chín
        events.add({
          'stage': 'Giai đoạn chín ',
          'date': formatter.format(sowingDate.value.add(Duration(days: stages['Chín'] as int))),
          'description': 'Thu hoạch lúa',
          'fertilizers': [
            {'name': 'Kali', 'amount': '12', 'unit': 'kg/ha'},
          ],
          'notes': 'Kiểm tra độ ẩm hạt trước khi thu hoạch',
        });

        timelineEvents.value = events;
        break;

      case 'OM 4900':
        final variety = riceVarietiesInfo[selectedVariety.value!]!;
        final stages = variety['stages'] as Map<String, dynamic>;
        final formatter = DateFormat('dd/MM/yyyy');

        final events = <Map<String, dynamic>>[];

        // Giai đoạn mạ
        events.add({
          'stage': 'Giai đoạn mạ',
          'date': formatter.format(sowingDate.value),
          'description': 'Bón lót trước khi gieo sạ',
          'fertilizers': [
            {'name': 'Phân hữu cơ', 'amount': '530', 'unit': 'kg/ha'},
            {'name': 'Super Lân', 'amount': '33', 'unit': 'kg/ha'},
          ],
        });

        // Giai đoạn đẻ nhánh
        events.add({
          'stage': 'Giai đoạn đẻ nhánh ',
          'date': formatter.format(sowingDate.value.add(Duration(days: stages['Đẻ nhánh'] as int))),
          'description': 'Thúc phân đợt 1',
          'fertilizers': [
            {'name': 'Urê', 'amount': '44', 'unit': 'kg/ha'},
            {'name': 'Kali Clorua', 'amount': '19', 'unit': 'kg/ha'},
            {'name': 'NPK 16-16-8', 'amount': '34', 'unit': 'kg/ha'},
          ],
        });

        // Giai đoạn làm đòng
        events.add({
          'stage': 'Giai đoạn làm đòng',
          'date': formatter.format(sowingDate.value.add(Duration(days: stages['Làm đòng'] as int))),
          'description': 'Đón đòng',
          'fertilizers': [
            {'name': 'Urê', 'amount': '34', 'unit': 'kg/ha'},
            {'name': 'Kali', 'amount': '24', 'unit': 'kg/ha'},
            {'name': 'Canxi-Bo', 'amount': '8', 'unit': 'kg/ha'},
          ],
        });

        // Giai đoạn trổ bông
        events.add({
          'stage': 'Giai đoạn trổ bông ',
          'date': formatter.format(sowingDate.value.add(Duration(days: stages['Trổ bông'] as int))),
          'description': 'Bón nuôi hạt',
          'fertilizers': [
            {'name': 'Kali', 'amount': '24', 'unit': 'kg/ha'},
            {'name': 'Silic', 'amount': '8', 'unit': 'kg/ha'},
            {'name': 'Bo', 'amount': '3', 'unit': 'kg/ha'},
          ],
        });

        // Giai đoạn chín
        events.add({
          'stage': 'Giai đoạn chín ',
          'date': formatter.format(sowingDate.value.add(Duration(days: stages['Chín'] as int))),
          'description': 'Thu hoạch lúa',
          'fertilizers': [
            {'name': 'Kali', 'amount': '13', 'unit': 'kg/ha'},
          ],
          'notes': 'Kiểm tra độ ẩm hạt trước khi thu hoạch',
        });

        timelineEvents.value = events;
        break;

      case 'Đài Thơm 8':
        final variety = riceVarietiesInfo[selectedVariety.value!]!;
        final stages = variety['stages'] as Map<String, dynamic>;
        final formatter = DateFormat('dd/MM/yyyy');

        final events = <Map<String, dynamic>>[];

        // Giai đoạn mạ
        events.add({
          'stage': 'Giai đoạn mạ',
          'date': formatter.format(sowingDate.value),
          'description': 'Bón lót trước khi gieo sạ',
          'fertilizers': [
            {'name': 'Phân hữu cơ', 'amount': '515', 'unit': 'kg/ha'},
            {'name': 'Super Lân', 'amount': '31', 'unit': 'kg/ha'},
          ],
        });

        // Giai đoạn đẻ nhánh
        events.add({
          'stage': 'Giai đoạn đẻ nhánh ',
          'date': formatter.format(sowingDate.value.add(Duration(days: stages['Đẻ nhánh'] as int))),
          'description': 'Thúc phân đợt 1',
          'fertilizers': [
            {'name': 'Urê', 'amount': '41', 'unit': 'kg/ha'},
            {'name': 'Kali Clorua', 'amount': '16', 'unit': 'kg/ha'},
            {'name': 'NPK 16-16-8', 'amount': '31', 'unit': 'kg/ha'},
          ],
        });

        // Giai đoạn làm đòng
        events.add({
          'stage': 'Giai đoạn làm đòng',
          'date': formatter.format(sowingDate.value.add(Duration(days: stages['Làm đòng'] as int))),
          'description': 'Đón đòng',
          'fertilizers': [
            {'name': 'Urê', 'amount': '31', 'unit': 'kg/ha'},
            {'name': 'Kali', 'amount': '21', 'unit': 'kg/ha'},
            {'name': 'Canxi-Bo', 'amount': '6', 'unit': 'kg/ha'},
          ],
        });

        // Giai đoạn trổ bông
        events.add({
          'stage': 'Giai đoạn trổ bông ',
          'date': formatter.format(sowingDate.value.add(Duration(days: stages['Trổ bông'] as int))),
          'description': 'Bón nuôi hạt',
          'fertilizers': [
            {'name': 'Kali', 'amount': '21', 'unit': 'kg/ha'},
            {'name': 'Silic', 'amount': '6', 'unit': 'kg/ha'},
            {'name': 'Bo', 'amount': '3', 'unit': 'kg/ha'},
          ],
        });

        // Giai đoạn chín
        events.add({
          'stage': 'Giai đoạn chín ',
          'date': formatter.format(sowingDate.value.add(Duration(days: stages['Chín'] as int))),
          'description': 'Thu hoạch lúa',
          'fertilizers': [
            {'name': 'Kali', 'amount': '11', 'unit': 'kg/ha'},
          ],
          'notes': 'Kiểm tra độ ẩm hạt trước khi thu hoạch',
        });

        timelineEvents.value = events;
        break;
    }
  }
}
