import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class HomeScreen extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Trang Chủ")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () => Get.toNamed('/profile'),
            child: Text("Hồ sơ cá nhân"),
          ),
          ElevatedButton(
            onPressed: () => Get.toNamed('/farmer_dashboard'),
            child: Text("Bảng điều khiển nông dân"),
          ),
          ElevatedButton(
            onPressed: () => Get.toNamed('/trader_dashboard'),
            child: Text("Bảng điều khiển thương lái"),
          ),
          ElevatedButton(
            onPressed: () => authController.logout(),
            child: Text("Đăng xuất"),
          ),
        ],
      ),
    );
  }
}
