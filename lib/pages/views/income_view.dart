import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:zapa_mortgage_admin_web/controllers/income_view_controller.dart';

import '../../res/app_colors.dart';
import '../../services/firestore_service.dart';
import '../../utils/utils_mehtods.dart';
import '../../utils/widgets/text_widget.dart';

class IncomeView extends GetView<IncomeViewController>{
  final String borrowerId;
  IncomeView({required this.borrowerId});
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: IncomeViewController(),
        builder: (controller){
        return Scaffold(
          body: Column(
            children: [
              Container(
                  width: Get.width * 1,
                  height: Get.height * .1,
                  decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Text(
                          'Incomes',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                              color: AppColors.textColorWhite
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: (){
                            // LiabilityDialog().addLiabilityDialog(borrowerId);
                          },
                          child: Container(
                            height: Get.height * 1,
                            width: 120,
                            decoration: BoxDecoration(
                                color: AppColors.secondaryColor,
                                borderRadius: BorderRadius.circular(10000)
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(Icons.add,color: AppColors.whiteColor,),
                                Text('Add New',style: TextStyle(color: AppColors.textColorWhite),)
                              ],
                            ),
                          ).paddingOnly(top: 16,bottom: 16,right: 16),
                        ),
                      )
                    ],
                  )
              ),
              Container(
                width: Get.width * 1,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const TextWidget(
                                  text: 'Borrower Income',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  fontColor: AppColors.textColorWhite,
                                  textAlign: TextAlign.start),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  StreamBuilder<double>(
                                    stream: FirestoreService().calculateTotalIncludedIncomeListener(borrowerId),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return const Text(
                                          'Loading...',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w900,
                                            color: AppColors.textColorWhite,
                                          ),
                                        );
                                      } else if (snapshot.hasError) {
                                        return Text(
                                          'Error: ${snapshot.error}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w900,
                                            color: AppColors.textColorWhite,
                                          ),
                                        );
                                      }

                                      double totalAmount = snapshot.data ?? 0.0;
                                      return TextWidget(
                                        text: '\$${UtilMethods().formatNumberWithCommas(totalAmount)}',
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900,
                                        fontColor: AppColors.textColorWhite,
                                        textAlign: TextAlign.start,
                                      );
                                    },
                                  ),

                                  Text(' /per month',
                                    style: TextStyle(color: AppColors.textColorWhite,fontSize: 8),)
                                  // const TextWidget(
                                  //     text: ' /per month',
                                  //     fontSize: 10,
                                  //     fontWeight: FontWeight.normal,
                                  //     fontColor: AppColors.textColorWhite,
                                  //     textAlign: TextAlign.start),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(height: Get.height * .06,width: 1,color: AppColors.whiteColor.withOpacity(.4),).paddingSymmetric(vertical: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const TextWidget(
                                  text: 'Verified Income',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  fontColor: AppColors.textColorWhite,
                                  textAlign: TextAlign.start),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  StreamBuilder<double>(
                                    stream: FirestoreService().calculateTotalVerifiedIncomesListener(borrowerId),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return const Text(
                                          'Loading...',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w900,
                                            color: AppColors.textColorWhite,
                                          ),
                                        );
                                      } else if (snapshot.hasError) {
                                        return Text(
                                          'Error: ${snapshot.error}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w900,
                                            color: AppColors.textColorWhite,
                                          ),
                                        );
                                      }

                                      double totalAmount = snapshot.data ?? 0.0;
                                      return TextWidget(
                                        text: '\$${UtilMethods().formatNumberWithCommas(totalAmount)}',
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900,
                                        fontColor: AppColors.textColorWhite,
                                        textAlign: TextAlign.start,
                                      );
                                    },
                                  ),


                                  Text(' /per month',
                                    style: TextStyle(color: AppColors.textColorWhite,fontSize: 8),)
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ).paddingSymmetric(horizontal: 12),
              ).paddingOnly(top: 8,left: 16,right: 16),
              Expanded(
                  child: SingleChildScrollView(
                    child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: FirestoreService().getIncome(borrowerId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData ||
                            snapshot.data?.data() == null) {
                          return Center(
                            child: const TextWidget(
                              text: 'No Income is added yet',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              fontColor: AppColors.textColorBlack,
                              textAlign: TextAlign.center,
                            ).paddingOnly(
                              top: Get.height * .06,
                              bottom: Get.height * .06,
                            ),
                          );
                        }

                        var documentData = snapshot.data!.data();
                        if (documentData!['incomes'] == null) {
                          return Center(
                            child: const TextWidget(
                              text: 'No Income is added yet',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              fontColor: AppColors.textColorBlack,
                              textAlign: TextAlign.center,
                            ).paddingOnly(
                              top: Get.height * .06,
                              bottom: Get.height * .06,
                            ),
                          );
                        }
                        List<dynamic> incomes = documentData['incomes'];
                        return
                        GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // Display two items in each row
                            mainAxisSpacing: 10.0, // Spacing between rows
                            crossAxisSpacing: 10.0, // Spacing between columns
                            childAspectRatio: 4 / 1.68,
                          ),
                          itemCount: incomes.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            var income = incomes[index];
                            double monthlyIncome = double.parse(income['monthlyIncome']);
                            double grossAnnualIncome = double.parse(income['grossAnnualIncome']);
                            int itemNumber = index + 1;
                            return income['addedBy'] == 'customer'?
                            Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: AppColors.liabilityItemsBackgroundColor.withOpacity(.4)
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: 24,
                                              height: 24,
                                              decoration: const BoxDecoration(
                                                  color: AppColors.whiteColor,
                                                  shape: BoxShape.circle
                                              ),
                                              child: Center(
                                                child: TextWidget(
                                                    text: itemNumber.toString(),
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    fontColor: AppColors.secondaryColor,
                                                    textAlign: TextAlign.center),
                                              ),
                                            ),
                                            income['type'] == 'business'?income['currentlyActive'] == 'true' && income['greaterOrLessThen2Years'] == 'true'?
                                            TextWidget(
                                                text: income['status'],
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                fontColor: income['status'] == 'Include'?AppColors.textColorGreen2:AppColors.errorTextColor,
                                                textAlign: TextAlign.center).paddingOnly(left: Get.width * .04):
                                            Stack(
                                              children: [
                                                TextWidget(
                                                    text: income['status'],
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    fontColor: income['status'] == 'Include'?AppColors.textColorGreen2:AppColors.errorTextColor,
                                                    textAlign: TextAlign.center).paddingOnly(left: Get.width * .04),
                                                income['includeIt'] == true ? Positioned(
                                                  top: Get.height * 0.011,
                                                  left: Get.width * 0.040,
                                                  child: Container(
                                                    width: Get.width * 0.40,
                                                    height: Get.height * 0.0018,
                                                    color: AppColors.blackColor,
                                                  ),
                                                ):const SizedBox(),
                                              ],
                                            ):
                                            TextWidget(
                                                text: income['status'],
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                fontColor: income['status'] == 'Include'?AppColors.textColorGreen2:AppColors.errorTextColor,
                                                textAlign: TextAlign.center).marginOnly(left: 4),
                                            // income['type'] == 'business'?income['currentlyActive'] == 'true' && income['greaterOrLessThen2Years'] == 'true'?
                                            income['type'] == 'business'?income['currentlyActive'] == 'true' && income['greaterOrLessThen2Years'] == 'true'?
                                            FlutterSwitch(
                                              activeText: 'Include',
                                              inactiveText: 'Exclude',
                                              activeColor: AppColors.primaryColor,
                                              inactiveColor: AppColors.blackColor.withOpacity(.1),
                                              value: income['status'] == 'Include'?true:false,
                                              valueFontSize: 8.0,
                                              width: Get.width * .04,
                                              height: 20,
                                              borderRadius: 30.0,
                                              showOnOff: false,
                                              toggleSize: 14,
                                              onToggle: (val) {
                                                if(income['status'] == 'Include'){
                                                  FirestoreService().updateIncomeStatus(borrowerId,index, 'Exclude');
                                                }else{
                                                  FirestoreService().updateIncomeStatus(borrowerId,index, 'Include');
                                                }
                                              },
                                            ).paddingOnly(left: 8):FlutterSwitch(
                                              activeText: 'Include',
                                              inactiveText: 'Exclude',
                                              activeColor: AppColors.primaryColor,
                                              inactiveColor: AppColors.blackColor.withOpacity(.1),
                                              value: false,
                                              valueFontSize: 8.0,
                                              width: Get.width * .04,
                                              height: 20,
                                              toggleColor: AppColors.greyColor,
                                              borderRadius: 30.0,
                                              showOnOff: false,
                                              toggleSize: 14,
                                              onToggle: (val) {
                                              },
                                            ).paddingOnly(left: 8): FlutterSwitch(
                                              activeText: 'Include',
                                              inactiveText: 'Exclude',
                                              activeColor: AppColors.primaryColor,
                                              inactiveColor: AppColors.blackColor.withOpacity(.1),
                                              value: income['status'] == 'Include'?true:false,
                                              valueFontSize: 8.0,
                                              width: Get.width * .04,
                                              height: 20,
                                              borderRadius: 30.0,
                                              showOnOff: false,
                                              toggleSize: 14,
                                              onToggle: (val) {
                                                if(income['status'] == 'Include'){
                                                  FirestoreService().updateIncomeStatus(borrowerId,index, 'Exclude');
                                                }else{
                                                  FirestoreService().updateIncomeStatus(borrowerId,index, 'Include');
                                                }
                                              },
                                            ).paddingOnly(left: 8),
                                          ],
                                        ),

                                        Row(
                                          children: [
                                            InkWell(
                                              onTap: (){
                                                // if(income['employerIncomeType'] == 'Fixed Income'){
                                                //   if(income['addedType'] == 'calculator'){
                                                //     Get.toNamed(RouteName.editFixedScreen,arguments: {
                                                //       'additionalW2IncomeTypesAdded':income['additionalW2IncomeTypesAdded'],
                                                //       'baseOvertime': income['baseOvertime'] ?? '0.0',
                                                //       'baseBonus':income['baseBonus'] ?? '0.0',
                                                //       'baseCommission':income['baseCommission'] ?? '0.0',
                                                //       'baseIncomeYearToDate':income['baseIncomeYearToDate'],
                                                //       'baseOther':income['baseOther'] ?? '0.0',
                                                //       'baseTip':income['baseTip'] ?? '0.0',
                                                //       'baseYear':income['baseYear'],
                                                //       'companyName':income['companyName'],
                                                //       'dateOfPayCheck':income['dateOfPayCheck'],
                                                //       'employerIncomeType':income['employerIncomeType'],
                                                //       'endDate':income['endDate'],
                                                //       'grossAnnualIncome':income['grossAnnualIncome'],
                                                //       'latestYearsW2Box5Income':income['latestYearsW2Box5Income'],
                                                //       'monthlyIncome':income['monthlyIncome'],
                                                //       'payPeriodEndDate':income['payPeriodEndDate'],
                                                //       'priorW2Bonus':income['priorW2Bonus'] ?? '0.0',
                                                //       'priorW2Commission':income['priorW2Commission'] ?? '0.0',
                                                //       'priorW2Other':income['priorW2Other'] ?? '0.0',
                                                //       'priorW2Overtime':income['priorW2Overtime'] ?? '0.0',
                                                //       'priorW2Tip':income['priorW2Tip'] ?? '0.0',
                                                //       'priorW2Year':income['priorW2Year'],
                                                //       'priorYearsW2Box5Income':income['priorYearsW2Box5Income'],
                                                //       'salaryCycle':income['salaryCycle'],
                                                //       'startDate':income['startDate'],
                                                //       'w2Bonus':income['w2Bonus'] ?? '0.0',
                                                //       'w2Commission':income['w2Commission'] ?? '0.0',
                                                //       'w2Other':income['w2Other'] ?? '0.0',
                                                //       'w2Overtime':income['w2Overtime'] ?? '0.0',
                                                //       'w2Tip':income['w2Tip'] ?? '0.0',
                                                //       'w2Year':income['w2Year'],
                                                //       'selectedPayPeriodEndDateDay':income['selectedPayPeriodEndDateDay'],
                                                //       'selectedPayPeriodEndDateMonth':income['selectedPayPeriodEndDateMonth'],
                                                //       'index':index.toString(),
                                                //
                                                //     });
                                                //   }else{
                                                //     ManualIncomeDialog().editManualIncome(Get.put(AddIncomeScreenController()),
                                                //         income['companyName'],income['grossAnnualIncome'],income['startDate'],income['endDate'],
                                                //         income['employerIncomeType'],index);
                                                //   }
                                                // }
                                                // else if(income['employerIncomeType'] == 'Variable Income'){
                                                //   if(income['addedType'] == 'calculator'){
                                                //     Get.toNamed(RouteName.editVariableScreen,arguments: {
                                                //       'addedBy':income['addedBy'],
                                                //       'addedType':income['addedType'],
                                                //       'baseBonus':income['baseBonus'],
                                                //       'baseCommission':income['baseCommission'],
                                                //       'baseIncome':income['baseIncome'],
                                                //       'baseOther':income['baseOther'],
                                                //       'baseOvertime':income['baseOvertime'],
                                                //       'baseTip':income['baseTip'],
                                                //       'companyName':income['companyName'],
                                                //       'employerIncomeType':income['employerIncomeType'],
                                                //       'endDate':income['endDate'],
                                                //       'grossAnnualIncome':income['grossAnnualIncome'],
                                                //       'monthlyIncome':income['monthlyIncome'],
                                                //       'payPeriodEndDate':income['payPeriodEndDate'],
                                                //       'priorW2Bonus':income['priorW2Bonus'],
                                                //       'priorW2Commission':income['priorW2Commission'],
                                                //       'priorW2Income':income['priorW2Income'],
                                                //       'priorW2Other':income['priorW2Other'],
                                                //       'priorW2Overtime':income['priorW2Overtime'],
                                                //       'priorW2Tip':income['priorW2Tip'],
                                                //       'salaryCycle':income['salaryCycle'],
                                                //       'startDate':income['startDate'],
                                                //       'status':income['status'],
                                                //       'w2Bonus':income['w2Bonus'],
                                                //       'w2Commission':income['w2Commission'],
                                                //       'w2Income':income['w2Income'],
                                                //       'w2Other':income['w2Other'],
                                                //       'w2Overtime':income['w2Overtime'],
                                                //       'w2Tip':income['w2Tip'],
                                                //       'baseYear':income['baseYear'],
                                                //       'w2Year':income['w2Year'],
                                                //       'priorW2Year':income['priorW2Year'],
                                                //       'selectedPayPeriodEndDateDay':income['selectedPayPeriodEndDateDay'],
                                                //       'selectedPayPeriodEndDateMonth':income['selectedPayPeriodEndDateMonth'],
                                                //     });
                                                //   }else{
                                                //     ManualIncomeDialog().editManualIncome(Get.put(AddIncomeScreenController()),
                                                //         income['companyName'],income['grossAnnualIncome'],income['startDate'],income['endDate'],
                                                //         income['employerIncomeType'],index);
                                                //   }
                                                // }
                                                // else if(income['employerIncomeType'] == 'Form 1040 & Sch C'){
                                                //   if(income['addedType'] == 'calculator'){
                                                //     Get.toNamed(RouteName.editScheduleCScreen,
                                                //         arguments: {
                                                //           'nameOfProprietor':income['nameOfProprietor'],
                                                //           'principalBusinessOrProfession':income['principalBusinessOrProfession'],
                                                //           'companyName':income['companyName'],
                                                //           'currentlyActive':income['currentlyActive'],
                                                //           'netProfitLossRecent':income['netProfitLossRecent'],
                                                //           'nonRecurringRecent':income['nonRecurringRecent'],
                                                //           'depletionRecent':income['depletionRecent'],
                                                //           'depreciationRecent':income['depreciationRecent'],
                                                //           'mealsAndEntertainmentExclusionRecent':income['mealsAndEntertainmentExclusionRecent'],
                                                //           'businessUseOfHomeRecent':income['businessUseOfHomeRecent'],
                                                //           'amortizationCasualtyLossOneTimeExpenseRecent':income['amortizationCasualtyLossOneTimeExpenseRecent'],
                                                //           'businessMilesRecent':income['businessMilesRecent'],
                                                //           'netProfitLossPrior':income['netProfitLossPrior'],
                                                //           'nonRecurringPrior':income['nonRecurringPrior'],
                                                //           'depletionPrior':income['depletionPrior'],
                                                //           'depreciationPrior':income['depreciationPrior'],
                                                //           'mealsAndEntertainmentExclusionPrior':income['mealsAndEntertainmentExclusionPrior'],
                                                //           'businessUseOfHomePrior':income['businessUseOfHomePrior'],
                                                //           'amortizationCasualtyLossOneTimeExpensePrior':income['amortizationCasualtyLossOneTimeExpensePrior'],
                                                //           'businessMilesPrior':income['businessMilesPrior'],
                                                //           'numberOfMonths':income['numberOfMonths'],
                                                //           'baseYear':income['baseYear'],
                                                //           'w2Year':income['w2Year'],
                                                //           'priorW2Year':income['priorW2Year'],
                                                //           'businessStartDateStamp':income['businessStartDateStamp'],
                                                //           'greaterOrLessThen2Years':income['greaterOrLessThen2Years'],
                                                //           'startDate':income['startDate'],
                                                //           'index':index.toString(),
                                                //         });
                                                //   }else{
                                                //     ManualBusinessDialog().editManualBusinessDialog(
                                                //         Get.put(AddIncomeScreenController()),
                                                //         index,
                                                //         income['companyName'],
                                                //         income['currentlyActive'],
                                                //         income['employerIncomeType'],
                                                //         income['grossAnnualIncome'],
                                                //         income['startDate'],
                                                //         income['businessStartDateStamp'],
                                                //         income['greaterOrLessThen2Years']
                                                //     );
                                                //   }
                                                // }
                                                // else if(income['employerIncomeType'] == 'Form 1065 & K1'){
                                                //   if(income['addedType'] == 'calculator'){
                                                //     Get.toNamed(RouteName.edit1040K11065Screen,
                                                //         arguments: {
                                                //           'nameOfPartnerShip':income['nameOfPartnerShip'],
                                                //           'principalBusinessActivity':income['principalBusinessActivity'],
                                                //           'principalProductOrService':income['principalProductOrService'],
                                                //           'companyName':income['companyName'],
                                                //           'startDate':income['startDate'],
                                                //           'currentlyActive':income['currentlyActive'],
                                                //           'w2IncomeFromSelfEmploymentRecent':income['w2IncomeFromSelfEmploymentRecent'],
                                                //           'w2IncomeFromSelfEmploymentPrior':income['w2IncomeFromSelfEmploymentPrior'],
                                                //           'ordinaryIncomeLossRecent':income['ordinaryIncomeLossRecent'],
                                                //           'guaranteedPaymentToPartnerRecent':income['guaranteedPaymentToPartnerRecent'],
                                                //           'ordinaryIncomeLossPrior':income['ordinaryIncomeLossPrior'],
                                                //           'guaranteedPaymentToPartnerPrior':income['guaranteedPaymentToPartnerPrior'],
                                                //           'ordinaryIncomeLossFromOtherPartnershipRecent':income['ordinaryIncomeLossFromOtherPartnershipRecent'],
                                                //           'nonRecurringOtherIncomeLossRecent':income['nonRecurringOtherIncomeLossRecent'],
                                                //           'depreciationRecent':income['depreciationRecent'],
                                                //           'depletionRecent':income['depletionRecent'],
                                                //           'amortizationCasualtyLossOneTimeExpenseRecent':income['amortizationCasualtyLossOneTimeExpenseRecent'],
                                                //           'mortgagePayableInLessThanOneYearRecent':income['mortgagePayableInLessThanOneYearRecent'],
                                                //           'mealsAndEntertainmentRecent':income['mealsAndEntertainmentRecent'],
                                                //           'ownershipPercentageRecent':income['ownershipPercentageRecent'],
                                                //           'ordinaryIncomeLossFromOtherPartnershipPrior':income['ordinaryIncomeLossFromOtherPartnershipPrior'],
                                                //           'nonRecurringOtherIncomeLossPrior':income['nonRecurringOtherIncomeLossPrior'],
                                                //           'depreciationPrior':income['depreciationPrior'],
                                                //           'depletionPrior':income['depletionPrior'],
                                                //           'amortizationCasualtyLossOneTimeExpensePrior':income['amortizationCasualtyLossOneTimeExpensePrior'],
                                                //           'mortgagePayableInLessThanOneYearPrior':income['mortgagePayableInLessThanOneYearPrior'],
                                                //           'mealsAndEntertainmentPrior':income['mealsAndEntertainmentPrior'],
                                                //           'ownershipPercentagePrior':income['ownershipPercentagePrior'],
                                                //           'addPartnershipReturnsPrior':income['addPartnershipReturnsPrior'],
                                                //           'addPartnershipReturnsRecent':income['addPartnershipReturnsRecent'],
                                                //           'numberOfMonths':income['numberOfMonths'],
                                                //           'baseYear':income['baseYear'],
                                                //           'w2Year':income['w2Year'],
                                                //           'priorW2Year':income['priorW2Year'],
                                                //           'businessStartDateStamp':income['businessStartDateStamp'],
                                                //           'greaterOrLessThen2Years':income['greaterOrLessThen2Years'],
                                                //           'index':index.toString(),
                                                //         });
                                                //   }else{
                                                //     ManualBusinessDialog().editManualBusinessDialog(
                                                //         Get.put(AddIncomeScreenController()),
                                                //         index,
                                                //         income['companyName'],
                                                //         income['currentlyActive'],
                                                //         income['employerIncomeType'],
                                                //         income['grossAnnualIncome'],
                                                //         income['startDate'],
                                                //         income['businessStartDateStamp'],
                                                //         income['greaterOrLessThen2Years']
                                                //     );
                                                //   }
                                                // }
                                                // else if(income['employerIncomeType'] == 'Form 1120S & K1'){
                                                //   if(income['addedType'] == 'calculator'){
                                                //     Get.toNamed(RouteName.edit1040K11120SScreen,
                                                //         arguments: {
                                                //           'nameOfPartnerShip':income['nameOfPartnerShip'],
                                                //           'sElectionEffectiveDate':income['sElectionEffectiveDate'],
                                                //           'companyName':income['companyName'],
                                                //           'startDate':income['startDate'],
                                                //           'currentlyActive':income['currentlyActive'],
                                                //           'w2IncomeFromSelfEmploymentRecent':income['w2IncomeFromSelfEmploymentRecent'],
                                                //           'w2IncomeFromSelfEmploymentPrior':income['w2IncomeFromSelfEmploymentPrior'],
                                                //           'ordinaryIncomeLossRecent':income['ordinaryIncomeLossRecent'],
                                                //           'ordinaryIncomeLossPrior':income['ordinaryIncomeLossPrior'],
                                                //           'nonRecurringOtherIncomeLossRecent':income['nonRecurringOtherIncomeLossRecent'],
                                                //           'depreciationRecent':income['depreciationRecent'],
                                                //           'depletionRecent':income['depletionRecent'],
                                                //           'amortizationCasualtyLossOneTimeExpenseRecent':income['amortizationCasualtyLossOneTimeExpenseRecent'],
                                                //           'mortgagePayableInLessThanOneYearRecent':income['mortgagePayableInLessThanOneYearRecent'],
                                                //           'mealsAndEntertainmentRecent':income['mealsAndEntertainmentRecent'],
                                                //           'ownershipPercentageRecent':income['ownershipPercentageRecent'],
                                                //           'nonRecurringOtherIncomeLossPrior':income['nonRecurringOtherIncomeLossPrior'],
                                                //           'depreciationPrior':income['depreciationPrior'],
                                                //           'depletionPrior':income['depletionPrior'],
                                                //           'amortizationCasualtyLossOneTimeExpensePrior':income['amortizationCasualtyLossOneTimeExpensePrior'],
                                                //           'mortgagePayableInLessThanOneYearPrior':income['mortgagePayableInLessThanOneYearPrior'],
                                                //           'mealsAndEntertainmentPrior':income['mealsAndEntertainmentPrior'],
                                                //           'ownershipPercentagePrior':income['ownershipPercentagePrior'],
                                                //           'addPartnershipReturnsPrior':income['addPartnershipReturnsPrior'],
                                                //           'addPartnershipReturnsRecent':income['addPartnershipReturnsRecent'],
                                                //           'numberOfMonths':income['numberOfMonths'],
                                                //           'baseYear':income['baseYear'],
                                                //           'w2Year':income['w2Year'],
                                                //           'priorW2Year':income['priorW2Year'],
                                                //           'businessStartDateStamp':income['businessStartDateStamp'],
                                                //           'greaterOrLessThen2Years':income['greaterOrLessThen2Years'],
                                                //           'index':index.toString(),
                                                //         });
                                                //   }else{
                                                //     ManualBusinessDialog().editManualBusinessDialog(
                                                //         Get.put(AddIncomeScreenController()),
                                                //         index,
                                                //         income['companyName'],
                                                //         income['currentlyActive'],
                                                //         income['employerIncomeType'],
                                                //         income['grossAnnualIncome'],
                                                //         income['startDate'],
                                                //         income['businessStartDateStamp'],
                                                //         income['greaterOrLessThen2Years']
                                                //     );
                                                //   }
                                                // }
                                                // else if(income['employerIncomeType'] == 'Form 1120'){
                                                //   if(income['addedType'] == 'calculator'){
                                                //     Get.toNamed(RouteName.edit10401120Screen,
                                                //         arguments: {
                                                //           'name':income['name'],
                                                //           'companyName':income['companyName'],
                                                //           'startDate':income['startDate'],
                                                //           'currentlyActive':income['currentlyActive'],
                                                //           'w2IncomeFromSelfEmploymentRecent':income['w2IncomeFromSelfEmploymentRecent'],
                                                //           'w2IncomeFromSelfEmploymentPrior':income['w2IncomeFromSelfEmploymentPrior'],
                                                //           'taxableIncomeRecent':income['taxableIncomeRecent'],
                                                //           'totalTaxRecent':income['totalTaxRecent'],
                                                //           'nonRecurringGainLossRecent':income['nonRecurringGainLossRecent'],
                                                //           'nonRecurringOtherIncomeLossRecent':income['nonRecurringOtherIncomeLossRecent'],
                                                //           'depreciationRecent':income['depreciationRecent'],
                                                //           'depletionRecent':income['depletionRecent'],
                                                //           'amortizationCasualtyLossOneTimeExpenseRecent':income['amortizationCasualtyLossOneTimeExpenseRecent'],
                                                //           'netOperatingLossAndSpecialDeductionsRecent':income['netOperatingLossAndSpecialDeductionsRecent'],
                                                //           'mortgagePayableInLessThanOneYearRecent':income['mortgagePayableInLessThanOneYearRecent'],
                                                //           'mealsAndEntertainmentRecent':income['mealsAndEntertainmentRecent'],
                                                //           'ownershipPercentageRecent':income['ownershipPercentageRecent'],
                                                //           'dividendsPaidToBorrowerRecent':income['dividendsPaidToBorrowerRecent'],
                                                //           'taxableIncomePrior':income['taxableIncomePrior'],
                                                //           'totalTaxPrior':income['totalTaxPrior'],
                                                //           'nonRecurringGainLossPrior':income['nonRecurringGainLossPrior'],
                                                //           'nonRecurringOtherIncomeLossPrior':income['nonRecurringOtherIncomeLossPrior'],
                                                //           'depreciationPrior':income['depreciationPrior'],
                                                //           'depletionPrior':income['depletionPrior'],
                                                //           'amortizationCasualtyLossOneTimeExpensePrior':income['amortizationCasualtyLossOneTimeExpensePrior'],
                                                //           'netOperatingLossAndSpecialDeductionsPrior':income['netOperatingLossAndSpecialDeductionsPrior'],
                                                //           'mortgagePayableInLessThanOneYearPrior':income['mortgagePayableInLessThanOneYearPrior'],
                                                //           'mealsAndEntertainmentPrior':income['mealsAndEntertainmentPrior'],
                                                //           'ownershipPercentagePrior':income['ownershipPercentagePrior'],
                                                //           'dividendsPaidToBorrowerPrior':income['dividendsPaidToBorrowerPrior'],
                                                //           'addPartnershipReturnsPrior':income['addPartnershipReturnsPrior'],
                                                //           'addPartnershipReturnsRecent':income['addPartnershipReturnsRecent'],
                                                //           'numberOfMonths':income['numberOfMonths'],
                                                //           'baseYear':income['baseYear'],
                                                //           'w2Year':income['w2Year'],
                                                //           'priorW2Year':income['priorW2Year'],
                                                //           'businessStartDateStamp':income['businessStartDateStamp'],
                                                //           'greaterOrLessThen2Years':income['greaterOrLessThen2Years'],
                                                //           'index':index.toString(),
                                                //         });
                                                //   }else{
                                                //     ManualBusinessDialog().editManualBusinessDialog(
                                                //         Get.put(AddIncomeScreenController()),
                                                //         index,
                                                //         income['companyName'],
                                                //         income['currentlyActive'],
                                                //         income['employerIncomeType'],
                                                //         income['grossAnnualIncome'],
                                                //         income['startDate'],
                                                //         income['businessStartDateStamp'],
                                                //         income['greaterOrLessThen2Years']
                                                //     );
                                                //   }
                                                // }
                                              },
                                              child: Container(
                                                  width: Get.width * .05,
                                                  height: 24,
                                                  decoration: BoxDecoration(
                                                      color: AppColors.secondaryColor,
                                                      borderRadius: BorderRadius.circular(1000)
                                                  ),
                                                  child: const Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      Icon(Icons.edit,size: 14,color: AppColors.whiteColor,),
                                                      Text('Edit',
                                                        style: TextStyle(
                                                            fontSize: 8,
                                                            color: AppColors.textColorWhite,
                                                            fontWeight: FontWeight.bold
                                                        ),)
                                                    ],
                                                  )
                                              ),
                                            ),
                                            SizedBox(width: 8,),
                                            InkWell(
                                              onTap: ()async{
                                                // ManualIncomeDialog().removeIncomeDialog(index);

                                              },
                                              child: Container(
                                                  width: Get.width * .05,
                                                  height: 24,
                                                  decoration: BoxDecoration(
                                                      color: AppColors.deleteButtonBg,
                                                      borderRadius: BorderRadius.circular(1000)
                                                  ),
                                                  child: const Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      Icon(Icons.delete,size: 14,color: AppColors.whiteColor,),
                                                      Text('Trash',
                                                        style: TextStyle(
                                                            fontSize: 8,
                                                            color: AppColors.textColorWhite,
                                                            fontWeight: FontWeight.bold
                                                        ),)
                                                    ],
                                                  )
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            TextWidget(
                                                text: income['companyName'],
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                fontColor: AppColors.primaryColor,
                                                textAlign: TextAlign.center),

                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                const Text('Start Date:',style: TextStyle(fontSize: 10),),
                                                Text(income['startDate'],style: const TextStyle(fontSize: 10),),
                                              ],
                                            ),
                                            income['type'] == 'income'? income['endDate'] != ''? Row(
                                              children: [
                                                const Text('End Date:',style: TextStyle(fontSize: 10),),
                                                Text(income['endDate'],style: const TextStyle(fontSize: 10),),
                                              ],
                                            ):
                                            const Text('Currently Present',style: TextStyle(fontSize: 10,color: AppColors.greenColor,fontWeight: FontWeight.bold),):
                                            income['currentlyActive'] == 'true'?const Text('Currently Active',style: TextStyle(fontSize: 10,color: AppColors.greenColor,fontWeight: FontWeight.bold),):
                                            const Text('Currently Inactive',style: TextStyle(fontSize: 10,color: AppColors.errorTextColor,fontWeight: FontWeight.bold),),
                                            // income['type'] == 'business'?UtilsMethods().isDifferenceGreaterThanTwoYears(income['businessStartDateStamp']) == true?Text('Yes'):Text('No'):const SizedBox()
                                          ],
                                        )
                                      ],
                                    ).paddingOnly(top: Get.height * .02),
                                    Container(
                                      width: Get.width * 1,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(width: 1,color: income['greaterOrLessThen2Years']=='false'?AppColors.primaryColor:AppColors.transparentColor)
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          income['type'] == 'business'?
                                          UtilMethods().isDifferenceGreaterThanTwoYears(income['businessStartDateStamp']) == true?const SizedBox():
                                          const Text('Note: Business less than 2 Years Old. So your Income is considered Excluded.',style: TextStyle(fontSize: 12),):const SizedBox(),
                                          income['type'] == 'business'&&UtilMethods().isDifferenceGreaterThanTwoYears(income['businessStartDateStamp']) == false  && income['greaterOrLessThen2Years']=='false'?Row(
                                            children: [
                                              Checkbox(
                                                  value: income['includeIt'],
                                                  activeColor: AppColors.primaryColor,
                                                  onChanged: (value){
                                                    if(income['includeIt'] == false){
                                                      FirestoreService().updateIncomeIncludeItStatus(borrowerId,index, true);
                                                    }else{
                                                      FirestoreService().updateIncomeIncludeItStatus(borrowerId,index, false);
                                                    }
                                                  }
                                              ),
                                              const Text('Check to include it anyway',style: TextStyle(fontSize: 12))
                                            ],
                                          ):const SizedBox(),
                                        ],
                                      ).paddingAll(4),
                                    ).marginOnly(top: income['greaterOrLessThen2Years']=='false'?4:0),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            income['addedType'] == 'calculator'?
                                            Row(
                                              children: [
                                                TextWidget(
                                                    text: '\$${UtilMethods().formatNumberWithCommas(grossAnnualIncome)}',
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    fontColor: AppColors.textColorApp,
                                                    textAlign: TextAlign.center
                                                ),
                                                // TextWidget(
                                                //     text: '/ ${income['salaryCycle']}',
                                                //     fontSize: 10,
                                                //     fontWeight: FontWeight.bold,
                                                //     fontColor: AppColors.textColorApp,
                                                //     textAlign: TextAlign.center
                                                // ),
                                              ],
                                            ):Row(
                                              children: [
                                                TextWidget(
                                                    text: '\$${UtilMethods().formatNumberWithCommas(grossAnnualIncome)}',
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    fontColor: AppColors.textColorApp,
                                                    textAlign: TextAlign.center
                                                ),
                                                // const TextWidget(
                                                //     text: '/ Monthly',
                                                //     fontSize: 10,
                                                //     fontWeight: FontWeight.bold,
                                                //     fontColor: AppColors.textColorApp,
                                                //     textAlign: TextAlign.center
                                                // ),
                                              ],
                                            ),
                                            TextWidget(
                                                text: income['type'] == 'income'?'Gross Annual Income':'Net Profit / Loss',
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                fontColor: AppColors.primarySecondaryColor.withOpacity(.7),
                                                textAlign: TextAlign.center
                                            )
                                          ],
                                        ),

                                        Container(width: Get.width * .001,height: Get.height * .04,color: AppColors.primaryColor,),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            TextWidget(
                                                text: '\$${UtilMethods().formatNumberWithCommas(monthlyIncome)}',
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                fontColor: AppColors.textColorApp,
                                                textAlign: TextAlign.center
                                            ),
                                            TextWidget(
                                                text: 'Monthly Income',
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                fontColor: AppColors.primarySecondaryColor.withOpacity(.7),
                                                textAlign: TextAlign.center
                                            )
                                          ],
                                        ),

                                      ],
                                    ).paddingOnly(top: Get.height * .008,bottom: Get.height * .01),
                                    income['addedType'] == 'manual'? Row(
                                      children: [
                                        const Expanded(
                                            flex: 6,
                                            child: Text('You have added this income manually. If you want to add details of this income you can use calculator:',
                                              style: TextStyle(fontSize: 12),)),
                                        Expanded(
                                          flex: 4,
                                          child: GestureDetector(
                                            onTap: (){
                                              // if(income['employerIncomeType'] == 'Fixed Income'){
                                              //   Get.toNamed(RouteName.editFixedScreen,arguments: {
                                              //     'additionalW2IncomeTypesAdded':income['additionalW2IncomeTypesAdded'] ?? 'false',
                                              //     'baseOvertime': income['baseOvertime'] ?? '0.0',
                                              //     'baseBonus':income['baseBonus'] ?? '0.0',
                                              //     'baseCommission':income['baseCommission'] ?? '0.0',
                                              //     'baseIncomeYearToDate':income['baseIncomeYearToDate'] ?? '0.0',
                                              //     'baseOther':income['baseOther'] ?? '0.0',
                                              //     'baseTip':income['baseTip'] ?? '0.0',
                                              //     'baseYear':income['baseYear'] ?? '',
                                              //     'companyName':income['companyName'],
                                              //     'dateOfPayCheck':income['dateOfPayCheck'] ?? '',
                                              //     'employerIncomeType':income['employerIncomeType'],
                                              //     'endDate':income['endDate'],
                                              //     'grossAnnualIncome':income['monthlyIncome'],
                                              //     'latestYearsW2Box5Income':income['latestYearsW2Box5Income'] ?? '0.0',
                                              //     'monthlyIncome':income['monthlyIncome'],
                                              //     'payPeriodEndDate':income['payPeriodEndDate'] ?? '',
                                              //     'priorW2Bonus':income['priorW2Bonus'] ?? '0.0',
                                              //     'priorW2Commission':income['priorW2Commission'] ?? '0.0',
                                              //     'priorW2Other':income['priorW2Other'] ?? '0.0',
                                              //     'priorW2Overtime':income['priorW2Overtime'] ?? '0.0',
                                              //     'priorW2Tip':income['priorW2Tip'] ?? '0.0',
                                              //     'priorW2Year':income['priorW2Year'] ?? '',
                                              //     'priorYearsW2Box5Income':income['priorYearsW2Box5Income'] ?? '0.0',
                                              //     'salaryCycle':income['salaryCycle'],
                                              //     'startDate':income['startDate'],
                                              //     'w2Bonus':income['w2Bonus'] ?? '0.0',
                                              //     'w2Commission':income['w2Commission'] ?? '0.0',
                                              //     'w2Other':income['w2Other'] ?? '0.0',
                                              //     'w2Overtime':income['w2Overtime'] ?? '0.0',
                                              //     'w2Tip':income['w2Tip'] ?? '0.0',
                                              //     'w2Year':income['w2Year'] ?? '',
                                              //     'selectedPayPeriodEndDateDay':income['selectedPayPeriodEndDateDay'] ?? '0',
                                              //     'selectedPayPeriodEndDateMonth':income['selectedPayPeriodEndDateMonth'] ?? '0',
                                              //     'index':index.toString(),
                                              //   });
                                              //
                                              // }
                                              // else if(income['employerIncomeType'] == 'Variable Income'){
                                              //   Get.toNamed(RouteName.editVariableScreen,arguments: {
                                              //     'addedBy':income['addedBy'],
                                              //     'addedType':income['addedType'],
                                              //     'baseBonus':income['baseBonus'] ?? '0.0',
                                              //     'baseCommission':income['baseCommission'] ?? '0.0',
                                              //     'baseIncome':income['baseIncome'] ?? '0.0',
                                              //     'baseOther':income['baseOther'] ?? '0.0',
                                              //     'baseOvertime':income['baseOvertime'] ?? '0.0',
                                              //     'baseTip':income['baseTip'] ?? '0.0',
                                              //     'companyName':income['companyName'],
                                              //     'employerIncomeType':income['employerIncomeType'],
                                              //     'endDate':income['endDate'],
                                              //     'grossAnnualIncome':income['monthlyIncome'],
                                              //     'monthlyIncome':income['monthlyIncome'],
                                              //     'payPeriodEndDate':income['payPeriodEndDate'],
                                              //     'priorW2Bonus':income['priorW2Bonus'] ?? '0.0',
                                              //     'priorW2Commission':income['priorW2Commission'] ?? '0.0',
                                              //     'priorW2Income':income['priorW2Income'] ?? '0.0',
                                              //     'priorW2Other':income['priorW2Other'] ?? '0.0',
                                              //     'priorW2Overtime':income['priorW2Overtime'] ?? '0.0',
                                              //     'priorW2Tip':income['priorW2Tip'] ?? '0.0',
                                              //     'salaryCycle':income['salaryCycle'],
                                              //     'startDate':income['startDate'],
                                              //     'status':income['status'],
                                              //     'w2Bonus':income['w2Bonus'] ?? '0.0',
                                              //     'w2Commission':income['w2Commission'] ?? '0.0',
                                              //     'w2Income':income['w2Income'] ?? '0.0',
                                              //     'w2Other':income['w2Other'] ?? '0.0',
                                              //     'w2Overtime':income['w2Overtime'] ?? '0.0',
                                              //     'w2Tip':income['w2Tip'] ?? '0.0',
                                              //     'baseYear':income['baseYear'],
                                              //     'w2Year':income['w2Year'],
                                              //     'priorW2Year':income['priorW2Year'],
                                              //     'selectedPayPeriodEndDateDay':income['selectedPayPeriodEndDateDay'] ?? '0',
                                              //     'selectedPayPeriodEndDateMonth':income['selectedPayPeriodEndDateMonth'] ?? '0',
                                              //     'index':index.toString(),
                                              //   });
                                              // }
                                              // else if(income['employerIncomeType'] == 'Form 1040 & Sch C'){
                                              //   Get.toNamed(RouteName.editScheduleCScreen,
                                              //       arguments: {
                                              //         'nameOfProprietor':income['nameOfProprietor']??'',
                                              //         'principalBusinessOrProfession':income['principalBusinessOrProfession']??'',
                                              //         'companyName':income['companyName'],
                                              //         'currentlyActive':income['currentlyActive'],
                                              //         'netProfitLossRecent':income['grossAnnualIncome']??'0.0',
                                              //         'nonRecurringRecent':income['nonRecurringRecent']??'0.0',
                                              //         'depletionRecent':income['depletionRecent']??'0.0',
                                              //         'depreciationRecent':income['depreciationRecent']??'0.0',
                                              //         'mealsAndEntertainmentExclusionRecent':income['mealsAndEntertainmentExclusionRecent']??'0.0',
                                              //         'businessUseOfHomeRecent':income['businessUseOfHomeRecent']??'0.0',
                                              //         'amortizationCasualtyLossOneTimeExpenseRecent':income['amortizationCasualtyLossOneTimeExpenseRecent']??'0.0',
                                              //         'businessMilesRecent':income['businessMilesRecent']??'0.0',
                                              //         'netProfitLossPrior':income['netProfitLossPrior']??'0.0',
                                              //         'nonRecurringPrior':income['nonRecurringPrior']??'0.0',
                                              //         'depletionPrior':income['depletionPrior']??'0.0',
                                              //         'depreciationPrior':income['depreciationPrior']??'0.0',
                                              //         'mealsAndEntertainmentExclusionPrior':income['mealsAndEntertainmentExclusionPrior']??'0.0',
                                              //         'businessUseOfHomePrior':income['businessUseOfHomePrior']??'0.0',
                                              //         'amortizationCasualtyLossOneTimeExpensePrior':income['amortizationCasualtyLossOneTimeExpensePrior']??'0.0',
                                              //         'businessMilesPrior':income['businessMilesPrior']??'0.0',
                                              //         'numberOfMonths':income['numberOfMonths']??'12.0',
                                              //         'baseYear':income['baseYear'],
                                              //         'w2Year':income['w2Year'],
                                              //         'priorW2Year':income['priorW2Year'],
                                              //         'businessStartDateStamp':income['businessStartDateStamp'],
                                              //         'greaterOrLessThen2Years':income['greaterOrLessThen2Years'],
                                              //         'startDate':income['startDate'],
                                              //         'index':index.toString(),
                                              //       });
                                              // }
                                              // else if(income['employerIncomeType'] == 'Form 1065 & K1'){
                                              //   Get.toNamed(RouteName.edit1040K11065Screen,
                                              //       arguments: {
                                              //         'nameOfPartnerShip':income['nameOfPartnerShip']??'',
                                              //         'principalBusinessActivity':income['principalBusinessActivity']??'',
                                              //         'principalProductOrService':income['principalProductOrService']??'',
                                              //         'companyName':income['companyName'],
                                              //         'startDate':income['startDate'],
                                              //         'currentlyActive':income['currentlyActive'],
                                              //         'w2IncomeFromSelfEmploymentRecent':income['w2IncomeFromSelfEmploymentRecent']??'0.0',
                                              //         'w2IncomeFromSelfEmploymentPrior':income['w2IncomeFromSelfEmploymentPrior']??'0.0',
                                              //         'ordinaryIncomeLossRecent':income['ordinaryIncomeLossRecent']??'0.0',
                                              //         'guaranteedPaymentToPartnerRecent':income['guaranteedPaymentToPartnerRecent']??'0.0',
                                              //         'ordinaryIncomeLossPrior':income['ordinaryIncomeLossPrior']??'0.0',
                                              //         'guaranteedPaymentToPartnerPrior':income['guaranteedPaymentToPartnerPrior']??'0.0',
                                              //         'ordinaryIncomeLossFromOtherPartnershipRecent':income['grossAnnualIncome']??'0.0',
                                              //         'nonRecurringOtherIncomeLossRecent':income['nonRecurringOtherIncomeLossRecent']??'0.0',
                                              //         'depreciationRecent':income['depreciationRecent']??'0.0',
                                              //         'depletionRecent':income['depletionRecent']??'0.0',
                                              //         'amortizationCasualtyLossOneTimeExpenseRecent':income['amortizationCasualtyLossOneTimeExpenseRecent']??'0.0',
                                              //         'mortgagePayableInLessThanOneYearRecent':income['mortgagePayableInLessThanOneYearRecent']??'0.0',
                                              //         'mealsAndEntertainmentRecent':income['mealsAndEntertainmentRecent']??'0.0',
                                              //         'ownershipPercentageRecent':income['ownershipPercentageRecent']??'50.0',
                                              //         'ordinaryIncomeLossFromOtherPartnershipPrior':income['ordinaryIncomeLossFromOtherPartnershipPrior']??'0.0',
                                              //         'nonRecurringOtherIncomeLossPrior':income['nonRecurringOtherIncomeLossPrior']??'0.0',
                                              //         'depreciationPrior':income['depreciationPrior']??'0.0',
                                              //         'depletionPrior':income['depletionPrior']??'0.0',
                                              //         'amortizationCasualtyLossOneTimeExpensePrior':income['amortizationCasualtyLossOneTimeExpensePrior']??'0.0',
                                              //         'mortgagePayableInLessThanOneYearPrior':income['mortgagePayableInLessThanOneYearPrior']??'0.0',
                                              //         'mealsAndEntertainmentPrior':income['mealsAndEntertainmentPrior']??'0.0',
                                              //         'ownershipPercentagePrior':income['ownershipPercentagePrior']??'0.0',
                                              //         'addPartnershipReturnsPrior':income['addPartnershipReturnsPrior']??'true',
                                              //         'addPartnershipReturnsRecent':income['addPartnershipReturnsRecent']??'true',
                                              //         'numberOfMonths':income['numberOfMonths']??'12.0',
                                              //         'baseYear':income['baseYear'],
                                              //         'w2Year':income['w2Year'],
                                              //         'priorW2Year':income['priorW2Year'],
                                              //         'businessStartDateStamp':income['businessStartDateStamp'],
                                              //         'greaterOrLessThen2Years':income['greaterOrLessThen2Years'],
                                              //         'index':index.toString(),
                                              //       });
                                              // }
                                              // else if(income['employerIncomeType'] == 'Form 1120S & K1'){
                                              //   Get.toNamed(RouteName.edit1040K11120SScreen,
                                              //       arguments: {
                                              //         'nameOfPartnerShip':income['nameOfPartnerShip']??'',
                                              //         'sElectionEffectiveDate':income['sElectionEffectiveDate']??'',
                                              //         'companyName':income['companyName'],
                                              //         'startDate':income['startDate'],
                                              //         'currentlyActive':income['currentlyActive'],
                                              //         'w2IncomeFromSelfEmploymentRecent':income['w2IncomeFromSelfEmploymentRecent']??'0.0',
                                              //         'w2IncomeFromSelfEmploymentPrior':income['w2IncomeFromSelfEmploymentPrior']??'0.0',
                                              //         'ordinaryIncomeLossRecent':income['grossAnnualIncome']??'0.0',
                                              //         'ordinaryIncomeLossPrior':income['ordinaryIncomeLossPrior']??'0.0',
                                              //         'nonRecurringOtherIncomeLossRecent':income['nonRecurringOtherIncomeLossRecent']??'0.0',
                                              //         'depreciationRecent':income['depreciationRecent']??'0.0',
                                              //         'depletionRecent':income['depletionRecent']??'0.0',
                                              //         'amortizationCasualtyLossOneTimeExpenseRecent':income['amortizationCasualtyLossOneTimeExpenseRecent']??'0.0',
                                              //         'mortgagePayableInLessThanOneYearRecent':income['mortgagePayableInLessThanOneYearRecent']??'0.0',
                                              //         'mealsAndEntertainmentRecent':income['mealsAndEntertainmentRecent']??'0.0',
                                              //         'ownershipPercentageRecent':income['ownershipPercentageRecent']??'0.0',
                                              //         'nonRecurringOtherIncomeLossPrior':income['nonRecurringOtherIncomeLossPrior']??'0.0',
                                              //         'depreciationPrior':income['depreciationPrior']??'0.0',
                                              //         'depletionPrior':income['depletionPrior']??'0.0',
                                              //         'amortizationCasualtyLossOneTimeExpensePrior':income['amortizationCasualtyLossOneTimeExpensePrior']??'0.0',
                                              //         'mortgagePayableInLessThanOneYearPrior':income['mortgagePayableInLessThanOneYearPrior']??'0.0',
                                              //         'mealsAndEntertainmentPrior':income['mealsAndEntertainmentPrior']??'0.0',
                                              //         'ownershipPercentagePrior':income['ownershipPercentagePrior']??'0.0',
                                              //         'addPartnershipReturnsPrior':income['addPartnershipReturnsPrior']??'true',
                                              //         'addPartnershipReturnsRecent':income['addPartnershipReturnsRecent']??'true',
                                              //         'numberOfMonths':income['numberOfMonths']??'12.0',
                                              //         'baseYear':income['baseYear'],
                                              //         'w2Year':income['w2Year'],
                                              //         'priorW2Year':income['priorW2Year'],
                                              //         'businessStartDateStamp':income['businessStartDateStamp'],
                                              //         'greaterOrLessThen2Years':income['greaterOrLessThen2Years'],
                                              //         'index':index.toString(),
                                              //       });
                                              // }
                                              // else if(income['employerIncomeType'] == 'Form 1120'){
                                              //   Get.toNamed(RouteName.edit10401120Screen,
                                              //       arguments: {
                                              //         'name':income['name'] ?? '',
                                              //         'companyName':income['companyName'],
                                              //         'startDate':income['startDate'],
                                              //         'currentlyActive':income['currentlyActive'],
                                              //         'w2IncomeFromSelfEmploymentRecent':income['w2IncomeFromSelfEmploymentRecent'] ?? '0.0',
                                              //         'w2IncomeFromSelfEmploymentPrior':income['w2IncomeFromSelfEmploymentPrior'] ?? '0.0',
                                              //         'taxableIncomeRecent':income['grossAnnualIncome'] ?? '0.0',
                                              //         'totalTaxRecent':income['totalTaxRecent'] ?? '0.0',
                                              //         'nonRecurringGainLossRecent':income['nonRecurringGainLossRecent'] ?? '0.0',
                                              //         'nonRecurringOtherIncomeLossRecent':income['nonRecurringOtherIncomeLossRecent'] ?? '0.0',
                                              //         'depreciationRecent':income['depreciationRecent'] ?? '0.0',
                                              //         'depletionRecent':income['depletionRecent'] ?? '0.0',
                                              //         'amortizationCasualtyLossOneTimeExpenseRecent':income['amortizationCasualtyLossOneTimeExpenseRecent'] ?? '0.0',
                                              //         'netOperatingLossAndSpecialDeductionsRecent':income['netOperatingLossAndSpecialDeductionsRecent'] ?? '0.0',
                                              //         'mortgagePayableInLessThanOneYearRecent':income['mortgagePayableInLessThanOneYearRecent'] ?? '0.0',
                                              //         'mealsAndEntertainmentRecent':income['mealsAndEntertainmentRecent'] ?? '0.0',
                                              //         'ownershipPercentageRecent':income['ownershipPercentageRecent'] ?? '0.0',
                                              //         'dividendsPaidToBorrowerRecent':income['dividendsPaidToBorrowerRecent'] ?? '0.0',
                                              //         'taxableIncomePrior':income['taxableIncomePrior'] ?? '0.0',
                                              //         'totalTaxPrior':income['totalTaxPrior'] ?? '0.0',
                                              //         'nonRecurringGainLossPrior':income['nonRecurringGainLossPrior'] ?? '0.0',
                                              //         'nonRecurringOtherIncomeLossPrior':income['nonRecurringOtherIncomeLossPrior'] ?? '0.0',
                                              //         'depreciationPrior':income['depreciationPrior'] ?? '0.0',
                                              //         'depletionPrior':income['depletionPrior'] ?? '0.0',
                                              //         'amortizationCasualtyLossOneTimeExpensePrior':income['amortizationCasualtyLossOneTimeExpensePrior'] ?? '0.0',
                                              //         'netOperatingLossAndSpecialDeductionsPrior':income['netOperatingLossAndSpecialDeductionsPrior'] ?? '0.0',
                                              //         'mortgagePayableInLessThanOneYearPrior':income['mortgagePayableInLessThanOneYearPrior'] ?? '0.0',
                                              //         'mealsAndEntertainmentPrior':income['mealsAndEntertainmentPrior'] ?? '0.0',
                                              //         'ownershipPercentagePrior':income['ownershipPercentagePrior'] ?? '0.0',
                                              //         'dividendsPaidToBorrowerPrior':income['dividendsPaidToBorrowerPrior'] ?? '0.0',
                                              //         'addPartnershipReturnsPrior':income['addPartnershipReturnsPrior'] ?? 'true',
                                              //         'addPartnershipReturnsRecent':income['addPartnershipReturnsRecent'] ?? 'true',
                                              //         'numberOfMonths':income['numberOfMonths'] ?? '12.0',
                                              //         'baseYear':income['baseYear'],
                                              //         'w2Year':income['w2Year'],
                                              //         'priorW2Year':income['priorW2Year'],
                                              //         'businessStartDateStamp':income['businessStartDateStamp'],
                                              //         'greaterOrLessThen2Years':income['greaterOrLessThen2Years'],
                                              //         'index':index.toString(),
                                              //       });
                                              // }

                                            },
                                            child: Container(
                                              height: Get.height * .04,
                                              decoration: BoxDecoration(
                                                  color: AppColors.primaryColor,
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              child: const Center(child: Text('Calculator',style: TextStyle(color: AppColors.textColorWhite),)),
                                            ),
                                          ),
                                        )],
                                    ).paddingOnly(top: Get.height * .01):const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text('This is income is added by using calculator.',
                                        style: TextStyle(fontSize: 12),),
                                    )
                                  ],
                                ).paddingAll(8)
                            ).marginOnly(top: 8):Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: AppColors.liabilityItemsBackgroundColor.withOpacity(.4)
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: 24,
                                              height: 24,
                                              decoration: const BoxDecoration(
                                                  color: AppColors.whiteColor,
                                                  shape: BoxShape.circle
                                              ),
                                              child: Center(
                                                child: TextWidget(
                                                    text: itemNumber.toString(),
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    fontColor: AppColors.secondaryColor,
                                                    textAlign: TextAlign.center),
                                              ),
                                            ),

                                          ],
                                        ),

                                        Row(
                                          children: [
                                            Container(
                                                decoration:  BoxDecoration(
                                                    color: AppColors.whiteColor,
                                                    borderRadius: BorderRadius.circular(1000)
                                                ),
                                                child: Text(income['verifyStatus'],style: TextStyle(fontWeight: FontWeight.bold,
                                                    color: income['verifyStatus'] == 'Verified'?AppColors.greenColor:AppColors.secondaryColor
                                                ),).paddingSymmetric(horizontal: 4)),
                                            SizedBox(width: Get.width * .04,),
                                            InkWell(
                                              onTap: (){

                                              },
                                              child: Container(
                                                  width: Get.width * .16,
                                                  height: 24,
                                                  decoration: BoxDecoration(
                                                      color: AppColors.secondaryColor,
                                                      borderRadius: BorderRadius.circular(1000)
                                                  ),
                                                  child: Center(
                                                    child: const Text('View Detail',
                                                      style: TextStyle(
                                                          fontSize: 8,
                                                          color: AppColors.textColorWhite,
                                                          fontWeight: FontWeight.bold
                                                      ),).marginSymmetric(horizontal: Get.width * .02),
                                                  )
                                              ),
                                            ),
                                          ],
                                        )

                                      ],
                                    ),
                                    Row(
                                      children: [
                                        TextWidget(
                                            text: income['companyName'],
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            fontColor: AppColors.primaryColor,
                                            textAlign: TextAlign.center),
                                      ],
                                    ).paddingOnly(top: Get.height * .02),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            income['addedType'] == 'calculator'?
                                            Row(
                                              children: [
                                                TextWidget(
                                                    text: '\$${UtilMethods().formatNumberWithCommas(grossAnnualIncome)}',
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    fontColor: AppColors.textColorApp,
                                                    textAlign: TextAlign.center
                                                ),
                                                // TextWidget(
                                                //     text: '/ ${income['salaryCycle']}',
                                                //     fontSize: 10,
                                                //     fontWeight: FontWeight.bold,
                                                //     fontColor: AppColors.textColorApp,
                                                //     textAlign: TextAlign.center
                                                // ),
                                              ],
                                            ):Row(
                                              children: [
                                                TextWidget(
                                                    text: '\$${UtilMethods().formatNumberWithCommas(grossAnnualIncome)}',
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    fontColor: AppColors.textColorApp,
                                                    textAlign: TextAlign.center
                                                ),
                                                const TextWidget(
                                                    text: '/ Monthly',
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    fontColor: AppColors.textColorApp,
                                                    textAlign: TextAlign.center
                                                ),
                                              ],
                                            ),
                                            TextWidget(
                                                text: 'Gross Annual Income',
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                fontColor: AppColors.primarySecondaryColor.withOpacity(.7),
                                                textAlign: TextAlign.center
                                            )
                                          ],
                                        ),

                                        Container(width: Get.width * .001,height: Get.height * .04,color: AppColors.primaryColor,),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            TextWidget(
                                                text: '\$${UtilMethods().formatNumberWithCommas(monthlyIncome)}',
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                fontColor: AppColors.textColorApp,
                                                textAlign: TextAlign.center
                                            ),
                                            TextWidget(
                                                text: 'Monthly Income',
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                fontColor: AppColors.primarySecondaryColor.withOpacity(.7),
                                                textAlign: TextAlign.center
                                            )
                                          ],
                                        ),

                                      ],
                                    ).paddingOnly(top: Get.height * .008,bottom: Get.height * .01),
                                    income['verifyStatus'] == 'Verified'?const Align(alignment:
                                    Alignment.centerLeft,child: Text('This income is verified by zapa mortgage using income docs. This income is Included.')):
                                    const Align(alignment:
                                    Alignment.centerLeft,child: Text('This income is verified by zapa mortgage using income docs. However this income is Excluded.'))
                                  ],
                                ).paddingAll(8)
                            ).marginOnly(top: 8);
                          },
                        ).marginAll(16);
                      },
                    ),
                  ),

              )

            ],
          ),
        );
        }
    );
  }

}