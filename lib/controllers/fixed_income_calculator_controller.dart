import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/firestore_service.dart';
import '../utils/utils_mehtods.dart';

class FixedIncomeCalculatorController extends GetxController{

  @override
  void onInit() {
    getCurrentAndPreviousYears();
    super.onInit();
  }

  final RxString baseYear = ''.obs;
  final RxString w2Year = ''.obs;
  final RxString priorW2Year = ''.obs;
  final RxString selectedAddedBy = 'processor'.obs;
  final RxBool _verifiedCheck = true.obs;
  final RxBool _verifiedButExeCheck = false.obs;
  final RxString _salaryCycle = ''.obs;
  final RxBool _currentWorking = true.obs;
  final RxBool  _additionalW2IncomeTypes = false.obs;
  final RxInt _selectedPayPeriodEndDateMonth = 0.obs;
  final RxInt _selectedPayPeriodEndDateDay = 0.obs;
  final RxInt _salaryCycleValue = 0.obs;
  final RxString _calculatedMonthlyIncomeFixed = '0.0'.obs;
  final RxDouble _calculatedMonthlyIncomeFixedSimple = 0.0.obs;
  final RxString _calculatedBaseIncomeYTDFixed = '0.0'.obs;
  final RxString _calculatedW2Fixed = '0.0'.obs;
  final RxString _calculatedPriorW2Fixed = '0.0'.obs;
  final RxString _calculatedDifference = '0.0'.obs;
  final RxString _calculatedDifferenceValueType = ''.obs;
  final RxDouble _totalOverTime = 0.0.obs;
  final RxDouble _totalBonus= 0.0.obs;
  final RxDouble _totalCommission = 0.0.obs;
  final RxDouble _totalTips = 0.0.obs;
  final RxDouble _totalOthers = 0.0.obs;
  final RxString _totalAdditionalW2sAmount = '0.0'.obs;
  final RxDouble _baseOverTime = 0.0.obs;
  final RxDouble _w2OverTime = 0.0.obs;
  final RxDouble _priorW2OverTime = 0.0.obs;
  final RxDouble _baseBonus = 0.0.obs;
  final RxDouble _w2Bonus = 0.0.obs;
  final RxDouble _priorW2Bonus = 0.0.obs;
  final RxDouble _baseCommission = 0.0.obs;
  final RxDouble _w2Commission = 0.0.obs;
  final RxDouble _priorW2Commission = 0.0.obs;
  final RxDouble _baseTips = 0.0.obs;
  final RxDouble _w2Tips = 0.0.obs;
  final RxDouble _priorW2Tips = 0.0.obs;
  final RxDouble _baseOthers = 0.0.obs;
  final RxDouble _w2Others = 0.0.obs;
  final RxDouble _priorW2Others = 0.0.obs;
  final RxString _summaryTotal = '0.0'.obs;
  final RxDouble _summaryTotalSample = 0.0.obs;

  final payPeriodEndDateController = TextEditingController();
  final dateOfPayCheckController = TextEditingController();
  final additionalW2IncomeController = TextEditingController();
  final payRatePerCycleController = TextEditingController();
  final baseIncomeYearToDateController = TextEditingController();
  final latestYearsW2Box5IncomeController = TextEditingController();
  final priorYearsW2Box5IncomeController = TextEditingController();
  final employerNameController = TextEditingController();
  final employerStartDateController = TextEditingController();
  final employerEndDateController = TextEditingController();
  final w2OverTimeFixedController = TextEditingController();
  final baseOverTimeFixedController = TextEditingController();
  final priorW2OverTimeFixedController = TextEditingController();
  final baseBonusFixedController = TextEditingController();
  final w2BonusFixedController = TextEditingController();
  final priorW2BonusFixedController = TextEditingController();
  final baseCommissionFixedController = TextEditingController();
  final w2CommissionFixedController = TextEditingController();
  final priorW2CommissionFixedController = TextEditingController();
  final baseTipsFixedController = TextEditingController();
  final w2TipsFixedController = TextEditingController();
  final priorW2TipsFixedController = TextEditingController();
  final baseOthersFixedController = TextEditingController();
  final w2OthersFixedController = TextEditingController();
  final priorW2OthersFixedController = TextEditingController();

  String get salaryCycle => _salaryCycle.value;
  int get salaryCycleValue => _salaryCycleValue.value;
  bool get currentWorkingFixedIncome => _currentWorking.value;
  int get selectedPayPeriodEndDateMonth => _selectedPayPeriodEndDateMonth.value;
  int get selectedPayPeriodEndDateDay => _selectedPayPeriodEndDateDay.value;
  String get calculatedMonthlyIncomeFixed => _calculatedMonthlyIncomeFixed.value;
  String get calculatedBaseIncomeYTDFixed => _calculatedBaseIncomeYTDFixed.value;
  String get calculatedW2Fixed => _calculatedW2Fixed.value;
  String get calculatedPriorW2Fixed => _calculatedPriorW2Fixed.value;
  String get calculatedDifference => _calculatedDifference.value;
  String get calculatedDifferenceValueType => _calculatedDifferenceValueType.value;
  double get totalOverTime => _totalOverTime.value;
  double get totalBonus => _totalBonus.value;
  double get totalCommission => _totalCommission.value;
  double get totalTips => _totalTips.value;
  double get totalOthers => _totalOthers.value;
  String get totalAdditionalW2sAmount => _totalAdditionalW2sAmount.value;
  bool get additionalW2IncomeTypes => _additionalW2IncomeTypes.value;
  double get baseOverTime => _baseOverTime.value;
  double get w2OverTime => _w2OverTime.value;
  double get priorW2OverTime => _priorW2OverTime.value;
  double get baseBonus => _baseBonus.value;
  double get w2Bonus => _w2Bonus.value;
  double get priorW2Bonus => _priorW2Bonus.value;
  double get baseCommission => _baseCommission.value;
  double get w2Commission => _w2Commission.value;
  double get priorW2Commission => _priorW2Commission.value;
  double get baseTips => _baseTips.value;
  double get w2Tips => _w2Tips.value;
  double get priorW2Tips => _priorW2Tips.value;
  double get baseOthers => _baseOthers.value;
  double get w2Others => _w2Others.value;
  double get priorW2Others => _priorW2Others.value;
  String get summaryTotal => _summaryTotal.value;
  double get summaryTotalSample => _summaryTotalSample.value;
  bool get verifiedCheck => _verifiedCheck.value;
  bool get verifiedButExeCheck => _verifiedButExeCheck.value;


  setSalaryCycle(String value){
    _salaryCycle.value = value;
    if(value == 'Hourly'){
      _salaryCycleValue.value = 40 * 52;
      calculateMonthlyIncome(payRatePerCycleController.text);
      calculateBaseIncomeYTD(baseIncomeYearToDateController.text);
      calculateTotalSummaryIncome();
    }if(value == 'Weekly'){
      _salaryCycleValue.value = 52;
      calculateMonthlyIncome(payRatePerCycleController.text);
      calculateBaseIncomeYTD(baseIncomeYearToDateController.text);
      calculateTotalSummaryIncome();
    }else if(value == 'Bi Weekly'){
      _salaryCycleValue.value = 26;
      calculateMonthlyIncome(payRatePerCycleController.text);
      calculateBaseIncomeYTD(baseIncomeYearToDateController.text);
      calculateTotalSummaryIncome();
    }else if(value == 'Semi Monthly'){
      _salaryCycleValue.value = 24;
      calculateMonthlyIncome(payRatePerCycleController.text);
      calculateBaseIncomeYTD(baseIncomeYearToDateController.text);
      calculateTotalSummaryIncome();
    }else if(value == 'Monthly'){
      if(payRatePerCycleController.text.isNotEmpty){
        _calculatedMonthlyIncomeFixed.value = payRatePerCycleController.text;
        calculateTotalSummaryIncome();
      }else{
        _calculatedMonthlyIncomeFixed.value = '0.0';
        calculateTotalSummaryIncome();
      }
    }

  }
  setCurrentWorkingFixed(bool value){
    _currentWorking.value = value;
  }
  setAdditionalW2IncomeTypes(bool value){
    _additionalW2IncomeTypes.value = value;
  }

  setSelectedPayPeriodEndDateDayAndMonth(int day, int month){
    _selectedPayPeriodEndDateDay.value = day;
    _selectedPayPeriodEndDateMonth.value = month;
    calculateOverTimeIncomeTestCase();
    calculateBonusIncomeTestCase();
    calculateCommissionIncomeTestCase();
    calculateTipsIncomeTestCase();
    calculateOthersIncomeTestCase();
  }

  setAdditionalIncomesValues(String type, double amount){
    if(type == 'baseOverTime'){
      _baseOverTime.value = amount;
    }else if(type == 'w2OverTime'){
      _w2OverTime.value = amount;
    }else if(type == 'priorW2OverTime'){
      _priorW2OverTime.value = amount;
    }else if(type == 'baseBonus'){
      _baseBonus.value = amount;
    }else if(type == 'w2Bonus'){
      _w2Bonus.value = amount;
    }else if(type == 'priorW2Bonus'){
      _priorW2Bonus.value = amount;
    }else if(type == 'baseCommission'){
      _baseCommission.value = amount;
    }else if(type == 'w2Commission'){
      _w2Commission.value = amount;
    }else if(type == 'priorW2Commission'){
      _priorW2Commission.value = amount;
    }else if(type == 'baseTips'){
      _baseTips.value = amount;
    }else if(type == 'w2Tips'){
      _w2Tips.value = amount;
    }else if(type == 'priorW2Tips'){
      _priorW2Tips.value = amount;
    }else if(type == 'baseOthers'){
      _baseOthers.value = amount;
    }else if(type == 'w2Others'){
      _w2Others.value = amount;
    }else if(type == 'priorW2Others'){
      _priorW2Others.value = amount;
    }
  }

