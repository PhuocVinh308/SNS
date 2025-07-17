import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:srs_common/srs_common.dart';

class CalendarController extends GetxController {
  final Rx<DateTime> sowingDate = DateTime.now().obs;
  final Rx<DateTime> dataDate = DateTime.now().subtract(Duration(days: 10)).obs;
  final Rx<String?> selectedVariety = Rx<String?>(null);
  final RxList<Map<String, dynamic>> timelineEvents = <Map<String, dynamic>>[].obs;
  final RxBool showTimeline = false.obs;
  final Map<String, Map<String, dynamic>> riceVarietiesInfo = {
    'OM 5451': {
      'growthDuration': 95,
      'description': 'Giống lúa ngắn ngày, năng suất cao',
      'suitableSoil': 'Đất phù sa, đất phèn nhẹ',
      'stages': {
        'Đẻ nhánh': 20,
        'Làm đòng': 35,
        'Trổ bông': 55,
        'Thu hoạch': 95,
      }
    },
    'OM 18': {
      'growthDuration': 90,
      'description': 'Giống lúa chất lượng cao, cứng cây',
      'suitableSoil': 'Đất phù sa, thích nghi rộng',
      'stages': {
        'Đẻ nhánh': 18,
        'Làm đòng': 32,
        'Trổ bông': 52,
        'Thu hoạch': 90,
      }
    },
    'Jasmine 85': {
      'growthDuration': 100,
      'description': 'Giống lúa thơm, chất lượng gạo cao',
      'suitableSoil': 'Đất phù sa, đất giồng',
      'stages': {
        'Đẻ nhánh': 22,
        'Làm đòng': 40,
        'Trổ bông': 60,
        'Thu hoạch': 100,
      }
    },
    'Đài thơm 8': {
      'growthDuration': 95,
      'description': 'Giống lúa thơm, chống đổ ngã tốt',
      'suitableSoil': 'Đất phù sa, đất giồng cát',
      'stages': {
        'Đẻ nhánh': 20,
        'Làm đòng': 35,
        'Trổ bông': 55,
        'Thu hoạch': 95,
      }
    },
  };

  List<String> get riceVarieties => riceVarietiesInfo.keys.toList();

  @override
  void onInit() {
    super.onInit();
    _generateSampleTimeline();
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

    final variety = riceVarietiesInfo[selectedVariety.value!]!;
    final stages = variety['stages'] as Map<String, dynamic>;
    final formatter = DateFormat('dd/MM/yyyy');

    final events = <Map<String, dynamic>>[];

    // Gieo sạ
    events.add({
      'stage': 'Gieo sạ',
      'date': formatter.format(dataDate.value),
      'description': 'Bón lót trước khi gieo sạ',
      'fertilizers': [
        {'name': 'Phân hữu cơ', 'amount': '150', 'unit': 'kg/ha'},
        {'name': 'Super Lân', 'amount': '50', 'unit': 'kg/ha'},
      ],
    });

    // Đẻ nhánh
    events.add({
      'stage': 'Đẻ nhánh',
      'date': formatter.format(sowingDate.value),
      'description': 'Thúc phân đợt 1',
      'fertilizers': [
        {'name': 'Đạm Urê', 'amount': '50', 'unit': 'kg/ha'},
        {'name': 'Kali Clorua', 'amount': '50', 'unit': 'kg/ha'},
      ],
    });

    // Làm đòng
    events.add({
      'stage': 'Làm đòng',
      'date': formatter.format(sowingDate.value.add(Duration(days: stages['Làm đòng'] as int))),
      'description': 'Đón đòng',
      'fertilizers': [
        {'name': 'NPK 18-4-22', 'amount': '150', 'unit': 'kg/ha'},
      ],
    });

    // Trổ bông
    events.add({
      'stage': 'Trổ bông',
      'date': formatter.format(sowingDate.value.add(Duration(days: stages['Trổ bông'] as int))),
      'description': 'Bón nuôi hạt',
      'fertilizers': [
        {'name': 'NPK 7-5-44 + TE', 'amount': '50', 'unit': 'kg/ha'},
      ],
    });

    // Thu hoạch
    events.add({
      'stage': 'Thu hoạch',
      'date': formatter.format(sowingDate.value.add(Duration(days: stages['Thu hoạch'] as int))),
      'description': 'Thu hoạch lúa',
      'notes': 'Kiểm tra độ ẩm hạt trước khi thu hoạch',
    });

    timelineEvents.value = events;
  }
}
