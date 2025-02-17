import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sns/routes/app_pages.dart';
import 'package:sns/routes/app_routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sàn Giao Dịch Lúa Gạo',
      initialRoute: AppRoutes.LOGIN,
      getPages: AppPages.routes,
    );
  }
}
