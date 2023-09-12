import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:zapa_mortgage_admin_web/utils/utils_mehtods.dart';

import '../services/firestore_service.dart';

class Form1040CalculatorController extends GetxController{

  final RxString _baseYear = ''.obs;
  final RxString _w2Year = ''.obs;
  final RxString _priorW2Year = ''.obs;
  final RxString selectedAddedBy = 'processor'.obs;

  final RxBool _currentlyActive = true.obs;
  final RxDouble _depRateLatest = 0.0.obs;
  final RxDouble _depRatePrior = 0.0.obs;

  RxString  businessStartDateStamp = ''.obs;
  RxString  greaterOrLessThen2Years = ''.obs;
  final RxBool _moreThan5YearsOld = false.obs;


  /// recent Sch C
  final RxDouble netProfitLossRecent = 0.0.obs;
  final RxDouble nonRecurringRecent = 0.0.obs;
  final RxDouble depletionRecent = 0.0.obs;
  final RxDouble depreciationRecent = 0.0.obs;
  final RxDouble mealsAndEntertainmentExclusionRecent = 0.0.obs;
  final RxDouble businessUseOfHomeRecent = 0.0.obs;
  final RxDouble amortizationCasualtyLossOneTimeExpenseRecent = 0.0.obs;
  final RxDouble businessMilesRecent = 0.0.obs;

  /// prior Sch C
  final RxDouble netProfitLossPrior = 0.0.obs;
  final RxDouble nonRecurringPrior = 0.0.obs;
  final RxDouble depletionPrior = 0.0.obs;
  final RxDouble depreciationPrior = 0.0.obs;
  final RxDouble mealsAndEntertainmentExclusionPrior = 0.0.obs;
  final RxDouble businessUseOfHomePrior = 0.0.obs;
  final RxDouble amortizationCasualtyLossOneTimeExpensePrior = 0.0.obs;
  final RxDouble businessMilesPrior = 0.0.obs;

  final RxDouble numberOfMonths = 0.0.obs;


  final RxDouble _subtotalRecent = 0.0.obs;
  final RxDouble _subtotalPrior = 0.0.obs;

  final RxDouble _monthlyIncome = 0.0.obs;
  final RxString _calculationMessage = ''.obs;

  final RxBool _verifiedCheck = true.obs;
  final RxBool _verifiedButExeCheck = false.obs;



  final nameOfProprietorTextController = TextEditingController();
  final principalBusinessOrProfessionTextController = TextEditingController();
  final businessNameTypeTextController = TextEditingController();
  final businessStartDateTextController = TextEditingController();


  /// Sch entries most recent year
  final netProfitLossIncomeRecentTextController = TextEditingController();
  final nonRecurringIncomeRecentTextController = TextEditingController();
  final depletionIncomeRecentTextController = TextEditingController();
  final depreciationIncomeRecentTextController = TextEditingController();
  final mealsAndEntertainmentExclusionRecentIncomeTextController = TextEditingController();
  final businessUseOfHomeRecentIncomeTextController = TextEditingController();
  final amortizationCasualtyLossOneTimeExpenseRecentIncomeTextController = TextEditingController();
  final businessMilesRecentIncomeTextController = TextEditingController();

  /// Sch entries prior year
  final netProfitLossIncomePriorTextController = TextEditingController();
  final nonRecurringIncomePriorTextController = TextEditingController();
  final depletionIncomePriorTextController = TextEditingController();
  final depreciationIncomePriorTextController = TextEditingController();
  final mealsAndEntertainmentExclusionPriorIncomeTextController = TextEditingController();
  final businessUseOfHomePriorIncomeTextController = TextEditingController();
  final amortizationCasualtyLossOneTimeExpensePriorIncomeTextController = TextEditingController();
  final businessMilesPriorIncomeTextController = TextEditingController();

  /// summary number of months
  final numberOfMonthsTextController = TextEditingController();


  bool get currentlyActive => _currentlyActive.value;
  String get baseYear => _baseYear.value;
  String get w2Year => _w2Year.value;
  String get priorW2Year => _priorW2Year.value;
  double get depRateLatest => _depRateLatest.value;
  double get depRatePrior => _depRatePrior.value;
  double get subtotalRecent => _subtotalRecent.value;
  double get subtotalPrior => _subtotalPrior.value;
  double get monthlyIncome => _monthlyIncome.value;
  bool get verifiedCheck => _verifiedCheck.value;
  bool get verifiedButExeCheck => _verifiedButExeCheck.value;
  String get calculationMessage => _calculationMessage.value;
  bool get moreThan5YearsOld => _moreThan5YearsOld.value;

