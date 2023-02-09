import 'package:dtnd/=models=/response/stock_model.dart';
import 'package:dtnd/config/service/app_services.dart';
import 'package:dtnd/data/implementations/data_center_service.dart';
import 'package:dtnd/generated/l10n.dart';
import 'package:dtnd/ui/screen/home/widget/simple_line_chart.dart';
import 'package:dtnd/ui/screen/stock_detail/stock_detail_screen.dart';
import 'package:dtnd/ui/theme/app_color.dart';
import 'package:dtnd/ui/theme/app_textstyle.dart';
import 'package:dtnd/ui/widget/icon/stock_icon.dart';
import 'package:dtnd/utilities/num_utils.dart';
import 'package:dtnd/utilities/responsive.dart';
import 'package:dtnd/utilities/time_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../home_controller.dart';

class HomeMarketOverview extends StatefulWidget {
  const HomeMarketOverview({super.key});
  @override
  State<HomeMarketOverview> createState() => _HomeMarketOverviewState();
}

class _HomeMarketOverviewState extends State<HomeMarketOverview>
    with SingleTickerProviderStateMixin {
  final HomeController homeController = HomeController();
  late final TabController _tabController;

  bool up = true;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ObxValue<Rx<bool>>((initialized) {
      if (!initialized.value) {
        return Center(
          child: Text(S.of(context).loading),
        );
      }
      final List<StockModel> data;
      switch (_tabController.index) {
        case 1:
          if (!up) {
            data = homeController.priceDecreaseToday;
          } else {
            data = homeController.priceIncreaseToday;
          }
          break;
        case 2:
          data = homeController.topVolumnToday;
          break;
        default:
          data = homeController.hotToday;
      }
      // Widget grid = SizedBox(
      //   height: 72 * 3 + 16 * 2,
      //   child: GridView.builder(
      //     padding: const EdgeInsets.symmetric(horizontal: 16),
      //     itemCount: data.length,
      //     scrollDirection: Axis.horizontal,
      //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //       crossAxisCount: 3,
      //       mainAxisSpacing: 16,
      //       crossAxisSpacing: 16,
      //       childAspectRatio: 72 / (width - 32),
      //     ),
      //     itemBuilder: (context, index) => HomeMarketOverviewItem(
      //       data: data[index],
      //     ),
      //   ),
      // );

      final Widget sortArrow = Container(
        // color: Colors.green,
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            Opacity(
              opacity: up ? 1.0 : 0.3,
              child: const Icon(
                Icons.expand_less_rounded,
                size: 12,
              ),
            ),
            Opacity(
              opacity: !up ? 1.0 : 0.3,
              child: const Icon(
                Icons.expand_more_rounded,
                size: 12,
              ),
            ),
          ],
        ),
      );
      Widget list = Column(
        children: [
          for (int i = 0; i < data.length; i++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: SizedBox(
                height: 72,
                child: HomeMarketOverviewItem(
                  data: data[i],
                ),
              ),
            )
        ],
      );
      Widget grid = Column(
        children: [
          PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                labelPadding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                onTap: (value) async {
                  print(_tabController.indexIsChanging);
                  if (!_tabController.indexIsChanging && value == 1) {
                    up = !up;
                  }
                  setState(() {});
                  await homeController.changeList(data);
                  // setState(() {});
                },
                tabs: <Widget>[
                  const Text("🔥HOT"),
                  Row(
                    children: [
                      const Text("Top biến động"),
                      sortArrow,
                    ],
                  ),
                  const Text("Top khối lượng"),
                ],
              ),
            ),
          ),
          list,
        ],
      );
      return grid;
    }, homeController.topInitialized);
  }
}

class HomeMarketOverviewItem extends StatelessWidget {
  const HomeMarketOverviewItem({
    super.key,
    required this.data,
    this.onHold,
    this.onTap,
  });
  final StockModel data;
  final VoidCallback? onTap;
  final VoidCallback? onHold;
  @override
  Widget build(BuildContext context) {
    final themeMode = AppService.instance.themeMode.value;
    final double width = Responsive.getMaxWidth(context);
    return Material(
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      child: InkWell(
        onTap: onTap ??
            () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => StockDetailScreen(stockModel: data),
                )),
        onLongPress: onHold,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        child: Ink(
          // alignment: Alignment.center,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            color: themeMode.isDark ? AppColors.bg_2 : AppColors.neutral_07,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StockIcon(
                stockCode: data.stock.stockCode,
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    data.stock.stockCode,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  ObxValue<Rx<num?>>(
                    (lastPrice) {
                      return Text(
                        "${data.stockData.changePc}%",
                        style: AppTextStyle.labelMedium_12.copyWith(
                          fontWeight: FontWeight.w600,
                          color: data.stockData.color,
                        ),
                      );
                    },
                    data.stockData.lastPrice,
                  ),
                ],
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Container(
                  constraints: BoxConstraints(
                      minWidth: MediaQuery.of(context).size.width / 5,
                      maxWidth: MediaQuery.of(context).size.width / 4),
                  child: Obx(() {
                    data.stockData.lastPrice.value;
                    return SimpleLineChart(
                      data: data,
                      future: DataCenterService().getStockTradingHistory.call(
                          data.stock.stockCode,
                          "5",
                          TimeUtilities.beginningOfDay,
                          DateTime.now()),
                      // future: data.getTradingHistory(DataCenterService(),
                      //     resolution: "5", from: TimeUtilities.beginningOfDay),
                    );
                  }),
                ),
              ),
              const SizedBox(width: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ObxValue<Rx<num?>>(
                  //   (lastPrice) {
                  //     return Text(
                  //       "${lastPrice.value}",
                  //       style: AppTextStyle.labelMedium_12.copyWith(
                  //         fontWeight: FontWeight.w600,
                  //         color: data.stockData.color,
                  //       ),
                  //     );
                  //   },
                  //   data.stockData.lastPrice,
                  // ),
                  ObxValue<Rx<num?>>(
                    (lastPrice) {
                      return Row(
                        children: [
                          data.stockData.prefixIcon(size: 12),
                          Text(
                            " ${data.stockData.lastPrice}",
                            maxLines: 1,
                            style: AppTextStyle.labelMedium_12.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: data.stockData.color,
                            ),
                          )
                        ],
                      );
                    },
                    data.stockData.lastPrice,
                  ),

                  Obx(() {
                    return Text(
                      "${NumUtils.formatInteger10(data.stockData.lot.value)} CP",
                      style: AppTextStyle.labelMedium_12.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.neutral_03,
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
