import 'package:dtnd/config/service/app_services.dart';
import 'package:dtnd/generated/l10n.dart';
import 'package:dtnd/ui/screen/virtual_assistant/va_access_element.dart';
import 'package:dtnd/ui/screen/virtual_assistant/va_filter/virtual_assistant_filter_screen.dart';
import 'package:dtnd/ui/screen/virtual_assistant/va_home/trash_component.dart';
import 'package:dtnd/ui/screen/virtual_assistant/va_home/va_controller.dart';
import 'package:dtnd/ui/screen/virtual_assistant/va_volatolity_warning/va_volatolity_warning_screen.dart';
import 'package:dtnd/ui/theme/app_color.dart';
import 'package:dtnd/ui/theme/app_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../utilities/responsive.dart';
import '../../../theme/app_textstyle.dart';
import '../../../widget/my_appbar.dart';

enum VAFeature {
  stockFilter,
  volatilityWarning,
}

extension VirtualAssistantFeatureX on VAFeature {
  String get name {
    switch (this) {
      case VAFeature.stockFilter:
        return S.current.filter_stock;
      case VAFeature.volatilityWarning:
        return "Lọc tín hiệu";
    }
  }

  String get iconPath {
    switch (this) {
      case VAFeature.stockFilter:
        return AppImages.chart2_icon;
      case VAFeature.volatilityWarning:
        return AppImages.directbox_receive_icon;
    }
  }

  VoidCallback onPressed(BuildContext context) {
    switch (this) {
      case VAFeature.stockFilter:
        return () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const AssistantStockFilterScreen(),
            ));
      case VAFeature.volatilityWarning:
        return () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const VAVolatilityWarningScreen(),
            ));
    }
  }
}

class VaScreen extends GetView<VAController> {
  final VAController avController = Get.put(VAController());

  VaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeMode = AppService.instance.themeMode.value;