  calculateMonthlyIncome(String annualIncome){
    if(annualIncome != ''){
      if(salaryCycle != 'Monthly'){
        var result = double.parse(annualIncome) * salaryCycleValue / 12;
        _calculatedMonthlyIncomeFixedSimple.value = result;
        double value = double.parse(result.toStringAsFixed(2));
        String finalResult = UtilMethods().formatNumberWithCommas(value).toString();
        _calculatedMonthlyIncomeFixed.value = finalResult;
        calculateTotalSummaryIncome();
      }else{
        var result = double.parse(annualIncome);
        _calculatedMonthlyIncomeFixedSimple.value = result;
        double value = double.parse(result.toStringAsFixed(2));
        String finalResult = UtilMethods().formatNumberWithCommas(value).toString();
        _calculatedMonthlyIncomeFixed.value = finalResult;
        calculateTotalSummaryIncome();
      }
    }else {
      _calculatedMonthlyIncomeFixed.value = '0.0';
      calculateTotalSummaryIncome();
    }
  }
  calculateDifference(){
    int months = selectedPayPeriodEndDateMonth - 1;
    String m = months.toString();
    double calculateDaysOfCurrentMonth = selectedPayPeriodEndDateDay / 30;
    String c = calculateDaysOfCurrentMonth.toString();
    double totalCount = double.parse(m) + double.parse(c);
    String monthCount = totalCount.toStringAsFixed(2);
    var result = _calculatedMonthlyIncomeFixedSimple.value * double.parse(monthCount) - double.parse(baseIncomeYearToDateController.text);

    String answer = result.toStringAsFixed(2);
    _calculatedDifference.value = answer;
    checkDoubleValue(result);
  }
  calculateBaseIncomeYTD(String baseIncome){
    if(baseIncome != ''){
      int months = selectedPayPeriodEndDateMonth - 1;
      String m = months.toString();
      double calculateDaysOfCurrentMonth = selectedPayPeriodEndDateDay / 30;
      String c = calculateDaysOfCurrentMonth.toString();
      double totalCount = double.parse(m) + double.parse(c);
      double result = double.parse(baseIncomeYearToDateController.text) / totalCount;
      _calculatedBaseIncomeYTDFixed.value = UtilMethods().formatNumberWithCommas(result);
      calculateDifference();
    }else{
      _calculatedBaseIncomeYTDFixed.value = '0.0';
      _calculatedDifference.value = '0.0';
    }
  }

  calculateW2Income(String w2Income){
    if(w2Income != ''){
      double calculate = double.parse(w2Income) / 12;
      String result = UtilMethods().formatNumberWithCommas(double.parse(calculate.toStringAsFixed(2)));
      _calculatedW2Fixed.value = result;
      // calculateDifference();
    }else{
      _calculatedW2Fixed.value = '0.0';
    }
  }
  calculatePriorW2Income(String priorW2Income){
    if(priorW2Income != ''){
      double calculate = double.parse(priorW2Income) / 12;
      String result = UtilMethods().formatNumberWithCommas(double.parse(calculate.toStringAsFixed(2)));
      _calculatedPriorW2Fixed.value = result;
    }else{
      _calculatedPriorW2Fixed.value = '0.0';
    }
  }

  calculateAdditionalMethod(String type){
    if(type == 'overTime'){
      return calculateOverTimeIncomeTestCase();
    }else if(type == 'bonus'){
      return calculateBonusIncomeTestCase();
    }else if(type == 'commission'){
      return calculateCommissionIncomeTestCase();
    }else if(type == 'tips'){
      return calculateTipsIncomeTestCase();
    }else if(type == 'other'){
      return calculateOthersIncomeTestCase();
    }
  }
  addIncome(String borrowerId, String verifyStatus, String selectedAddedBy)async{
    await FirestoreService().addFixedIncomeCalculator(
      borrowerId,
      employerNameController.text,
      employerStartDateController.text,
      employerEndDateController.text,
      dateOfPayCheckController.text,
      payPeriodEndDateController.text,
      salaryCycle,
      payRatePerCycleController.text,
      baseIncomeYearToDateController.text,
      latestYearsW2Box5IncomeController.text,
      priorYearsW2Box5IncomeController.text,
      additionalW2IncomeTypes.toString(),
      baseOverTime,
      w2OverTime,
      priorW2OverTime,
      baseBonus,
      w2Bonus,
      priorW2Bonus,
      baseCommission,
      w2Commission,
      priorW2Commission,
      baseTips,
      w2Tips,
      priorW2Tips,
      baseOthers,
      w2Others,
      priorW2Others,
      'Fixed Income',
      _calculatedMonthlyIncomeFixedSimple.toString(),
      totalOverTime.toString(),
      totalBonus.toString(),
      totalCommission.toString(),
      totalTips.toString(),
      totalOthers.toString(),
      summaryTotalSample.toString(),
      baseYear.value,
      w2Year.value,
      priorW2Year.value,
      selectedPayPeriodEndDateDay.toString(),
      selectedPayPeriodEndDateMonth.toString(),
      verifyStatus,
      selectedAddedBy
    );
  }

  calculateOverTimeIncomeTestCase(){
     if(priorW2OverTime < w2OverTime && priorW2OverTime != 0.0 && w2OverTime != 0.0 && baseOverTime == 0.0){
    double totalAmount = priorW2OverTime + w2OverTime;
    double totalYearsAndMonth = 24;
    double overTimeAmount = totalAmount / totalYearsAndMonth;
    _totalOverTime.value = overTimeAmount;
    calculateTotalSummaryIncome();
    }
    else if(w2OverTime > priorW2OverTime && priorW2OverTime != 0.0 && w2OverTime != 0.0 && baseOverTime == 0.0){
    double totalAmount = priorW2OverTime + w2OverTime;
    double totalYearsAndMonth = 24;
    double overTimeAmount = totalAmount / totalYearsAndMonth;
    _totalOverTime.value = overTimeAmount;
    calculateTotalSummaryIncome();
    }
    else if(priorW2OverTime > w2OverTime && priorW2OverTime != 0.0 && w2OverTime != 0.0 && baseOverTime == 0.0){
    double totalAmount = w2OverTime;
    double totalYearsAndMonth = 12;
    double overTimeAmount = totalAmount / totalYearsAndMonth;
    _totalOverTime.value = overTimeAmount;
    calculateTotalSummaryIncome();
    }
    else if(w2OverTime < priorW2OverTime && priorW2OverTime != 0.0 && w2OverTime != 0.0 && baseOverTime == 0.0){
    double totalAmount = w2OverTime;
    double totalYearsAndMonth = 12;
    double overTimeAmount = totalAmount / totalYearsAndMonth;
    _totalOverTime.value = overTimeAmount;
    calculateTotalSummaryIncome();
    }
    /// w2 and base
    else if(w2OverTime < baseOverTime && w2OverTime != 0.0 && baseOverTime != 0.0 && priorW2OverTime == 0.0){
    double totalAmount = w2OverTime + baseOverTime;
    double totalYearsAndMonth = 12 + double.parse(calculateBaseMonthAndDays());
    double overTimeAmount = totalAmount / totalYearsAndMonth;
    _totalOverTime.value = overTimeAmount;
    calculateTotalSummaryIncome();
    }
    else if(baseOverTime > w2OverTime && w2OverTime != 0.0 && baseOverTime != 0.0 && priorW2OverTime == 0.0){
    double totalAmount = w2OverTime + baseOverTime;
    double totalYearsAndMonth = 12 + double.parse(calculateBaseMonthAndDays());
    double overTimeAmount = totalAmount / totalYearsAndMonth;
    _totalOverTime.value = overTimeAmount;
    calculateTotalSummaryIncome();
    }
    else if(w2OverTime > baseOverTime && w2OverTime != 0.0 && baseOverTime != 0.0 && priorW2OverTime == 0.0){
    double totalAmount = baseOverTime;
    double totalYearsAndMonth = double.parse(calculateBaseMonthAndDays());
    double overTimeAmount = totalAmount / totalYearsAndMonth;
    _totalOverTime.value = overTimeAmount;
    calculateTotalSummaryIncome();
    }
    else if(baseOverTime < w2OverTime && w2OverTime != 0.0 && baseOverTime != 0.0 && priorW2OverTime == 0.0){
    double totalAmount = baseOverTime;
    double totalYearsAndMonth = double.parse(calculateBaseMonthAndDays());
    double overTimeAmount = totalAmount / totalYearsAndMonth;
    _totalOverTime.value = overTimeAmount;
    calculateTotalSummaryIncome();
    }
    /// base / w2 / prior w2
    else if(priorW2OverTime < w2OverTime && w2OverTime < baseOverTime){
      double totalAmount = priorW2OverTime + w2OverTime + baseOverTime;
      double totalYearsAndMonth = 24 + double.parse(calculateBaseMonthAndDays());
      double overTimeAmount = totalAmount / totalYearsAndMonth;
      _totalOverTime.value = overTimeAmount;
      calculateTotalSummaryIncome();
    }else if(priorW2OverTime > w2OverTime && w2OverTime > baseOverTime){
      double totalAmount = baseOverTime;
      double totalYearsAndMonth = double.parse(calculateBaseMonthAndDays());
      double overTimeAmount = totalAmount / totalYearsAndMonth;
      _totalOverTime.value = overTimeAmount;
      calculateTotalSummaryIncome();
    }else if(baseOverTime != 0.0 && w2OverTime == 0.0 && priorW2OverTime != 0.0){
      _totalOverTime.value = 0.0;
      calculateTotalSummaryIncome();
    }else if(baseOverTime != 0.0 && w2OverTime == 0.0 && priorW2OverTime == 0.0){
      _totalOverTime.value = 0.0;
      calculateTotalSummaryIncome();
    }else if(baseOverTime == 0.0 && w2OverTime != 0.0 && priorW2OverTime == 0.0){
      _totalOverTime.value = 0.0;
      calculateTotalSummaryIncome();
    }else if(baseOverTime == 0.0 && w2OverTime == 0.0 && priorW2OverTime != 0.0){
      _totalOverTime.value = 0.0;
      calculateTotalSummaryIncome();
    }else if(baseOverTime == 0.0 && w2OverTime == 0.0 && priorW2OverTime == 0.0){
      _totalOverTime.value = 0.0;
      calculateTotalSummaryIncome();
    }
  }

