import 'package:flutter/material.dart';
import 'package:srs_common/srs_common.dart';
import 'package:srs_common/srs_common_lib.dart';

class CustomBottomAppBar extends StatelessWidget {
  const CustomBottomAppBar({
    Key? key,
    this.index,
    this.homeCallback,
    this.notificationCallback,
    this.personCallback,
    this.additionalHomeFunction,
    this.additionalNotificationFunction,
    this.additionalPersonFunction,
  }) : super(key: key);

  final int? index;
  final Function? homeCallback;
  final Function? additionalHomeFunction;

  final Function? notificationCallback;
  final Function? additionalNotificationFunction;

  final Function? personCallback;
  final Function? additionalPersonFunction;

  static final String _homeMainRoute = "/srs_landing/main-route";
  static final String _notificationMainRoute = "/srs_landing/main-route";
  static final String _personMainRoute = "/srs_landing/main-route";

  static const double _iconsSize = 30;
  static const Color _iconsColorsActive = CustomColors.color833162;
  static const Color _iconsColorsNonActive = CustomColors.color999999;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: CustomColors.colorE9E7E7,
      shape: const CircularNotchedRectangle(),
      notchMargin: 5.sp,
      height: kBottomNavigationBarHeight,
      padding: EdgeInsets.zero,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _itemBottomAppBar(
            title: 'thông báo'.tr.toCapitalized(),
            iconData: Icons.notifications_outlined,
            indexBtn: 0,
            onTap: () {
              if (Get.currentRoute != _notificationMainRoute) {
                additionalNotificationFunction?.call();
                Get.offAllNamed(_notificationMainRoute)?.then((value) {
                  notificationCallback?.call();
                });
              }
            },
          ),
          _itemBottomAppBar(
            title: 'trang chủ'.tr.toCapitalized(),
            iconData: Icons.house_outlined,
            indexBtn: 1,
            onTap: () {
              if (Get.currentRoute != _homeMainRoute) {
                additionalHomeFunction?.call();
                Get.offAllNamed(_homeMainRoute)?.then((value) {
                  homeCallback?.call();
                });
              }
            },
          ),
          _itemBottomAppBar(
            title: 'cá nhân'.tr.toCapitalized(),
            iconData: Icons.person,
            indexBtn: 2,
            onTap: () {
              if (Get.currentRoute != _personMainRoute) {
                additionalPersonFunction?.call();
                Get.offAllNamed(_personMainRoute)?.then((value) {
                  personCallback?.call();
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _itemBottomAppBar({String? title, Function? onTap, IconData? iconData, required int indexBtn}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            onTap?.call();
          },
          icon: Icon(
            iconData,
            color: index == null || index == indexBtn ? _iconsColorsActive : _iconsColorsNonActive,
          ),
          iconSize: _iconsSize,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          // override default min size of 48px
          style: const ButtonStyle(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap, // the '2023' part
          ),
          splashRadius: _iconsSize,
        ),
        Text(
          title ?? '',
          style: GoogleFonts.roboto(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: index == null || index == indexBtn ? _iconsColorsActive : _iconsColorsNonActive,
          ),
        ),
      ],
    );
  }
}
