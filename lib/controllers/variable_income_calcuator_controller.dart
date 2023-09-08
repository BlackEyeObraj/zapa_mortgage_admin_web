import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/firestore_service.dart';
import '../utils/utils_mehtods.dart';


class VariableIncomeCalculatorController extends GetxController{
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
  final RxString _salaryCycle = 'Hourly'.obs;
  final RxBool _currentWorking = true.obs;
  final RxBool _additionalW2IncomeTypes = false.obs;
  final RxInt _selectedPayPeriodEndDateMonth = 0.obs;
  final RxInt _selectedPayPeriodEndDateDay = 0.obs;
  final RxInt _salaryCycleValue = 0.obs;
  final RxString _calculatedMonthlyIncomeFixed = '0.0'.obs;
  final RxString _calculatedBaseIncomeYTDFixed = '0.0'.obs;
  final RxString _calculatedW2Fixed = '0.0'.obs;
  final RxString _calculatedPriorW2Fixed = '0.0'.obs;
  final RxString _calculatedDifference = '0.0'.obs;
  final RxString _calculatedDifferenceValueType = ''.obs;
  final RxDouble _totalOverTime = 0.0.obs;
  final RxDouble _totalIncome = 0.0.obs;
  final RxDouble _totalBonus= 0.0.obs;
  final RxDouble _totalCommission = 0.0.obs;
  final RxDouble _totalTips = 0.0.obs;
  final RxDouble _totalOthers = 0.0.obs;
  final RxString _totalAdditionalW2sAmount = '0.0'.obs;
  final RxDouble _baseIncome = 0.0.obs;
  final RxDouble _w2Income = 0.0.obs;
  final RxDouble _priorW2Income = 0.0.obs;
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
  final RxString _summaryTotalSimple = '0.0'.obs;

  final payPeriodEndDateController = TextEditingController();
  final dateOfPayCheckController = TextEditingController();
  final additionalW2IncomeController = TextEditingController();
  final payRatePerCycleController = TextEditingController();
  final latestYearsW2Box5IncomeController = TextEditingController();
  final priorYearsW2Box5IncomeController = TextEditingController();
  final employerNameController = TextEditingController();
  final employmentStartDateController = TextEditingController();
  final employmentEndDateController = TextEditingController();
  final baseIncomeController = TextEditingController();
  final w2IncomeController = TextEditingController();
  final priorW2IncomeController = TextEditingController();
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
  double get totalIncome => _totalIncome.value;
  double get totalOverTime => _totalOverTime.value;
  double get totalBonus => _totalBonus.value;
  double get totalCommission => _totalCommission.value;
  double get totalTips => _totalTips.value;
  double get totalOthers => _totalOthers.value;
  String get totalAdditionalW2sAmount => _totalAdditionalW2sAmount.value;
  bool get additionalW2IncomeTypes => _additionalW2IncomeTypes.value;
  double get baseIncome => _baseIncome.value;
  double get w2Income => _w2Income.value;
  double get priorW2Income => _priorW2Income.value;
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
  String get summaryTotalSimple => _summaryTotalSimple.value;
  bool get verifiedCheck => _verifiedCheck.value;
  bool get verifiedButExeCheck => _verifiedButExeCheck.value;

  setSalaryCycle(String value){
    _salaryCycle.value = value;
    if(value == 'Hourly'){
      _totalIncome.value = 0.0;
      _summaryTotal.value = '0.0';
      _salaryCycleValue.value = 40 * 52;
      calculateIncomeTestCase();
    }if(value == 'Weekly'){
      _totalIncome.value = 0.0;

      _summaryTotal.value = '0.0';

      _salaryCycleValue.value = 52;
      calculateIncomeTestCase();
    }else if(value == 'Bi Weekly'){
      _summaryTotal.value = '0.0';
      _totalIncome.value = 0.0;
      _salaryCycleValue.value = 26;
      calculateIncomeTestCase();
    }else if(value == 'Semi Monthly'){
      _summaryTotal.value = '0.0';

      _salaryCycleValue.value = 24;
      calculateIncomeTestCase();
    }else if(value == 'Monthly'){
      _totalIncome.value = 0.0;
      _summaryTotal.value = '0.0';

      _calculatedMonthlyIncomeFixed.value = payRatePerCycleController.text;
      calculateIncomeTestCase();
    }

  }
  setCurrentWorkingFixed(bool value){
    _currentWorking.value = value;
  }


  setSelectedPayPeriodEndDateDayAndMonth(int day, int month){
    _selectedPayPeriodEndDateDay.value = day;
    _selectedPayPeriodEndDateMonth.value = month;
    calculateBonusIncomeTestCase();
    calculateOverTimeIncomeTestCase();
    calculateBonusIncomeTestCase();
    calculateCommissionIncomeTestCase();
    calculateTipsIncomeTestCase();
    calculateOthersIncomeTestCase();
  }