  calculateBonusIncomeTestCase(){
    if(priorW2Bonus < w2Bonus && priorW2Bonus != 0.0 && w2Bonus != 0.0 && baseBonus == 0.0){
      double totalAmount = priorW2Bonus + w2Bonus;
      double totalYearsAndMonth = 24;
      double overTimeAmount = totalAmount / totalYearsAndMonth;
      _totalBonus.value = overTimeAmount;
      calculateTotalSummaryIncome();
    }
    else if(w2Bonus > priorW2Bonus && priorW2Bonus != 0.0 && w2Bonus != 0.0 && baseBonus == 0.0){
      double totalAmount = priorW2Bonus + w2Bonus;
      double totalYearsAndMonth = 24;
      double overTimeAmount = totalAmount / totalYearsAndMonth;
      _totalBonus.value = overTimeAmount;
      calculateTotalSummaryIncome();
    }
    else if(priorW2Bonus > w2Bonus && priorW2Bonus != 0.0 && w2Bonus != 0.0 && baseBonus == 0.0){
      double totalAmount = w2Bonus;
      double totalYearsAndMonth = 12;
      double overTimeAmount = totalAmount / totalYearsAndMonth;
      _totalBonus.value = overTimeAmount;
      calculateTotalSummaryIncome();
    }
    else if(w2Bonus < priorW2Bonus && priorW2Bonus != 0.0 && w2Bonus != 0.0 && baseBonus == 0.0){
      double totalAmount = w2Bonus;
      double totalYearsAndMonth = 12;
      double overTimeAmount = totalAmount / totalYearsAndMonth;
      _totalBonus.value = overTimeAmount;
      calculateTotalSummaryIncome();
    }
    /// w2 and base
    else if(w2Bonus < baseBonus && w2Bonus != 0.0 && baseBonus != 0.0 && priorW2Bonus == 0.0){
      double totalAmount = w2Bonus + baseBonus;
      double totalYearsAndMonth = 12 + double.parse(calculateBaseMonthAndDays());
      double overTimeAmount = totalAmount / totalYearsAndMonth;
      _totalBonus.value = overTimeAmount;
      calculateTotalSummaryIncome();
    }
    else if(baseBonus > w2Bonus && w2Bonus != 0.0 && baseBonus != 0.0 && priorW2Bonus == 0.0){
      double totalAmount = w2Bonus + baseBonus;
      double totalYearsAndMonth = 12 + double.parse(calculateBaseMonthAndDays());
      double overTimeAmount = totalAmount / totalYearsAndMonth;
      _totalBonus.value = overTimeAmount;
      calculateTotalSummaryIncome();
    }
    else if(w2Bonus > baseBonus && w2Bonus != 0.0 && baseBonus != 0.0 && priorW2Bonus == 0.0){
      double totalAmount = baseBonus;
      double totalYearsAndMonth = double.parse(calculateBaseMonthAndDays());
      double overTimeAmount = totalAmount / totalYearsAndMonth;
      _totalBonus.value = overTimeAmount;
      calculateTotalSummaryIncome();
    }
    else if(baseBonus < w2Bonus && w2Bonus != 0.0 && baseBonus != 0.0 && priorW2Bonus == 0.0){
      double totalAmount = baseBonus;
      double totalYearsAndMonth = double.parse(calculateBaseMonthAndDays());
      double overTimeAmount = totalAmount / totalYearsAndMonth;
      _totalBonus.value = overTimeAmount;
      calculateTotalSummaryIncome();
    }
    /// base / w2 / prior w2
    else if(priorW2Bonus < w2Bonus && w2Bonus < baseBonus){
      double totalAmount = priorW2Bonus + w2Bonus + baseBonus;
      double totalYearsAndMonth = 24 + double.parse(calculateBaseMonthAndDays());
      double overTimeAmount = totalAmount / totalYearsAndMonth;
      _totalBonus.value = overTimeAmount;
      calculateTotalSummaryIncome();
    }else if(priorW2Bonus > w2Bonus && w2Bonus > baseBonus){
      double totalAmount = baseBonus;
      double totalYearsAndMonth = double.parse(calculateBaseMonthAndDays());
      double overTimeAmount = totalAmount / totalYearsAndMonth;
      _totalBonus.value = overTimeAmount;
      calculateTotalSummaryIncome();
    }else if(baseBonus != 0.0 && w2Bonus == 0.0 && priorW2Bonus != 0.0){
      _totalBonus.value = 0.0;
      calculateTotalSummaryIncome();
    }else if(baseBonus != 0.0 && w2Bonus == 0.0 && priorW2Bonus == 0.0){
      _totalBonus.value = 0.0;
      calculateTotalSummaryIncome();
    }else if(baseBonus == 0.0 && w2Bonus != 0.0 && priorW2Bonus == 0.0){
      _totalBonus.value = 0.0;
      calculateTotalSummaryIncome();
    }else if(baseBonus == 0.0 && w2Bonus == 0.0 && priorW2Bonus != 0.0){
      _totalBonus.value = 0.0;
      calculateTotalSummaryIncome();
    }else if(baseBonus == 0.0 && w2Bonus == 0.0 && priorW2Bonus == 0.0){
      _totalBonus.value = 0.0;
      calculateTotalSummaryIncome();
    }
    // double sumOfBonusTimesIncome = baseBonus + w2Bonus + priorW2Bonus;
    // double sumOfTimePeriod = 24 + double.parse(calculateBaseMonthAndDays());
    // double calculatedAmount = sumOfBonusTimesIncome/sumOfTimePeriod;
    // _totalBonus.value  = calculatedAmount;
    // calculateTotalSummaryIncome();
    // Logs().showLog('${baseBonus.toString()} - ${w2Bonus.toString()} - ${priorW2Bonus.toString()}');
    // // 21 < 22 < 23
    // if(priorW2Bonus != 0.0 && priorW2Bonus < w2Bonus && w2Bonus < baseBonus){
    //   Logs().showLog('${baseBonus.toString()} + ${w2Bonus.toString()} + ${priorW2Bonus.toString()}');
    //   double totalAmount = baseBonus + w2Bonus + priorW2Bonus;
    //   double totalYearAndMonths = 24 + double.parse(calculateBaseMonthAndDays());
    //   double answer = totalAmount / totalYearAndMonths;
    //   _totalBonus.value = double.parse(answer.toStringAsFixed(2));
    //   Logs().showLog(_totalBonus.value.toString());
    //   calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
    //   calculateTotalSummaryIncome();
    // }
    // else if(baseBonus == 0.0 && w2Bonus > priorW2Bonus && priorW2Bonus != 0.0){
    //   Logs().showLog('test');
    //   double totalAmount = w2Bonus + priorW2Bonus;
    //   double totalYearAndMonths = 24;
    //   double answer = totalAmount / totalYearAndMonths;
    //   _totalBonus.value = double.parse(answer.toStringAsFixed(2));
    //   Logs().showLog(_totalBonus.value.toString());
    //   calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
    //   calculateTotalSummaryIncome();
    // }
    // else if(baseBonus == 0.0 && w2Bonus < priorW2Bonus){
    //   double totalAmount = w2Bonus;
    //   double totalYearAndMonths = 12;
    //   double answer = totalAmount / totalYearAndMonths;
    //   _totalBonus.value = double.parse(answer.toStringAsFixed(2));
    //   calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
    //   calculateTotalSummaryIncome();
    // }
    // else if(baseBonus != 0.0 && w2Bonus == 0.0 && priorW2Bonus != 0.0){
    //   _totalBonus.value = 0.0;
    //   calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
    //   calculateTotalSummaryIncome();
    // }
    // else if(baseBonus != 0.0 && w2Bonus == 0.0 && priorW2Bonus == 0.0){
    //   _totalBonus.value = 0.0;
    //   calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
    //   calculateTotalSummaryIncome();
    // }
    // else if (baseBonus != 0.0 && baseBonus < w2Bonus && w2Bonus > priorW2Bonus){
    //   double totalAmount = baseBonus;
    //   double totalYearAndMonths = double.parse(calculateBaseMonthAndDays());
    //   double answer = totalAmount / totalYearAndMonths;
    //   _totalBonus.value = double.parse(answer.toStringAsFixed(2));
    //   calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
    //   calculateTotalSummaryIncome();
    // }else if(baseBonus == 0.0 && w2Bonus != 0.0 && priorW2Bonus == 0.0){
    //   _totalBonus.value = 0.0;
    //   calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
    //   calculateTotalSummaryIncome();
    // }
    // // 21 > 22 < 23
    // else if(priorW2Bonus > w2Bonus && w2Bonus < baseBonus){
    //   double totalAmount = baseBonus + w2Bonus;
    //   double totalYearAndMonths = 12 + double.parse(calculateBaseMonthAndDays());
    //   double answer = totalAmount / totalYearAndMonths;
    //   _totalBonus.value = double.parse(answer.toStringAsFixed(2));
    //   Logs().showLog(_totalBonus.value.toString());
    //   calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
    //   calculateTotalSummaryIncome();
    // }
    // // 21 > 22 > 23
    // else if(priorW2Bonus > w2Bonus && w2Bonus > baseBonus){
    //   double totalAmount = baseBonus;
    //   double totalYearAndMonths = double.parse(calculateBaseMonthAndDays());
    //   double answer = totalAmount / totalYearAndMonths;
    //   _totalBonus.value = double.parse(answer.toStringAsFixed(2));
    //   Logs().showLog(_totalBonus.value.toString());
    //   calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
    //   calculateTotalSummaryIncome();
    // }
    //
    // // 21 < 22 > 23
    // else if(w2Bonus > priorW2Bonus && w2Bonus > baseBonus){
    //   double totalAmount = baseBonus;
    //   double totalYearAndMonths = double.parse(calculateBaseMonthAndDays());
    //   double answer = totalAmount / totalYearAndMonths;
    //   _totalBonus.value = double.parse(answer.toStringAsFixed(2));
    //   Logs().showLog(_totalBonus.value.toString());
    //   calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
    //   calculateTotalSummaryIncome();
    // }
    // // 21 < 22 > 23
    // else if(priorW2Bonus > w2Bonus && w2Bonus < baseBonus){
    //   double totalAmount = baseBonus + w2Bonus;
    //   double totalYearAndMonths = 24;
    //   double answer = totalAmount / totalYearAndMonths;
    //   _totalBonus.value = double.parse(answer.toStringAsFixed(2));
    //   Logs().showLog(_totalBonus.value.toString());
    //   calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
    //   calculateTotalSummaryIncome();
    // }
    // else if(priorW2Bonus < w2Bonus && w2Bonus > baseBonus){
    //   double totalAmount = baseBonus + w2Bonus;
    //   double totalYearAndMonths = 24;
    //   double answer = totalAmount / totalYearAndMonths;
    //   _totalBonus.value = double.parse(answer.toStringAsFixed(2));
    //   Logs().showLog(_totalBonus.value.toString());
    //   calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
    //   calculateTotalSummaryIncome();
    // }
    //
    // else if(priorW2Bonus == 0.0 && baseBonus > w2Bonus){
    //   double totalAmount = baseBonus + w2Bonus;
    //   double totalYearAndMonths = 12 + double.parse(calculateBaseMonthAndDays());
    //   double answer = totalAmount / totalYearAndMonths;
    //   _totalBonus.value = double.parse(answer.toStringAsFixed(2));
    //   Logs().showLog(_totalBonus.value.toString());
    //   calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
    //   calculateTotalSummaryIncome();
    // }
    //
    // else{
    //   _totalBonus.value = 0.0;
    //   Logs().showLog(_totalBonus.value.toString());
    //   calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
    //   calculateTotalSummaryIncome();
    // }


  }

