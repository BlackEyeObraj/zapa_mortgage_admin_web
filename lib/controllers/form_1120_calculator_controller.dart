import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zapa_mortgage_admin_web/utils/utils_mehtods.dart';

class From1120CalculatorController extends GetxController{
  final RxString _baseYear = ''.obs;
  final RxString _w2Year = ''.obs;
  final RxString _priorW2Year = ''.obs;
  final RxBool _currentlyActive = true.obs;
  final RxBool _addPartnershipReturnsRecent = true.obs;
  final RxBool _addPartnershipReturnsPrior = true.obs;
  final RxString selectedAddedBy = 'processor'.obs;
  final RxBool _moreThan5YearsOld = false.obs;


  RxString  businessStartDateStamp = ''.obs;
  RxString  greaterOrLessThen2Years = ''.obs;

  /////// Form 1040 //////
  final RxDouble w2IncomeFromSelfEmploymentRecent = 0.0.obs;
  final RxDouble w2IncomeFromSelfEmploymentPrior = 0.0.obs;
  /// Subtotal
  final RxDouble _w2IncomeFromSelfEmploymentRecentSubTotal = 0.0.obs;
  final RxDouble _w2IncomeFromSelfEmploymentPriorSubTotal = 0.0.obs;

  /////// Form 1120 recent ///////
  final RxDouble taxableIncomeRecent = 0.0.obs;
  final RxDouble totalTaxRecent = 0.0.obs;
  final RxDouble nonRecurringGainLossRecent = 0.0.obs;
  final RxDouble nonRecurringOtherIncomeLossRecent = 0.0.obs;
  final RxDouble depreciationRecent = 0.0.obs;
  final RxDouble depletionRecent = 0.0.obs;
  final RxDouble amortizationCasualtyLossOneTimeExpenseRecent = 0.0.obs;
  final RxDouble netOperatingLossAndSpecialDeductionsRecent = 0.0.obs;
  final RxDouble mortgagePayableInLessThanOneYearRecent = 0.0.obs;
  final RxDouble mealsAndEntertainmentRecent = 0.0.obs;
  /// form 1120 subtotal
  final RxDouble _from1120RecentSubtotal = 0.0.obs;

  final RxDouble ownershipPercentageRecent = 0.0.obs;
  /// form 1120 cashFlow subtotal
  final RxDouble _cashFlowRecentSubtotal = 0.0.obs;
  final RxDouble dividendsPaidToBorrowerRecent = 0.0.obs;

  final RxDouble _totalCorpIncomeRecent = 0.0.obs;

  final RxBool _verifiedCheck = true.obs;
  final RxBool _verifiedButExeCheck = false.obs;
  final RxString _calculationMessage = ''.obs;

  /////// Form 1120 prior ///////
  final RxDouble taxableIncomePrior = 0.0.obs;
  final RxDouble totalTaxPrior = 0.0.obs;
  final RxDouble nonRecurringGainLossPrior = 0.0.obs;
  final RxDouble nonRecurringOtherIncomeLossPrior = 0.0.obs;
  final RxDouble depreciationPrior = 0.0.obs;
  final RxDouble depletionPrior = 0.0.obs;
  final RxDouble amortizationCasualtyLossOneTimeExpensePrior = 0.0.obs;
  final RxDouble netOperatingLossAndSpecialDeductionsPrior = 0.0.obs;
  final RxDouble mortgagePayableInLessThanOneYearPrior = 0.0.obs;
  final RxDouble mealsAndEntertainmentPrior = 0.0.obs;
  /// form 1120 subtotal
  final RxDouble _from1120PriorSubtotal = 0.0.obs;

  final RxDouble ownershipPercentagePrior = 0.0.obs;
  /// form 1065 cashFlow subtotal
  final RxDouble _cashFlowPriorSubtotal = 0.0.obs;

  final RxDouble dividendsPaidToBorrowerPrior = 0.0.obs;
  final RxDouble _totalCorpIncomePrior = 0.0.obs;


