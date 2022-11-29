import 'package:dtnd/=models=/response/stock_model.dart';
import 'package:dtnd/generated/l10n.dart';
import 'package:dtnd/ui/screen/home/widget/home_section.dart';
import 'package:dtnd/ui/screen/stock_detail.dart/widget/bounce_price.dart';
import 'package:dtnd/ui/screen/stock_detail.dart/widget/financial_index.dart';
import 'package:dtnd/ui/screen/stock_detail.dart/widget/stock_detail_news.dart';
import 'package:dtnd/ui/screen/stock_detail.dart/widget/three_price.dart';
import 'package:flutter/material.dart';

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
    return Column(
      children: <Widget>[
        const SizedBox(
          height: 20,
        ),
        ThreePrices(
          stockModel: widget.stockModel,
        ),
        const SizedBox(
          height: 20,
        ),
        BoundPrice(
          stockModel: widget.stockModel,
        ),
        const SizedBox(
          height: 20,
        ),
        HomeSection(
          title: S.of(context).financial_index,
          child: const FinancialIndex(),
        ),
        const SizedBox(
          height: 20,
        ),
        HomeSection(
          title: S.of(context).news_and_events,
          child: StockDetailNews(
            stockCode: widget.stockModel.stock.stockCode,
          ),
        ),
      ],
    );
  }
}