  calculateCommissionIncomeTestCase(){
    if(priorW2Commission < w2Commission && priorW2Commission != 0.0 && w2Commission != 0.0 && baseCommission == 0.0){
      double totalAmount = priorW2Commission + w2Commission;
      double totalYearsAndMonth = 24;
      double overTimeAmount = totalAmount / totalYearsAndMonth;
      _totalCommission.value = overTimeAmount;
      calculateTotalSummaryIncome();
    }
    else if(w2Commission > priorW2Commission && priorW2Commission != 0.0 && w2Commission != 0.0 && baseCommission == 0.0){
      double totalAmount = priorW2Commission + w2Commission;
      double totalYearsAndMonth = 24;
      double overTimeAmount = totalAmount / totalYearsAndMonth;
      _totalCommission.value = overTimeAmount;
      calculateTotalSummaryIncome();
    }
    else if(priorW2Commission > w2Commission && priorW2Commission != 0.0 && w2Commission != 0.0 && baseCommission == 0.0){
      double totalAmount = w2Commission;
      double totalYearsAndMonth = 12;
      double overTimeAmount = totalAmount / totalYearsAndMonth;
      _totalCommission.value = overTimeAmount;
      calculateTotalSummaryIncome();
    }
    else if(w2Commission < priorW2Commission && priorW2Commission != 0.0 && w2Commission != 0.0 && baseCommission == 0.0){
      double totalAmount = w2Commission;
      double totalYearsAndMonth = 12;
      double overTimeAmount = totalAmount / totalYearsAndMonth;
      _totalCommission.value = overTimeAmount;
      calculateTotalSummaryIncome();
    }
    /// w2 and base
    else if(w2Commission < baseCommission && w2Commission != 0.0 && baseCommission != 0.0 && priorW2Commission == 0.0){
      double totalAmount = w2Commission + baseCommission;
      double totalYearsAndMonth = 12 + double.parse(calculateBaseMonthAndDays());
      double overTimeAmount = totalAmount / totalYearsAndMonth;
      _totalCommission.value = overTimeAmount;
      calculateTotalSummaryIncome();
    }
    else if(baseCommission > w2Commission && w2Commission != 0.0 && baseCommission != 0.0 && priorW2Commission == 0.0){
      double totalAmount = w2Commission + baseCommission;
      double totalYearsAndMonth = 12 + double.parse(calculateBaseMonthAndDays());
      double overTimeAmount = totalAmount / totalYearsAndMonth;
      _totalCommission.value = overTimeAmount;
      calculateTotalSummaryIncome();
    }
    else if(w2Commission > baseCommission && w2Commission != 0.0 && baseCommission != 0.0 && priorW2Commission == 0.0){
      double totalAmount = baseCommission;
      double totalYearsAndMonth = double.parse(calculateBaseMonthAndDays());
      double overTimeAmount = totalAmount / totalYearsAndMonth;
      _totalCommission.value = overTimeAmount;
      calculateTotalSummaryIncome();
    }
    else if(baseCommission < w2Commission && w2Commission != 0.0 && baseCommission != 0.0 && priorW2Commission == 0.0){
      double totalAmount = baseCommission;
      double totalYearsAndMonth = double.parse(calculateBaseMonthAndDays());
      double overTimeAmount = totalAmount / totalYearsAndMonth;
      _totalCommission.value = overTimeAmount;
      calculateTotalSummaryIncome();
    }
    /// base / w2 / prior w2
    else if(priorW2Commission < w2Commission && w2Commission < baseCommission){
      double totalAmount = priorW2Commission + w2Commission + baseCommission;
      double totalYearsAndMonth = 24 + double.parse(calculateBaseMonthAndDays());
      double overTimeAmount = totalAmount / totalYearsAndMonth;
      _totalCommission.value = overTimeAmount;
      calculateTotalSummaryIncome();
    }else if(priorW2Commission > w2Commission && w2Commission > baseCommission){
      double totalAmount = baseCommission;
      double totalYearsAndMonth = double.parse(calculateBaseMonthAndDays());
      double overTimeAmount = totalAmount / totalYearsAndMonth;
      _totalCommission.value = overTimeAmount;
      calculateTotalSummaryIncome();
    }else if(baseCommission != 0.0 && w2Commission == 0.0 && priorW2Commission != 0.0){
      _totalCommission.value = 0.0;
      calculateTotalSummaryIncome();
    }else if(baseCommission != 0.0 && w2Commission == 0.0 && priorW2Commission == 0.0){
      _totalCommission.value = 0.0;
      calculateTotalSummaryIncome();
    }else if(baseCommission == 0.0 && w2Commission != 0.0 && priorW2Commission == 0.0){
      _totalCommission.value = 0.0;
      calculateTotalSummaryIncome();
    }else if(baseCommission == 0.0 && w2Commission == 0.0 && priorW2Commission != 0.0){
      _totalCommission.value = 0.0;
      calculateTotalSummaryIncome();
    }else if(baseCommission == 0.0 && w2Commission == 0.0 && priorW2Commission == 0.0){
      _totalCommission.value = 0.0;
      calculateTotalSummaryIncome();
    }
    // double sumOfCommissionTimesIncome = baseCommission + w2Commission + priorW2Commission;
    // double sumOfTimePeriod = 24 + double.parse(calculateBaseMonthAndDays());
    // double calculatedAmount = sumOfCommissionTimesIncome/sumOfTimePeriod;
    // _totalCommission.value  = calculatedAmount;
    // calculateTotalSummaryIncome();
    // Logs().showLog('${baseCommission.toString()} - ${w2Commission.toString()} - ${priorW2Commission.toString()}');
    // // 21 < 22 < 23
    // if(priorW2Commission != 0.0 && priorW2Commission < w2Commission && w2Commission < baseCommission){
    //   Logs().showLog('${baseCommission.toString()} + ${w2Commission.toString()} + ${priorW2Commission.toString()}');
    //   double totalAmount = baseCommission + w2Commission + priorW2Commission;
    //   double totalYearAndMonths = 24 + double.parse(calculateBaseMonthAndDays());
    //   double answer = totalAmount / totalYearAndMonths;
    //   _totalCommission.value = double.parse(answer.toStringAsFixed(2));
    //   Logs().showLog(_totalCommission.value.toString());
    //   calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
    //   calculateTotalSummaryIncome();
    // }
    // else if(baseCommission == 0.0 && w2Commission > priorW2Commission && priorW2Commission != 0.0){
    //   Logs().showLog('test');
    //   double totalAmount = w2Commission + priorW2Commission;
    //   double totalYearAndMonths = 24;
    //   double answer = totalAmount / totalYearAndMonths;
    //   _totalCommission.value = double.parse(answer.toStringAsFixed(2));
    //   Logs().showLog(_totalCommission.value.toString());
    //   calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
    //   calculateTotalSummaryIncome();
    // }
    // else if(baseCommission == 0.0 && w2Commission < priorW2Commission){
    //   double totalAmount = w2Commission;
    //   double totalYearAndMonths = 12;
    //   double answer = totalAmount / totalYearAndMonths;
    //   _totalCommission.value = double.parse(answer.toStringAsFixed(2));
    //   calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
    //   calculateTotalSummaryIncome();
    // }
    // else if(baseCommission != 0.0 && w2Commission == 0.0 && priorW2Commission != 0.0){
    //   _totalCommission.value = 0.0;
    //   calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
    //   calculateTotalSummaryIncome();
    // }
    // else if(baseCommission != 0.0 && w2Commission == 0.0 && priorW2Commission == 0.0){
    //   _totalCommission.value = 0.0;
    //   calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
    //   calculateTotalSummaryIncome();
    // }
    // else if (baseCommission != 0.0 && baseCommission < w2Commission && w2Commission > priorW2Commission){
    //   double totalAmount = baseCommission;
    //   double totalYearAndMonths = double.parse(calculateBaseMonthAndDays());
    //   double answer = totalAmount / totalYearAndMonths;
    //   _totalCommission.value = double.parse(answer.toStringAsFixed(2));
    //   calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
    //   calculateTotalSummaryIncome();
    // }
    // else if(baseCommission == 0.0 && w2Commission != 0.0 && priorW2Commission == 0.0){
    //   _totalCommission.value = 0.0;
    //   calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
    //   calculateTotalSummaryIncome();
    // }
    // // 21 > 22 < 23
    // else if(priorW2Commission > w2Commission && w2Commission < baseCommission){
    //   double totalAmount = baseCommission + w2Commission;
    //   double totalYearAndMonths = 12 + double.parse(calculateBaseMonthAndDays());
    //   double answer = totalAmount / totalYearAndMonths;
    //   _totalCommission.value = double.parse(answer.toStringAsFixed(2));
    //   Logs().showLog(_totalCommission.value.toString());
    //   calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
    //   calculateTotalSummaryIncome();
    // }
    // // 21 > 22 > 23
    // else if(priorW2Commission > w2Commission && w2Commission > baseCommission){
    //   double totalAmount = baseCommission;
    //   double totalYearAndMonths = double.parse(calculateBaseMonthAndDays());
    //   double answer = totalAmount / totalYearAndMonths;
    //   _totalCommission.value = double.parse(answer.toStringAsFixed(2));
    //   Logs().showLog(_totalCommission.value.toString());
    //   calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
    //   calculateTotalSummaryIncome();
    // }
    //
    // // 21 < 22 > 23
    // else if(w2Commission > priorW2Commission && w2Commission > baseCommission){
    //   double totalAmount = baseCommission;
    //   double totalYearAndMonths = double.parse(calculateBaseMonthAndDays());
    //   double answer = totalAmount / totalYearAndMonths;
    //   _totalCommission.value = double.parse(answer.toStringAsFixed(2));
    //   Logs().showLog(_totalCommission.value.toString());
    //   calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
    //   calculateTotalSummaryIncome();
    // }
    // // 21 < 22 > 23
    // else if(priorW2Commission > w2Commission && w2Commission < baseCommission){
    //   double totalAmount = baseCommission + w2Commission;
    //   double totalYearAndMonths = 24;
    //   double answer = totalAmount / totalYearAndMonths;
    //   _totalCommission.value = double.parse(answer.toStringAsFixed(2));
    //   Logs().showLog(_totalCommission.value.toString());
    //   calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
    //   calculateTotalSummaryIncome();
    // }
    // else if(priorW2Commission < w2Commission && w2Commission > baseCommission){
    //   double totalAmount = baseCommission + w2Commission;
    //   double totalYearAndMonths = 24;
    //   double answer = totalAmount / totalYearAndMonths;
    //   _totalCommission.value = double.parse(answer.toStringAsFixed(2));
    //   Logs().showLog(_totalCommission.value.toString());
    //   calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
    //   calculateTotalSummaryIncome();
    // }
    //
    // else if(priorW2Commission == 0.0 && baseCommission > w2Commission){
    //   double totalAmount = baseCommission + w2Commission;
    //   double totalYearAndMonths = 12 + double.parse(calculateBaseMonthAndDays());
    //   double answer = totalAmount / totalYearAndMonths;
    //   _totalCommission.value = double.parse(answer.toStringAsFixed(2));
    //   Logs().showLog(_totalCommission.value.toString());
    //   calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
    //   calculateTotalSummaryIncome();
    // }
    //
    // else{
    //   _totalCommission.value = 0.0;
    //   Logs().showLog(_totalCommission.value.toString());
    //   calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
    //   calculateTotalSummaryIncome();
    // }


  }

