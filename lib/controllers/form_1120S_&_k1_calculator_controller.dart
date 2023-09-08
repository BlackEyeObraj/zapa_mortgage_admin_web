import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Form1120SCalculatorController extends GetxController{
  final RxString _baseYear = ''.obs;
  final RxString _w2Year = ''.obs;
  final RxString _priorW2Year = ''.obs;
  final RxBool _currentlyActive = true.obs;
  final RxBool _addPartnershipReturnsRecent = true.obs;
  final RxBool _addPartnershipReturnsPrior = true.obs;

  RxString  businessStartDateStamp = ''.obs;
  RxString  greaterOrLessThen2Years = ''.obs;

  /////// Form 1040 //////
  final RxDouble w2IncomeFromSelfEmploymentRecent = 0.0.obs;
  final RxDouble w2IncomeFromSelfEmploymentPrior = 0.0.obs;
  /// Subtotal
  final RxDouble _w2IncomeFromSelfEmploymentRecentSubTotal = 0.0.obs;
  final RxDouble _w2IncomeFromSelfEmploymentPriorSubTotal = 0.0.obs;

  /////// K1 ///////
  final RxDouble ordinaryIncomeLossRecent = 0.0.obs;
  final RxDouble ordinaryIncomeLossPrior = 0.0.obs;
  /// subtotal
  final RxDouble _k1SubtotalRecent = 0.0.obs;
  final RxDouble _k1SubtotalPrior = 0.0.obs;

  /////// Form 1120S recent ///////
  final RxDouble nonRecurringOtherIncomeLossRecent = 0.0.obs;
  final RxDouble depreciationRecent = 0.0.obs;
  final RxDouble depletionRecent = 0.0.obs;
  final RxDouble amortizationCasualtyLossOneTimeExpenseRecent = 0.0.obs;
  final RxDouble mortgagePayableInLessThanOneYearRecent = 0.0.obs;
  final RxDouble mealsAndEntertainmentRecent = 0.0.obs;
  /// form 1120S subtotal
  final RxDouble _from1120SRecentSubtotal = 0.0.obs;

  final RxDouble ownershipPercentageRecent = 0.0.obs;
  /// form 1120S cashFlow subtotal
  final RxDouble _cashFlowRecentSubtotal = 0.0.obs;


  /////// Form 1120S prior ///////
  final RxDouble nonRecurringOtherIncomeLossPrior = 0.0.obs;
  final RxDouble depreciationPrior = 0.0.obs;
  final RxDouble depletionPrior = 0.0.obs;
  final RxDouble amortizationCasualtyLossOneTimeExpensePrior = 0.0.obs;
  final RxDouble mortgagePayableInLessThanOneYearPrior = 0.0.obs;
  final RxDouble mealsAndEntertainmentPrior = 0.0.obs;
  /// form 1065 subtotal
  final RxDouble _from1120SPriorSubtotal = 0.0.obs;

  final RxDouble ownershipPercentagePrior = 0.0.obs;
  /// form 1065 cashFlow subtotal
  final RxDouble _cashFlowPriorSubtotal = 0.0.obs;


  final RxDouble _personalTaxReturnsRecent = 0.0.obs;
  final RxDouble _personalTaxReturnsPrior = 0.0.obs;

  final RxDouble _totalOfTaxReturnAndGrandTotalRecent = 0.0.obs;
  final RxDouble _totalOfTaxReturnAndGrandTotalPrior = 0.0.obs;

  final RxDouble numberOfMonths = 0.0.obs;
  final RxDouble _monthlyIncome = 0.0.obs;


  final nameOfPartnerShipTextController = TextEditingController();
  final sElectionEffectiveDateTextController = TextEditingController();
  final businessNameTypeTextController = TextEditingController();
  final businessStartDateTextController = TextEditingController();

  /// Form 1040
  final w2IncomeFromSelfEmploymentMostRecentTextController = TextEditingController();
  final w2IncomeFromSelfEmploymentPriorTextController = TextEditingController();

  /// K1
  final ordinaryIncomeLossRecentTextController = TextEditingController();
  final ordinaryIncomeLossPriorTextController = TextEditingController();

  /// From 1120s recent
  final nonRecurringOtherIncomeLossRecentTextController = TextEditingController();
  final depreciationRecentTextController = TextEditingController();
  final depletionRecentTextController = TextEditingController();
  final amortizationCasualtyLossOneTimeExpenseRecentIncomeTextController = TextEditingController();
  final mortgagePayableInLessThanOneYearRecentIncomeTextController = TextEditingController();
  final mealsAndEntertainmentRecentIncomeTextController = TextEditingController();
  final ownershipPercentageRecentIncomeTextController = TextEditingController();

  /// From 1120s prior
  final nonRecurringOtherIncomeLossPriorTextController = TextEditingController();
  final depreciationPriorTextController = TextEditingController();
  final depletionPriorTextController = TextEditingController();
  final amortizationCasualtyLossOneTimeExpensePriorIncomeTextController = TextEditingController();
  final mortgagePayableInLessThanOneYearPriorIncomeTextController = TextEditingController();
  final mealsAndEntertainmentPriorIncomeTextController = TextEditingController();
  final ownershipPercentagePriorIncomeTextController = TextEditingController();

  final numberOfMonthsTextController = TextEditingController();

  bool get currentlyActive => _currentlyActive.value;
  String get baseYear => _baseYear.value;
  String get w2Year => _w2Year.value;
  String get priorW2Year => _priorW2Year.value;
  double get w2IncomeFromSelfEmploymentRecentSubTotal => _w2IncomeFromSelfEmploymentRecentSubTotal.value;
  double get w2IncomeFromSelfEmploymentPriorSubTotal => _w2IncomeFromSelfEmploymentPriorSubTotal.value;

  double get k1SubtotalRecent => _k1SubtotalRecent.value;
  double get k1SubtotalPrior => _k1SubtotalPrior.value;

  double get from1120SRecentSubtotal => _from1120SRecentSubtotal.value;
  double get cashFlowRecentSubtotal => _cashFlowRecentSubtotal.value;
  double get from1120SPriorSubtotal => _from1120SPriorSubtotal.value;
  double get cashFlowPriorSubtotal => _cashFlowPriorSubtotal.value;

  double get personalTaxReturnsRecent => _personalTaxReturnsRecent.value;
  double get personalTaxReturnsPrior => _personalTaxReturnsPrior.value;

  bool get addPartnershipReturnsRecent => _addPartnershipReturnsRecent.value;
  bool get addPartnershipReturnsPrior => _addPartnershipReturnsPrior.value;

  double get totalOfTaxReturnAndGrandTotalRecent => _totalOfTaxReturnAndGrandTotalRecent.value;
  double get totalOfTaxReturnAndGrandTotalPrior => _totalOfTaxReturnAndGrandTotalPrior.value;

  double get monthlyIncome => _monthlyIncome.value;


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
      _personalTaxReturnsRecent.value = w2IncomeFromSelfEmploymentRecent.value + ordinaryIncomeLossRecent.value;
      sumOfTaxReturnsAndPartnershipIncome('recent');
      calculateMonthlyIncome();
    }else{
      _w2IncomeFromSelfEmploymentPriorSubTotal.value = w2IncomeFromSelfEmploymentPrior.value;
      _personalTaxReturnsPrior.value = w2IncomeFromSelfEmploymentPrior.value + ordinaryIncomeLossPrior.value;
      sumOfTaxReturnsAndPartnershipIncome('prior');
      calculateMonthlyIncome();
    }
  }
  calculateK1SubTotalAmount(String type){
    if(type == 'recent') {
      _k1SubtotalRecent.value = ordinaryIncomeLossRecent.value;

      _personalTaxReturnsRecent.value = w2IncomeFromSelfEmploymentRecent.value + ordinaryIncomeLossRecent.value;

      sumOfTaxReturnsAndPartnershipIncome('recent');
      calculateMonthlyIncome();
    }else{
      _k1SubtotalPrior.value = ordinaryIncomeLossPrior.value;

      _personalTaxReturnsPrior.value = w2IncomeFromSelfEmploymentPrior.value + ordinaryIncomeLossPrior.value;

      sumOfTaxReturnsAndPartnershipIncome('prior');
      calculateMonthlyIncome();
    }
  }
  calculateForm1120SSubTotalAmount(String type){
    if(type == 'recent') {
      double calculatedMealsAndEntertainmentRecent = -mealsAndEntertainmentRecent.value;
      double calculatedMortgagePayableInLessThanOneYearRecent = -mortgagePayableInLessThanOneYearRecent.value;
      _from1120SRecentSubtotal.value = nonRecurringOtherIncomeLossRecent.value +
          depreciationRecent.value + depletionRecent.value + amortizationCasualtyLossOneTimeExpenseRecent.value +
          calculatedMortgagePayableInLessThanOneYearRecent + calculatedMealsAndEntertainmentRecent;
      calculateOwnerShipPercentageTotalAmount('recent');
      sumOfTaxReturnsAndPartnershipIncome('recent');
      calculateMonthlyIncome();
    }else{
      double calculatedMealsAndEntertainmentPrior = -mealsAndEntertainmentPrior.value;
      double calculatedMortgagePayableInLessThanOneYearPrior = -mortgagePayableInLessThanOneYearPrior.value;
      _from1120SPriorSubtotal.value = nonRecurringOtherIncomeLossPrior.value +
          depreciationPrior.value + depletionPrior.value + amortizationCasualtyLossOneTimeExpensePrior.value +
          calculatedMortgagePayableInLessThanOneYearPrior + calculatedMealsAndEntertainmentPrior;
      calculateOwnerShipPercentageTotalAmount('prior');
      sumOfTaxReturnsAndPartnershipIncome('prior');
      calculateMonthlyIncome();
    }
  }
  calculateOwnerShipPercentageTotalAmount(String type){
    if(type == 'recent') {
      _cashFlowRecentSubtotal.value = (from1120SRecentSubtotal * ownershipPercentageRecent.value) / 100;
      sumOfTaxReturnsAndPartnershipIncome('recent');
      calculateMonthlyIncome();
    }else{
      _cashFlowPriorSubtotal.value = (from1120SPriorSubtotal * ownershipPercentagePrior.value) / 100;
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
        _totalOfTaxReturnAndGrandTotalRecent.value = personalTaxReturnsRecent + cashFlowRecentSubtotal;
        calculateMonthlyIncome();
      }else{
        _totalOfTaxReturnAndGrandTotalRecent.value = personalTaxReturnsRecent;
        calculateMonthlyIncome();
      }
    }else{
      if(addPartnershipReturnsPrior == true){
        _totalOfTaxReturnAndGrandTotalPrior.value = personalTaxReturnsPrior + cashFlowPriorSubtotal;
        calculateMonthlyIncome();
      }else{
        _totalOfTaxReturnAndGrandTotalPrior.value = personalTaxReturnsPrior;
        calculateMonthlyIncome();
      }
    }
  }
  calculateMonthlyIncome(){
    double sumOfGrandTotals = _totalOfTaxReturnAndGrandTotalRecent.value + _totalOfTaxReturnAndGrandTotalPrior.value;
    double checkInfinity = sumOfGrandTotals / numberOfMonths.value;
    if (checkInfinity.isInfinite) {
      _monthlyIncome.value = 0.0; // Set to a default value for infinity
    } else if (checkInfinity.isNaN) {
      _monthlyIncome.value = 0.0; // Set to a default value for NaN
    } else {
      _monthlyIncome.value = checkInfinity;
    }
  }
}