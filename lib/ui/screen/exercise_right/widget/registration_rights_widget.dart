import 'package:dtnd/=models=/response/account/unexecuted_right_model.dart';
import 'package:dtnd/utilities/num_utils.dart';
import 'package:flutter/material.dart';

import '../../../theme/app_color.dart';
import '../../../theme/app_textstyle.dart';

class RegistrationRightsWidget extends StatefulWidget {
  const RegistrationRightsWidget({super.key, required this.data});

  final UnexecutedRightModel? data;

  @override
  State<RegistrationRightsWidget> createState() =>
      _RegistrationRightsWidgetState();
}

class _RegistrationRightsWidgetState extends State<RegistrationRightsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
          color: AppColors.neutral_06,
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [Text(widget.data?.cSHARECODE.toString() ?? '')],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Trạng thái',
                  style: AppTextStyle.labelMedium_12
                      .copyWith(color: AppColors.neutral_03)),
              Text(widget.data?.cSTATUSNAME.toString() ?? '')
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Giá mua',
                  style: AppTextStyle.labelMedium_12
                      .copyWith(color: AppColors.neutral_03)),
              Text("${NumUtils.formatInteger(widget.data?.cBUYPRICE ?? 0)} đ"),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Số CP được hưởng',
                  style: AppTextStyle.labelMedium_12
                      .copyWith(color: AppColors.neutral_03)),
              Text(widget.data?.cRIGHTVOLUME.toString() ?? '')
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tỷ lệ',
                  style: AppTextStyle.labelMedium_12
                      .copyWith(color: AppColors.neutral_03)),
              Text(widget.data?.cRIGHTRATE.toString() ?? '')
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Mã CP được mua',
                  style: AppTextStyle.labelMedium_12
                      .copyWith(color: AppColors.neutral_03)),
              Text(widget.data?.cRECEIVESHARECODE.toString() ?? '')
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Số CP còn được mua',
                  style: AppTextStyle.labelMedium_12
                      .copyWith(color: AppColors.neutral_03)),
              Text(((NumUtils.formatDouble(widget.data?.cSHARERIGHT ??
                  0 -
                      (widget.data?.cSHAREBUY ?? 0) /
                          (widget.data?.cSHARERIGHT ?? 0)))))
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