  calculateTipsIncomeTestCase(){
    if(priorW2Tips < w2Tips && priorW2Tips != 0.0 && w2Tips != 0.0 && baseTips == 0.0){
      double totalAmount = priorW2Tips + w2Tips;
      double totalYearsAndMonth = 24;
      double overTimeAmount = totalAmount / totalYearsAndMonth;
      _totalTips.value = overTimeAmount;
      calculateTotalSummaryIncome();
    }
    else if(w2Tips > priorW2Tips && priorW2Tips != 0.0 && w2Tips != 0.0 && baseTips == 0.0){
      double totalAmount = priorW2Tips + w2Tips;
      double totalYearsAndMonth = 24;
      double overTimeAmount = totalAmount / totalYearsAndMonth;
      _totalTips.value = overTimeAmount;
      calculateTotalSummaryIncome();
    }
    else if(priorW2Tips > w2Tips && priorW2Tips != 0.0 && w2Tips != 0.0 && baseTips == 0.0){
      double totalAmount = w2Tips;
      double totalYearsAndMonth = 12;
      double overTimeAmount = totalAmount / totalYearsAndMonth;
      _totalTips.value = overTimeAmount;
      calculateTotalSummaryIncome();
    }
    else if(w2Tips < priorW2Tips && priorW2Tips != 0.0 && w2Tips != 0.0 && baseTips == 0.0){
      double totalAmount = w2Tips;
      double totalYearsAndMonth = 12;
      double overTimeAmount = totalAmount / totalYearsAndMonth;
      _totalTips.value = overTimeAmount;
      calculateTotalSummaryIncome();
    }
    /// w2 and base
    else if(w2Tips < baseTips && w2Tips != 0.0 && baseTips != 0.0 && priorW2Tips == 0.0){
      double totalAmount = w2Tips + baseTips;
      double totalYearsAndMonth = 12 + double.parse(calculateBaseMonthAndDays());
      double overTimeAmount = totalAmount / totalYearsAndMonth;
      _totalTips.value = overTimeAmount;
      calculateTotalSummaryIncome();
    }
    else if(baseTips > w2Tips && w2Tips != 0.0 && baseTips != 0.0 && priorW2Tips == 0.0){
      double totalAmount = w2Tips + baseTips;
      double totalYearsAndMonth = 12 + double.parse(calculateBaseMonthAndDays());
      double overTimeAmount = totalAmount / totalYearsAndMonth;
      _totalTips.value = overTimeAmount;
      calculateTotalSummaryIncome();
    }
    else if(w2Tips > baseTips && w2Tips != 0.0 && baseTips != 0.0 && priorW2Tips == 0.0){
      double totalAmount = baseTips;
      double totalYearsAndMonth = double.parse(calculateBaseMonthAndDays());
      double overTimeAmount = totalAmount / totalYearsAndMonth;
      _totalTips.value = overTimeAmount;
      calculateTotalSummaryIncome();
    }
    else if(baseTips < w2Tips && w2Tips != 0.0 && baseTips != 0.0 && priorW2Tips == 0.0){
      double totalAmount = baseTips;
      double totalYearsAndMonth = double.parse(calculateBaseMonthAndDays());
      double overTimeAmount = totalAmount / totalYearsAndMonth;
      _totalTips.value = overTimeAmount;
      calculateTotalSummaryIncome();
    }
    /// base / w2 / prior w2
    else if(priorW2Tips < w2Tips && w2Tips < baseTips){
      double totalAmount = priorW2Tips + w2Tips + baseTips;
      double totalYearsAndMonth = 24 + double.parse(calculateBaseMonthAndDays());
      double overTimeAmount = totalAmount / totalYearsAndMonth;
      _totalTips.value = overTimeAmount;
      calculateTotalSummaryIncome();
    }else if(priorW2Tips > w2Tips && w2Tips > baseTips){
      double totalAmount = baseTips;
      double totalYearsAndMonth = double.parse(calculateBaseMonthAndDays());
      double overTimeAmount = totalAmount / totalYearsAndMonth;
      _totalTips.value = overTimeAmount;
      calculateTotalSummaryIncome();
    }else if(baseTips != 0.0 && w2Tips == 0.0 && priorW2Tips != 0.0){
      _totalTips.value = 0.0;
      calculateTotalSummaryIncome();
    }else if(baseTips != 0.0 && w2Tips == 0.0 && priorW2Tips == 0.0){
      _totalTips.value = 0.0;
      calculateTotalSummaryIncome();
    }else if(baseTips == 0.0 && w2Tips != 0.0 && priorW2Tips == 0.0){
      _totalTips.value = 0.0;
      calculateTotalSummaryIncome();
    }else if(baseTips == 0.0 && w2Tips == 0.0 && priorW2Tips != 0.0){
      _totalTips.value = 0.0;
      calculateTotalSummaryIncome();
    }else if(baseTips == 0.0 && w2Tips == 0.0 && priorW2Tips == 0.0){
      _totalTips.value = 0.0;
      calculateTotalSummaryIncome();
    }
    // double sumOfTipsIncome = baseTips + w2Tips + priorW2Tips;
    // double sumOfTimePeriod = 24 + double.parse(calculateBaseMonthAndDays());
    // double calculatedAmount = sumOfTipsIncome/sumOfTimePeriod;
    // _totalTips.value  = calculatedAmount;
    // calculateTotalSummaryIncome();
    // Logs().showLog('${baseTips.toString()} - ${w2Tips.toString()} - ${priorW2Tips.toString()}');
    // // 21 < 22 < 23
    // if(priorW2Tips != 0.0 && priorW2Tips < w2Tips && w2Tips < baseTips){
    //   Logs().showLog('${baseTips.toString()} + ${w2Tips.toString()} + ${priorW2Tips.toString()}');
    //   double totalAmount = baseTips + w2Tips + priorW2Tips;
    //   double totalYearAndMonths = 24 + double.parse(calculateBaseMonthAndDays());
    //   double answer = totalAmount / totalYearAndMonths;
    //   _totalTips.value = double.parse(answer.toStringAsFixed(2));
    //   Logs().showLog(_totalTips.value.toString());
    //   calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
    //   calculateTotalSummaryIncome();
    // }
    // else if(baseTips == 0.0 && w2Tips > priorW2Tips && priorW2Tips != 0.0){
    //   Logs().showLog('test');
    //   double totalAmount = w2Tips + priorW2Tips;
    //   double totalYearAndMonths = 24;
    //   double answer = totalAmount / totalYearAndMonths;
    //   _totalTips.value = double.parse(answer.toStringAsFixed(2));
    //   Logs().showLog(_totalTips.value.toString());
    //   calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
    //   calculateTotalSummaryIncome();
    // }
    // else if(baseTips == 0.0 && w2Tips < priorW2Tips){
    //   double totalAmount = w2Tips;
    //   double totalYearAndMonths = 12;
    //   double answer = totalAmount / totalYearAndMonths;
    //   _totalTips.value = double.parse(answer.toStringAsFixed(2));
    //   calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
    //   calculateTotalSummaryIncome();
    // }
    // else if(baseTips != 0.0 && w2Tips == 0.0 && priorW2Tips != 0.0){
    //   _totalTips.value = 0.0;
    //   calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
    //   calculateTotalSummaryIncome();
    // }
    // else if(baseTips != 0.0 && w2Tips == 0.0 && priorW2Tips == 0.0){
    //   _totalTips.value = 0.0;
    //   calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
    //   calculateTotalSummaryIncome();
    // }
    // else if (baseTips != 0.0 && baseTips < w2Tips && w2Tips > priorW2Tips){
    //   double totalAmount = baseTips;
    //   double totalYearAndMonths = double.parse(calculateBaseMonthAndDays());
    //   double answer = totalAmount / totalYearAndMonths;
    //   _totalTips.value = double.parse(answer.toStringAsFixed(2));
    //   calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
    //   calculateTotalSummaryIncome();
    // }
    // else if(baseTips == 0.0 && w2Tips != 0.0 && priorW2Tips == 0.0){
    //   _totalTips.value = 0.0;
    //   calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
    //   calculateTotalSummaryIncome();
    // }
    // // 21 > 22 < 23
    // else if(priorW2Tips > w2Tips && w2Tips < baseTips){
    //   double totalAmount = baseTips + w2Tips;
    //   double totalYearAndMonths = 12 + double.parse(calculateBaseMonthAndDays());
    //   double answer = totalAmount / totalYearAndMonths;
    //   _totalTips.value = double.parse(answer.toStringAsFixed(2));
    //   Logs().showLog(_totalTips.value.toString());
    //   calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
    //   calculateTotalSummaryIncome();
    // }
    // // 21 > 22 > 23
    // else if(priorW2Tips > w2Tips && w2Tips > baseTips){
    //   double totalAmount = baseTips;
    //   double totalYearAndMonths = double.parse(calculateBaseMonthAndDays());
    //   double answer = totalAmount / totalYearAndMonths;
    //   _totalTips.value = double.parse(answer.toStringAsFixed(2));
    //   Logs().showLog(_totalTips.value.toString());
    //   calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
    //   calculateTotalSummaryIncome();
    // }
    //
    // // 21 < 22 > 23
    // else if(w2Tips > priorW2Tips && w2Tips > baseTips){
    //   double totalAmount = baseTips;
    //   double totalYearAndMonths = double.parse(calculateBaseMonthAndDays());
    //   double answer = totalAmount / totalYearAndMonths;
    //   _totalTips.value = double.parse(answer.toStringAsFixed(2));
    //   Logs().showLog(_totalTips.value.toString());
    //   calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
    //   calculateTotalSummaryIncome();
    // }
    // // 21 < 22 > 23
    // else if(priorW2Tips > w2Tips && w2Tips < baseTips){
    //   double totalAmount = baseTips + w2Tips;
    //   double totalYearAndMonths = 24;
    //   double answer = totalAmount / totalYearAndMonths;
    //   _totalTips.value = double.parse(answer.toStringAsFixed(2));
    //   Logs().showLog(_totalTips.value.toString());
    //   calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
    //   calculateTotalSummaryIncome();
    // }
    // else if(priorW2Tips < w2Tips && w2Tips > baseTips){
    //   double totalAmount = baseTips + w2Tips;
    //   double totalYearAndMonths = 24;
    //   double answer = totalAmount / totalYearAndMonths;
    //   _totalTips.value = double.parse(answer.toStringAsFixed(2));
    //   Logs().showLog(_totalTips.value.toString());
    //   calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
    //   calculateTotalSummaryIncome();
    // }
    //
    // else if(priorW2Tips == 0.0 && baseTips > w2Tips){
    //   double totalAmount = baseTips + w2Tips;
    //   double totalYearAndMonths = 12 + double.parse(calculateBaseMonthAndDays());
    //   double answer = totalAmount / totalYearAndMonths;
    //   _totalTips.value = double.parse(answer.toStringAsFixed(2));
    //   Logs().showLog(_totalTips.value.toString());
    //   calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
    //   calculateTotalSummaryIncome();
    // }
    //
    // else{
    //   _totalTips.value = 0.0;
    //   Logs().showLog(_totalTips.value.toString());
    //   calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
    //   calculateTotalSummaryIncome();
    // }


  }

