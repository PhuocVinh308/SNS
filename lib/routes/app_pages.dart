import 'package:get/get.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/farmer_dashboard.dart';
import '../screens/trader_dashboard.dart';

import '../controllers/auth_controller.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(name: AppRoutes.LOGIN, page: () => LoginScreen(), binding: AuthBinding()),
    GetPage(name: AppRoutes.REGISTER, page: () => RegisterScreen()),
    GetPage(name: AppRoutes.HOME, page: () => HomeScreen()),
    GetPage(name: AppRoutes.PROFILE, page: () => ProfileScreen()),
    GetPage(name: AppRoutes.FARMER_DASHBOARD, page: () => FarmerDashboard()),
    GetPage(name: AppRoutes.TRADER_DASHBOARD, page: () => TraderDashboard()),
  ];
}

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
  }
}
