import 'package:intl/intl.dart';
import 'package:srs_authen/srs_authen.dart' as srs_authen;
import 'package:srs_calendar/srs_calendar.dart' as srs_calendar;
import 'package:srs_common/srs_common.dart';
import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_diary/srs_diary.dart' as srs_diary;
import 'package:srs_disease/srs_disease.dart' as srs_disease;
import 'package:srs_forum/srs_forum.dart' as srs_forum;
import 'package:srs_landing/srs_landing.dart';
import 'package:srs_notification/srs_notification.dart' as srs_notification;
import 'package:srs_transaction/srs_transaction.dart' as srs_transaction;

class LandingInitController {
  // banner
  final CarouselSliderController bannerController = CarouselSliderController();
  Rx<int> bannerCurrentIndex = 0.obs;
  RxList<String> bannerImgList = RxList<String>();
  final service = LandingService();

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
        'assets/images/bn1.jpg',
        'assets/images/bn2.jpg',
        'assets/images/bn3.jpg',
        'assets/images/bn4.jpg',
        'assets/images/bn5.jpg',
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
          image: FontAwesomeIcons.comments,
          route: srs_forum.AllRoute.mainRoute,
        ),
        MenuModel(
          id: 2,
          name: 'dịch vụ'.tr.toCapitalized(),
          image: FontAwesomeIcons.store,
          route: srs_transaction.AllRoute.mainRoute,
        ),
        MenuModel(
          id: 3,
          name: 'Nhận biết bệnh trên lá lúa'.tr.toCapitalized(),
          image: FontAwesomeIcons.viruses,
          route: srs_disease.AllRouteDisease.diseaseMainRoute,
        ),
        MenuModel(
          id: 4,
          name: 'Sổ tay nông nghiệp'.tr.toCapitalized(),
          image: FontAwesomeIcons.book,
          route: srs_diary.AllRouteDiary.diaryMainRoute,
        ),
        MenuModel(
          id: 5,
          name: 'Lịch thời vụ'.tr.toCapitalized(),
          image: FontAwesomeIcons.calendarDays,
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

  String getTypeAccount() {
    return (userModel.value.userRole == "THUONG_LAI"
        ? 'thương lái'.tr.toCapitalized()
        : userModel.value.userRole == "NONG_DAN"
            ? 'nông dân'.tr.toCapitalized()
            : '');
  }

  initSyncEnv() async {
    try {
      service.fetchFireStoreDataByCollectionSync(
        collectionPath: "tb_env",
        onListen: (snapshot) {
          var map = {
            for (var doc in snapshot.docs) doc.id: doc.data() as Map<String, dynamic>, // Gán doc.id làm key và dữ liệu làm value
          };
          var modelValue = DriveServiceModel.fromJson(map['google_drive'] ?? DriveServiceModel().toJson());
          CustomGlobals().setDriveServiceModel(modelValue);
        },
      );
    } catch (e) {
      rethrow;
    }
  }
}
