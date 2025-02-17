import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Đăng ký")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Get.toNamed('/home');
          },
          child: Text("Hoàn tất đăng ký"),
        ),
      ),
    );
  }
}
