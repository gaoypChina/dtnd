import 'package:dtnd/=models=/response/stock_model.dart';
import 'package:dtnd/ui/screen/stock_detail/widget/bounce_price.dart';
import 'package:dtnd/ui/screen/stock_detail/widget/three_price.dart';
import 'package:dtnd/ui/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel2/sliding_up_panel2.dart';

class TabTradingBoard extends StatefulWidget {
  const TabTradingBoard({
    super.key,
    required this.stockModel,
  });

  final StockModel stockModel;

  @override
  State<TabTradingBoard> createState() => _TabTradingBoardState();
}

class _TabTradingBoardState extends State<TabTradingBoard> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Bảng giá",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ThreePrices(stockModel: widget.stockModel),
          ),
          const Divider(
            thickness: 0.5,
            color: AppColors.neutral_04,
            height: 20,
            endIndent: 32,
            indent: 32,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Thấp',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontSize: 10, color: AppColors.neutral_03),
                    ),
                    Text(
                      widget.stockModel.stockData.lowPrice.value?.toString() ??
                          "",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.semantic_03,
                          fontWeight: FontWeight.w600),
                    )
                  ],
                )),
                Expanded(
                    child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Trung bình',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 10, color: AppColors.neutral_03),
                      ),
                      Text(
                        widget.stockModel.stockData.avePrice.value
                                ?.toString() ??
                            "",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.semantic_02,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                )),
                Expanded(
                    child: Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cao',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 10, color: AppColors.neutral_03),
                      ),
                      Text(
                        widget.stockModel.stockData.highPrice.value
                                ?.toString() ??
                            "",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.semantic_01,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