  final RxDouble _personalTaxReturnsRecent = 0.0.obs;
  final RxDouble _personalTaxReturnsPrior = 0.0.obs;
  final RxDouble _totalOfTaxReturnAndGrandTotalRecent = 0.0.obs;
  final RxDouble _totalOfTaxReturnAndGrandTotalPrior = 0.0.obs;
  final RxDouble numberOfMonths = 0.0.obs;
  final RxDouble _monthlyIncome = 0.0.obs;


  final nameTextController = TextEditingController();
  final businessNameTypeTextController = TextEditingController();
  final businessStartDateTextController = TextEditingController();


  /// Form 1040
  final w2IncomeFromSelfEmploymentMostRecentTextController = TextEditingController();
  final w2IncomeFromSelfEmploymentPriorTextController = TextEditingController();

  /// recent year
  final taxableIncomeRecentTextController = TextEditingController();
  final totalTaxRecentTextController = TextEditingController();
  final nonRecurringGainLossRecentTextController = TextEditingController();
  final nonRecurringOtherIncomeLossRecentTextController = TextEditingController();
  final depreciationRecentTextController = TextEditingController();
  final depletionRecentTextController = TextEditingController();
  final amortizationCasualtyLossOneTimeExpenseRecentIncomeTextController = TextEditingController();
  final netOperatingLossAndSpecialDeductionsRecentIncomeTextController = TextEditingController();
  final mortgagePayableInLessThanOneYearRecentIncomeTextController = TextEditingController();
  final travelAndEntertainmentExecutionRecentIncomeTextController = TextEditingController();
  final ownershipPercentageRecentIncomeTextController = TextEditingController();
  final dividendsPaidToBorrowerRecentIncomeTextController = TextEditingController();

  /// prior year
  final taxableIncomePriorTextController = TextEditingController();
  final totalTaxPriorTextController = TextEditingController();
  final nonRecurringGainLossPriorTextController = TextEditingController();
  final nonRecurringOtherIncomeLossPriorTextController = TextEditingController();
  final depreciationPriorTextController = TextEditingController();
  final depletionPriorTextController = TextEditingController();
  final amortizationCasualtyLossOneTimeExpensePriorIncomeTextController = TextEditingController();
  final netOperatingLossAndSpecialDeductionsPriorIncomeTextController = TextEditingController();
  final mortgagePayableInLessThanOneYearPriorIncomeTextController = TextEditingController();
  final travelAndEntertainmentExecutionPriorIncomeTextController = TextEditingController();
  final ownershipPercentagePriorIncomeTextController = TextEditingController();
  final dividendsPaidToBorrowerPriorIncomeTextController = TextEditingController();



  bool get currentlyActive => _currentlyActive.value;
  String get baseYear => _baseYear.value;
  String get w2Year => _w2Year.value;
  String get priorW2Year => _priorW2Year.value;

  double get w2IncomeFromSelfEmploymentRecentSubTotal => _w2IncomeFromSelfEmploymentRecentSubTotal.value;
  double get w2IncomeFromSelfEmploymentPriorSubTotal => _w2IncomeFromSelfEmploymentPriorSubTotal.value;

  double get from1120RecentSubtotal => _from1120RecentSubtotal.value;
  double get cashFlowRecentSubtotal => _cashFlowRecentSubtotal.value;
  double get from1120PriorSubtotal => _from1120PriorSubtotal.value;
  double get cashFlowPriorSubtotal => _cashFlowPriorSubtotal.value;

  double get personalTaxReturnsRecent => _personalTaxReturnsRecent.value;
  double get personalTaxReturnsPrior => _personalTaxReturnsPrior.value;

  bool get addPartnershipReturnsRecent => _addPartnershipReturnsRecent.value;
  bool get addPartnershipReturnsPrior => _addPartnershipReturnsPrior.value;

  double get totalOfTaxReturnAndGrandTotalRecent => _totalOfTaxReturnAndGrandTotalRecent.value;
  double get totalOfTaxReturnAndGrandTotalPrior => _totalOfTaxReturnAndGrandTotalPrior.value;

