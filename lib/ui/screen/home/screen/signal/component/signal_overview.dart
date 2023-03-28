import 'package:dtnd/=models=/response/stock_model.dart';
import 'package:dtnd/=models=/response/top_signal_detail_model.dart';
import 'package:dtnd/=models=/response/top_signal_stock_model.dart';
import 'package:dtnd/generated/l10n.dart';
import 'package:dtnd/ui/theme/app_color.dart';
import 'package:dtnd/ui/theme/app_textstyle.dart';
import 'package:dtnd/utilities/time_utils.dart';
import 'package:flutter/material.dart';

class SignalOverview extends StatelessWidget {
  const SignalOverview({super.key, this.detail});
  final TopSignalDetailModel? detail;
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              detail?.prefixIcon(size: 28) ?? Container(),
              const SizedBox(width: 10),
              Text(
                detail?.cSELLPRICE?.toString() ?? "-",
                style: AppTextStyle.headlineSmall_24
                    .copyWith(color: detail?.color),
              ),
              // const SizedBox(width: 10),
              // Text(
              //   "${NumUtils.formatInteger10(stockData.lot.value)} CP",
              //   style: AppTextStyle.labelMedium_12
              //       .copyWith(color: AppColors.neutral_03),
              // ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    S.of(context).buy_date,
                    style: AppTextStyle.labelSmall_10.copyWith(
                        color: AppColors.neutral_03,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 4),
                  Text(
                      detail?.cBUYDATE != null
                          ? TimeUtilities.commonTimeFormat
                              .format(detail!.cBUYDATE!)
                          : "-",
                      style: AppTextStyle.labelSmall_10),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Loại tín hiệu",
                    style: AppTextStyle.labelSmall_10.copyWith(
                        color: AppColors.neutral_03,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 4),
                  Text(detail?.cTYPE ?? "-", style: AppTextStyle.labelSmall_10),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: const BoxDecoration(
              color: AppColors.neutral_06,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _Column(
                  "Giá mua",
                  detail?.cBUYPRICE.toString() ?? "-",
                  textStyle: textTheme.titleSmall,
                ),
                const VerticalDivider(
                  thickness: 1,
                  width: 1,
                ),
                _Column(
                  "Lợi nhuận",
                  "${detail?.cPC ?? "-"}%",
                  textStyle: textTheme.titleSmall,
                ),
                const VerticalDivider(
                  thickness: 1,
                  width: 1,
                ),
                _Column(
                  "Rủi ro",
                  "${detail?.rUIRO ?? "-"}%",
                  textStyle: textTheme.titleSmall,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _Column extends StatelessWidget {
  const _Column(this.label, this.value, {this.textStyle});
  final String label;
  final String value;
  final TextStyle? textStyle;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style:
              AppTextStyle.labelMedium_12.copyWith(color: AppColors.neutral_03),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: textStyle ?? Theme.of(context).textTheme.titleSmall,
        )
      ],
    );
  }
}
