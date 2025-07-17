import 'package:flutter/material.dart';
import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_common/srs_common.dart';
import 'package:srs_transaction/srs_transaction.dart';

class TransactionPage extends GetView<TransactionController> {
  const TransactionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: SafeArea(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            backgroundColor: Colors.grey.shade50,
            body: RefreshIndicator(
              onRefresh: () => controller.loadTransactions(),
              child: Column(
                children: [
                  // AppBar cố định
                  const TransactionAppBar(),
                  
                  // Body có thể scroll
                  Expanded(
                    child: Container(
                      width: 1.sw,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.r),
                          topRight: Radius.circular(20.r),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, -5),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.r),
                          topRight: Radius.circular(20.r),
                        ),
                        child: const TransactionBody(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // FAB để thêm giao dịch mới
            floatingActionButton: Obx(() {
              // Chỉ hiển thị FAB nếu user là nông dân
              if (controller.userRole.value == 'farmer') {
                return FloatingActionButton.extended(
                  onPressed: () => controller.showCreateTransactionDialog(),
                  backgroundColor: CustomColors.color06b252,
                  elevation: 2,
                  icon: Icon(
                    Icons.add_circle_outline,
                    color: Colors.white,
                    size: 20.w,
                  ),
                  label: CustomText(
                    'Đăng tin',
                    color: Colors.white,
                    fontSize: CustomConsts.h6,
                    fontWeight: CustomConsts.bold,
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
            
            // Bottom sheet cho bộ lọc (nếu cần)
            bottomSheet: Obx(() {
              if (controller.isFilterActive.value) {
                return Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.r),
                      topRight: Radius.circular(20.r),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: CustomText(
                              'Đang lọc: ${controller.activeFilters.value}',
                              fontSize: CustomConsts.h6,
                              color: CustomColors.color313131,
                            ),
                          ),
                          TextButton(
                            onPressed: () => controller.clearFilters(),
                            child: CustomText(
                              'Xóa bộ lọc',
                              fontSize: CustomConsts.h6,
                              color: CustomColors.color06b252,
                              fontWeight: CustomConsts.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
          ),
        ),
      ),
    );
  }
}
