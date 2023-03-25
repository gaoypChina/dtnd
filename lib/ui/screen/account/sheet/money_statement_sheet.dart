import 'package:dtnd/=models=/response/cash_transaction_model.dart';
import 'package:dtnd/data/i_exchange_service.dart';
import 'package:dtnd/data/implementations/exchange_service.dart';
import 'package:dtnd/ui/screen/account/component/cash_transaction_component.dart';
import 'package:dtnd/ui/theme/app_color.dart';
import 'package:dtnd/ui/theme/app_image.dart';
import 'package:dtnd/ui/theme/app_textstyle.dart';
import 'package:dtnd/ui/widget/calendar/day_input.dart';
import 'package:dtnd/ui/widget/empty_list_widget.dart';
import 'package:dtnd/ui/widget/icon/sheet_header.dart';
import 'package:dtnd/utilities/num_utils.dart';
import 'package:dtnd/utilities/time_utils.dart';
import 'package:flutter/material.dart';

class MoneyStatementSheet extends StatefulWidget {
  const MoneyStatementSheet({super.key});

  @override
  State<MoneyStatementSheet> createState() => _MoneyStatementSheetState();
}

class _MoneyStatementSheetState extends State<MoneyStatementSheet> {
  final IExchangeService exchangeService = ExchangeService();

  final List<CashTransactionHistoryModel> list = [];
  TotalCashTransactionModel? total;
  late DateTime fromDay;
  late DateTime toDay;
  late DateTime firstDay;
  late DateTime lastDay;
  @override
  void initState() {
    fromDay = TimeUtilities.getPreviousDateTime(TimeUtilities.month(1));
    toDay = DateTime.now();
    firstDay = TimeUtilities.getPreviousDateTime(TimeUtilities.month(3));
    lastDay = toDay;
    super.initState();
    getData();
  }

  Future<void> getData() async {
    final res = await exchangeService.getCashTransactions(
      fromDay: fromDay,
      toDay: toDay,
    );
    list.clear();
    total = res.total;
    list.addAll(res.listHistory);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SheetHeader(
              title: "Sao kê tiền",
              backData: null,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DayInput(
                    initialDay: fromDay,
                    firstDay: firstDay,
                    lastDay: lastDay,
                    onChanged: (value) {
                      setState(() {
                        fromDay = value;
                      });
                      getData();
                    },
                  ),
                  DayInput(
                    initialDay: toDay,
                    firstDay: firstDay,
                    lastDay: lastDay,
                    onChanged: (value) {
                      setState(() {
                        toDay = value;
                      });
                      getData();
                    },
                  )
                ],
              ),
            ),
            Expanded(child: Builder(builder: (context) {
              if (list.isEmpty || total == null) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    EmptyListWidget(),
                  ],
                );
              } else {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox.square(
                                dimension: 40,
                                child:
                                    Image.asset(AppImages.blue_chart_star_icon),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Số dư đầu kỳ",
                                    style: AppTextStyle.labelMedium_12.copyWith(
                                      color: AppColors.neutral_03,
                                    ),
                                  ),
                                  Text(
                                    NumUtils.formatInteger(
                                        total!.cCASHFISRTBALANCE ?? 0),
                                    style: textTheme.titleSmall,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "Số dư cuối kỳ",
                                style: AppTextStyle.labelMedium_12.copyWith(
                                  color: AppColors.neutral_03,
                                ),
                              ),
                              Text(
                                NumUtils.formatInteger(
                                    total!.cCASHCLOSEBALANCE ?? 0),
                                style: textTheme.titleSmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          return CashTransactionComponent(
                            data: list.elementAt(index),
                          );
                        },
                      ),
                    ),
                    // for (var item in list)
                    //   CashTransactionComponent(
                    //     data: item,
                    //   )
                  ],
                );
              }
            }))
          ],
        ),
      ),
    );
  }
}
