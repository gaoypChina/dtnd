// ignore_for_file: constant_identifier_names

import 'dart:async';

import 'package:dtnd/=models=/response/stock_model.dart';
import 'package:dtnd/config/service/app_services.dart';
import 'package:dtnd/data/i_data_center_service.dart';
import 'package:dtnd/data/i_user_service.dart';
import 'package:dtnd/data/implementations/data_center_service.dart';
import 'package:dtnd/data/implementations/user_service.dart';
import 'package:dtnd/generated/l10n.dart';
import 'package:dtnd/ui/screen/exchange_stock/stock_order/sheet/stock_order_sheet.dart';
import 'package:dtnd/ui/screen/login/login_screen.dart';
import 'package:dtnd/ui/screen/stock_detail/enum/detail_tab_enum.dart';
import 'package:dtnd/ui/screen/stock_detail/sheet/business_infomation_sheet.dart';
import 'package:dtnd/ui/screen/stock_detail/tab/finance_index_tab.dart';
import 'package:dtnd/ui/screen/stock_detail/tab/overview_tab.dart';
import 'package:dtnd/ui/screen/stock_detail/widget/component/price_alert.dart';
import 'package:dtnd/ui/screen/stock_detail/widget/component/stock_detail_appbar.dart';
import 'package:dtnd/ui/screen/stock_detail/widget/financial_index.dart';
import 'package:dtnd/ui/screen/stock_detail/widget/stock_detail_chart.dart';
import 'package:dtnd/ui/screen/stock_detail/widget/stock_detail_news.dart';
import 'package:dtnd/ui/screen/stock_detail/widget/stock_detail_overview.dart';
import 'package:dtnd/ui/screen/stock_detail/widget/tab_trading_board.dart';
import 'package:dtnd/ui/theme/app_color.dart';
import 'package:dtnd/ui/theme/app_image.dart';
import 'package:dtnd/ui/widget/overlay/login_first_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sliding_up_panel2/sliding_up_panel2.dart';

import '../exchange_stock/stock_order/business/stock_order_cmd.dart';
import '../home/widget/home_section.dart';

class StockDetailScreen extends StatefulWidget {
  const StockDetailScreen({
    Key? key,
    required this.stockModel,
  }) : super(key: key);
  final StockModel stockModel;

  @override
  State<StockDetailScreen> createState() => _StockDetailScreenState();
}

class _StockDetailScreenState extends State<StockDetailScreen>
    with SingleTickerProviderStateMixin {
  final IDataCenterService dataCenterService = DataCenterService();
  final IUserService userService = UserService();
  late final TabController _tabController;

  late final ScrollController scrollController;
  late final PanelController panelController;

  bool initialized = false;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    scrollController = ScrollController();
    panelController = PanelController();
    super.initState();
    initData();
  }

  void initData() async {
    await getStockIndayTradingHistory();
    await getSecurityBasicInfo();
    setState(() {
      initialized = true;
    });
  }

  Future<void> getStockIndayTradingHistory() async {
    widget.stockModel.indayTradingHistory.value = await dataCenterService
        .getStockIndayTradingHistory(widget.stockModel.stock.stockCode);
  }

  Future<void> getSecurityBasicInfo() async {
    widget.stockModel.securityBasicInfo.value = await dataCenterService
        .getSecurityBasicInfo(widget.stockModel.stock.stockCode);
  }

  Future<void> getStockRankingFinancialIndex() async {
    widget.stockModel.stockRankingFinancialIndex.value = await dataCenterService
        .getStockRankingFinancialIndex(widget.stockModel.stock.stockCode);
  }

  Future<void> getIndayMatchedOrders() async {
    final listMatchedOrder = await dataCenterService
        .getIndayMatchedOrders(widget.stockModel.stock.stockCode);
    widget.stockModel.updateListMatchedOrder(listMatchedOrder);
  }

  void _onFABTapped() async {
    // print("userService.isLogin ${userService.isLogin}");
    if (!userService.isLogin) {
      final toLogin = await showDialog<bool>(
        context: context,
        builder: (context) {
          return const LoginFirstCatalog();
        },
      );
      if (toLogin ?? false) {
        if (!mounted) return;
        final result = await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ));
        if (result) {
          return _onFABTapped();
        }
      }
    } else {
      // return StockOrderISheet(widget.stockModel).showSheet(context, );
      StockOrderISheet(widget.stockModel).show(
          context,
          StockOrderSheet(
            stockModel: widget.stockModel,
            orderData: null,
          ));
    }
  }

  void _onAppbarTap() {
    BusinessInformationISheet(widget.stockModel).show(
        context,
        BusinessInformationSheet(
          stockModel: widget.stockModel,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StockDetailAppbar(
        stockModel: widget.stockModel,
        onTap: _onAppbarTap,
      ),
      // appBar: StockDetailAppbar(stock: widget.stockModel.stock),
      body: ListView(children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: StockDetailOverview(stockModel: widget.stockModel),
        ),
        SizedBox(
            height: 200,
            width: MediaQuery.of(context).size.width,
            child: StockDetailChart(stockModel: widget.stockModel)),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: PriceAlert(),
        ),
        TabTradingBoard(
          stockModel: widget.stockModel,
        )
      ]),
      backgroundColor: AppColors.bg_1,
      floatingActionButton: SizedBox.square(
        dimension: 40,
        child: Material(
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          child: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(6)),
            onTap: _onFABTapped,
            child: Ink(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(6)),
                color: AppColors.primary_01,
              ),
              child: SvgPicture.asset(
                AppImages.arrange_circle,
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