  addIncome(String borrowerId, String verifyStatus, String selectedAddedBy)async{
    await FirestoreService().addVariableIncomeCalculator(
      borrowerId,
      employerNameController.text,
      employmentStartDateController.text,
      employmentEndDateController.text,
        payPeriodEndDateController.text,
        salaryCycle,
      salaryCycle == 'Hourly'?'${baseIncome+w2Income+priorW2Income}':payRatePerCycleController.text,
      baseIncome,
      w2Income,
      priorW2Income,
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
      summaryTotalSimple,
      'Variable Income',
      baseYear.toString(),
      w2Year.toString(),
      priorW2Year.toString(),
      selectedPayPeriodEndDateMonth.toString(),
      selectedPayPeriodEndDateDay.toString(),
      verifyStatus,
      selectedAddedBy
    );
  }
  setAdditionalIncomesValues(String type, double amount){
    if(type == 'baseIncome'){
      _baseIncome.value = amount;
    }else if(type == 'w2Income'){
      _w2Income.value = amount;
    }else if(type == 'priorW2Income'){
      _priorW2Income.value = amount;
    }else if(type == 'baseOverTime'){
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


  calculateAdditionalMethod(String type){
    if(type == 'income'){
      return calculateIncomeTestCase();
    }else if(type == 'overTime'){
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

  calculatePayRate(){
    if(payRatePerCycleController.text.isNotEmpty){
      if(salaryCycle == 'Hourly'){
        _summaryTotal.value = '0.0';

        double sumOfIncomes = baseIncome + w2Income + priorW2Income;
        double sumOfYearsAndMonths = 24 + double.parse(calculateBaseMonthAndDays());
        double total = sumOfIncomes/sumOfYearsAndMonths;
        _totalIncome.value = total;
        calculateTotalSummaryIncome();
      }else if(salaryCycle == 'Weekly'){
        _summaryTotal.value = '0.0';
        _totalIncome.value = 0.0;
        _totalIncome.value = double.parse(payRatePerCycleController.text) * salaryCycleValue / 12;
        calculateTotalSummaryIncome();
      }else if(salaryCycle == 'Bi Weekly'){
        _summaryTotal.value = '0.0';

        _totalIncome.value = double.parse(payRatePerCycleController.text) * salaryCycleValue / 12;
        calculateTotalSummaryIncome();
      }else if(salaryCycle == 'Semi Monthly'){
        _summaryTotal.value = '0.0';
        _totalIncome.value = 0.0;

        _totalIncome.value = double.parse(payRatePerCycleController.text) * salaryCycleValue / 12;
        calculateTotalSummaryIncome();
      }else if(salaryCycle == 'Monthly'){
        _summaryTotal.value = '0.0';
        _totalIncome.value == 0.0;

        _totalIncome.value = double.parse(payRatePerCycleController.text);
        calculateTotalSummaryIncome();
      }
    }else{
      _summaryTotal.value = '0.0';
      _totalIncome.value = 0.0;
      calculateTotalSummaryIncome();

    }

  }
  calculateIncomeTestCase(){
    if(baseIncomeController.text.isNotEmpty && w2IncomeController.text.isNotEmpty && priorW2IncomeController.text.isNotEmpty){
      if(salaryCycle == 'Hourly'){
        _summaryTotal.value = '0.0';
        double sumOfIncomes = baseIncome + w2Income + priorW2Income;
        double sumOfYearsAndMonths = 24 + double.parse(calculateBaseMonthAndDays());
        double total = sumOfIncomes/sumOfYearsAndMonths;
        _totalIncome.value = total;
        calculateTotalSummaryIncome();
      }else if(salaryCycle == 'Weekly'){
        _summaryTotal.value = '0.0';
        _totalIncome.value = payRatePerCycleController.text.isEmpty?0.0: double.parse(payRatePerCycleController.text) * salaryCycleValue / 12;
        calculateTotalSummaryIncome();
      }else if(salaryCycle == 'Bi Weekly'){
        _summaryTotal.value = '0.0';
        _totalIncome.value = payRatePerCycleController.text.isEmpty?0.0:double.parse(payRatePerCycleController.text) * salaryCycleValue / 12;
        calculateTotalSummaryIncome();
      }else if(salaryCycle == 'Semi Monthly'){
        _summaryTotal.value = '0.0';
        _totalIncome.value = payRatePerCycleController.text.isEmpty?0.0:double.parse(payRatePerCycleController.text) * salaryCycleValue / 12;
        calculateTotalSummaryIncome();
      }else if(salaryCycle == 'Monthly'){
        _summaryTotal.value = '0.0';
        _totalIncome.value =payRatePerCycleController.text.isEmpty?0.0: double.parse(payRatePerCycleController.text);
        calculateTotalSummaryIncome();
      }
    }
    else if(payRatePerCycleController.text.isNotEmpty){
      _summaryTotal.value = '0.0';
      calculatePayRate();
    }else{
      _totalIncome.value = 0.0;
      _summaryTotal.value = '0.0';
    }
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
  }


  calculateTotalSummaryIncome(){
    print(totalIncome.toString());
    double sum = totalIncome + totalOverTime + totalBonus + totalCommission + totalTips + totalOthers;
    _summaryTotalSimple.value = sum.toString();
    String twoDecimalPlaces = sum.toStringAsFixed(2);
    String separateUnits = UtilMethods().formatNumberWithCommas(double.parse(twoDecimalPlaces));
    _summaryTotal.value = separateUnits;
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