import 'dart:async';

import 'package:get/get.dart';

import '../services/firestore_service.dart';

class LiabilityViewController extends GetxController{
  StreamSubscription<double>? _subscription;

  final RxDouble _totalVerifiedButExcludedMonthlyLiability = 0.0.obs;
  final RxDouble _totalExcludedPayOffBalance = 0.0.obs;
  final RxBool _verifiedCheck = true.obs;
  final RxBool _verifiedButExeCheck = false.obs;
  final RxString selectedAddedBy = 'processor'.obs;
  RxString selectedLiabilityType = ''.obs;
  RxDouble onePercentAmount = 0.00.obs;
  RxBool idoKnow = false.obs;
  RxBool idoNotKnow = true.obs;
  final RxString _statusLiability = ''.obs;


  double get totalExcludedPayOffBalance => _totalExcludedPayOffBalance.value;
  double get totalVerifiedButExcludedMonthlyLiability => _totalVerifiedButExcludedMonthlyLiability.value;
  bool get verifiedCheck => _verifiedCheck.value;
  bool get verifiedButExeCheck => _verifiedButExeCheck.value;
  String get statusLiability => _statusLiability.value;



  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }

  void setLiabilityValue(String borrowerId) {
    _subscription = FirestoreService()
        .calculateTotalVerifiedButExcludedMonthlyLiabilityListener(borrowerId)
        .listen((value) {
      _totalVerifiedButExcludedMonthlyLiability.value = value;
    });
    _subscription = FirestoreService()
        .calculateTotalExcludedPayOffBalanceListener(borrowerId)
        .listen((value) {
      _totalExcludedPayOffBalance.value = value;
    });
  }

  setVerifyCheck(String type, bool value){
    if(type == 'verified'){
      _verifiedCheck.value = value;
    }else{
      _verifiedButExeCheck.value = value;
    }
  }
  calculateOnePercent(double amount) {
    onePercentAmount.value  = amount * 0.01;
  }
  setStatusLiability(String value) {
    _statusLiability.value = value;
  }
}