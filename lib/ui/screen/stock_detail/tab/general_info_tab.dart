import 'package:dtnd/=models=/response/business_profile_model.dart';
import 'package:dtnd/=models=/response/stock_model.dart';
import 'package:dtnd/ui/theme/app_color.dart';
import 'package:dtnd/ui/theme/app_image.dart';
import 'package:dtnd/ui/theme/app_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../=models=/response/company_info.dart';
import '../../../../data/i_network_service.dart';
import '../../../../data/implementations/network_service.dart';
import '../../../../utilities/logger.dart';

class GeneralInfoTab extends StatefulWidget {
  const GeneralInfoTab({
    super.key,
    required this.stockModel,
  });

  final StockModel stockModel;

  @override
  State<GeneralInfoTab> createState() => _GeneralInfoTabState();
}

class _GeneralInfoTabState extends State<GeneralInfoTab> {
  late Future<CompanyInfo> companyInfo;
  final INetworkService iNetworkService = NetworkService();

  @override
  void initState() {
    companyInfo =
        iNetworkService.getCompanyInfo(widget.stockModel.stockData.sym);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final int leaderLength = widget.stockModel.businnessLeaders!.length > 4
        ? 4
        : widget.stockModel.businnessLeaders!.length;
    return FutureBuilder<CompanyInfo>(
        future: companyInfo,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox();
          }
          if (snapshot.connectionState == ConnectionState.done) {
            var info = snapshot.data!;
            return SingleChildScrollView(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      color: AppColors.neutral_06,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Ngày thành lập",
                                  style: textTheme.bodyMedium!
                                      .copyWith(color: AppColors.neutral_03),
                                ),
                                Text(
                                  info.foundDateString,
                                  style: textTheme.titleSmall,
                                ),
                              ],
                            )),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Mã số thuế",
                                  style: textTheme.bodyMedium!
                                      .copyWith(color: AppColors.neutral_03),
                                ),
                                Text(
                                  info.taxCode ?? "",
                                  style: textTheme.titleSmall,
                                ),
                              ],
                            ))
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Tên viết tắt",
                                  style: textTheme.bodyMedium!
                                      .copyWith(color: AppColors.neutral_03),
                                ),
                                Text(
                                  info.name ?? "",
                                  style: textTheme.titleSmall,
                                ),
                              ],
                            )),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Người đại diện",
                                  style: textTheme.bodyMedium!
                                      .copyWith(color: AppColors.neutral_03),
                                ),
                                Text(
                                  info.name ?? "",
                                  style: textTheme.titleSmall,
                                ),
                              ],
                            ))
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Image.asset(
                              AppImages.call,
                              width: 15,
                            ),
                            const SizedBox(width: 9),
                            Text(
                              info.infoSupplier ?? "",
                              style: textTheme.titleSmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Image.asset(
                              AppImages.global,
                              width: 15,
                            ),
                            const SizedBox(width: 9),
                            Text(
                              info.uRL ?? "",
                              style: textTheme.titleSmall,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Text(
                        "Thành viên Hội đồng quản trị",
                        style: textTheme.titleMedium!
                            .copyWith(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, i) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            color: AppColors.neutral_06,
                          ),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.stockModel.businnessLeaders
                                            ?.elementAt(i)
                                            .fullName ??
                                        "-",
                                    style: textTheme.labelMedium!
                                        .copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    widget.stockModel.businnessLeaders
                                            ?.elementAt(i)
                                            .position ??
                                        "-",
                                    style: AppTextStyle.bodySmall_8
                                        .copyWith(color: AppColors.neutral_04),
                                  )
                                ],
                              ),
                              Expanded(
                                  child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    width: (widget.stockModel.businnessLeaders
                                                    ?.elementAt(i)
                                                    .personalHeldPct ??
                                                1)
                                            .toDouble() *
                                        2,
                                    height: 10,
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(4)),
                                        color:
                                            AppColors.graphColors.elementAt(i)),
                                  ),
                                  Text(
                                    "${widget.stockModel.businnessLeaders?.elementAt(i).personalHeldPct?.toString() ?? "-"}%",
                                    style: textTheme.labelMedium!
                                        .copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ))
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 8);
                      },
                      itemCount: leaderLength),
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Cơ cấu cổ đông",
                      style: textTheme.titleMedium!
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(color: Colors.white),
                    child: AspectRatio(
                      aspectRatio: 1.3,
                      child: SfCircularChart(
                          palette: AppColors.graphColors,
                          legend: Legend(
                            isVisible: true,
                            overflowMode: LegendItemOverflowMode.wrap,
                            position: LegendPosition.bottom,
                          ),
                          annotations: <CircularChartAnnotation>[
                            CircularChartAnnotation(
                              height: "80%",
                              width: "80%",
                              widget: PhysicalModel(
                                shape: BoxShape.circle,
                                elevation: 10,
                                shadowColor: Colors.black,
                                color: Colors.white,
                                child: Center(
                                    child: Text(
                                  "",
                                  style: textTheme.bodyMedium!.copyWith(
                                      color: AppColors.color_secondary,
                                      fontWeight: FontWeight.w700),
                                )),
                              ),
                            ),
                          ],
                          series: <
                              DoughnutSeries<BusinnessLeaderModel, String>>[
                            DoughnutSeries<BusinnessLeaderModel, String>(
                              dataSource: widget.stockModel.businnessLeaders,
                              innerRadius: "75%%",
                              radius: "80%",
                              xValueMapper: (BusinnessLeaderModel data, _) =>
                                  data.fullName,
                              yValueMapper: (BusinnessLeaderModel data, _) =>
                                  data.personalHeldPct,
                              dataLabelMapper: (BusinnessLeaderModel data, _) =>
                                  "${data.personalHeldPct}%",
                              dataLabelSettings: const DataLabelSettings(
                                isVisible: true,
                                // Positioning the data label
                                margin: EdgeInsets.all(0),
                                labelPosition: ChartDataLabelPosition.outside,
                              ),
                            )
                          ]),
                    ),
                  )
                ],
              ),
            );
          }
          return const SizedBox();
        });
  }
}
