import 'package:flutter/material.dart';
import 'package:srs_common/srs_common.dart';
import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_diary/srs_diary.dart';
import 'package:intl/intl.dart';

class DiaryBody extends GetView<DiaryController> {
  const DiaryBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                20.verticalSpace,
                _buildSummaryCard(),
                20.verticalSpace,
                _buildMonthSelector(),
                20.verticalSpace,
              ],
            ),
          ),
          _buildTransactionsList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: CustomColors.color06b252,
        onPressed: () => _showAddTransactionDialog(),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Obx(() {
      final profit = controller.totalIncome.value - controller.totalExpense.value;
      final isProfit = profit >= 0;
      
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isProfit ? [
              CustomColors.color06b252,
              CustomColors.color06b252.withOpacity(0.8),
            ] : [
                            Colors.red.withOpacity(0.8),
                            Colors.red.withOpacity(0.6),

            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            BoxShadow(
              color: isProfit 
                ? CustomColors.color06b252.withOpacity(0.2)
                : Colors.red.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSummaryItem(
                  'Thu nhập',
                  Icons.arrow_upward,
                  Colors.white,
                  controller.totalIncome,
                ),
                _buildSummaryItem(
                  'Chi phí',
                  Icons.arrow_downward,
                  Colors.white.withOpacity(0.8),
                  controller.totalExpense,
                ),
              ],
            ),
            15.verticalSpace,
            Divider(color: Colors.white.withOpacity(0.2)),
            15.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  'Lợi nhuận',
                  color: Colors.white,
                  fontSize: CustomConsts.h5,
                  fontWeight: CustomConsts.bold,
                ),
                CustomText(
                  '${profit >= 0 ? '' : '-'}${NumberFormat.currency(locale: 'vi_VN', symbol: 'đ', decimalDigits: 0).format(profit.abs())}',
                  color: Colors.white,
                  fontSize: CustomConsts.h4,
                  fontWeight: CustomConsts.bold,
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSummaryItem(String title, IconData icon, Color color, RxDouble value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(icon, color: color, size: 16.w),
            ),
            10.horizontalSpace,
            CustomText(
              title,
              color: color,
              fontSize: CustomConsts.h6,
            ),
          ],
        ),
        10.verticalSpace,
        Obx(() => CustomText(
          '${NumberFormat.currency(locale: 'vi_VN', symbol: 'đ', decimalDigits: 0).format(value.value)}',
          color: color,
          fontSize: CustomConsts.h5,
          fontWeight: CustomConsts.bold,
        )),
      ],
    );
  }

  Widget _buildMonthSelector() {
    return Container(
      height: 40.h,
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          IconButton(
            onPressed: () => controller.previousMonth(),
            icon: Icon(Icons.chevron_left, color: CustomColors.color313131),
          ),
          Expanded(
            child: Obx(() => Center(
              child: CustomText(
                DateFormat('MMMM yyyy', 'vi_VN').format(controller.selectedMonth.value),
                fontSize: CustomConsts.h5,
                fontWeight: CustomConsts.bold,
              ),
            )),
          ),
          IconButton(
            onPressed: () => controller.nextMonth(),
            icon: Icon(Icons.chevron_right, color: CustomColors.color313131),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsList() {
    return Obx(() {
      // Lấy danh sách giao dịch của tháng được chọn
      final monthlyTransactions = controller.getTransactionsByMonth(controller.selectedMonth.value);
      
      if (monthlyTransactions.isEmpty) {
        return SliverFillRemaining(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.note_alt_outlined,
                  size: 80.w,
                  color: CustomColors.color06b252.withOpacity(0.5),
                ),
                20.verticalSpace,
                CustomText(
                  'Chưa có ghi chép nào trong tháng này',
                  fontSize: CustomConsts.h5,
                  color: CustomColors.color313131.withOpacity(0.7),
                ),
              ],
            ),
          ),
        );
      }

      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final transaction = monthlyTransactions[index];
            return _buildTransactionItem(transaction);
          },
          childCount: monthlyTransactions.length,
        ),
      );
    });
  }

  Widget _buildTransactionItem(DiaryTransaction transaction) {
    return Dismissible(
      key: Key(transaction.id),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.w),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => controller.deleteTransaction(transaction.id),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: InkWell(
            onTap: () => _showTransactionDetail(transaction),
            borderRadius: BorderRadius.circular(12.r),
            child: Padding(
              padding: EdgeInsets.all(15.w),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: transaction.isExpense
                          ? Colors.red.withOpacity(0.1)
                          : CustomColors.color06b252.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      transaction.isExpense ? Icons.remove : Icons.add,
                      color: transaction.isExpense
                          ? Colors.red
                          : CustomColors.color06b252,
                      size: 20.w,
                    ),
                  ),
                  15.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: CustomText(
                                transaction.description,
                                fontSize: CustomConsts.h5,
                                fontWeight: CustomConsts.bold,
                              ),
                            ),
                            CustomText(
                              DateFormat('dd/MM').format(transaction.date),
                              fontSize: CustomConsts.h6,
                              color: CustomColors.color313131.withOpacity(0.6),
                            ),
                          ],
                        ),
                        5.verticalSpace,
                        CustomText(
                          transaction.category,
                          fontSize: CustomConsts.h6,
                          color: CustomColors.color313131.withOpacity(0.7),
                        ),
                      ],
                    ),
                  ),
                  15.horizontalSpace,
                  CustomText(
                    '${NumberFormat.currency(locale: 'vi_VN', symbol: 'đ', decimalDigits: 0).format(transaction.amount)}',
                    fontSize: CustomConsts.h5,
                    fontWeight: CustomConsts.bold,
                    color: transaction.isExpense
                        ? Colors.red
                        : CustomColors.color06b252,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showTransactionDetail(DiaryTransaction transaction) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Container(
          width: Get.width * 0.9,
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    'Chi tiết giao dịch',
                    fontSize: CustomConsts.h4,
                    fontWeight: CustomConsts.bold,
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
              15.verticalSpace,
              _buildDetailRow('Loại', transaction.isExpense ? 'Chi phí' : 'Thu nhập'),
              _buildDetailRow('Mô tả', transaction.description),
              _buildDetailRow('Danh mục', transaction.category),
              _buildDetailRow('Ngày', DateFormat('dd/MM/yyyy').format(transaction.date)),
              _buildDetailRow('Số tiền', NumberFormat.currency(
                locale: 'vi_VN',
                symbol: 'đ',
                decimalDigits: 0,
              ).format(transaction.amount)),
              if (transaction.note != null && transaction.note!.isNotEmpty)
                _buildDetailRow('Ghi chú', transaction.note!),
              20.verticalSpace,
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.color06b252,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: CustomText(
                    'Đóng',
                    color: Colors.white,
                    fontSize: CustomConsts.h5,
                    fontWeight: CustomConsts.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80.w,
            child: CustomText(
              label,
              fontSize: CustomConsts.h6,
              color: CustomColors.color313131.withOpacity(0.7),
            ),
          ),
          Expanded(
            child: CustomText(
              value,
              fontSize: CustomConsts.h6,
              fontWeight: CustomConsts.medium,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddTransactionDialog() {
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController amountController = TextEditingController();
    final TextEditingController noteController = TextEditingController();
    
    bool isExpense = true;
    String selectedCategory = controller.expenseCategories[0];
    DateTime selectedDate = DateTime.now();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Container(
          width: Get.width * 0.9,
          padding: EdgeInsets.all(20.w),
          child: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header với icon
                    Center(
                      child: Container(
                        width: 50.w,
                        height: 50.w,
                        decoration: BoxDecoration(
                          color: CustomColors.color06b252.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.add_chart,
                          color: CustomColors.color06b252,
                          size: 30.w,
                        ),
                      ),
                    ),
                    10.verticalSpace,
                    Center(
                      child: CustomText(
                        'Thêm giao dịch mới',
                        fontSize: CustomConsts.h4,
                        fontWeight: CustomConsts.bold,
                      ),
                    ),
                    20.verticalSpace,

                    // Loại giao dịch với animation
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      padding: EdgeInsets.all(5.w),
                      child: Row(
                        children: [
                          Expanded(
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              child: ElevatedButton(
                                onPressed: () => setState(() {
                                  isExpense = true;
                                  selectedCategory = controller.expenseCategories[0];
                                }),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isExpense 
                                      ? Colors.red 
                                      : Colors.transparent,
                                  elevation: 0,
                                  padding: EdgeInsets.symmetric(vertical: 12.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.remove_circle_outline,
                                      color: isExpense ? Colors.white : Colors.grey,
                                      size: 20.w,
                                    ),
                                    8.horizontalSpace,
                                    CustomText(
                                      'Chi phí',
                                      color: isExpense ? Colors.white : Colors.grey,
                                      fontSize: CustomConsts.h6,
                                      fontWeight: isExpense ? CustomConsts.bold : CustomConsts.medium,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              child: ElevatedButton(
                                onPressed: () => setState(() {
                                  isExpense = false;
                                  selectedCategory = controller.incomeCategories[0];
                                }),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: !isExpense 
                                      ? CustomColors.color06b252 
                                      : Colors.transparent,
                                  elevation: 0,
                                  padding: EdgeInsets.symmetric(vertical: 12.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_circle_outline,
                                      color: !isExpense ? Colors.white : Colors.grey,
                                      size: 20.w,
                                    ),
                                    8.horizontalSpace,
                                    CustomText(
                                      'Thu nhập',
                                      color: !isExpense ? Colors.white : Colors.grey,
                                      fontSize: CustomConsts.h6,
                                      fontWeight: !isExpense ? CustomConsts.bold : CustomConsts.medium,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    20.verticalSpace,
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          final number = int.tryParse(value.replaceAll(RegExp(r'[^0-9]'), ''));
                          if (number != null) {
                            amountController.text = NumberFormat.currency(
                              locale: 'vi_VN',
                              symbol: '',
                              decimalDigits: 0,
                            ).format(number);
                            amountController.selection = TextSelection.fromPosition(
                              TextPosition(offset: amountController.text.length),
                            );
                          }
                        }
                      },
                      decoration: InputDecoration(
                        labelText: 'Số tiền',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(color: CustomColors.color06b252),
                        ),
                        prefixIcon: Icon(
                          Icons.monetization_on_outlined,
                          color: CustomColors.color06b252,
                        ),
                        suffixText: 'đ',
                        suffixStyle: TextStyle(
                          color: CustomColors.color06b252,
                          fontWeight: CustomConsts.bold,
                        ),
                      ),
                    ),
                    15.verticalSpace,

                    // Mô tả
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Mô tả',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(color: CustomColors.color06b252),
                        ),
                        prefixIcon: Icon(
                          Icons.description_outlined,
                          color: CustomColors.color06b252,
                        ),
                      ),
                    ),
                    15.verticalSpace,

                    // Ngày với giao diện mới
                    InkWell(
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: CustomColors.color06b252,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null) {
                          setState(() => selectedDate = picked);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              color: CustomColors.color06b252,
                              size: 20.w,
                            ),
                            15.horizontalSpace,
                            CustomText(
                              DateFormat('dd/MM/yyyy').format(selectedDate),
                              fontSize: CustomConsts.h6,
                            ),
                            Spacer(),
                            Icon(
                              Icons.arrow_drop_down,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                    15.verticalSpace,

                    // Nút lưu với hiệu ứng
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => Get.back(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[200],
                              elevation: 0,
                              padding: EdgeInsets.symmetric(vertical: 15.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            child: CustomText(
                              'Hủy',
                              color: CustomColors.color313131.withOpacity(0.7),
                              fontSize: CustomConsts.h5,
                              fontWeight: CustomConsts.bold,
                            ),
                          ),
                        ),
                        10.horizontalSpace,
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (descriptionController.text.isEmpty || 
                                  amountController.text.isEmpty) {
                                Get.snackbar(
                                  'Thông báo',
                                  'Vui lòng điền đầy đủ thông tin',
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                  snackPosition: SnackPosition.TOP,
                                  margin: EdgeInsets.all(10.w),
                                  borderRadius: 10.r,
                                  icon: Icon(Icons.error_outline, color: Colors.white),
                                );
                                return;
                              }

                              final amount = double.tryParse(
                                amountController.text.replaceAll(RegExp(r'[^0-9]'), '')
                              );
                              if (amount == null) {
                                Get.snackbar(
                                  'Thông báo',
                                  'Số tiền không hợp lệ',
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                  snackPosition: SnackPosition.TOP,
                                  margin: EdgeInsets.all(10.w),
                                  borderRadius: 10.r,
                                  icon: Icon(Icons.error_outline, color: Colors.white),
                                );
                                return;
                              }

                              controller.addNewTransaction(
                                DiaryTransaction(
                                  id: controller.generateTransactionId(),
                                  date: selectedDate,
                                  description: descriptionController.text,
                                  amount: amount,
                                  isExpense: isExpense,
                                  category: selectedCategory,
                                  note: noteController.text.isEmpty ? null : noteController.text,
                                ),
                              );
                              Get.back();
                              Get.snackbar(
                                'Thành công',
                                'Đã thêm giao dịch mới',
                                backgroundColor: CustomColors.color06b252,
                                colorText: Colors.white,
                                snackPosition: SnackPosition.TOP,
                                margin: EdgeInsets.all(10.w),
                                borderRadius: 10.r,
                                icon: Icon(Icons.check_circle, color: Colors.white),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: CustomColors.color06b252,
                              elevation: 0,
                              padding: EdgeInsets.symmetric(vertical: 15.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            child: CustomText(
                              'Lưu',
                              color: Colors.white,
                              fontSize: CustomConsts.h5,
                              fontWeight: CustomConsts.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