  calculateOthersIncomeTestCase(){
    if(priorW2Others < w2Others && priorW2Others != 0.0 && w2Others != 0.0 && baseOthers == 0.0){
      double totalAmount = priorW2Others + w2Others;
      double totalYearsAndMonth = 24;
      double overTimeAmount = totalAmount / totalYearsAndMonth;
      _totalOthers.value = overTimeAmount;
      calculateTotalSummaryIncome();
    }
    else if(w2Others > priorW2Others && priorW2Others != 0.0 && w2Others != 0.0 && baseOthers == 0.0){
      double totalAmount = priorW2Others + w2Others;
      double totalYearsAndMonth = 24;
      double overTimeAmount = totalAmount / totalYearsAndMonth;
      _totalOthers.value = overTimeAmount;
      calculateTotalSummaryIncome();
    }
    else if(priorW2Others > w2Others && priorW2Others != 0.0 && w2Others != 0.0 && baseOthers == 0.0){
      double totalAmount = w2Others;
      double totalYearsAndMonth = 12;
      double overTimeAmount = totalAmount / totalYearsAndMonth;
      _totalOthers.value = overTimeAmount;
      calculateTotalSummaryIncome();
    }
    else if(w2Others < priorW2Others && priorW2Others != 0.0 && w2Others != 0.0 && baseOthers == 0.0){
      double totalAmount = w2Others;
      double totalYearsAndMonth = 12;
      double overTimeAmount = totalAmount / totalYearsAndMonth;
      _totalOthers.value = overTimeAmount;
      calculateTotalSummaryIncome();
    }
    /// w2 and base
    else if(w2Others < baseOthers && w2Others != 0.0 && baseOthers != 0.0 && priorW2Others == 0.0){
      double totalAmount = w2Others + baseOthers;
      double totalYearsAndMonth = 12 + double.parse(calculateBaseMonthAndDays());
      double overTimeAmount = totalAmount / totalYearsAndMonth;
      _totalOthers.value = overTimeAmount;
      calculateTotalSummaryIncome();
    }
    else if(baseOthers > w2Others && w2Others != 0.0 && baseOthers != 0.0 && priorW2Others == 0.0){
      double totalAmount = w2Others + baseOthers;
      double totalYearsAndMonth = 12 + double.parse(calculateBaseMonthAndDays());
      double overTimeAmount = totalAmount / totalYearsAndMonth;
      _totalOthers.value = overTimeAmount;
      calculateTotalSummaryIncome();
    }
    else if(w2Others > baseOthers && w2Others != 0.0 && baseOthers != 0.0 && priorW2Others == 0.0){
      double totalAmount = baseOthers;
      double totalYearsAndMonth = double.parse(calculateBaseMonthAndDays());
      double overTimeAmount = totalAmount / totalYearsAndMonth;
      _totalOthers.value = overTimeAmount;
      calculateTotalSummaryIncome();
    }
    else if(baseOthers < w2Others && w2Others != 0.0 && baseOthers != 0.0 && priorW2Others == 0.0){
      double totalAmount = baseOthers;
      double totalYearsAndMonth = double.parse(calculateBaseMonthAndDays());
      double overTimeAmount = totalAmount / totalYearsAndMonth;
      _totalOthers.value = overTimeAmount;
      calculateTotalSummaryIncome();
    }
    /// base / w2 / prior w2
    else if(priorW2Others < w2Others && w2Others < baseOthers){
      double totalAmount = priorW2Others + w2Others + baseOthers;
      double totalYearsAndMonth = 24 + double.parse(calculateBaseMonthAndDays());
      double overTimeAmount = totalAmount / totalYearsAndMonth;
      _totalOthers.value = overTimeAmount;
      calculateTotalSummaryIncome();
    }else if(priorW2Others > w2Others && w2Others > baseOthers){
      double totalAmount = baseOthers;
      double totalYearsAndMonth = double.parse(calculateBaseMonthAndDays());
      double overTimeAmount = totalAmount / totalYearsAndMonth;
      _totalOthers.value = overTimeAmount;
      calculateTotalSummaryIncome();
    }else if(baseOthers != 0.0 && w2Others == 0.0 && priorW2Others != 0.0){
      _totalOthers.value = 0.0;
      calculateTotalSummaryIncome();
    }else if(baseOthers != 0.0 && w2Others == 0.0 && priorW2Others == 0.0){
      _totalOthers.value = 0.0;
      calculateTotalSummaryIncome();
    }else if(baseOthers == 0.0 && w2Others != 0.0 && priorW2Others == 0.0){
      _totalOthers.value = 0.0;
      calculateTotalSummaryIncome();
    }else if(baseOthers == 0.0 && w2Others == 0.0 && priorW2Others != 0.0){
      _totalOthers.value = 0.0;
      calculateTotalSummaryIncome();
    }else if(baseOthers == 0.0 && w2Others == 0.0 && priorW2Others == 0.0){
      _totalOthers.value = 0.0;
      calculateTotalSummaryIncome();
    }
    // double sumOfOtherIncome = baseOthers + w2Others + priorW2Others;
    // double sumOfTimePeriod = 24 + double.parse(calculateBaseMonthAndDays());
    // double calculatedAmount = sumOfOtherIncome/sumOfTimePeriod;
    // _totalOthers.value  = calculatedAmount;
    // calculateTotalSummaryIncome();
    // Logs().showLog('${baseOthers.toString()} - ${w2Others.toString()} - ${priorW2Others.toString()}');
    // // 21 < 22 < 23
    // if(priorW2Others != 0.0 && priorW2Others < w2Others && w2Others < baseOthers){
    //   Logs().showLog('${baseOthers.toString()} + ${w2Others.toString()} + ${priorW2Others.toString()}');
    //   double totalAmount = baseOthers + w2Others + priorW2Others;
    //   double totalYearAndMonths = 24 + double.parse(calculateBaseMonthAndDays());
    //   double answer = totalAmount / totalYearAndMonths;
    //   _totalOthers.value = double.parse(answer.toStringAsFixed(2));
    //   Logs().showLog(_totalOthers.value.toString());
    //   calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
    //   calculateTotalSummaryIncome();
    // }
    // else if(baseOthers == 0.0 && w2Others > priorW2Others && priorW2Others != 0.0){
    //   Logs().showLog('test');
    //   double totalAmount = w2Others + priorW2Others;
    //   double totalYearAndMonths = 24;
    //   double answer = totalAmount / totalYearAndMonths;
    //   _totalOthers.value = double.parse(answer.toStringAsFixed(2));
    //   Logs().showLog(_totalOthers.value.toString());
    //   calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
    //   calculateTotalSummaryIncome();
    // }
    // else if(baseOthers == 0.0 && w2Others < priorW2Others){
    //   double totalAmount = w2Others;
    //   double totalYearAndMonths = 12;
    //   double answer = totalAmount / totalYearAndMonths;
    //   _totalOthers.value = double.parse(answer.toStringAsFixed(2));
    //   calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
    //   calculateTotalSummaryIncome();
    // }
    // else if(baseOthers != 0.0 && w2Others == 0.0 && priorW2Others != 0.0){
    //   _totalOthers.value = 0.0;
    //   calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
    //   calculateTotalSummaryIncome();
    // }
    // else if(baseOthers != 0.0 && w2Others == 0.0 && priorW2Others == 0.0){
    //   _totalOthers.value = 0.0;
    //   calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
    //   calculateTotalSummaryIncome();
    // }
    // else if (baseOthers != 0.0 && baseOthers < w2Others && w2Others > priorW2Others){
    //   double totalAmount = baseOthers;
    //   double totalYearAndMonths = double.parse(calculateBaseMonthAndDays());
    //   double answer = totalAmount / totalYearAndMonths;
    //   _totalOthers.value = double.parse(answer.toStringAsFixed(2));
    //   calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
    //   calculateTotalSummaryIncome();
    // }
    // else if(baseOthers == 0.0 && w2Others != 0.0 && priorW2Others == 0.0){
    //   _totalOthers.value = 0.0;
    //   calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
    //   calculateTotalSummaryIncome();
    // }
    // // 21 > 22 < 23
    // else if(priorW2Others > w2Others && w2Others < baseOthers){
    //   double totalAmount = baseOthers + w2Others;
    //   double totalYearAndMonths = 12 + double.parse(calculateBaseMonthAndDays());
    //   double answer = totalAmount / totalYearAndMonths;
    //   _totalOthers.value = double.parse(answer.toStringAsFixed(2));
    //   Logs().showLog(_totalOthers.value.toString());
    //   calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
    //   calculateTotalSummaryIncome();
    // }
    // // 21 > 22 > 23
    // else if(priorW2Others > w2Others && w2Others > baseOthers){
    //   double totalAmount = baseOthers;
    //   double totalYearAndMonths = double.parse(calculateBaseMonthAndDays());
    //   double answer = totalAmount / totalYearAndMonths;
    //   _totalOthers.value = double.parse(answer.toStringAsFixed(2));
    //   Logs().showLog(_totalOthers.value.toString());
    //   calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
    //   calculateTotalSummaryIncome();
    // }
    //
    // // 21 < 22 > 23
    // else if(w2Others > priorW2Others && w2Others > baseOthers){
    //   double totalAmount = baseOthers;
    //   double totalYearAndMonths = double.parse(calculateBaseMonthAndDays());
    //   double answer = totalAmount / totalYearAndMonths;
    //   _totalOthers.value = double.parse(answer.toStringAsFixed(2));
    //   Logs().showLog(_totalOthers.value.toString());
    //   calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
    //   calculateTotalSummaryIncome();
    // }
    // // 21 < 22 > 23
    // else if(priorW2Others > w2Others && w2Others < baseOthers){
    //   double totalAmount = baseOthers + w2Others;
    //   double totalYearAndMonths = 24;
    //   double answer = totalAmount / totalYearAndMonths;
    //   _totalOthers.value = double.parse(answer.toStringAsFixed(2));
    //   Logs().showLog(_totalOthers.value.toString());
    //   calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
    //   calculateTotalSummaryIncome();
    // }
    // else if(priorW2Others < w2Others && w2Others > baseOthers){
    //   double totalAmount = baseOthers + w2Others;
    //   double totalYearAndMonths = 24;
    //   double answer = totalAmount / totalYearAndMonths;
    //   _totalOthers.value = double.parse(answer.toStringAsFixed(2));
    //   Logs().showLog(_totalOthers.value.toString());
    //   calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
    //   calculateTotalSummaryIncome();
    // }
    //
    // else if(priorW2Others == 0.0 && baseOthers > w2Others){
    //   double totalAmount = baseOthers + w2Others;
    //   double totalYearAndMonths = 12 + double.parse(calculateBaseMonthAndDays());
    //   double answer = totalAmount / totalYearAndMonths;
    //   _totalOthers.value = double.parse(answer.toStringAsFixed(2));
    //   Logs().showLog(_totalOthers.value.toString());
    //   calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
    //   calculateTotalSummaryIncome();
    // }
    //
    // else{
    //   _totalOthers.value = 0.0;
    //   Logs().showLog(_totalOthers.value.toString());
    //   calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
    //   calculateTotalSummaryIncome();
    // }


  }

