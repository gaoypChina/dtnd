import 'dart:async';
import 'package:dtnd/=models=/response/inday_matched_order.dart';
import 'package:dtnd/=models=/response/stock_model.dart';
import 'package:dtnd/data/i_data_center_service.dart';
import 'package:dtnd/data/implementations/data_center_service.dart';
import 'package:dtnd/generated/l10n.dart';
import 'package:dtnd/ui/theme/app_color.dart';
import 'package:dtnd/ui/theme/app_image.dart';
import 'package:dtnd/ui/widget/icon/active_button.dart';
import 'package:dtnd/utilities/num_utils.dart';
import 'package:flutter/material.dart';

class TabMatchedDetail extends StatefulWidget {
  const TabMatchedDetail({
    super.key,
    required this.stockModel,
  });

  final StockModel stockModel;

  @override
  State<TabMatchedDetail> createState() => _TabMatchedDetailState();
}

class _TabMatchedDetailState extends State<TabMatchedDetail> {
  final IDataCenterService dataCenterService = DataCenterService();

  bool byTime = true;

  num maxVolumn = 0;

  StreamController<List<IndayMatchedOrder>> listMatchedOrder =
      StreamController<List<IndayMatchedOrder>>.broadcast();

  @override
  void initState() {
    super.initState();
    getIndayMatchedOrders();
  }

  void getIndayMatchedOrders() {
    dataCenterService
        .getIndayMatchedOrders(widget.stockModel.stock.stockCode)
        .then((list) {
      listMatchedOrder.sink.add(list);
    });
  }

  void changeMode(bool newValue) {
    if (byTime != newValue) {
      setState(() {
        byTime = newValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.of(context).matched_order_by_time,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.w700),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ActiveButton(
                    size: 12,
                    icon: AppImages.timer,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    isActive: () => byTime,
                    onActive: () => changeMode(true),
                    activeButtonColor: (themeMode) => AppColors.primary_01,
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                  ),
                  const SizedBox(width: 10),
                  ActiveButton(
                    size: 12,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    icon: AppImages.chart,
                    isActive: () => !byTime,
                    onActive: () => changeMode(false),
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                  ),
                ],
              )
            ],
          ),
        ),
        const _TabMatchedDetailHeader(),
        Expanded(
          child: StreamBuilder<List<IndayMatchedOrder>>(
              stream: listMatchedOrder.stream,
              initialData: const [],
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasData) {
                  var list = snapshot.data!;
                  widget.stockModel
                      .updateListMatchedOrder(list.reversed.toList());
                  maxVolumn = widget.stockModel.maxVolumnMatchedOrder;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: list.length,
                    itemBuilder: (BuildContext context, int index) {
                      var element = list[index];
                      return _TabMatchedDetailRow(
                        byTime: byTime,
                        data: element,
                        maxVolumn: maxVolumn,
                        colorFunct: widget.stockModel.stockData.getPriceColor,
                      );
                    },
                  );
                }
                return const SizedBox();
              }),
        ),
      ],
    );
  }
}

class _TabMatchedDetailRow extends StatelessWidget {
  const _TabMatchedDetailRow({
    required this.byTime,
    required this.data,
    required this.colorFunct,
    required this.maxVolumn,
  });

  final bool byTime;
  final IndayMatchedOrder data;
  final Function colorFunct;
  final num maxVolumn;

  @override
  Widget build(BuildContext context) {
    if (!byTime) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        child: DefaultTextStyle(
          style: Theme.of(context).textTheme.labelMedium!,
          child: Row(
            children: [
              SizedBox(
                width: 40,
                child: Text(
                  NumUtils.formatDouble(data.matchPrice),
                  style: TextStyle(color: colorFunct.call(data.matchPrice)),
                  textAlign: TextAlign.right,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                  child: Row(
                children: [
                  Flexible(
                    flex: data.matchVolume.toInt(),
                    child: Container(
                      height: 6,
                      decoration: const BoxDecoration(
                        borderRadius:
                            BorderRadius.horizontal(right: Radius.circular(4)),
                        color: AppColors.primary_01,
                      ),
                      alignment: Alignment.bottomCenter,
                    ),
                  ),
                  Flexible(
                    flex: maxVolumn.toInt() - data.matchVolume.toInt(),
                    child: Container(),
                  )
                ],
              )),
              const SizedBox(width: 10),
              SizedBox(
                width: 50,
                child: Text(
                  NumUtils.formatInteger10(data.matchVolume),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.labelMedium!,
        child: Row(
          children: [
            Expanded(
                child: Text(
              data.time,
              textAlign: TextAlign.left,
            )),
            Expanded(
                child: Text(
              NumUtils.formatInteger10(data.matchVolume),
              textAlign: TextAlign.right,
            )),
            Expanded(
                child: Text(
              NumUtils.formatDouble(data.matchPrice),
              style: TextStyle(color: colorFunct.call(data.matchPrice)),
              textAlign: TextAlign.right,
            )),
            Expanded(
                child: Text(
              "${NumUtils.formatDouble(data.priceChange)}%",
              style: TextStyle(color: colorFunct.call(data.matchPrice)),
              textAlign: TextAlign.right,
            )),
          ],
        ),
      ),
    );
  }
}

class _TabMatchedDetailHeader extends StatelessWidget {
  const _TabMatchedDetailHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.labelMedium!,
        child: Row(
          children: [
            Expanded(child: Text(S.of(context).time)),
            Expanded(
                child: Text(
              S.of(context).matched_vol,
              textAlign: TextAlign.right,
            )),
            Expanded(
                child: Text(
              S.of(context).matched_price,
              textAlign: TextAlign.right,
            )),
            Expanded(
                child: Text(
              S.of(context).vol_analysis,
              textAlign: TextAlign.right,
            )),
          ],
        ),
      ),
    );
  }
}
