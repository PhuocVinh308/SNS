import 'package:flutter/material.dart';
import 'package:srs_common/srs_common.dart';
import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_landing/srs_landing.dart';

class LandingBody extends GetView<LandingController> {
  const LandingBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearch(),
        10.verticalSpace,
        _buildBanner(),
        15.verticalSpace,
        _buildTitleBtn('tính năng nổi bật'.tr.toCapitalized(), () {}),
        15.verticalSpace,
        _buildMenus(),
        15.verticalSpace,
        _buildTitleBtn('thông tin nổi bật'.tr.toCapitalized(), () {}),
        15.verticalSpace,
        _buildNews(),
      ],
    );
  }

  _buildSearch() {
    return Row(
      children: [
        Expanded(
          child: CustomTextField(
            titleEnabled: false,
            hint: '${'tìm kiếm ở đây'.tr.toCapitalized()}...',
            prefixIcon: Icon(
              Icons.search,
              size: 30.sp,
            ),
          ),
        ),
        10.horizontalSpace,
        Container(
          height: 50.sp,
          width: 50.sp,
          decoration: BoxDecoration(
            color: CustomColors.color06b252,
            borderRadius: BorderRadius.circular(8.sp),
          ),
          alignment: Alignment.center,
          child: FaIcon(
            FontAwesomeIcons.sliders,
            color: CustomColors.colorFFFFFF,
            size: 25.sp,
          ),
        )
      ],
    );
  }

  _buildBanner() {
    return Container(
      padding: EdgeInsets.only(left: 5.sp, right: 5.sp),
      child: controller.bannerImgList.isEmpty
          ? Container(
              decoration: BoxDecoration(
                color: CustomColors.colorFFFFFF,
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0.sp),
                ),
              ),
              margin: EdgeInsets.all(5.0.sp),
              child: ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0.sp),
                ),
                child: Center(
                  child: Icon(
                    Icons.cloud_off_sharp,
                    color: CustomColors.colorB8B7B7,
                    size: 80.sp,
                  ),
                ),
              ),
            )
          : Stack(
              children: [
                Column(
                  children: [
                    CarouselSlider(
                      items: _buildBannerImgSlider(),
                      carouselController: controller.bannerController,
                      options: CarouselOptions(
                          aspectRatio: 16 / 9,
                          enlargeCenterPage: true,
                          scrollDirection: Axis.horizontal,
                          autoPlay: true,
                          viewportFraction: 1.0,
                          animateToClosest: true,
                          enableInfiniteScroll: true,
                          pageSnapping: true,
                          onPageChanged: (imgIndex, reason) {
                            controller.bannerCurrentIndex.value = imgIndex;
                          }),
                    ),
                  ],
                ),
                Obx(() {
                  return Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: controller.bannerImgList.asMap().entries.map((entry) {
                        return GestureDetector(
                          onTap: () => controller.bannerController.animateToPage(entry.key),
                          child: Container(
                            width: 15.0.sp,
                            height: 5.0.sp,
                            margin: EdgeInsets.symmetric(vertical: 8.0.sp, horizontal: 4.0.sp),
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(8.sp),
                              color: controller.bannerCurrentIndex.value == entry.key ? CustomColors.color06b252 : CustomColors.colorA7D4EC,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }),
              ],
            ),
    );
  }

  _buildBannerImgSlider() {
    return controller.bannerImgList
        .map(
          (item) => Container(
            margin: EdgeInsets.all(5.0.sp),
            child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(5.0.sp),
              ),
              child: Image.network(
                item,
                fit: BoxFit.cover,
                width: Get.width,
                errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                  return Container(
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: CustomColors.colorFFFFFF,
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0.sp),
                      ),
                    ),
                    margin: EdgeInsets.all(5.0.sp),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0.sp),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.cloud_off_sharp,
                          color: CustomColors.colorB8B7B7,
                          size: 70.sp,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        )
        .toList();
  }

  _buildTitleBtn(String title, Function? onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: CustomText(
            title,
            textAlign: TextAlign.left,
            fontSize: CustomConsts.title,
            maxLines: 2,
          ),
        ),
        TextButton(
          onPressed: () {
            onTap?.call();
          },
          child: CustomText(
            'tất cả'.tr.toCapitalized(),
            textAlign: TextAlign.left,
            fontSize: CustomConsts.h5,
            color: CustomColors.color06b252,
          ),
        )
      ],
    );
  }

  _buildMenus() {
    return Obx(() {
      return SizedBox(
        height: .5.sh.sp,
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 8.sp,
          crossAxisSpacing: 10.sp,
          childAspectRatio: 1.0,
          children: List.generate(
            controller.menus.length,
            (int index) {
              var data = controller.menus[index];
              return AnimationConfiguration.staggeredGrid(
                position: index,
                duration: const Duration(milliseconds: 375),
                columnCount: 2,
                child: SizedBox(
                  child: ScaleAnimation(
                    child: FadeInAnimation(
                      child: _itemMenu(
                        image: data.image,
                        title: data.name,
                        onTap: () {
                          if (data.route == null || data.route == "") {
                            SnackBarUtil.showSnackBar(
                              message: '${'chức năng đang phát triển'.tr.toCapitalized()}!',
                              status: CustomSnackBarStatus.warning,
                            );
                          } else {
                            Get.toNamed(data.route!);
                          }
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    });
  }

  _itemMenu({String? image, String? title, Function? onTap}) {
    return InkWell(
      onTap: () {
        onTap?.call();
      },
      borderRadius: BorderRadius.circular(16.sp),
      child: Container(
        padding: EdgeInsets.all(5.sp),
        decoration: BoxDecoration(
          color: CustomColors.colorFFFFFF,
          border: Border.all(color: Colors.grey.shade300, width: 1.5),
          borderRadius: BorderRadius.circular(16.sp),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Image.asset(
                  image ?? 'assets/images/empty_data.png',
                  height: .15.sh.spMax,
                  width: .5.sw.spMax,
                  fit: BoxFit.cover,
                ),
                CustomText(
                  title ?? '',
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  _buildNews() {
    return SizedBox(
      height: .5.sh.sp,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: Container(
                  padding: EdgeInsets.all(15.sp),
                  height: 200.sp,
                  decoration: BoxDecoration(
                    color: CustomColors.colorFFFFFF,
                    boxShadow: [
                      BoxShadow(
                        color: CustomColors.color000000.withOpacity(0.1), // Màu bóng
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomText(
                                    'Glowrose-Mobile-App-Topics/attachments/1344796?mode=media',
                                    fontSize: CustomConsts.title,
                                    fontWeight: CustomConsts.semiBold,
                                    maxLines: 2,
                                  ),
                                  5.verticalSpace,
                                  CustomText(
                                    'Glowrose-Mobile-App-Topics/attachments/1344796?mode=media',
                                    maxLines: 2,
                                    color: CustomColors.color313131.withOpacity(.8),
                                  ),
                                ],
                              ),
                            ),
                            10.horizontalSpace,
                            Image.asset(
                              'assets/images/farmer.png',
                              fit: BoxFit.cover,
                              width: 100.spMax,
                              height: 100.spMax,
                            ),
                          ],
                        ),
                      ),
                      20.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _itemNoteNews(
                            FaIcon(
                              FontAwesomeIcons.message,
                              color: CustomColors.color313131,
                              size: 25.sp,
                            ),
                            '99+',
                          ),
                          _itemNoteNews(
                            FaIcon(
                              FontAwesomeIcons.heart,
                              color: CustomColors.color313131,
                              size: 25.sp,
                            ),
                            '99+',
                          ),
                          _itemNoteNews(
                            FaIcon(
                              FontAwesomeIcons.eye,
                              color: CustomColors.color313131,
                              size: 25.sp,
                            ),
                            '99+',
                          ),
                          _itemNoteNews(
                            FaIcon(
                              FontAwesomeIcons.clock,
                              color: CustomColors.color313131,
                              size: 25.sp,
                            ),
                            '6d',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, value) => SizedBox(height: 15.sp),
        itemCount: 10,
      ),
    );
  }

  _itemNoteNews(Widget? icon, String? title) {
    return Row(
      children: [
        icon ?? const SizedBox(),
        10.horizontalSpace,
        CustomText(title ?? ""),
      ],
    );
  }
}
