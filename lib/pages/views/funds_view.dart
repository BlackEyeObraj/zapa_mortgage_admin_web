import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:zapa_mortgage_admin_web/controllers/funds_view_controller.dart';

import '../../res/app_colors.dart';
import '../../services/firestore_service.dart';
import '../../utils/dialogs/add_fund_dialog.dart';
import '../../utils/utils_mehtods.dart';
import '../../utils/widgets/text_widget.dart';

class FundsView extends GetView<FundsViewController>{
  final String borrowerId;
  FundsView({required this.borrowerId});
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: FundsViewController(),
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
                          'Funds & Assets',
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
                            FundDialog().addFundDialog(borrowerId);

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
                                  text: 'Total Funds',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  fontColor: AppColors.textColorWhite,
                                  textAlign: TextAlign.start),
                              StreamBuilder<double>(
                                stream: FirestoreService().calculateTotalIncludedFundsListener(borrowerId),
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
                              )
                            ],
                          ),
                        ),
                        Container(height: Get.height * .06,width: 1,color: AppColors.whiteColor.withOpacity(.4),),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const TextWidget(
                                  text: 'Verified Funds',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  fontColor: AppColors.textColorWhite,
                                  textAlign: TextAlign.start),
                              StreamBuilder<double>(
                                stream: FirestoreService().calculateTotalVerifiedFundsListener(borrowerId),
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
                              )

                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: Get.width * 1,
                      height: Get.height * .0004,
                      color: AppColors.whiteColor,
                    ).paddingOnly(top: 8),
                    StreamBuilder<double>(
                      stream: FirestoreService().calculateTotalTotalGiftFundsListener(borrowerId),
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
                        return Align(
                          alignment: Alignment.center,
                          child: RichText(
                            text: TextSpan(
                              text: 'Gift Funds of ',
                              style: const TextStyle(color: AppColors.textColorWhite,fontSize: 12),
                              children: <TextSpan>[
                                TextSpan(text: '\$${UtilMethods().formatNumberWithCommas(totalAmount)}', style: const TextStyle(fontWeight: FontWeight.bold),),
                                const TextSpan(text: ' included in Verified Funds.'),
                              ],
                            ),
                          ).paddingOnly(top: 8),
                        );
                      },
                    ),

                    // Expanded(
                    //     flex: 5,
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: [
                    //         const TextWidget(
                    //             text: 'Total Funds',
                    //             fontSize: 16,
                    //             fontWeight: FontWeight.w900,
                    //             fontColor: AppColors.textColorWhite,
                    //             textAlign: TextAlign.start),
                    //       ],
                    //     )),
                    // Expanded(
                    //     flex: 5,
                    //     child: Row(
                    //       children: [
                    //         Obx(() => TextWidget(
                    //               text: '\$ ${UtilsMethods().formatNumberWithCommas(controller.totalFunds)}',
                    //               fontSize: 16,
                    //               fontWeight: FontWeight.w900,
                    //               fontColor: AppColors.textColorWhite,
                    //               textAlign: TextAlign.start),
                    //         ),
                    //
                    //       ],
                    //     )),
                  ],
                ).paddingAll(12),
              ).paddingOnly(top: 8,left: 16,right: 16),

              Expanded(
                  child: SingleChildScrollView(
                    child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: FirestoreService().getFunds(borrowerId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData ||
                            snapshot.data?.data() == null) {
                          return Center(
                            child: const TextWidget(
                              text: 'No Funds are added yet',
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
                        if (documentData!['funds'] == null) {
                          return Center(
                            child: const TextWidget(
                              text: 'No Funds are added yet',
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

                        List<dynamic> funds = documentData['funds'];
                        // funds.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));
                        return GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // Display two items in each row
                              mainAxisSpacing: 10.0, // Spacing between rows
                              crossAxisSpacing: 10.0, // Spacing between columns
                              childAspectRatio: 3 / .9,
                            ),
                            itemCount: funds.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              // controller.setFundsTotal();
                              var fund = funds[index];
                              double balanceAmount = double.parse(fund['currentBalance']);
                              int itemNumber = index + 1;
                              return fund['addedBy'] == 'customer'? Container(
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
                                              Row(
                                                children: [
                                                  TextWidget(
                                                      text: fund['status'],
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold,
                                                      fontColor: fund['status'] == 'Include'?AppColors.textColorGreen2:AppColors.errorTextColor,
                                                      textAlign: TextAlign.center).paddingOnly(left: 8),
                                                  FlutterSwitch(
                                                    activeText: 'Include',
                                                    inactiveText: 'Exclude',
                                                    activeColor: AppColors.primaryColor,
                                                    inactiveColor: AppColors.blackColor.withOpacity(.1),
                                                    value: fund['status'] == 'Include'?true:false,
                                                    valueFontSize: 8.0,
                                                    width: Get.width * .04,
                                                    height: 20,
                                                    borderRadius: 30.0,
                                                    showOnOff: false,
                                                    toggleSize: 14,
                                                    onToggle: (val) {
                                                      if(fund['status'] == 'Include'){
                                                        FirestoreService().updateFundStatus(borrowerId,index, 'Exclude');
                                                      }else{
                                                        FirestoreService().updateFundStatus(borrowerId,index, 'Include');
                                                      }
                                                    },
                                                  ).paddingOnly(left: 8),

                                                ],
                                              )
                                            ],
                                          ),

                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  InkWell(
                                                    onTap: (){
                                                      // LiabilityDialog().editLiabilityDialog(
                                                      //     index,
                                                      //     liability['name'],
                                                      //     monthlyAmount.toStringAsFixed(2),
                                                      //     liability['type'],
                                                      //     balanceAmount.toStringAsFixed(2),
                                                      //     liability['monthRemaining'],
                                                      //     liability['status'],
                                                      //     controller
                                                      //
                                                      // );
                                                    },
                                                    child: Container(
                                                        width: Get.width * .04,
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
                                                    ).marginOnly(right: 16),
                                                  ),
                                                  InkWell(
                                                    onTap: ()async{
                                                      // LiabilityDialog().removeLiabilityDialog(index);
                                                    },
                                                    child: Container(
                                                        width: Get.width * .04,
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

                                        ],
                                      ),
                                      fund['assetType'] == 'Gift Funds - from Donor'? Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Checkbox(
                                              value: fund['userVerifiedFund'],
                                              activeColor: AppColors.primaryColor,
                                              onChanged: (value){
                                                if(fund['userVerifiedFund'] == true){
                                                  FirestoreService().updateUserVerifyFundValue(borrowerId,index,false);
                                                }else{
                                                  FirestoreService().updateUserVerifyFundValue(borrowerId,index,true);
                                                }
                                              }
                                          ),
                                          Flexible(
                                            child: Text('I verify I shall receive these Gift Funds.',style: TextStyle(fontSize: 10,
                                                color: fund['userVerifiedFund'] == true?AppColors.textColorGreen2:AppColors.redColor,
                                                fontWeight: FontWeight.bold),),
                                          )
                                        ],
                                      ):const SizedBox(),
                                      // fund['userVerifiedFund'] == false? const Text('*This fund is under verification process. So it will be considered Excluded until its verified.',
                                      //   style: TextStyle(color: AppColors.redColor),).paddingOnly(top: 8):const SizedBox(),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextWidget(
                                              text: fund['assetType'],
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontColor: AppColors.textColorBlack,
                                              textAlign: TextAlign.center),
                                          TextWidget(
                                              text: '\$${UtilMethods().formatNumberWithCommas(balanceAmount)}',
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontColor: AppColors.textColorApp,
                                              textAlign: TextAlign.center),
                                        ],
                                      ).paddingOnly(top: 8),
                                      Container(
                                        width: Get.width * 1,
                                        height: Get.height * .002,
                                        decoration: BoxDecoration(
                                            color: AppColors.blackColor.withOpacity(.2)
                                        ),
                                      ).paddingOnly(top: 8),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const TextWidget(
                                              text: 'Bank / Source :',
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontColor: AppColors.textColorBlack,
                                              textAlign: TextAlign.center),
                                          TextWidget(
                                              text: fund['bankName'],
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontColor: AppColors.textColorApp,
                                              textAlign: TextAlign.center),
                                        ],
                                      ).paddingOnly(top: 12),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const TextWidget(
                                              text: 'Account Number :',
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontColor: AppColors.textColorBlack,
                                              textAlign: TextAlign.center),
                                          TextWidget(
                                              text: fund['accountNumber'] != ''?fund['accountNumber']: 'N/A',
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontColor: AppColors.textColorApp,
                                              textAlign: TextAlign.center),
                                        ],
                                      ).paddingOnly(top: 6),

                                    ],
                                  ).paddingAll(8)
                              ).paddingSymmetric(vertical: 4):
                              Container(
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
                                                  child: Text(fund['verifyStatus'],style: TextStyle(fontWeight: FontWeight.bold,
                                                      color: fund['verifyStatus'] == 'Verified'?AppColors.greenColor:AppColors.secondaryColor
                                                  ),).paddingSymmetric(horizontal: 4)).marginOnly(right: 8),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      InkWell(
                                                        onTap: (){
                                                          // LiabilityDialog().editLiabilityDialog(
                                                          //     index,
                                                          //     liability['name'],
                                                          //     monthlyAmount.toStringAsFixed(2),
                                                          //     liability['type'],
                                                          //     balanceAmount.toStringAsFixed(2),
                                                          //     liability['monthRemaining'],
                                                          //     liability['status'],
                                                          //     controller
                                                          //
                                                          // );
                                                        },
                                                        child: Container(
                                                            width: Get.width * .04,
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
                                                        ).marginOnly(right: 16),
                                                      ),
                                                      InkWell(
                                                        onTap: ()async{
                                                          // LiabilityDialog().removeLiabilityDialog(index);
                                                        },
                                                        child: Container(
                                                            width: Get.width * .04,
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

                                            ],
                                          ),

                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextWidget(
                                              text: fund['assetType'],
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontColor: AppColors.textColorBlack,
                                              textAlign: TextAlign.center),
                                          TextWidget(
                                              text: '\$${UtilMethods().formatNumberWithCommas(balanceAmount)}',
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontColor: AppColors.textColorApp,
                                              textAlign: TextAlign.center),
                                        ],
                                      ).paddingOnly(top: 12),
                                      Container(
                                        width: Get.width * 1,
                                        height: Get.height * .002,
                                        decoration: BoxDecoration(
                                            color: AppColors.blackColor.withOpacity(.2)
                                        ),
                                      ).paddingOnly(top: 8),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const TextWidget(
                                              text: 'Bank / Source :',
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontColor: AppColors.textColorBlack,
                                              textAlign: TextAlign.center),
                                          TextWidget(
                                              text: fund['bankName'],
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontColor: AppColors.textColorApp,
                                              textAlign: TextAlign.center),
                                        ],
                                      ).paddingOnly(top: 12),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const TextWidget(
                                              text: 'Account Number :',
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontColor: AppColors.textColorBlack,
                                              textAlign: TextAlign.center),
                                          TextWidget(
                                              text: fund['accountNumber'] != ''?fund['accountNumber']: 'N/A',
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontColor: AppColors.textColorApp,
                                              textAlign: TextAlign.center),
                                        ],
                                      ).paddingOnly(top: 6),
                                      Row(
                                        mainAxisAlignment:MainAxisAlignment.end,
                                        children: [
                                          Text('Added By: ',style: TextStyle(fontSize: 12),),
                                          Text(fund['addedByName'],style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold)),
                                        ],
                                      ).marginOnly(top: 8)
                                    ],
                                  ).paddingAll(8)
                              ).paddingSymmetric(vertical: 4);
                            },
                          ).marginAll(16);
                          // ListView.separated(
                          // separatorBuilder: (context, index) => const SizedBox(height: 8),
                          // itemCount: funds.length,
                          // shrinkWrap: true,
                          // physics: const NeverScrollableScrollPhysics(),
                          // itemBuilder: (context, index) {
                          //   // controller.setFundsTotal();
                          //   var fund = funds[index];
                          //   double balanceAmount = double.parse(fund['currentBalance']);
                          //   int itemNumber = index + 1;
                          //   return fund['addedBy'] == 'customer'? Container(
                          //       decoration: BoxDecoration(
                          //           borderRadius: BorderRadius.circular(10),
                          //           color: AppColors.liabilityItemsBackgroundColor.withOpacity(.4)
                          //       ),
                          //       child: Column(
                          //         crossAxisAlignment: CrossAxisAlignment.end,
                          //         children: [
                          //           Row(
                          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //             children: [
                          //               Row(
                          //                 children: [
                          //                   Container(
                          //                     width: 24,
                          //                     height: 24,
                          //                     decoration: const BoxDecoration(
                          //                         color: AppColors.whiteColor,
                          //                         shape: BoxShape.circle
                          //                     ),
                          //                     child: Center(
                          //                       child: TextWidget(
                          //                           text: itemNumber.toString(),
                          //                           fontSize: 10,
                          //                           fontWeight: FontWeight.bold,
                          //                           fontColor: AppColors.secondaryColor,
                          //                           textAlign: TextAlign.center),
                          //                     ),
                          //                   ),
                          //                   Row(
                          //                     children: [
                          //                       TextWidget(
                          //                           text: fund['status'],
                          //                           fontSize: 12,
                          //                           fontWeight: FontWeight.bold,
                          //                           fontColor: fund['status'] == 'Include'?AppColors.textColorGreen2:AppColors.errorTextColor,
                          //                           textAlign: TextAlign.center).paddingOnly(left: Get.width * .04),
                          //                       // FlutterSwitch(
                          //                       //   activeText: 'Include',
                          //                       //   inactiveText: 'Exclude',
                          //                       //   activeColor: AppColors.primaryColor,
                          //                       //   inactiveColor: AppColors.blackColor.withOpacity(.1),
                          //                       //   value: fund['status'] == 'Include'?true:false,
                          //                       //   valueFontSize: 8.0,
                          //                       //   width: Get.width * .12,
                          //                       //   height: 20,
                          //                       //   borderRadius: 30.0,
                          //                       //   showOnOff: false,
                          //                       //   toggleSize: 14,
                          //                       //   onToggle: (val) {
                          //                       //     if(fund['status'] == 'Include'){
                          //                       //       FirestoreService().updateFundStatus(index, 'Exclude');
                          //                       //     }else{
                          //                       //       FirestoreService().updateFundStatus(index, 'Include');
                          //                       //     }
                          //                       //   },
                          //                       // ).paddingOnly(left: Get.width * .04),
                          //
                          //                     ],
                          //                   )
                          //                 ],
                          //               ),
                          //
                          //               Row(
                          //                 children: [
                          //                   InkWell(
                          //                     onTap: (){
                          //                       // FundDialog().editFundDialog(index,
                          //                       //     fund['assetType'],
                          //                       //     fund['accountNumber'],
                          //                       //     fund['currentBalance'],
                          //                       //     fund['bankName'],
                          //                       //     fund['userVerifiedFund'],
                          //                       //     controller,
                          //                       //     fund['status']);
                          //                     },
                          //                     child: Container(
                          //                         width: Get.width * .14,
                          //                         height: 24,
                          //                         decoration: BoxDecoration(
                          //                             color: AppColors.secondaryColor,
                          //                             borderRadius: BorderRadius.circular(1000)
                          //                         ),
                          //                         child: const Row(
                          //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //                           children: [
                          //                             Icon(Icons.edit,size: 14,color: AppColors.whiteColor,),
                          //                             Text('Edit',
                          //                               style: TextStyle(
                          //                                   fontSize: 8,
                          //                                   color: AppColors.textColorWhite,
                          //                                   fontWeight: FontWeight.bold
                          //                               ),)
                          //                             // TextWidget(
                          //                             //     text: 'Trash',
                          //                             //     fontSize: 4,
                          //                             //     fontWeight: FontWeight.bold,
                          //                             //     fontColor: AppColors.textColorWhite,
                          //                             //     textAlign: TextAlign.center)
                          //                           ],
                          //                         ).marginSymmetric(horizontal: 8)
                          //                     ),
                          //                   ),
                          //                   // SizedBox(width: Get.width * .04,),
                          //                   // InkWell(
                          //                   //   onTap: ()async{
                          //                   //     FundDialog().removeFundDialog(index);
                          //                   //   },
                          //                   //   child: Container(
                          //                   //       width: Get.width * .14,
                          //                   //       height: 24,
                          //                   //       decoration: BoxDecoration(
                          //                   //           color: AppColors.deleteButtonBg,
                          //                   //           borderRadius: BorderRadius.circular(1000)
                          //                   //       ),
                          //                   //       child: const Row(
                          //                   //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //                   //         children: [
                          //                   //           Icon(Icons.delete,size: 14,color: AppColors.whiteColor,),
                          //                   //           Text('Trash',
                          //                   //             style: TextStyle(
                          //                   //                 fontSize: 8,
                          //                   //                 color: AppColors.textColorWhite,
                          //                   //                 fontWeight: FontWeight.bold
                          //                   //             ),)
                          //                   //         ],
                          //                   //       ).marginSymmetric(horizontal: 6)
                          //                   //   ),
                          //                   // ),
                          //                 ],
                          //               )
                          //             ],
                          //           ),
                          //           fund['assetType'] == 'Gift Funds - from Donor'? Row(
                          //             crossAxisAlignment: CrossAxisAlignment.center,
                          //             children: [
                          //               Checkbox(
                          //                   value: fund['userVerifiedFund'],
                          //                   activeColor: AppColors.primaryColor,
                          //                   onChanged: (value){
                          //                     if(fund['userVerifiedFund'] == true){
                          //                       FirestoreService().updateUserVerifyFundValue(borrowerId,index,false);
                          //                     }else{
                          //                       FirestoreService().updateUserVerifyFundValue(borrowerId,index,true);
                          //                     }
                          //                   }
                          //               ),
                          //               Flexible(
                          //                 child: Text('I verify I shall receive these Gift Funds.',style: TextStyle(fontSize: 10,
                          //                     color: fund['userVerifiedFund'] == true?AppColors.textColorGreen2:AppColors.redColor,
                          //                     fontWeight: FontWeight.bold),),
                          //               )
                          //             ],
                          //           ):const SizedBox(),
                          //           // fund['userVerifiedFund'] == false? const Text('*This fund is under verification process. So it will be considered Excluded until its verified.',
                          //           //   style: TextStyle(color: AppColors.redColor),).paddingOnly(top: 8):const SizedBox(),
                          //           Row(
                          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //             children: [
                          //               TextWidget(
                          //                   text: fund['assetType'],
                          //                   fontSize: 14,
                          //                   fontWeight: FontWeight.bold,
                          //                   fontColor: AppColors.textColorBlack,
                          //                   textAlign: TextAlign.center),
                          //               TextWidget(
                          //                   text: '\$${UtilMethods().formatNumberWithCommas(balanceAmount)}',
                          //                   fontSize: 14,
                          //                   fontWeight: FontWeight.bold,
                          //                   fontColor: AppColors.textColorApp,
                          //                   textAlign: TextAlign.center),
                          //             ],
                          //           ).paddingOnly(top: 4),
                          //           Container(
                          //             width: Get.width * 1,
                          //             height: Get.height * .002,
                          //             decoration: BoxDecoration(
                          //                 color: AppColors.blackColor.withOpacity(.2)
                          //             ),
                          //           ).paddingOnly(top: 8),
                          //           Row(
                          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //             children: [
                          //               const TextWidget(
                          //                   text: 'Bank / Source :',
                          //                   fontSize: 14,
                          //                   fontWeight: FontWeight.bold,
                          //                   fontColor: AppColors.textColorBlack,
                          //                   textAlign: TextAlign.center),
                          //               TextWidget(
                          //                   text: fund['bankName'],
                          //                   fontSize: 14,
                          //                   fontWeight: FontWeight.bold,
                          //                   fontColor: AppColors.textColorApp,
                          //                   textAlign: TextAlign.center),
                          //             ],
                          //           ).paddingOnly(top: 12),
                          //           Row(
                          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //             children: [
                          //               const TextWidget(
                          //                   text: 'Account Number :',
                          //                   fontSize: 14,
                          //                   fontWeight: FontWeight.bold,
                          //                   fontColor: AppColors.textColorBlack,
                          //                   textAlign: TextAlign.center),
                          //               TextWidget(
                          //                   text: fund['accountNumber'] != ''?fund['accountNumber']: 'N/A',
                          //                   fontSize: 14,
                          //                   fontWeight: FontWeight.bold,
                          //                   fontColor: AppColors.textColorApp,
                          //                   textAlign: TextAlign.center),
                          //             ],
                          //           ).paddingOnly(top: 6),
                          //
                          //         ],
                          //       ).paddingAll(8)
                          //   ).paddingSymmetric(vertical: 4):
                          //   Container(
                          //       decoration: BoxDecoration(
                          //           borderRadius: BorderRadius.circular(10),
                          //           color: AppColors.liabilityItemsBackgroundColor.withOpacity(.4)
                          //       ),
                          //       child: Column(
                          //         crossAxisAlignment: CrossAxisAlignment.end,
                          //         children: [
                          //           Row(
                          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //             children: [
                          //               Row(
                          //                 children: [
                          //                   Container(
                          //                     width: 24,
                          //                     height: 24,
                          //                     decoration: const BoxDecoration(
                          //                         color: AppColors.whiteColor,
                          //                         shape: BoxShape.circle
                          //                     ),
                          //                     child: Center(
                          //                       child: TextWidget(
                          //                           text: itemNumber.toString(),
                          //                           fontSize: 10,
                          //                           fontWeight: FontWeight.bold,
                          //                           fontColor: AppColors.secondaryColor,
                          //                           textAlign: TextAlign.center),
                          //                     ),
                          //                   ),
                          //
                          //                 ],
                          //               ),
                          //               Row(
                          //                 children: [
                          //                   Container(
                          //                       decoration:  BoxDecoration(
                          //                           color: AppColors.whiteColor,
                          //                           borderRadius: BorderRadius.circular(1000)
                          //                       ),
                          //                       child: Text(fund['verifyStatus'],style: TextStyle(fontWeight: FontWeight.bold,
                          //                           color: fund['verifyStatus'] == 'Verified'?AppColors.greenColor:AppColors.secondaryColor
                          //                       ),).paddingSymmetric(horizontal: 4)),
                          //
                          //                 ],
                          //               )
                          //             ],
                          //           ),
                          //           Row(
                          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //             children: [
                          //               TextWidget(
                          //                   text: fund['assetType'],
                          //                   fontSize: 14,
                          //                   fontWeight: FontWeight.bold,
                          //                   fontColor: AppColors.textColorBlack,
                          //                   textAlign: TextAlign.center),
                          //               TextWidget(
                          //                   text: '\$${UtilMethods().formatNumberWithCommas(balanceAmount)}',
                          //                   fontSize: 14,
                          //                   fontWeight: FontWeight.bold,
                          //                   fontColor: AppColors.textColorApp,
                          //                   textAlign: TextAlign.center),
                          //             ],
                          //           ).paddingOnly(top: 12),
                          //           Container(
                          //             width: Get.width * 1,
                          //             height: Get.height * .002,
                          //             decoration: BoxDecoration(
                          //                 color: AppColors.blackColor.withOpacity(.2)
                          //             ),
                          //           ).paddingOnly(top: 8),
                          //           Row(
                          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //             children: [
                          //               const TextWidget(
                          //                   text: 'Bank / Source :',
                          //                   fontSize: 14,
                          //                   fontWeight: FontWeight.bold,
                          //                   fontColor: AppColors.textColorBlack,
                          //                   textAlign: TextAlign.center),
                          //               TextWidget(
                          //                   text: fund['bankName'],
                          //                   fontSize: 14,
                          //                   fontWeight: FontWeight.bold,
                          //                   fontColor: AppColors.textColorApp,
                          //                   textAlign: TextAlign.center),
                          //             ],
                          //           ).paddingOnly(top: 12),
                          //           Row(
                          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //             children: [
                          //               const TextWidget(
                          //                   text: 'Account Number :',
                          //                   fontSize: 14,
                          //                   fontWeight: FontWeight.bold,
                          //                   fontColor: AppColors.textColorBlack,
                          //                   textAlign: TextAlign.center),
                          //               TextWidget(
                          //                   text: fund['accountNumber'] != ''?fund['accountNumber']: 'N/A',
                          //                   fontSize: 14,
                          //                   fontWeight: FontWeight.bold,
                          //                   fontColor: AppColors.textColorApp,
                          //                   textAlign: TextAlign.center),
                          //             ],
                          //           ).paddingOnly(top: 6),
                          //         ],
                          //       ).paddingAll(8)
                          //   ).paddingSymmetric(vertical: 4);
                          // },
                        // );
                      },
                    )
                  )
              )
            ],
          ),

        );
        }
    );
  }

}