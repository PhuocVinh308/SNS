import 'package:srs_farming_diary/srs_farming_diary.dart';

class MenuModel {
  static List<MenuItemModel> getMenuItems() {
    return [
      // ... existing menu items ...
      MenuItemModel(
        title: 'Nhật ký canh tác',
        icon: Icons.book_outlined,
        route: '/farming-diary',
        page: const FarmingDiaryPage(),
      ),
    ];
  }
} 