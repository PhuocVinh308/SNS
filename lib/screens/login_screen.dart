import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class LoginScreen extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Đăng nhập")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            authController.login();
          },
          child: Text("Đăng nhập"),
        ),
      ),
    );
  }
}