  void checkDoubleValue(double value) {
    String result = value < 0 ? "negative" : (value > 0 ? "positive" : "zero");
    _calculatedDifferenceValueType.value = result;
  }

  calculateTotalSummaryIncome(){
    if(additionalW2IncomeTypes == true){
      double sum = _calculatedMonthlyIncomeFixedSimple.value + totalOverTime + totalBonus + totalCommission + totalTips + totalOthers;
      _summaryTotalSample.value = sum;
      String twoDecimalPlaces = sum.toStringAsFixed(2);
      String separateUnits = UtilMethods().formatNumberWithCommas(double.parse(twoDecimalPlaces));
      _summaryTotal.value = separateUnits;
    }else{
      double sum = _calculatedMonthlyIncomeFixedSimple.value + 0.0 + 0.0 + 0.0 + 0.0 + 0.0;
      _summaryTotalSample.value = sum;
      String twoDecimalPlaces = sum.toStringAsFixed(2);
      String separateUnits = UtilMethods().formatNumberWithCommas(double.parse(twoDecimalPlaces));
      _summaryTotal.value = separateUnits;
    }
    // Logs().showLog('$_calculatedMonthlyIncomeFixedSimple - $totalOverTime - $totalBonus - $totalCommission - $totalTips - $totalOthers - $salaryCycle');

  }
  calculateBaseMonthAndDays(){
    int months = selectedPayPeriodEndDateMonth - 1;
    String m = months.toString();
    double calculateDaysOfCurrentMonth = selectedPayPeriodEndDateDay / 30;
    String c = calculateDaysOfCurrentMonth.toString();
    double totalCount = double.parse(m) + double.parse(c);
    return totalCount.toStringAsFixed(2);
  }
  getCurrentAndPreviousYears(){
    var currentDate = DateTime.now();
    var w2Date = DateTime(currentDate.year-1);
    var priorW2Date = DateTime(w2Date.year-1);
    baseYear.value = currentDate.year.toString();
    w2Year.value = w2Date.year.toString();
    priorW2Year.value = priorW2Date.year.toString();
  }
  setVerifyCheck(String type, bool value){
    if(type == 'verified'){
      _verifiedCheck.value = value;
    }else{
      _verifiedButExeCheck.value = value;
    }
  }
}














