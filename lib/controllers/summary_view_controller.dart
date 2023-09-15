import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../services/firestore_service.dart';
import '../utils/constants.dart';

class SummaryViewController extends GetxController{
  RxString borrowerId = ''.obs;
  StreamSubscription<double>? _subscription;
  TimeOfDay selectedTime = TimeOfDay.now();

  final RxString nickName = ''.obs;
  final RxDouble _totalVerifiedGrossIncome = 0.0.obs;
  final RxDouble _totalGrossIncome = 0.0.obs;
  final RxDouble _totalVerifiedLiability = 0.0.obs;
  final RxDouble _totalLiability = 0.0.obs;
  final RxDouble _totalVerifiedFunds = 0.0.obs;
  final RxDouble _totalFunds = 0.0.obs;


  double get totalVerifiedGrossIncome => _totalVerifiedGrossIncome.value;
  double get totalGrossIncome => _totalGrossIncome.value;
  double get totalVerifiedLiability => _totalVerifiedLiability.value;
  double get totalLiability => _totalLiability.value;
  double get totalVerifiedFunds => _totalVerifiedFunds.value;
  double get totalFunds => _totalFunds.value;


  @override
  void onInit() async{
    print('test: ${borrowerId.value}');
    super.onInit();
  }


  setSummaryValue(String borrowerId, String borrowerName, String borrowerPhoneNumber){
    final box = GetStorage();
    _subscription = FirestoreService()
        .calculateTotalVerifiedIncomesListener(borrowerId)
        .listen((value) {
      _totalVerifiedGrossIncome.value = value;
    });
    _subscription = FirestoreService()
        .calculateTotalIncludedIncomeListener(borrowerId)
        .listen((value) {
      _totalGrossIncome.value = value;
    });
    _subscription = FirestoreService()
        .calculateTotalVerifiedLiabilityListener(borrowerId)
        .listen((value) {
      _totalVerifiedLiability.value = value;
    });
    _subscription = FirestoreService()
        .calculateTotalIncludedLiabilityListener(borrowerId)
        .listen((value) {
      _totalLiability.value = value;
    });
    _subscription = FirestoreService()
        .calculateTotalVerifiedFundsListener(borrowerId)
        .listen((value) {
      _totalVerifiedFunds.value = value;
    });
    _subscription = FirestoreService()
        .calculateTotalIncludedFundsListener(borrowerId)
        .listen((value) {
      _totalFunds.value = value;
    });
    Future.delayed(const Duration(seconds: 1), ()async {
      await FirestoreService().historyDataAdd("${box.read(Constants.USER_NAME)} has viewed ${borrowerName.isEmpty?borrowerPhoneNumber:borrowerName}.");
    });
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
  setBorrowerId(String id){
    borrowerId.value = id;
  }

}