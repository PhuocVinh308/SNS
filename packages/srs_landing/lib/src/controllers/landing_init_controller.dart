import 'package:srs_authen/srs_authen.dart' as srs_authen;
import 'package:srs_common/srs_common.dart';
import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_forum/srs_forum.dart' as srs_forum;
import 'package:srs_notification/srs_notification.dart' as srs_notification;
import 'package:srs_landing/srs_landing.dart';
import 'package:intl/intl.dart';
import 'package:srs_calendar/srs_calendar.dart' as srs_calendar;
import 'package:srs_diary/srs_diary.dart' as srs_diary;
import 'package:srs_disease/srs_disease.dart' as srs_disease;

class LandingInitController {
  // banner
  final CarouselSliderController bannerController = CarouselSliderController();
  Rx<int> bannerCurrentIndex = 0.obs;
  RxList<String> bannerImgList = RxList<String>();

  // menu
  RxList<MenuModel> menus = RxList<MenuModel>();

  // userName
  Rx<srs_authen.UserInfoModel> userModel = srs_authen.UserInfoModel().obs;
  RxList<srs_forum.ForumPostModel> newPosts = <srs_forum.ForumPostModel>[].obs;
  // notification
  final notificationController = Get.put(srs_notification.NotificationController());

  init() async {
    try {
      await _initBanner();
      await _initMenus();
      await initUserModel();
      await initSyncNewPost();
      await notificationController.initFirebaseMessage();
    } catch (e) {
      DialogUtil.catchException(obj: e);
    }
  }

  initUserModel() async {
    try {
      userModel.value = CustomGlobals().userInfo;
    } catch (e) {
      rethrow;
    }
  }

  _initBanner() async {
    try {
      /// banner
      bannerImgList.value = [
        'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
        'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
        'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
        'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
        'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
        'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
      ];
    } catch (e) {
      rethrow;
    }
  }

  _initMenus() async {
    try {
      menus.value = [
        MenuModel(
          id: 1,
          name: 'diễn đàn'.tr.toCapitalized(),
          image: 'assets/images/forum.png',
          route: srs_forum.AllRoute.mainRoute,
        ),
        MenuModel(
          id: 1,
          name: 'diễn đàn'.tr.toCapitalized(),
          image: 'assets/images/forum.png',
          route: srs_forum.AllRoute.mainRoute,
        ),
        MenuModel(
          id: 1,
          name: 'diễn đàn'.tr.toCapitalized(),
          image: 'assets/images/forum.png',
          route: srs_forum.AllRoute.mainRoute,
        ),
        MenuModel(
          id: 1,
          name: 'Nhận biết bệnh trên lá lúa'.tr.toCapitalized(),
          image: 'assets/images/forum.png',
          route: srs_disease.AllRouteDisease.diseaseMainRoute,
        ),
        MenuModel(
          id: 1,
          name: 'Sổ tay nông nghiệp'.tr.toCapitalized(),
          image: 'assets/images/forum.png',
          route: srs_diary.AllRouteDiary.diaryMainRoute,
        ),
        MenuModel(
          id: 1,
          name: 'Lịch thời vụ'.tr.toCapitalized(),
          image: 'assets/images/forum.png',
          route: srs_calendar.AllRoute.mainRoute,
        ),
      ];
    } catch (e) {
      rethrow;
    }
  }

  initSyncNewPost() async {
    try {
      await srs_forum.ForumHelper.initNewForumPost();
      newPosts.value = srs_forum.ForumHelper.listNewPost;
    } catch (e) {
      rethrow;
    }
  }

  coreGetTimeCreate(String? value) {
    if (value == null) return 'đang cập nhật...'.tr.toCapitalized();
    try {
      // Phân tích chuỗi ngày giờ
      DateTime dateTime = DateTime.parse(value);
      // Định dạng giờ: HH:mm:ss (24h)
      String formattedTime = DateFormat('HH:mm:ss').format(dateTime);
      // Định dạng ngày: dd/MM/yyyy
      String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
      // Kết hợp lại
      String finalFormattedDateTime = "$formattedTime $formattedDate";
      return finalFormattedDateTime;
    } catch (e) {
      return 'đang cập nhật...'.tr.toCapitalized();
    }
  }
}
