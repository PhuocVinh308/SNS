import 'package:flutter/material.dart';

class FarmerDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bảng điều khiển nông dân")),
      body: Center(child: Text("Quản lý ruộng lúa và đăng tin bán lúa")),
    );
  }
}