// calculateOverTimeIncomeTest(){
//   if(baseOverTimeFixedController.text.isNotEmpty && w2OverTimeFixedController.text.isNotEmpty && priorW2OverTimeFixedController.text.isNotEmpty){
//     print('base + w2 * pw2');
//     double totalAmount = double.parse(baseOverTimeFixedController.text) + double.parse(w2OverTimeFixedController.text) + double.parse(priorW2OverTimeFixedController.text);
//     double totalYearAndMonths = 24 + double.parse(calculateBaseMonthAndDays());
//     print(totalAmount.toString());
//     print(totalYearAndMonths.toString());
//     double answer = totalAmount / totalYearAndMonths;
//     print(answer.toString());
//     _totalOverTime.value = double.parse(answer.toStringAsFixed(2));
//     calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
//     print(_totalAdditionalW2sAmount.value.toString());
//
//   }else if(w2OverTimeFixedController.text.isNotEmpty && priorW2OverTimeFixedController.text.isNotEmpty){
//     print('w2 + pw2');
//     double totalAmount = double.parse(w2OverTimeFixedController.text) + double.parse(priorW2OverTimeFixedController.text);
//     double totalYearAndMonths = 24;
//     print(totalAmount.toString());
//     print(totalYearAndMonths.toString());
//     double answer = totalAmount / totalYearAndMonths;
//     print(answer.toString());
//     _totalOverTime.value = double.parse(answer.toStringAsFixed(2));
//     calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
//     print(_totalAdditionalW2sAmount.value.toString());
//   }else if(baseOverTimeFixedController.text.isNotEmpty && w2OverTimeFixedController.text.isNotEmpty){
//     print('base + w2');
//     double totalAmount = double.parse(baseOverTimeFixedController.text) + double.parse(w2OverTimeFixedController.text);
//     double totalYearAndMonths = 12 + double.parse(calculateBaseMonthAndDays());
//     print(totalAmount.toString());
//     print(totalYearAndMonths.toString());
//     double answer = totalAmount / totalYearAndMonths;
//     print(answer.toString());
//     _totalOverTime.value = double.parse(answer.toStringAsFixed(2));
//     print(_totalOverTime.value.toString());
//     calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
//   }
//   else{
//     _totalOverTime.value = 0.0;
//     print(_totalOverTime.value.toString());
//     calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
//   }
// }
// calculateBonusIncomeTest(){
//   if(baseBonusFixedController.text.isNotEmpty && w2BonusFixedController.text.isNotEmpty && priorW2BonusFixedController.text.isNotEmpty){
//     print('base + w2 * pw2');
//     double totalAmount = double.parse(baseBonusFixedController.text) + double.parse(w2BonusFixedController.text) + double.parse(priorW2BonusFixedController.text);
//     double totalYearAndMonths = 24 + double.parse(calculateBaseMonthAndDays());
//     print(totalAmount.toString());
//     print(totalYearAndMonths.toString());
//     double answer = totalAmount / totalYearAndMonths;
//     print(answer.toString());
//     _totalBonus.value = double.parse(answer.toStringAsFixed(2));
//     calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
//     print(_totalAdditionalW2sAmount.value.toString());
//
//   }else if(w2BonusFixedController.text.isNotEmpty && priorW2BonusFixedController.text.isNotEmpty){
//     print('w2 + pw2');
//     double totalAmount = double.parse(w2BonusFixedController.text) + double.parse(priorW2BonusFixedController.text);
//     double totalYearAndMonths = 24;
//     print(totalAmount.toString());
//     print(totalYearAndMonths.toString());
//     double answer = totalAmount / totalYearAndMonths;
//     print(answer.toString());
//     _totalBonus.value = double.parse(answer.toStringAsFixed(2));
//     calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
//     print(_totalAdditionalW2sAmount.value.toString());
//   }else if(baseBonusFixedController.text.isNotEmpty && w2BonusFixedController.text.isNotEmpty){
//     print('base + w2');
//     double totalAmount = double.parse(baseBonusFixedController.text) + double.parse(w2BonusFixedController.text);
//     double totalYearAndMonths = 12 + double.parse(calculateBaseMonthAndDays());
//     print(totalAmount.toString());
//     print(totalYearAndMonths.toString());
//     double answer = totalAmount / totalYearAndMonths;
//     print(answer.toString());
//     _totalBonus.value = double.parse(answer.toStringAsFixed(2));
//     print(_totalBonus.value.toString());
//     calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
//     print(_totalAdditionalW2sAmount.value.toString());
//   }
//   else{
//     _totalBonus.value = 0.0;
//     print(_totalBonus.value.toString());
//     calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
//   }
// }
// calculateCommissionIncomeTest(){
//   if(baseCommissionFixedController.text.isNotEmpty && w2CommissionFixedController.text.isNotEmpty && priorW2CommissionFixedController.text.isNotEmpty){
//     print('base + w2 * pw2');
//     double totalAmount = double.parse(baseCommissionFixedController.text) + double.parse(w2CommissionFixedController.text) + double.parse(priorW2CommissionFixedController.text);
//     double totalYearAndMonths = 24 + double.parse(calculateBaseMonthAndDays());
//     print(totalAmount.toString());
//     print(totalYearAndMonths.toString());
//     double answer = totalAmount / totalYearAndMonths;
//     print(answer.toString());
//     _totalCommission.value = double.parse(answer.toStringAsFixed(2));
//     calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
//     print(_totalAdditionalW2sAmount.value.toString());
//
//   }else if(w2CommissionFixedController.text.isNotEmpty && priorW2CommissionFixedController.text.isNotEmpty){
//     print('w2 + pw2');
//     double totalAmount = double.parse(w2CommissionFixedController.text) + double.parse(priorW2CommissionFixedController.text);
//     double totalYearAndMonths = 24;
//     print(totalAmount.toString());
//     print(totalYearAndMonths.toString());
//     double answer = totalAmount / totalYearAndMonths;
//     print(answer.toString());
//     _totalCommission.value = double.parse(answer.toStringAsFixed(2));
//     calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
//     print(_totalAdditionalW2sAmount.value.toString());
//   }else if(baseCommissionFixedController.text.isNotEmpty && w2CommissionFixedController.text.isNotEmpty){
//     print('base + w2');
//     double totalAmount = double.parse(baseCommissionFixedController.text) + double.parse(w2CommissionFixedController.text);
//     double totalYearAndMonths = 12 + double.parse(calculateBaseMonthAndDays());
//     print(totalAmount.toString());
//     print(totalYearAndMonths.toString());
//     double answer = totalAmount / totalYearAndMonths;
//     print(answer.toString());
//     _totalCommission.value = double.parse(answer.toStringAsFixed(2));
//     calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
//     print(_totalAdditionalW2sAmount.value.toString());
//   }
//   else{
//     _totalCommission.value = 0.0;
//     print(_totalCommission.value.toString());
//     calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
//   }
// }
// calculateTipsIncomeTest(){
//   if(baseTipsFixedController.text.isNotEmpty && w2TipsFixedController.text.isNotEmpty && priorW2TipsFixedController.text.isNotEmpty){
//     print('base + w2 * pw2');
//     double totalAmount = double.parse(baseTipsFixedController.text) + double.parse(w2TipsFixedController.text) + double.parse(priorW2TipsFixedController.text);
//     double totalYearAndMonths = 24 + double.parse(calculateBaseMonthAndDays());
//     print(totalAmount.toString());
//     print(totalYearAndMonths.toString());
//     double answer = totalAmount / totalYearAndMonths;
//     print(answer.toString());
//     _totalTips.value = double.parse(answer.toStringAsFixed(2));
//     calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
//     print(_totalAdditionalW2sAmount.value.toString());
//
//   }else if(w2TipsFixedController.text.isNotEmpty && priorW2TipsFixedController.text.isNotEmpty){
//     print('w2 + pw2');
//     double totalAmount = double.parse(w2TipsFixedController.text) + double.parse(priorW2TipsFixedController.text);
//     double totalYearAndMonths = 24;
//     print(totalAmount.toString());
//     print(totalYearAndMonths.toString());
//     double answer = totalAmount / totalYearAndMonths;
//     print(answer.toString());
//     _totalTips.value = double.parse(answer.toStringAsFixed(2));
//     calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
//     print(_totalAdditionalW2sAmount.value.toString());
//   }else if(baseTipsFixedController.text.isNotEmpty && w2TipsFixedController.text.isNotEmpty){
//     print('base + w2');
//     double totalAmount = double.parse(baseTipsFixedController.text) + double.parse(w2TipsFixedController.text);
//     double totalYearAndMonths = 12 + double.parse(calculateBaseMonthAndDays());
//     print(totalAmount.toString());
//     print(totalYearAndMonths.toString());
//     double answer = totalAmount / totalYearAndMonths;
//     print(answer.toString());
//     _totalTips.value = double.parse(answer.toStringAsFixed(2));
//     calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
//     print(_totalAdditionalW2sAmount.value.toString());
//   }
//   else{
//     _totalTips.value = 0.0;
//     print(_totalTips.value.toString());
//     calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
//   }
// }
// calculateOtherIncomeTest(){
//   if(baseOthersFixedController.text.isNotEmpty && w2OthersFixedController.text.isNotEmpty && priorW2OthersFixedController.text.isNotEmpty){
//     print('base + w2 * pw2');
//     double totalAmount = double.parse(baseOthersFixedController.text) + double.parse(w2OthersFixedController.text) + double.parse(priorW2OthersFixedController.text);
//     double totalYearAndMonths = 24 + double.parse(calculateBaseMonthAndDays());
//     print(totalAmount.toString());
//     print(totalYearAndMonths.toString());
//     double answer = totalAmount / totalYearAndMonths;
//     print(answer.toString());
//     _totalOthers.value = double.parse(answer.toStringAsFixed(2));
//     calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
//     print(_totalAdditionalW2sAmount.value.toString());
//
//   }else if(w2OthersFixedController.text.isNotEmpty && priorW2OthersFixedController.text.isNotEmpty){
//     print('w2 + pw2');
//     double totalAmount = double.parse(w2OthersFixedController.text) + double.parse(priorW2OthersFixedController.text);
//     double totalYearAndMonths = 24;
//     print(totalAmount.toString());
//     print(totalYearAndMonths.toString());
//     double answer = totalAmount / totalYearAndMonths;
//     print(answer.toString());
//     _totalOthers.value = double.parse(answer.toStringAsFixed(2));
//     calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
//     print(_totalAdditionalW2sAmount.value.toString());
//   }else if(baseOthersFixedController.text.isNotEmpty && w2OthersFixedController.text.isNotEmpty){
//     print('base + w2');
//     double totalAmount = double.parse(baseOthersFixedController.text) + double.parse(w2OthersFixedController.text);
//     double totalYearAndMonths = 12 + double.parse(calculateBaseMonthAndDays());
//     print(totalAmount.toString());
//     print(totalYearAndMonths.toString());
//     double answer = totalAmount / totalYearAndMonths;
//     print(answer.toString());
//     _totalOthers.value = double.parse(answer.toStringAsFixed(2));
//     calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
//     print(_totalAdditionalW2sAmount.value.toString());
//   }
//   else{
//     _totalOthers.value = 0.0;
//     print(_totalTips.value.toString());
//     calculateTotalW2Incomes(totalOverTime, totalBonus, totalCommission, totalTips, totalOthers);
//   }
// }

