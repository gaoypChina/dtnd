import 'package:dtnd/=models=/response/account/unexecuted_right_model.dart';
import 'package:dtnd/generated/l10n.dart';
import 'package:dtnd/ui/widget/icon/sheet_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../data/i_local_storage_service.dart';
import '../../../../data/implementations/local_storage_service.dart';
import '../../../../utilities/num_utils.dart';
import '../../../../utilities/validator.dart';
import '../../../theme/app_color.dart';
import '../../../theme/app_image.dart';
import '../../../theme/app_textstyle.dart';
import '../../../widget/input/interval_input.dart';

class RegistrationRightsSheet extends StatefulWidget {
  const RegistrationRightsSheet({super.key, required this.data});

  final UnexecutedRightModel? data;

  @override
  State<RegistrationRightsSheet> createState() =>
      _RegistrationRightsSheetState();
}

class _RegistrationRightsSheetState extends State<RegistrationRightsSheet>
    with AppValidator {
  final TextEditingController priceController = TextEditingController();
  final TextEditingController volumeController = TextEditingController();

  final GlobalKey<FormState> pinKey = GlobalKey<FormState>();
  final TextEditingController pinController = TextEditingController();
  final ILocalStorageService localStorageService = LocalStorageService();

  bool loading = false;
  bool checked = false;

  @override
  void initState() {
    super.initState();
    pinController.text =
        localStorageService.sharedPreferences.getString(pinCodeKey) ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SheetHeader(title: 'Đăng ký quyền'),
            const SizedBox(
              height: 8,
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppColors.primary_03,
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        widget.data?.cSHARECODE.toString() ?? '',
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
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
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Giá mua',
                          style: AppTextStyle.labelMedium_12
                              .copyWith(color: AppColors.neutral_03)),
                      Text(
                          "${NumUtils.formatInteger(widget.data?.cBUYPRICE ?? 0)} đ"),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Số tiền phải nộp',
                          style: AppTextStyle.labelMedium_12
                              .copyWith(color: AppColors.neutral_03)),
                      const Text('1000000')
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Expanded(
                  child: IntervalInput(
                    controller: volumeController,
                    labelText: S.of(context).volumn,
                    interval: (value) => 100,
                    validator: volumnValidator,
                    // onChanged: onChangeVol,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Form(
                    key: pinKey,
                    autovalidateMode: AutovalidateMode.disabled,
                    child: (localStorageService.sharedPreferences
                                .getString(pinCodeKey)
                                ?.isEmpty ??
                            true)
                        ? TextFormField(
                            controller: pinController,
                            // onChanged: (value) => pinFormKey.currentState?.didChange(value),
                            validator: pinValidator,
                            autovalidateMode: AutovalidateMode.disabled,
                            decoration: InputDecoration(
                              labelText: S.of(context).pin_code,
                              // contentPadding: const EdgeInsets.all(0),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              floatingLabelAlignment:
                                  FloatingLabelAlignment.start,
                              suffixIcon: InkWell(
                                onTap: () {
                                  checked = !checked;
                                  if (checked && pinController.text != '') {
                                    EasyLoading.showToast(
                                        S.of(context).saved_pin_code,
                                        maskType: EasyLoadingMaskType.clear);
                                  }
                                  setState(() {});
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: SvgPicture.asset(
                                    AppImages.save_pin_code_icon,
                                    color: (checked && pinController.text != '')
                                        ? AppColors.semantic_01
                                        : AppColors.primary_01,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            InkWell(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  color: AppColors.color_primary_1,
                ),
                child: Text(
                  S.of(context).confirm,
                  style:
                      const TextStyle(fontSize: 12, color: AppColors.light_bg),
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }
}
