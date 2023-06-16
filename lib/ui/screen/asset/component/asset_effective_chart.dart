import 'dart:math';

import 'package:dtnd/=models=/response/account/asset_chart_element.dart';
import 'package:dtnd/=models=/response/stock_trading_history.dart';
import 'package:dtnd/ui/theme/app_color.dart';
import 'package:dtnd/utilities/charts/chart_data_mixin.dart';
import 'package:dtnd/utilities/charts_util.dart';
import 'package:dtnd/utilities/num_utils.dart';
import 'package:dtnd/utilities/time_utils.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';

final simpleCurrencyFormatter =
    charts.BasicNumericTickFormatterSpec.fromNumberFormat(
        NumberFormat.compact());
const percentageFormatter = PercentTickFormatterSpec();

class AssetEffectiveChart extends StatefulWidget {
  const AssetEffectiveChart({super.key, this.datas, this.indexDatas});
  final List<AssetChartElementModel>? datas;
  final StockTradingHistory? indexDatas;
  @override
  State<AssetEffectiveChart> createState() => _AssetEffectiveChartState();
}

class _AssetEffectiveChartState extends State<AssetEffectiveChart>
    with ChartDatasMixin {
  final Random random = Random();
  static const secondaryMeasureAxisId = 'secondaryMeasureAxisId';

  late List<AssetChartElementModel> datas;
  late List<num> assetPercents;
  late List<num> indexPercents;
  late List<OhlcHistoryItem>? indexDatas;
  late List<charts.Series<dynamic, DateTime>> assetSeriesList;
  DateTime start = DateTime.now().subtract(const Duration(days: 1));
  DateTime end = DateTime.now();
  @override
  void initState() {
    super.initState();
    _generateChartData();
  }

  @override
  void didUpdateWidget(covariant AssetEffectiveChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    _generateChartData();
  }

  void _generateChartData() {
    if (mounted) {
      setState(() {
        datas = widget.datas ?? [];
        if (datas.isNotEmpty) {
          start = datas.first.cTRADINGDATE;
          end = datas.last.cTRADINGDATE;
          assetPercents = [datas.first.cDAYPROFITRATE];
          for (var element in datas) {
            assetPercents.add(assetPercents.last + element.cDAYPROFITRATE);
          }
        }
        assetSeriesList = [
          charts.Series(
            id: "Tài sản",
            data: datas,
            domainFn: (data, _) => data.cTRADINGDATE,
            measureFn: (_, index) => assetPercents.elementAt(index!),
            seriesColor: charts.ColorUtil.fromDartColor(AppColors.semantic_03),
          )..setAttribute(charts.measureAxisIdKey, secondaryMeasureAxisId),
          // charts.Series(
          //   id: "VN30",
          //   data: datas,
          //   domainFn: (data, _) => data.cTRADINGDATE,
          //   measureFn: (data, _) => data.cCASHBALANCE,
          //   seriesColor: charts.ColorUtil.fromDartColor(AppColors.primary_01),
          // )..setAttribute(charts.measureAxisIdKey, secondaryMeasureAxisId),
          // // charts.Series(
          // //   id: "Nợ",
          // //   data: datas,
          // //   domainFn: (data, _) => data.cTRADINGDATE,
          // //   measureFn: (data, _) => data.cLOANBALANCE,
          // //   seriesColor: charts.ColorUtil.fromDartColor(AppColors.semantic_03),
          // // )..setAttribute(charts.measureAxisIdKey, secondaryMeasureAxisId),
          // charts.Series(
          //   id: "Giá trị CK",
          //   data: datas,
          //   domainFn: (data, _) => data.cTRADINGDATE,
          //   measureFn: (data, _) => data.cSHARECLOSEVALUE,
          //   seriesColor: charts.ColorUtil.fromDartColor(AppColors.semantic_01),
          // )..setAttribute(charts.measureAxisIdKey, secondaryMeasureAxisId),
        ];
      });
      if (widget.indexDatas != null) {
        indexDatas = historyToChartItem(widget.indexDatas!);
        print(indexDatas!.first.time.beginningOfDay.toString());
        print(datas.first.cTRADINGDATE.toString());
        print(indexDatas!.first.time.beginningOfDay
            .isSameDay(datas.first.cTRADINGDATE));
        if (indexDatas!.first.time.beginningOfDay
            .isSameDay(datas.first.cTRADINGDATE)) {
          indexPercents = [indexDatas!.first.percent];
        } else {
          final index = indexDatas!.indexWhere((element) =>
              element.time.beginningOfDay.isSameDay(datas.first.cTRADINGDATE));
          print(index);
          if (index > 0) {
            indexDatas!.removeRange(0, index);
            print(indexDatas!.first.time.beginningOfDay.toString());
            indexPercents = [indexDatas!.first.percent];
          } else {
            return;
          }
        }
        for (var element in indexDatas!) {
          print(indexPercents.last);
          print(element.percent);
          indexPercents.add(indexPercents.last + element.percent);
        }
        assetSeriesList.add(
          charts.Series(
            id: "VN30",
            data: indexDatas!,
            domainFn: (data, _) => (data.time as DateTime).beginningOfDay,
            measureFn: (_, index) => indexPercents.elementAt(index!),
            seriesColor: charts.ColorUtil.fromDartColor(AppColors.primary_01),
          )..setAttribute(charts.measureAxisIdKey, secondaryMeasureAxisId),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.bottomCenter,
      child: charts.TimeSeriesChart(
        assetSeriesList,
        animate: false,

        // Configure a stroke width to enable borders on the bars.
        // defaultRenderer: new charts.LineRendererConfig(
        //   // groupingType: charts.BarGroupingType.stacked,
        //   strokeWidthPx: 2.0,
        // ),
        // layoutConfig: charts.LayoutConfig(
        //   leftMarginSpec: charts.MarginSpec.fixedPixel(10),
        //   topMarginSpec: charts.MarginSpec.fixedPixel(0),
        //   rightMarginSpec: charts.MarginSpec.fixedPixel(10),
        //   bottomMarginSpec: charts.MarginSpec.fixedPixel(20),
        // ),
        defaultRenderer:
            charts.LineRendererConfig(includeArea: true, smoothLine: true),
        behaviors: [
          charts.SeriesLegend(
            // Positions for "start" and "end" will be left and right respectively
            // for widgets with a build context that has directionality ltr.
            // For rtl, "start" and "end" will be right and left respectively.
            // Since this example has directionality of ltr, the legend is
            // positioned on the right side of the chart.
            position: charts.BehaviorPosition.bottom,
            // By default, if the position of the chart is on the left or right of
            // the chart, [horizontalFirst] is set to false. This means that the
            // legend entries will grow as new rows first instead of a new column.
            horizontalFirst: true,
            // This defines the padding around each legend entry.
            cellPadding: const EdgeInsets.only(right: 4.0),
            // Set show measures to true to display measures in series legend,
            // when the datum is selected.
            // showMeasures: true,
            // Optionally provide a measure formatter to format the measure value.
            // If none is specified the value is formatted as a decimal.
            measureFormatter: (num? value) => "",
            // defaultHiddenSeries: const ["Nợ", "Tài sản"],
          ),
          charts.LinePointHighlighter(
              symbolRenderer: CustomTooltipRenderer(_ToolTipMgr.instance,
                  size: MediaQuery.of(context).size,
                  fontSize: 10) // add this line in behaviours
              ),
        ],
        selectionModels: [
          charts.SelectionModelConfig(
            updatedListener: (charts.SelectionModel model) {
              if (model.hasDatumSelection) {
                late final String time;
                try {
                  time =
                      "Ngày : ${TimeUtilities.commonTimeFormat.format(model.selectedDatum.first.datum.cTRADINGDATE)}";
                } catch (e) {
                  time =
                      "Ngày : ${TimeUtilities.commonTimeFormat.format(model.selectedDatum.first.datum.time)}";
                }
                final List<String> datas = [
                  time,
                ];
                for (var element in model.selectedDatum) {
                  final String label = element.series.id;
                  final String value;
                  switch (label) {
                    case "Tài sản":
                      value = NumUtils.formatDouble(
                          assetPercents.elementAt(element.index!));
                      break;
                    case "VN30":
                      value = NumUtils.formatDouble(
                          indexPercents.elementAt(element.index!));
                      break;
                    // case "Giá trị CK":
                    //   value =
                    //       NumUtils.formatDouble(element.datum.cSHARECLOSEVALUE);
                    //   break;
                    default:
                      value = "0";
                  }
                  final String data = "$label : $value%";
                  datas.add(data);
                }

                _ToolTipMgr.instance.setData(datas);
              }
            },
          ),
        ],
        dateTimeFactory: const charts.LocalDateTimeFactory(),
        domainAxis: charts.DateTimeAxisSpec(
          viewport: charts.DateTimeExtents(start: start, end: end),
          // tickProviderSpec:
          //     charts.DayTickProviderSpec(increments: [datas.length ~/ 3]),
          tickFormatterSpec:
              charts.BasicDateTimeTickFormatterSpec.fromDateFormat(
            DateFormat("dd-MM-yyyy"),
          ),
          renderSpec: charts.GridlineRendererSpec(
            labelOffsetFromAxisPx: 6,
            axisLineStyle: charts.LineStyleSpec(
              dashPattern: const [4],
              thickness: 1,
              color: charts.ColorUtil.fromDartColor(AppColors.neutral_03),
            ),
            labelStyle: const charts.TextStyleSpec(fontSize: 8),
            lineStyle: const charts.LineStyleSpec(dashPattern: [4]),
          ),
        ),
        primaryMeasureAxis: charts.NumericAxisSpec(
          tickProviderSpec:
              const charts.BasicNumericTickProviderSpec(zeroBound: false),
          tickFormatterSpec: simpleCurrencyFormatter,
        ),
        secondaryMeasureAxis: charts.NumericAxisSpec(
          tickProviderSpec:
              const charts.BasicNumericTickProviderSpec(zeroBound: false),
          tickFormatterSpec: simpleCurrencyFormatter,
          renderSpec: charts.GridlineRendererSpec(
            axisLineStyle: charts.LineStyleSpec(
              dashPattern: const [4],
              thickness: 1,
              color: charts.ColorUtil.fromDartColor(AppColors.neutral_03),
            ),
            labelStyle: const charts.TextStyleSpec(fontSize: 8),
            lineStyle: const charts.LineStyleSpec(dashPattern: [4]),
          ),
        ),
      ),
    );
  }
}

class PercentTickFormatterSpec implements charts.NumericTickFormatterSpec {
  const PercentTickFormatterSpec();
  @override
  PercentageTickFormatter createTickFormatter(charts.ChartContext context) {
    return const PercentageTickFormatter();
  }
}

class PercentageTickFormatter extends charts.SimpleTickFormatterBase<num> {
  const PercentageTickFormatter();

  @override
  String formatValue(num value) {
    if ((value % 1.0) != 0) {
      return "$value%";
    } else {
      return "${value.toInt()}%";
    }
  }

  @override
  bool operator ==(Object other) => other is PercentageTickFormatter;

  @override
  int get hashCode => 31;
}

class _ToolTipMgr extends TooltipData {
  _ToolTipMgr._intern();
  static final _ToolTipMgr instance = _ToolTipMgr._intern();
}