  @override
  void onInit() async{
    await getCurrentAndPreviousYears();
    _depRateLatest.value = await FirestoreService().getDepreciationRateForLatestYear(w2Year);
    _depRatePrior.value = await FirestoreService().getDepreciationRateForPriorYear(priorW2Year);
    super.onInit();
  }

  setCurrentActiveStatus(bool value){
    _currentlyActive.value = value;
  }

  getCurrentAndPreviousYears()async{
    var currentDate = DateTime.now();
    var w2Date = DateTime(currentDate.year-1);
    var priorW2Date = DateTime(w2Date.year-1);
    _baseYear.value = currentDate.year.toString();
    _w2Year.value = w2Date.year.toString();
    _priorW2Year.value = priorW2Date.year.toString();
    _depRateLatest.value = await FirestoreService().getDepreciationRateForLatestYear(w2Year);
    _depRatePrior.value = await FirestoreService().getDepreciationRateForPriorYear(priorW2Year);
  }

  calculateSubTotalAmount(String type) {
    if(type == 'recent'){
      double calculatedNonDeductibleRecent = -mealsAndEntertainmentExclusionRecent.value;
      _subtotalRecent.value = netProfitLossRecent.value + nonRecurringRecent.value + depletionRecent.value + depreciationRecent.value + businessUseOfHomeRecent.value + amortizationCasualtyLossOneTimeExpenseRecent.value + calculatedNonDeductibleRecent + (businessMilesRecent.value * depRateLatest);
      // double sumOfGrandTotals = _subtotalRecent.value + _subtotalPrior.value;
      // double checkInfinity = sumOfGrandTotals / numberOfMonths.value;
      // if (checkInfinity.isInfinite) {
      //   _monthlyIncome.value = 0.0; // Set to a default value for infinity
      // } else if (checkInfinity.isNaN) {
      //   _monthlyIncome.value = 0.0; // Set to a default value for NaN
      // } else {
      //   _monthlyIncome.value = checkInfinity;
      // }
      calculateMonthlyIncome();
    }else if(type == 'prior'){
      double calculatedNonDeductiblePrior = -mealsAndEntertainmentExclusionPrior.value;
      _subtotalPrior.value = netProfitLossPrior.value + nonRecurringPrior.value + depletionPrior.value + depreciationPrior.value + businessUseOfHomePrior.value + amortizationCasualtyLossOneTimeExpensePrior.value + calculatedNonDeductiblePrior + (businessMilesPrior.value * depRatePrior);
      // double sumOfGrandTotals = _subtotalRecent.value + _subtotalPrior.value;
      // double checkInfinity = sumOfGrandTotals / numberOfMonths.value;
      // if (checkInfinity.isInfinite) {
      //   _monthlyIncome.value = 0.0; // Set to a default value for infinity
      // } else if (checkInfinity.isNaN) {
      //   _monthlyIncome.value = 0.0; // Set to a default value for NaN
      // } else {
      //   _monthlyIncome.value = checkInfinity;
      // }
      calculateMonthlyIncome();
    }
    // else{
    //   double sumOfGrandTotals = _subtotalRecent.value + _subtotalPrior.value;
    //   double checkInfinity = sumOfGrandTotals / numberOfMonths.value;
    //   if (checkInfinity.isInfinite) {
    //     _monthlyIncome.value = 0.0; // Set to a default value for infinity
    //   } else if (checkInfinity.isNaN) {
    //     _monthlyIncome.value = 0.0; // Set to a default value for NaN
    //   } else {
    //     _monthlyIncome.value = checkInfinity;
    //   }
    // }
  }

