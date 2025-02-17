import 'package:flutter/material.dart';

class TraderDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bảng điều khiển thương lái")),
      body: Center(child: Text("Tìm kiếm nguồn lúa và thương lượng giá")),
    );
  }
}
