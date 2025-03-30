import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_disease/srs_disease.dart';

class AllBindingDisease extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DiseaseController());
  }
}
