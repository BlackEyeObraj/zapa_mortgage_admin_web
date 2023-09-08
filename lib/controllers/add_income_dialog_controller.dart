import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/utils_mehtods.dart';

class AddIncomeDialogController extends GetxController{
  final RxString _workType = ''.obs;
  final RxString _employerIncomeType = ''.obs;
  final RxString _addIncomeMethodType = ''.obs;
  final RxString _businessIncomeType = ''.obs;
  final RxString _addBusinessMethodType = ''.obs;
  final RxString _otherIncomeType = ''.obs;
  final RxString _addOtherMethodType = ''.obs;
  final RxBool _currentlyWorking = true.obs;
  final RxString _monthlyIncome = '0.00'.obs;
  final RxString _calculatedMonthlyIncome = '0.00'.obs;
  final RxString selectedAddedBy = 'processor'.obs;
  final RxBool _verifiedCheck = true.obs;
  final RxBool _verifiedButExeCheck = false.obs;
  final RxBool _currentlyActive = true.obs;


  final companyNameTextController = TextEditingController();
  final grossAnnualIncomeTextController = TextEditingController();
  final startDateIncomeTextController = TextEditingController();
  final endDateIncomeTextController = TextEditingController();


  final businessNameTextController = TextEditingController();
  final netProfitTextController = TextEditingController();
  final startDateOfBusinessTextController = TextEditingController();



  String get workType => _workType.value;
  String get employerIncomeType => _employerIncomeType.value;
  String get addIncomeMethodType => _addIncomeMethodType.value;
  String get businessIncomeType => _businessIncomeType.value;
  String get addBusinessMethodType => _addBusinessMethodType.value;
  String get otherIncomeType => _otherIncomeType.value;
  String get addOtherMethodType => _addOtherMethodType.value;
  bool get currentlyWorking => _currentlyWorking.value;
  String get monthlyIncome => _monthlyIncome.value;
  String get calculatedMonthlyIncome => _calculatedMonthlyIncome.value;
  bool get verifiedCheck => _verifiedCheck.value;
  bool get verifiedButExeCheck => _verifiedButExeCheck.value;
  bool get currentlyActive => _currentlyActive.value;



  setWorkType(String value){
    _workType.value = value;
  }
  setEmployerIncomeType(String value){
    _employerIncomeType.value = value;
  }
  setAddIncomeMethodType(String value){
    _addIncomeMethodType.value = value;
  }
  setBusinessIncomeType(String value){
    _businessIncomeType.value = value;
  }
  setAddBusinessMethodType(String value){
    _addBusinessMethodType.value = value;
  }
  setOtherIncomeType(String value){
    _otherIncomeType.value = value;
  }
  setAddOtherMethodType(String value){
    _addOtherMethodType.value = value;
  }
  setCurrentWorkingStatus(bool value){
    _currentlyWorking.value = value;
  }
  calculateMonthlyIncome(String annualIncome){
    double monthly = double.parse(annualIncome) / 12;
    String set2DigitsAfterDecimal = monthly.toStringAsFixed(2);
    String addCommas = UtilMethods().formatNumberWithCommas(double.parse(set2DigitsAfterDecimal));
    _monthlyIncome.value = set2DigitsAfterDecimal;
    _calculatedMonthlyIncome.value = addCommas;
  }
  setMonthlyIncomeToZero(){
    _calculatedMonthlyIncome.value = '0.00';
  }
  setVerifyCheck(String type, bool value){
    if(type == 'verified'){
      _verifiedCheck.value = value;
    }else{
      _verifiedButExeCheck.value = value;
    }
  }
  setBusinessNameTextController(String value){
    businessNameTextController.text = value;
  }
  setNetProfitTextController(String value){
    netProfitTextController.text = value;
  }
  setStartDateOfBusinessTextController(String value){
    startDateOfBusinessTextController.text = value;
  }
  setCurrentActiveStatus(bool value){
    _currentlyActive.value = value;
  }
}