  double get monthlyIncome => _monthlyIncome.value;
  double get totalCorpIncomeRecent => _totalCorpIncomeRecent.value;
  double get totalCorpIncomePrior => _totalCorpIncomePrior.value;
  bool get verifiedCheck => _verifiedCheck.value;
  bool get moreThan5YearsOld => _moreThan5YearsOld.value;
  bool get verifiedButExeCheck => _verifiedButExeCheck.value;
  String get calculationMessage => _calculationMessage.value;

  @override
  void onInit() async{
    await getCurrentAndPreviousYears();
    super.onInit();
  }

  setCurrentActiveStatus(bool value){
    _currentlyActive.value = value;
  }
  getCurrentAndPreviousYears(){
    var currentDate = DateTime.now();
    var w2Date = DateTime(currentDate.year-1);
    var priorW2Date = DateTime(w2Date.year-1);
    _baseYear.value = currentDate.year.toString();
    _w2Year.value = w2Date.year.toString();
    _priorW2Year.value = priorW2Date.year.toString();
  }
  calculateForm1040SubTotalAmount(String type){
    if(type == 'recent'){
      _w2IncomeFromSelfEmploymentRecentSubTotal.value = w2IncomeFromSelfEmploymentRecent.value;
      _personalTaxReturnsRecent.value = w2IncomeFromSelfEmploymentRecent.value;
      sumOfTaxReturnsAndPartnershipIncome('recent');
      calculateMonthlyIncome();
    }else{
      _w2IncomeFromSelfEmploymentPriorSubTotal.value = w2IncomeFromSelfEmploymentPrior.value;
      _personalTaxReturnsPrior.value = w2IncomeFromSelfEmploymentPrior.value;
      sumOfTaxReturnsAndPartnershipIncome('prior');
      calculateMonthlyIncome();
    }
  }
  calculateForm1120SubTotalAmount(String type){
    if(type == 'recent') {
      double calculatedTotalTaxRecent = -totalTaxRecent.value;
      double calculatedMealsAndEntertainmentRecent = -mealsAndEntertainmentRecent.value;
      double calculatedMortgagePayableInLessThanOneYearRecent = -mortgagePayableInLessThanOneYearRecent.value;
      _from1120RecentSubtotal.value = taxableIncomeRecent.value + calculatedTotalTaxRecent + nonRecurringGainLossRecent.value+
          nonRecurringOtherIncomeLossRecent.value + depreciationRecent.value + depletionRecent.value +
          amortizationCasualtyLossOneTimeExpenseRecent.value + netOperatingLossAndSpecialDeductionsRecent.value +
          calculatedMortgagePayableInLessThanOneYearRecent + calculatedMealsAndEntertainmentRecent;
      calculateOwnerShipPercentageTotalAmount('recent');
      sumOfTaxReturnsAndPartnershipIncome('recent');
      calculateMonthlyIncome();
    }else{
      double calculatedTotalTaxPrior = -totalTaxPrior.value;
      double calculatedMealsAndEntertainmentPrior = -mealsAndEntertainmentPrior.value;
      double calculatedMortgagePayableInLessThanOneYearPrior = -mortgagePayableInLessThanOneYearPrior.value;
      _from1120PriorSubtotal.value = taxableIncomePrior.value + calculatedTotalTaxPrior + nonRecurringGainLossPrior.value+
          nonRecurringOtherIncomeLossPrior.value + depreciationPrior.value + depletionPrior.value +
          amortizationCasualtyLossOneTimeExpensePrior.value + netOperatingLossAndSpecialDeductionsPrior.value +
          calculatedMortgagePayableInLessThanOneYearPrior + calculatedMealsAndEntertainmentPrior;
      calculateOwnerShipPercentageTotalAmount('prior');
      sumOfTaxReturnsAndPartnershipIncome('prior');
      calculateMonthlyIncome();
    }
  }
  calculateOwnerShipPercentageTotalAmount(String type){
    if(type == 'recent') {
      _cashFlowRecentSubtotal.value = (from1120RecentSubtotal * ownershipPercentageRecent.value) / 100;
      sumOfTaxReturnsAndPartnershipIncome('recent');
      calculateMonthlyIncome();
    }else{
      _cashFlowPriorSubtotal.value = (from1120PriorSubtotal * ownershipPercentagePrior.value) / 100;
      sumOfTaxReturnsAndPartnershipIncome('prior');
      calculateMonthlyIncome();
    }
  }
  setPartnerShipReturns(String type,bool status){
    if(type == 'recent'){
      _addPartnershipReturnsRecent.value = status;
      sumOfTaxReturnsAndPartnershipIncome('recent');
      calculateMonthlyIncome();
    }else{
      _addPartnershipReturnsPrior.value = status;
      sumOfTaxReturnsAndPartnershipIncome('prior');
      calculateMonthlyIncome();
    }
  }
  sumOfTaxReturnsAndPartnershipIncome(String type){
    if(type == 'recent') {
      if(addPartnershipReturnsRecent == true){
        _totalOfTaxReturnAndGrandTotalRecent.value = personalTaxReturnsRecent + (totalCorpIncomeRecent == 0.0? cashFlowRecentSubtotal:totalCorpIncomeRecent);
        calculateMonthlyIncome();
      }else{
        _totalOfTaxReturnAndGrandTotalRecent.value = personalTaxReturnsRecent;
        calculateMonthlyIncome();
      }
    }else{
      if(addPartnershipReturnsPrior == true){
        _totalOfTaxReturnAndGrandTotalPrior.value = personalTaxReturnsPrior + (totalCorpIncomePrior == 0.0? cashFlowPriorSubtotal:totalCorpIncomePrior);
        calculateMonthlyIncome();
      }else{
        _totalOfTaxReturnAndGrandTotalPrior.value = personalTaxReturnsPrior;
        calculateMonthlyIncome();
      }
    }
  }
  calculateMonthlyIncome(){
    if(!_moreThan5YearsOld.value){
      if(_totalOfTaxReturnAndGrandTotalPrior.value == _totalOfTaxReturnAndGrandTotalRecent.value && _totalOfTaxReturnAndGrandTotalPrior.value != 0.0 && _totalOfTaxReturnAndGrandTotalRecent.value != 0.0){
        double total= _totalOfTaxReturnAndGrandTotalPrior.value + _totalOfTaxReturnAndGrandTotalRecent.value;
        _monthlyIncome.value =total/24;
        setCalculationMessage('1', _totalOfTaxReturnAndGrandTotalPrior.value, _totalOfTaxReturnAndGrandTotalRecent.value, w2Year, priorW2Year,_monthlyIncome.value);
      }
      else if(_totalOfTaxReturnAndGrandTotalPrior.value < _totalOfTaxReturnAndGrandTotalRecent.value && _totalOfTaxReturnAndGrandTotalPrior.value != 0.0 && _totalOfTaxReturnAndGrandTotalRecent.value != 0.0){
        double total= _totalOfTaxReturnAndGrandTotalPrior.value + _totalOfTaxReturnAndGrandTotalRecent.value;
        _monthlyIncome.value =total/24;
        setCalculationMessage('2', _totalOfTaxReturnAndGrandTotalPrior.value, _totalOfTaxReturnAndGrandTotalRecent.value, w2Year, priorW2Year,_monthlyIncome.value);
      }
      else if(_totalOfTaxReturnAndGrandTotalPrior.value > _totalOfTaxReturnAndGrandTotalRecent.value && _totalOfTaxReturnAndGrandTotalPrior.value != 0.0 && _totalOfTaxReturnAndGrandTotalRecent.value != 0.0){
        double total= _totalOfTaxReturnAndGrandTotalRecent.value;
        _monthlyIncome.value =total/12;
        setCalculationMessage('3', _totalOfTaxReturnAndGrandTotalPrior.value, _totalOfTaxReturnAndGrandTotalRecent.value, w2Year, priorW2Year,_monthlyIncome.value);
      }
      else if(_totalOfTaxReturnAndGrandTotalPrior.value == 0.0 && _totalOfTaxReturnAndGrandTotalRecent.value != 0.0){
        double total= _totalOfTaxReturnAndGrandTotalRecent.value;
        _monthlyIncome.value =total/24;
        setCalculationMessage('4', _totalOfTaxReturnAndGrandTotalPrior.value, _totalOfTaxReturnAndGrandTotalRecent.value, w2Year, priorW2Year,_monthlyIncome.value);
      }
      else if(_totalOfTaxReturnAndGrandTotalPrior.value != 0.0 && _totalOfTaxReturnAndGrandTotalRecent.value == 0.0){
        _monthlyIncome.value = 0.0;
        setCalculationMessage('5', _totalOfTaxReturnAndGrandTotalPrior.value, _totalOfTaxReturnAndGrandTotalRecent.value, w2Year, priorW2Year,_monthlyIncome.value);
      }
      else{
        _monthlyIncome.value = 0.0;
        setCalculationMessage('7', _totalOfTaxReturnAndGrandTotalPrior.value, _totalOfTaxReturnAndGrandTotalRecent.value, w2Year, priorW2Year,_monthlyIncome.value);
      }
    }else{
      if(_totalOfTaxReturnAndGrandTotalPrior.value == 0.0 && _totalOfTaxReturnAndGrandTotalRecent.value != 0.0){
        double total= _totalOfTaxReturnAndGrandTotalRecent.value;
        _monthlyIncome.value =total/12;
        setCalculationMessage('6', _totalOfTaxReturnAndGrandTotalPrior.value, _totalOfTaxReturnAndGrandTotalRecent.value, w2Year, priorW2Year,_monthlyIncome.value);
      }else if(_totalOfTaxReturnAndGrandTotalPrior.value != 0.0 && _totalOfTaxReturnAndGrandTotalRecent.value != 0.0){
        double total= _totalOfTaxReturnAndGrandTotalRecent.value;
        _monthlyIncome.value =total/12;
        setCalculationMessage('6', _totalOfTaxReturnAndGrandTotalPrior.value, _totalOfTaxReturnAndGrandTotalRecent.value, w2Year, priorW2Year,_monthlyIncome.value);
      }else{
        _monthlyIncome.value = 0.0;
        setCalculationMessage('7', _totalOfTaxReturnAndGrandTotalPrior.value, _totalOfTaxReturnAndGrandTotalRecent.value, w2Year, priorW2Year,_monthlyIncome.value);
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
      'if your business is more than 5 years old then trend is only set for one year $w2Year only. So the monthly income is considered as \n${UtilMethods().formatNumberWithCommas(subTotalRecent)} / 12 = ${UtilMethods().formatNumberWithCommas(monthlyIncome)}';
    }else if(condition == '7'){
      _calculationMessage.value = '';
    }
  }
  calculateTotalCorpIncome(String type){
    if(type == 'recent'){
      _totalCorpIncomeRecent.value = dividendsPaidToBorrowerRecent.value != 0.0? cashFlowRecentSubtotal - dividendsPaidToBorrowerRecent.value:0.0;
      // _cashFlowRecentSubtotal.value = dividendsPaidToBorrowerRecent.value != 0.0? cashFlowRecentSubtotal - dividendsPaidToBorrowerRecent.value:0.0;
      sumOfTaxReturnsAndPartnershipIncome('recent');
    }else{
      _totalCorpIncomePrior.value = dividendsPaidToBorrowerPrior.value != 0.0? cashFlowPriorSubtotal - dividendsPaidToBorrowerPrior.value:0.0;
      // _cashFlowPriorSubtotal.value = dividendsPaidToBorrowerPrior.value != 0.0? cashFlowPriorSubtotal - dividendsPaidToBorrowerPrior.value:0.0;
      sumOfTaxReturnsAndPartnershipIncome('prior');
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