    return Scaffold(
      appBar: MyAppBar(
        leading: Align(
          alignment: Alignment.centerRight,
          child: SizedBox.square(
            dimension: 32,
            child: InkWell(
              onTap: () =>
                  Navigator.of(context).popUntil((route) => route.isFirst),
              borderRadius: const BorderRadius.all(Radius.circular(6)),
              child: Ink(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                  color: themeMode.isLight
                      ? AppColors.neutral_05
                      : AppColors.neutral_01,
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColors.primary_01,
                  size: 10,
                ),
              ),
            ),
          ),
        ),
        title: S.of(context).DTND_assistant,
        actions: [
          GestureDetector(
            onTap: () {
              // cái này là khi click vào cái chấm ba chấm ...
            },
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              child: SvgPicture.asset(AppImages.icon_dot),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  VaAccess.values.length,
                  (index) => VaAccessElement(
                    value: VaAccess.values.elementAt(index),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Text(
                  //   "Danh mục theo dõi (5/15)",
                  //   style: AppTextStyle.titleMedium_16
                  //       .copyWith(color: AppColors.neu_01),
                  // ),
                  // const SizedBox(width: 12),
                  // InkWell(
                  //   child: SizedBox.square(
                  //     dimension: 25,
                  //     child: SvgPicture.asset(AppImages.icon_setting),
                  //   ),
                  //   onTap: () {
                  //     const InfoISheet().show(
                  //       context,
                  //       SafeArea(
                  //         child: Padding(
                  //           padding: const EdgeInsets.symmetric(
                  //               horizontal: 16, vertical: 20),
                  //           child: Column(
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             children: [
                  //               const SheetHeader(
                  //                 title: 'Cài đặt thiết lập danh mục',
                  //                 implementBackButton: false,
                  //               ),
                  //               const SizedBox(
                  //                 height: 16,
                  //               ),
                  //               const Text('Danh mục của bạn'),
                  //               const SizedBox(
                  //                 height: 16,
                  //               ),
                  //               const Text('Rủi ro tối đa'),
                  //               const SizedBox(
                  //                 height: 16,
                  //               ),
                  //               IntervalInputCustom2(
                  //                 controller: avController.priceController,
                  //                 labelText: 'Rủi ro tối đa',
                  //                 defaultValue: 0,
                  //               ),
                  //               const SizedBox(
                  //                 height: 10,
                  //               ),
                  //               Row(
                  //                 mainAxisAlignment:
                  //                     MainAxisAlignment.spaceBetween,
                  //                 children: [
                  //                   Text(
                  //                     'Tỷ lệ chốt cắt lỗ',
                  //                     style: AppTextStyle.labelMedium_12,
                  //                   ),
                  //                   InkWell(
                  //                     child: SvgPicture.asset(
                  //                         AppImages.icon_setting_va),
                  //                     onTap: () {
                  //                       const ListBotSheet().show(
                  //                         context,
                  //                         SafeArea(
                  //                           child: Padding(
                  //                             padding:
                  //                                 const EdgeInsets.symmetric(
                  //                                     horizontal: 16,
                  //                                     vertical: 20),
                  //                             child: Column(
                  //                               crossAxisAlignment:
                  //                                   CrossAxisAlignment.start,
                  //                               children: const [
                  //                                 SheetHeader(
                  //                                   title: 'Danh sách bot',
                  //                                   implementBackButton: true,
                  //                                 ),
                  //                                 SizedBox(
                  //                                   height: 16,
                  //                                 ),
                  //                               ],
                  //                             ),
                  //                           ),
                  //                         ),
                  //                       );
                  //                     },
                  //                   )
                  //                 ],
                  //               ),
                  //               const SizedBox(height: 16),
                  //               Row(
                  //                 children: [
                  //                   Expanded(
                  //                     child: IntervalInput(
                  //                       controller:avController.priceController,
                  //                       labelText: S.of(context).price,
                  //                       interval: (value) => 0.1,
                  //                       defaultValue: 0,
                  //                       // onChanged: onChangedPrice,
                  //                       // onTextChanged: _onPriceChangeHandler,
                  //                     ),
                  //                   ),
                  //                   const SizedBox(width: 16),
                  //                   Expanded(
                  //                     child: Material(
                  //                       child: TextFormField(
                  //                         controller: avController.priceController,
                  //                         validator: (value) => '',
                  //                         // onChanged: ()=>{},
                  //                         keyboardType: const TextInputType
                  //                             .numberWithOptions(decimal: true),
                  //                         inputFormatters: [
                  //                           ThousandsSeparatorInputFormatter()
                  //                         ],
                  //                         decoration: InputDecoration(
                  //                           labelText: 'Bán khi giá',
                  //                           contentPadding:
                  //                               const EdgeInsets.only(left: 50),
                  //                           floatingLabelBehavior:
                  //                               FloatingLabelBehavior.always,
                  //                           floatingLabelAlignment:
                  //                               FloatingLabelAlignment.start,
                  //                           prefixIcon: Padding(
                  //                             padding: const EdgeInsets.all(18),
                  //                             child: SvgPicture.asset(AppImages
                  //                                 .icon_greater_than_or_equal_to),
                  //                             // SvgPicture.asset(
                  //                             //     AppImages.icon_downt),
                  //                             // SvgPicture.asset(
                  //                             //     AppImages.icon_line),
                  //                           ),
                  //                           suffixIcon: Padding(
                  //                             padding:
                  //                                 const EdgeInsets.all(8.0),
                  //                             child: SvgPicture.asset(
                  //                                 AppImages.icon_percent),
                  //                           ),
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ],
                  //               ),
                  //               const SizedBox(height: 16),
                  //               Text('Khối lượng'),
                  //               const SizedBox(height: 16),
                  //               Row(
                  //                 children: [
                  //                   Expanded(
                  //                     child: TextFormField(
                  //                       controller: avController.priceController,
                  //                       keyboardType: const TextInputType
                  //                           .numberWithOptions(decimal: true),
                  //                       inputFormatters: [
                  //                         ThousandsSeparatorInputFormatter()
                  //                       ],
                  //                       decoration: const InputDecoration(
                  //                         contentPadding: EdgeInsets.only(
                  //                             left: 15, right: 15),
                  //                         labelText: 'Khối lượng cố định',
                  //                         floatingLabelBehavior:
                  //                             FloatingLabelBehavior.always,
                  //                         floatingLabelAlignment:
                  //                             FloatingLabelAlignment.start,
                  //                       ),
                  //                     ),
                  //                   ),
                  //                   const SizedBox(width: 16),
                  //                   Expanded(
                  //                     child: IntervalInputCustom2(
                  //                       controller: avController.volumeController,
                  //                       labelText: 'Khối lượng theo tỷ lệ',
                  //                       validator: AppValidator.volumnValidator,
                  //                       // onChanged: onChangeVol,
                  //                     ),
                  //                   ),
                  //                 ],
                  //               ),
                  //               const SizedBox(height: 16),
                  //               InkWell(
                  //                 child: Container(
                  //                   height: 48,
                  //                   decoration: BoxDecoration(
                  //                     borderRadius: BorderRadius.circular(6),
                  //                     color: AppColors.color_secondary,
                  //                   ),
                  //                   alignment: Alignment.center,
                  //                   child: Text(
                  //                     'Lưu',
                  //                     style: AppTextStyle.textButtonTextStyle
                  //                         .copyWith(
                  //                             color: AppColors.neutral_05),
                  //                   ),
                  //                 ),
                  //                 onTap: () {
                  //                   // Click để lưu
                  //                 },
                  //               )
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //     );
                  //   },
                  // ),
                  // đoạn này để thể hiện biểu đồ nhé

                  // TrashComponentAv(snapshotData:  )
                  Column(
                    children: [
                      for (int i = 0; i < (avController.data?.length ?? 0); i++)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          child: SizedBox(
                            height: 72,
                            child: TrashComponentAv(
                              snapshotData: avController.data![i],
                            ),
                          ),
                        )
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 180),
            SizedBox(
              height: Responsive.getMaxWidth(context) / 3,
              child: Column(
                children: [
                  const Text(
                    'Danh mục chưa có dữ liệu',
                    style: TextStyle(fontSize: 15),
                  ),
                  InkWell(
                    child: const Text(
                      'Lọc cổ phiếu',
                      style:
                          TextStyle(color: AppColors.semantic_01, fontSize: 15),
                    ),
                    onTap: () {
                      Navigator.of(context).push<void>(
                        MaterialPageRoute(
                            builder: (context) =>
                                const AssistantStockFilterScreen()),
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.neutral_05)),
          color: AppColors.neutral_06,
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.only(
                    top: 16, bottom: 36, right: 16, left: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: AppColors.color_secondary,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Bắt đầu',
                            style: AppTextStyle.textButtonTextStyle
                                .copyWith(color: AppColors.neutral_05),
                          ),
                        ),
                        onTap: () {
                          // chỗ này click vào nút bắt đầu
                        },
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
