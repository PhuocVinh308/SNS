import 'package:flutter/material.dart';
import 'package:srs_common/srs_common.dart';
import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_forum/srs_forum.dart' as srs_forum;
import 'package:srs_landing/srs_landing.dart' as srs_landing;
import 'package:srs_setting/srs_setting.dart' as srs_setting;

class CustomBottomAppBar extends StatelessWidget {
  const CustomBottomAppBar({
    Key? key,
    this.index,
    this.homeCallback,
    this.additionalHomeFunction,
    this.serviceCallback,
    this.additionalServiceFunction,
    this.forumCallback,
    this.additionalForumFunction,
    this.profileCallback,
    this.additionalProfileFunction,
  }) : super(key: key);

  final int? index;

  final Function? homeCallback;
  final Function? additionalHomeFunction;

  final Function? serviceCallback;
  final Function? additionalServiceFunction;

  final Function? forumCallback;
  final Function? additionalForumFunction;

  final Function? profileCallback;
  final Function? additionalProfileFunction;

  static const String _homeRoute = srs_landing.AllRoute.mainRoute;
  static final String _serviceRoute = "/srs_landing/main-route";
  static const String _forumRoute = srs_forum.AllRoute.mainRoute;
  static const String _profileRoute = srs_setting.AllRoute.mainRoute;

  static final double _textSize = 14.sp;
  static final double _iconsSize = 25.sp;
  static const Color _iconsColorsActive = CustomColors.color06b252;
  static const Color _iconsColorsNonActive = CustomColors.color999999;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CustomColors.colorFFFFFF,
        boxShadow: [
          BoxShadow(
            color: CustomColors.color000000.withOpacity(0.1), // Màu bóng
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, -4), // Bóng phía trên
          ),
        ],
      ),
      child: BottomAppBar(
        color: CustomColors.colorFFFFFF,
        shape: const CircularNotchedRectangle(),
        notchMargin: 5.sp,
        height: kBottomNavigationBarHeight + 14.sp,
        padding: EdgeInsets.zero,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _itemBottomAppBar(
              title: 'trang chủ'.tr.toCapitalized(),
              iconData: FontAwesomeIcons.house,
              indexBtn: 0,
              onTap: () {
                if (Get.currentRoute != _homeRoute) {
                  additionalHomeFunction?.call();
                  Get.offAllNamed(_homeRoute)?.then((value) {
                    homeCallback?.call();
                  });
                }
              },
            ),
            _itemBottomAppBar(
              title: 'dịch vụ'.tr.toCapitalized(),
              iconData: FontAwesomeIcons.store,
              indexBtn: 1,
              onTap: () {
                if (Get.currentRoute != _serviceRoute) {
                  additionalServiceFunction?.call();
                  Get.offAllNamed(_serviceRoute)?.then((value) {
                    serviceCallback?.call();
                  });
                }
              },
            ),
            _itemBottomAppBar(
              title: 'diễn đàn'.tr.toCapitalized(),
              iconData: FontAwesomeIcons.comments,
              indexBtn: 2,
              onTap: () {
                if (Get.currentRoute != _forumRoute) {
                  additionalForumFunction?.call();
                  Get.offAllNamed(_forumRoute)?.then((value) {
                    forumCallback?.call();
                  });
                }
              },
            ),
            _itemBottomAppBar(
              title: 'cá nhân'.tr.toCapitalized(),
              iconData: FontAwesomeIcons.user,
              indexBtn: 3,
              onTap: () {
                if (Get.currentRoute != _profileRoute) {
                  additionalProfileFunction?.call();
                  Get.offAllNamed(_profileRoute)?.then((value) {
                    profileCallback?.call();
                  });
                }
              },
            ),
          ],
        ),
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
          icon: Column(
            children: [
              FaIcon(
                iconData,
                color: index == null || index == indexBtn ? _iconsColorsActive : _iconsColorsNonActive,
              ),
              Text(
                title ?? '',
                style: GoogleFonts.roboto(
                  fontSize: _textSize,
                  fontWeight: FontWeight.w400,
                  color: index == null || index == indexBtn ? _iconsColorsActive : _iconsColorsNonActive,
                ),
              ),
            ],
          ),
          iconSize: _iconsSize,
          // padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          // override default min size of 48px
          style: const ButtonStyle(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap, // the '2023' part
          ),
          splashRadius: _iconsSize,
        ),
      ],
    );
  }
}
