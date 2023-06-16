import 'package:dtnd/=models=/response/accumulation/contract_model.dart';
import 'package:dtnd/=models=/response/accumulation/fee_rate_model.dart';
import 'package:dtnd/=models=/response/accumulation/single_contract.dart';
import 'package:dtnd/data/i_data_center_service.dart';
import 'package:dtnd/data/i_user_service.dart';
import 'package:dtnd/data/implementations/data_center_service.dart';
import 'package:dtnd/data/implementations/user_service.dart';
import 'package:get/get.dart';

import '../../../../=models=/response/accumulation/contract_fee_model.dart';

class AccumulationController {
  static final AccumulationController _instance =
      AccumulationController._intern();

  static AccumulationController get instance => _instance;

  AccumulationController._intern();

  factory AccumulationController() => _instance;

  // State
  final IUserService userService = UserService();
  final IDataCenterService dataCenterService = DataCenterService();
  final Rx<List<FeeRateModel>?> listFeeRate = Rx(<FeeRateModel>[]);
  final Rx<List<ContractModel>?> listAllContract = Rx(<ContractModel>[]);
  final Rx<bool> accumulationInitialized = false.obs;
  final Rx<bool> baseContract = false.obs;
  final RxString openDay = ''.obs;
  final RxString endDay = ''.obs;
  final RxString liquidRate = ''.obs;
  final RxString liquidFee = ''.obs;
  SingleContract? singleContract;
  ContractFee? contractFee;

  get flagContract => baseContract.value;
  final RxDouble cashValue = 0.0.obs;
  final RxDouble feeValue = 0.0.obs;

  Future<void> init() async {
    await getFeeRate();
    await getAllContract();
    await checkContractBase();
    accumulationInitialized.value = true;
  }

  Future<void> getFeeRate() async {
    final allFeeRate = await userService.getAllFreeRate();
    if ((allFeeRate?.isEmpty ?? true) || allFeeRate == null) {
      listFeeRate.value!.clear();
      listFeeRate.refresh();
    } else {
      listFeeRate.value!.clear();
      listFeeRate.value!.addAll(allFeeRate);
      listFeeRate.refresh();
    }
  }

  FeeRateModel getItemFeeRate(String id) {
    FeeRateModel itemWithId;
    itemWithId = listFeeRate.value!.firstWhere((item) => item.id == id);
    return itemWithId;
  }

  Future<void> getAllContract() async {
    final allContract = await userService.getAllContract();
    if ((allContract?.isEmpty ?? true) || allContract == null) {
      listAllContract.value!.clear();
      listAllContract.refresh();
      return;
    } else {
      listAllContract.value!.clear();
      listAllContract.value!.addAll(allContract);
      listAllContract.refresh();
    }
  }

  Future<SingleContract?> getSingleContract(String itemId) async {
    singleContract = await userService.getSingleContract(itemId);
    liquidRate.value = singleContract?.cLIQUIDRATE.toString() ?? '';
    liquidFee.value = singleContract?.cLIQUIDFEE.toString() ?? '';
    return singleContract;
  }

  ContractModel getItemContract(String id) {
    ContractModel itemWithId;
    itemWithId = listAllContract.value!.firstWhere((item) => item.id == id);
    return itemWithId;
  }

  Future<void> checkContractBase() async {
    baseContract.value = await userService.checkContractBase();
    baseContract.refresh();
  }

  Future<ContractFee?> getProvisionalFee(String term, String capital) async {
    contractFee = await userService.getProvisionalFee(term, capital);
    if (contractFee != null) {
      cashValue.value =
          double.tryParse(contractFee!.cCASHVALUE.toString()) ?? 0;
      feeValue.value = double.tryParse(contractFee!.cFEEVALUE.toString()) ?? 0;
      openDay.value = contractFee?.cOPENDATE.toString() ?? '';
      endDay.value = contractFee?.cEXPIREDATE.toString() ?? '';
    }
    return contractFee;
  }

  Future<void> liquidAll(String contractId) async {
    await userService.liquidAll(contractId);
  }
}