  void calculateMonthlyIncome() {
    if(!_moreThan5YearsOld.value){
      if(_subtotalPrior.value == _subtotalRecent.value && _subtotalPrior.value != 0.0 && _subtotalRecent.value != 0.0){
        double total= _subtotalPrior.value + _subtotalRecent.value;
        _monthlyIncome.value =total/24;
        setCalculationMessage('1', _subtotalPrior.value, _subtotalRecent.value, w2Year, priorW2Year,_monthlyIncome.value);
      }
      else if(_subtotalPrior.value < _subtotalRecent.value && _subtotalPrior.value != 0.0 && _subtotalRecent.value != 0.0){
        double total= _subtotalPrior.value + _subtotalRecent.value;
        _monthlyIncome.value =total/24;
        setCalculationMessage('2', _subtotalPrior.value, _subtotalRecent.value, w2Year, priorW2Year,_monthlyIncome.value);
      }
      else if(_subtotalPrior.value > _subtotalRecent.value && _subtotalPrior.value != 0.0 && _subtotalRecent.value != 0.0){
        double total= _subtotalRecent.value;
        _monthlyIncome.value =total/12;
        setCalculationMessage('3', _subtotalPrior.value, _subtotalRecent.value, w2Year, priorW2Year,_monthlyIncome.value);
      }
      else if(_subtotalPrior.value == 0.0 && _subtotalRecent.value != 0.0){
        double total= _subtotalRecent.value;
        _monthlyIncome.value =total/24;
        setCalculationMessage('4', _subtotalPrior.value, _subtotalRecent.value, w2Year, priorW2Year,_monthlyIncome.value);
      }
      else if(_subtotalPrior.value != 0.0 && _subtotalRecent.value == 0.0){
        _monthlyIncome.value = 0.0;
        setCalculationMessage('5', _subtotalPrior.value, _subtotalRecent.value, w2Year, priorW2Year,_monthlyIncome.value);
      }
      else{
        _monthlyIncome.value = 0.0;
        setCalculationMessage('7', _subtotalPrior.value, _subtotalRecent.value, w2Year, priorW2Year,_monthlyIncome.value);
      }
    }else{
      if(_subtotalPrior.value == 0.0 && _subtotalRecent.value != 0.0){
        double total= _subtotalRecent.value;
        _monthlyIncome.value =total/24;
        setCalculationMessage('6', _subtotalPrior.value, _subtotalRecent.value, w2Year, priorW2Year,_monthlyIncome.value);
      }else if(_subtotalPrior.value != 0.0 && _subtotalRecent.value != 0.0){
        double total= _subtotalRecent.value;
        _monthlyIncome.value =total/24;
        setCalculationMessage('6', _subtotalPrior.value, _subtotalRecent.value, w2Year, priorW2Year,_monthlyIncome.value);
      }else{
        _monthlyIncome.value = 0.0;
        setCalculationMessage('7', _subtotalPrior.value, _subtotalRecent.value, w2Year, priorW2Year,_monthlyIncome.value);
      }
    }
  }

  setCalculationMessage(String condition, double subTotalPrior ,double subTotalRecent, String w2Year, String w2PriorYear, double monthlyIncome){
    if(condition == '1'){
      _calculationMessage.value =
      'Trend is average. Based on years $w2PriorYear & $w2Year income.\n'
          '${UtilMethods().formatNumberWithCommas(subTotalPrior)} + ${UtilMethods().formatNumberWithCommas(subTotalRecent)} / 24 = ${UtilMethods().formatNumberWithCommas(monthlyIncome)}';
    }else if(condition == '2'){
      _calculationMessage.value =
      'Trend is increasing. Based on years $w2PriorYear & $w2Year income.\n'
          '${UtilMethods().formatNumberWithCommas(subTotalPrior)} + ${UtilMethods().formatNumberWithCommas(subTotalRecent)} / 24 = ${UtilMethods().formatNumberWithCommas(monthlyIncome)}';
    }else if(condition == '3'){
      _calculationMessage.value =
      'Trend is declining. Based on years $w2PriorYear & $w2Year income. So the income of $w2Year will be considered.\n'
          '${UtilMethods().formatNumberWithCommas(subTotalRecent)} / 12 = ${UtilMethods().formatNumberWithCommas(monthlyIncome)}';
    }else if(condition == '4'){
      _calculationMessage.value =
      'Trend is only set for one year. Based on year $w2Year income.\n'
          '${UtilMethods().formatNumberWithCommas(subTotalRecent)} / 24 = ${UtilMethods().formatNumberWithCommas(monthlyIncome)}';
    }else if(condition == '5'){
      _calculationMessage.value =
      'Trend is only set for one year $w2PriorYear only. So the monthly income is considered \$0.00 for not providing $w2Year income.';
    }else if(condition == '6'){
      _calculationMessage.value =
      'if your business is more than 5 years old then trend is only set for one year $w2Year only. So the monthly income is considered as \n${UtilMethods().formatNumberWithCommas(subTotalRecent)} / 24 = ${UtilMethods().formatNumberWithCommas(monthlyIncome)}';
    }else if(condition == '7'){
      _calculationMessage.value = '';
    }
  }
  setMoreThan5YearsOld(bool value){
    _moreThan5YearsOld.value = value;
    calculateMonthlyIncome();
  }


  setVerifyCheck(String type, bool value){
    if(type == 'verified'){
      _verifiedCheck.value = value;
    }else{
      _verifiedButExeCheck.value = value;
    }

  }
}