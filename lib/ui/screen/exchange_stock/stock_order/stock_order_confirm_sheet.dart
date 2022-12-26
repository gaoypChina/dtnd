import 'package:cached_network_image/cached_network_image.dart';
import 'package:dtnd/=models=/exchange.dart';
import 'package:dtnd/=models=/response/stock_model.dart';
import 'package:dtnd/=models=/side.dart';
import 'package:dtnd/=models=/ui_model/user_cmd.dart';
import 'package:dtnd/config/service/app_services.dart';
import 'package:dtnd/generated/l10n.dart';
import 'package:dtnd/ui/theme/app_color.dart';
import 'package:dtnd/ui/theme/app_textstyle.dart';
import 'package:dtnd/ui/widget/button/single_color_text_button.dart';
import 'package:dtnd/ui/widget/icon/sheet_header.dart';
import 'package:dtnd/ui/widget/icon/stock_circle_icon.dart';
import 'package:dtnd/utilities/num_utils.dart';
import 'package:dtnd/utilities/string_util.dart';
import 'package:flutter/material.dart';

import 'data/order_data.dart';

class StockOrderConfirmSheet extends StatefulWidget {
  const StockOrderConfirmSheet({
    super.key,
    required this.stockModel,
    required this.orderData,
  });
  final StockModel stockModel;
  final OrderData orderData;
  @override
  State<StockOrderConfirmSheet> createState() => _StockOrderConfirmSheetState();
}

class _StockOrderConfirmSheetState extends State<StockOrderConfirmSheet> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SheetHeader(
              title: S.of(context).order_confirm,
              backData: widget.orderData,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    StockCirleIcon(
                      stockCode: widget.stockModel.stock.stockCode,
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.stockModel.stock.stockCode,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          widget.stockModel.stock.postTo!.name,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    color: widget.orderData.side.isBuy
                        ? AppColors.accent_light_01
                        : AppColors.accent_light_03,
                  ),
                  child: Text(
                    widget.orderData.side.name(context).toUpperCase(),
                    style: AppTextStyle.titleSmall_14.copyWith(
                      color: widget.orderData.side.isBuy
                          ? AppColors.semantic_01
                          : AppColors.semantic_03,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                color: AppColors.neutral_06,
              ),
              child: Column(
                children: [
                  _Row(
                    label: S.of(context).volumn,
                    value: widget.orderData.volumn.toString(),
                  ),
                  const SizedBox(height: 8),
                  _Row(
                    label: widget.orderData.side.isBuy
                        ? S.of(context).buy_price
                        : S.of(context).sell_price,
                    value: widget.orderData.price,
                  ),
                  const SizedBox(height: 8),
                  _Row(
                    label: S.of(context).order_type,
                    value: widget.orderData.orderType.detailName,
                  ),
                  const SizedBox(height: 8),
                  _Row(
                    label: S.of(context).exchange_total,
                    value: widget.orderData.exchangeTotal?.toString(),
                    valueColor: AppColors.primary_01,
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  S.of(context).period_of_validity,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: SingleColorTextButton(
                    text: S.of(context).confirm.toUpperCase(),
                    color: AppColors.semantic_01,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.label,
    this.value,
    this.valueColor,
  });
  final String label;
  final String? value;
  final Color? valueColor;
  @override
  Widget build(BuildContext context) {
    final textheme = Theme.of(context).textTheme;
    final labelTheme = textheme.titleSmall!;
    final valueTheme = textheme.bodyMedium!
        .copyWith(fontWeight: FontWeight.w600, color: valueColor);
    String valueTxt;
    if (value == null) {
      valueTxt = "-";
    } else if (value!.isNum) {
      valueTxt = NumUtils.formatDoubleString(value);
    } else {
      valueTxt = value!;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: labelTheme,
        ),
        Text(
          valueTxt,
          style: valueTheme,
        ),
      ],
    );
  }
}
