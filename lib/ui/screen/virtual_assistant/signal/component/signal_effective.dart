import 'package:dtnd/=models=/response/top_signal_detail_model.dart';
import 'package:dtnd/ui/theme/app_color.dart';
import 'package:dtnd/ui/theme/app_image.dart';
import 'package:dtnd/ui/theme/app_textstyle.dart';
import 'package:flutter/material.dart';

const List<String> _label = ["1W", "2W", "1M", "3M"];

class SignalEffective extends StatefulWidget {
  const SignalEffective({super.key, this.data});
  final TopSignalDetailModel? data;
  @override
  State<SignalEffective> createState() => _SignalEffectiveState();
}

class _SignalEffectiveState extends State<SignalEffective> {
  late List<num> _value;
  @override
  void initState() {
    super.initState();
    generateData();
  }

  void generateData() {
    if (widget.data == null) {
      _value = List.generate(4, (index) => 0);
    } else {
      _value = widget.data!.list;
    }
  }

  @override
  void didUpdateWidget(covariant SignalEffective oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data?.cSHARECODE != widget.data?.cSHARECODE) {
      generateData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          color: Colors.white),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox.square(
                  dimension: 36, child: Image.asset(AppImages.signal_icon)),
              const SizedBox(width: 12),
              Text(
                "Hiệu quả",
                style: AppTextStyle.titleSmall_14
                    .copyWith(color: AppColors.primary_01),
              )
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              for (int i = 0; i < _label.length; i++)
                Expanded(
                  child: _Figure(
                    title: _label[i],
                    value: _value[i],
                  ),
                )
            ],
          )
        ],
      ),
    );
  }
}

class _Figure extends StatelessWidget {
  const _Figure({this.value = 0, this.title});
  final String? title;
  final num value;
  @override
  Widget build(BuildContext context) {
    final String path;
    final Color color;
    final Color bgColor;
    switch (value.compareTo(0)) {
      case 1:
        path = AppImages.prefix_up_icon2;
        color = AppColors.semantic_01;
        bgColor = AppColors.accent_light_01;
        break;
      case -1:
        path = AppImages.prefix_down_icon2;
        color = AppColors.semantic_03;
        bgColor = AppColors.accent_light_03;
        break;
      default:
        path = AppImages.prefix_ref_icon;
        color = AppColors.semantic_02;
        bgColor = AppColors.accent_light_02;
        break;
    }
    final Widget icon = Image.asset(
      path,
    );
    return Column(
      children: [
        Text(
          title ?? "-",
          style:
              AppTextStyle.labelMedium_12.copyWith(color: AppColors.neutral_04),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            color: bgColor,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox.square(
                dimension: 10,
                child: icon,
              ),
              const SizedBox(width: 3),
              Text(
                "${value.toString()}%",
                style: AppTextStyle.labelMedium_12
                    .copyWith(fontWeight: FontWeight.w600, color: color),
              ),
            ],
          ),
        )
      ],
    );
  }
}
