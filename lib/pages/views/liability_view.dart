import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:zapa_mortgage_admin_web/controllers/liability_view_controller.dart';

import '../../res/app_colors.dart';
import '../../services/firestore_service.dart';
import '../../utils/dialogs/add_liabilities_dialog.dart';
import '../../utils/utils_mehtods.dart';
import '../../utils/widgets/text_widget.dart';

class LiabilityView extends GetView<LiabilityViewController>{
  final String borrowerId;
  LiabilityView({required this.borrowerId});
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: LiabilityViewController(),
        builder: (controller){
          controller.setLiabilityValue(borrowerId);
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
                        'Liability',
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
                          LiabilityDialog().addLiabilityDialog(borrowerId);
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
                                  text: 'Liability',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  fontColor: AppColors.textColorWhite,
                                  textAlign: TextAlign.start),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  StreamBuilder<double>(
                                    stream: FirestoreService().calculateTotalIncludedLiabilityListener(borrowerId),
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
                                  Text(' /per month',style: TextStyle(
                                      color: AppColors.textColorWhite,
                                      fontSize: 8
                                  ),)
                                  // const TextWidget(
                                  //     text: ' /per month',
                                  //     fontSize: 2,
                                  //     fontWeight: FontWeight.normal,
                                  //     fontColor: AppColors.textColorWhite,
                                  //     textAlign: TextAlign.start),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: Get.width * .0001,
                          height: Get.height * .04,
                          color: AppColors.whiteColor,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const TextWidget(
                                  text: 'Verified Liability',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  fontColor: AppColors.textColorWhite,
                                  textAlign: TextAlign.start),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  StreamBuilder<double>(
                                    stream: FirestoreService().calculateTotalVerifiedLiabilityListener(borrowerId),
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

                                  Text(' /per month',style: TextStyle(
                                      color: AppColors.textColorWhite,
                                      fontSize: 8
                                  ),)
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Container(
                              height: Get.height * .0002,
                              color: AppColors.whiteColor,
                            ).paddingOnly(right: Get.width * .04)
                        ),
                        Expanded(child: Container(
                          height: Get.height * .0002,
                          color: AppColors.whiteColor,
                        ).paddingOnly(left: Get.width * .04)),
                      ],
                    ).paddingSymmetric(vertical: Get.height * .01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const TextWidget(
                                  text: 'Balance',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  fontColor: AppColors.textColorWhite,
                                  textAlign: TextAlign.start),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  StreamBuilder<double>(
                                    stream: FirestoreService().calculateTotalBalanceLiabilityListener(borrowerId),
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

                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: Get.width * .0001,
                          height: Get.height * .04,
                          color: AppColors.whiteColor,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const TextWidget(
                                  text: 'Verified Balance',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  fontColor: AppColors.textColorWhite,
                                  textAlign: TextAlign.start),
                              StreamBuilder<double>(
                                stream: FirestoreService().calculateTotalVerifiedBalanceListener(borrowerId),
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
                    Obx(() =>  RichText(
                      text: TextSpan(
                        text: 'Total monthly liability ',
                        style: const TextStyle(color: AppColors.textColorWhite,fontSize: 12),
                        children: <TextSpan>[
                          TextSpan(text: '\$${UtilMethods().formatNumberWithCommas(controller.totalVerifiedButExcludedMonthlyLiability)}', style: const TextStyle(fontWeight: FontWeight.bold),),
                          const TextSpan(text: ' excluded & Balance payoff of '),
                          TextSpan(text: '\$${UtilMethods().formatNumberWithCommas(controller.totalExcludedPayOffBalance)} ', style: const TextStyle(fontWeight: FontWeight.bold),),
                          const TextSpan(text: 'at Closing.'),
                        ],
                      ),
                    ).paddingOnly(top: 8))
                  ],
                ).paddingAll(12),
              ).paddingOnly(top: 8,left: 16,right: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: FirestoreService().getLiabilities(borrowerId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData ||
                          snapshot.data?.data() == null) {
                        return Center(
                          child: const TextWidget(
                            text: 'No Liability is added yet',
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
                      if (documentData!['liability'] == null) {
                        return Center(
                          child: const TextWidget(
                            text: 'No Liability is added yet',
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
                      List<dynamic> liabilities = documentData['liability'];
                      return GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // Display two items in each row
                              mainAxisSpacing: 10.0, // Spacing between rows
                              crossAxisSpacing: 10.0, // Spacing between columns
                              childAspectRatio: 4 / 1,
                            ),
                            itemCount: liabilities.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext ctx, index) {
                              var liability = liabilities[index];
                              double monthlyAmount = double.parse(liability['monthlyAmount']);
                              double balanceAmount = double.parse(liability['balanceAmount']);
                              int itemNumber = index + 1;
                              return liability['addedBy'] == 'customer'? Container(
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
                                              TextWidget(
                                                  text: liability['status'],
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  fontColor: liability['status'] == 'Include'?AppColors.textColorGreen2:AppColors.errorTextColor,
                                                  textAlign: TextAlign.center).marginOnly(left: 16),
                                              FlutterSwitch(
                                                activeText: 'Include',
                                                inactiveText: 'Exclude',
                                                activeColor: AppColors.primaryColor,
                                                inactiveColor: AppColors.blackColor.withOpacity(.1),
                                                value: liability['status'] == 'Include'?true:false,
                                                valueFontSize: 8.0,
                                                width: Get.width * .04,
                                                height: 20,
                                                borderRadius: 30.0,
                                                showOnOff: false,
                                                toggleSize: 14,
                                                onToggle: (val) {
                                                  if(liability['status'] == 'Include'){
                                                    FirestoreService().updateLiabilityStatus(index, 'Exclude',borrowerId);
                                                  }else{
                                                    FirestoreService().updateLiabilityStatus(index, 'Include',borrowerId);
                                                  }
                                                },
                                              ).marginOnly(left: 16),
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
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: TextWidget(
                                                  text: liability['name'],
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  fontColor: AppColors.textColorApp,
                                                  textAlign: TextAlign.center
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: TextWidget(
                                                  text: liability['type'],
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  fontColor: AppColors.textColorApp,
                                                  textAlign: TextAlign.center
                                              ),
                                            ),
                                          ),

                                        ],
                                      ).paddingOnly(top: 12),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Expanded(child: SizedBox(
                                            height: Get.height * .06,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                TextWidget(
                                                    text: '\$${UtilMethods().formatNumberWithCommas(balanceAmount)}',
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    fontColor: AppColors.textColorApp,
                                                    textAlign: TextAlign.center
                                                ),
                                                TextWidget(
                                                    text: 'Balance',
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    fontColor: AppColors.primarySecondaryColor.withOpacity(.7),
                                                    textAlign: TextAlign.center
                                                )
                                              ],
                                            ),
                                          )),
                                          Container(
                                            width: Get.width * .002,
                                            height: Get.height * .04,
                                            decoration: BoxDecoration(
                                                color: AppColors.blackColor.withOpacity(.4)
                                            ),
                                          ),
                                          Expanded(child: SizedBox(
                                            height: Get.height * .06,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                TextWidget(
                                                    text: liability['monthRemaining'] != ''? liability['monthRemaining']:'N/A',
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold,
                                                    fontColor: AppColors.textColorApp,
                                                    textAlign: TextAlign.center
                                                ),
                                                TextWidget(
                                                    text: 'Mo. remaining',
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    fontColor: AppColors.primarySecondaryColor.withOpacity(.7),
                                                    textAlign: TextAlign.center
                                                )
                                              ],
                                            ),
                                          )),
                                          Container(
                                            width: Get.width * .002,
                                            height: Get.height * .04,
                                            decoration: BoxDecoration(
                                                color: AppColors.blackColor.withOpacity(.4)
                                            ),
                                          ),
                                          Expanded(child: SizedBox(
                                            height: Get.height * .06,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                TextWidget(
                                                    text: '\$${UtilMethods().formatNumberWithCommas(monthlyAmount)}',
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    fontColor: AppColors.textColorApp,
                                                    textAlign: TextAlign.center
                                                ),
                                                TextWidget(
                                                    text: 'Per month',
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    fontColor: AppColors.primarySecondaryColor.withOpacity(.7),
                                                    textAlign: TextAlign.center
                                                )
                                              ],
                                            ),
                                          )),

                                        ],
                                      ),
                                    ],
                                  ).paddingAll(8)
                              ).marginOnly(top: 8,):
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
                                                  child: Text(liability['verifyStatus'],style: TextStyle(fontWeight: FontWeight.bold,
                                                      color: liability['verifyStatus'] == 'Verified'?AppColors.greenColor:AppColors.secondaryColor
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
                                          )

                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: TextWidget(
                                                  text: liability['name'],
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  fontColor: AppColors.textColorApp,
                                                  textAlign: TextAlign.center
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: TextWidget(
                                                  text: liability['type'],
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  fontColor: AppColors.textColorApp,
                                                  textAlign: TextAlign.center
                                              ),
                                            ),
                                          ),

                                        ],
                                      ).paddingOnly(top: 12),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Expanded(child: SizedBox(
                                            height: Get.height * .06,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                TextWidget(
                                                    text: '\$${UtilMethods().formatNumberWithCommas(balanceAmount)}',
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    fontColor: AppColors.textColorApp,
                                                    textAlign: TextAlign.center
                                                ),
                                                TextWidget(
                                                    text: 'Balance',
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    fontColor: AppColors.primarySecondaryColor.withOpacity(.7),
                                                    textAlign: TextAlign.center
                                                )
                                              ],
                                            ),
                                          )),
                                          Container(
                                            width: Get.width * .002,
                                            height: Get.height * .04,
                                            decoration: BoxDecoration(
                                                color: AppColors.blackColor.withOpacity(.4)
                                            ),
                                          ),
                                          Expanded(child: SizedBox(
                                            height: Get.height * .06,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                TextWidget(
                                                    text: liability['monthRemaining'] != ''? liability['monthRemaining']:'N/A',
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold,
                                                    fontColor: AppColors.textColorApp,
                                                    textAlign: TextAlign.center
                                                ),
                                                TextWidget(
                                                    text: 'Mo. remaining',
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    fontColor: AppColors.primarySecondaryColor.withOpacity(.7),
                                                    textAlign: TextAlign.center
                                                )
                                              ],
                                            ),
                                          )),
                                          Container(
                                            width: Get.width * .002,
                                            height: Get.height * .04,
                                            decoration: BoxDecoration(
                                                color: AppColors.blackColor.withOpacity(.4)
                                            ),
                                          ),
                                          Expanded(child: SizedBox(
                                            height: Get.height * .06,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                TextWidget(
                                                    text: '\$${UtilMethods().formatNumberWithCommas(monthlyAmount)}',
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    fontColor: AppColors.textColorApp,
                                                    textAlign: TextAlign.center
                                                ),
                                                TextWidget(
                                                    text: 'Per month',
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    fontColor: AppColors.primarySecondaryColor.withOpacity(.7),
                                                    textAlign: TextAlign.center
                                                )
                                              ],
                                            ),
                                          )),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          liability['verifyStatus'] == 'Verified'?Align(alignment: Alignment.centerLeft,child: Text('This liability is verified by ZAPA Mortgage Team. This liability is Included.', style: TextStyle(fontSize: 12),)):
                                          liability['executionReason'] == 'To Be Paid'? Align(alignment: Alignment.centerLeft,child: Text('Excluded (To Be Paid - Payoff \$${UtilMethods().formatNumberWithCommas(double.parse(liability['balanceAmount']))} at Closing)', style: TextStyle(fontSize: 12),)):
                                          liability['executionReason'] == 'Paid by Others'? Align(alignment: Alignment.centerLeft,child: Text('Excluded (Paid by Others)', style: TextStyle(fontSize: 12),)):
                                          liability['executionReason'] == 'Less than 10 Months Remaining'? Align(alignment: Alignment.centerLeft,child: Text('Excluded (Less than 10 Months Remaining)', style: TextStyle(fontSize: 12),)):
                                          liability['executionReason'] == 'Court Ordered / Other'? Align(alignment: Alignment.centerLeft,child: Text('Excluded (Court Ordered / Other)', style: TextStyle(fontSize: 12),)):const Text(''),
                                          Row(
                                            children: [
                                              Text('Added By: ',style: TextStyle(fontSize: 12),),
                                              Text(liability['addedByName'],style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold)),
                                            ],
                                          )
                                        ],
                                      )

                                    ],
                                  ).paddingAll(8)
                              ).marginOnly(top: 8);
                            },
                            ).marginAll(16);
                      
                      //   ListView.separated(
                      //   separatorBuilder: (context, index) => const SizedBox(height: 8),
                      //   itemCount: liabilities.length,
                      //   shrinkWrap: true,
                      //   physics: const NeverScrollableScrollPhysics(),
                      //   itemBuilder: (context, index) {
                      //     var liability = liabilities[index];
                      //     double monthlyAmount = double.parse(liability['monthlyAmount']);
                      //     double balanceAmount = double.parse(liability['balanceAmount']);
                      //     int itemNumber = index + 1;
                      //     return liability['addedBy'] == 'customer'? Container(
                      //         decoration: BoxDecoration(
                      //             borderRadius: BorderRadius.circular(10),
                      //             color: AppColors.liabilityItemsBackgroundColor.withOpacity(.4)
                      //         ),
                      //         child: Column(
                      //           crossAxisAlignment: CrossAxisAlignment.end,
                      //           children: [
                      //             Row(
                      //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //               children: [
                      //                 Row(
                      //                   children: [
                      //                     Container(
                      //                       width: 24,
                      //                       height: 24,
                      //                       decoration: const BoxDecoration(
                      //                           color: AppColors.whiteColor,
                      //                           shape: BoxShape.circle
                      //                       ),
                      //                       child: Center(
                      //                         child: TextWidget(
                      //                             text: itemNumber.toString(),
                      //                             fontSize: 10,
                      //                             fontWeight: FontWeight.bold,
                      //                             fontColor: AppColors.secondaryColor,
                      //                             textAlign: TextAlign.center),
                      //                       ),
                      //                     ),
                      //                     TextWidget(
                      //                         text: liability['status'],
                      //                         fontSize: 12,
                      //                         fontWeight: FontWeight.bold,
                      //                         fontColor: liability['status'] == 'Include'?AppColors.textColorGreen2:AppColors.errorTextColor,
                      //                         textAlign: TextAlign.center).paddingOnly(left: Get.width * .04),
                      //                     FlutterSwitch(
                      //                       activeText: 'Include',
                      //                       inactiveText: 'Exclude',
                      //                       activeColor: AppColors.primaryColor,
                      //                       inactiveColor: AppColors.blackColor.withOpacity(.1),
                      //                       value: liability['status'] == 'Include'?true:false,
                      //                       valueFontSize: 8.0,
                      //                       width: Get.width * .12,
                      //                       height: 20,
                      //                       borderRadius: 30.0,
                      //                       showOnOff: false,
                      //                       toggleSize: 14,
                      //                       onToggle: (val) {
                      //                         if(liability['status'] == 'Include'){
                      //                           FirestoreService().updateLiabilityStatus(index, 'Exclude',borrowerId);
                      //                         }else{
                      //                           FirestoreService().updateLiabilityStatus(index, 'Include',borrowerId);
                      //                         }
                      //                       },
                      //                     ).paddingOnly(left: Get.width * .04),
                      //                   ],
                      //                 ),
                      //
                      //                 Row(
                      //                   children: [
                      //                     InkWell(
                      //                       onTap: (){
                      //                         // LiabilityDialog().editLiabilityDialog(
                      //                         //     index,
                      //                         //     liability['name'],
                      //                         //     monthlyAmount.toStringAsFixed(2),
                      //                         //     liability['type'],
                      //                         //     balanceAmount.toStringAsFixed(2),
                      //                         //     liability['monthRemaining'],
                      //                         //     liability['status'],
                      //                         //     controller
                      //                         //
                      //                         // );
                      //                       },
                      //                       child: Container(
                      //                           width: Get.width * .16,
                      //                           height: 24,
                      //                           decoration: BoxDecoration(
                      //                               color: AppColors.secondaryColor,
                      //                               borderRadius: BorderRadius.circular(1000)
                      //                           ),
                      //                           child: const Row(
                      //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //                             children: [
                      //                               Icon(Icons.edit,size: 14,color: AppColors.whiteColor,),
                      //                               Text('Edit',
                      //                                 style: TextStyle(
                      //                                     fontSize: 8,
                      //                                     color: AppColors.textColorWhite,
                      //                                     fontWeight: FontWeight.bold
                      //                                 ),)
                      //                             ],
                      //                           ).marginSymmetric(horizontal: Get.width * .02)
                      //                       ),
                      //                     ),
                      //                     SizedBox(width: Get.width * .04,),
                      //                     InkWell(
                      //                       onTap: ()async{
                      //                         // LiabilityDialog().removeLiabilityDialog(index);
                      //                       },
                      //                       child: Container(
                      //                           width: Get.width * .16,
                      //                           height: 24,
                      //                           decoration: BoxDecoration(
                      //                               color: AppColors.deleteButtonBg,
                      //                               borderRadius: BorderRadius.circular(1000)
                      //                           ),
                      //                           child: const Row(
                      //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //                             children: [
                      //                               Icon(Icons.delete,size: 14,color: AppColors.whiteColor,),
                      //                               Text('Trash',
                      //                                 style: TextStyle(
                      //                                     fontSize: 8,
                      //                                     color: AppColors.textColorWhite,
                      //                                     fontWeight: FontWeight.bold
                      //                                 ),)
                      //                             ],
                      //                           ).marginSymmetric(horizontal: Get.width * .02)
                      //                       ),
                      //                     ),
                      //                   ],
                      //                 )
                      //               ],
                      //             ),
                      //             Row(
                      //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //               children: [
                      //                 Flexible(
                      //                   child: Align(
                      //                     alignment: Alignment.centerLeft,
                      //                     child: TextWidget(
                      //                         text: liability['name'],
                      //                         fontSize: 14,
                      //                         fontWeight: FontWeight.bold,
                      //                         fontColor: AppColors.textColorApp,
                      //                         textAlign: TextAlign.center
                      //                     ),
                      //                   ),
                      //                 ),
                      //                 Flexible(
                      //                   child: Align(
                      //                     alignment: Alignment.centerRight,
                      //                     child: TextWidget(
                      //                         text: liability['type'],
                      //                         fontSize: 14,
                      //                         fontWeight: FontWeight.bold,
                      //                         fontColor: AppColors.textColorApp,
                      //                         textAlign: TextAlign.center
                      //                     ),
                      //                   ),
                      //                 ),
                      //
                      //               ],
                      //             ).paddingOnly(top: 12),
                      //             Row(
                      //               mainAxisAlignment: MainAxisAlignment.center,
                      //               children: [
                      //                 Expanded(child: SizedBox(
                      //                   height: Get.height * .06,
                      //                   child: Column(
                      //                     mainAxisAlignment: MainAxisAlignment.center,
                      //                     crossAxisAlignment: CrossAxisAlignment.center,
                      //                     children: [
                      //                       TextWidget(
                      //                           text: '\$${UtilMethods().formatNumberWithCommas(balanceAmount)}',
                      //                           fontSize: 14,
                      //                           fontWeight: FontWeight.bold,
                      //                           fontColor: AppColors.textColorApp,
                      //                           textAlign: TextAlign.center
                      //                       ),
                      //                       TextWidget(
                      //                           text: 'Balance',
                      //                           fontSize: 10,
                      //                           fontWeight: FontWeight.bold,
                      //                           fontColor: AppColors.primarySecondaryColor.withOpacity(.7),
                      //                           textAlign: TextAlign.center
                      //                       )
                      //                     ],
                      //                   ),
                      //                 )),
                      //                 Container(
                      //                   width: Get.width * .002,
                      //                   height: Get.height * .04,
                      //                   decoration: BoxDecoration(
                      //                       color: AppColors.blackColor.withOpacity(.4)
                      //                   ),
                      //                 ),
                      //                 Expanded(child: SizedBox(
                      //                   height: Get.height * .06,
                      //                   child: Column(
                      //                     mainAxisAlignment: MainAxisAlignment.center,
                      //                     crossAxisAlignment: CrossAxisAlignment.center,
                      //                     children: [
                      //                       TextWidget(
                      //                           text: liability['monthRemaining'] != ''? liability['monthRemaining']:'N/A',
                      //                           fontSize: 13,
                      //                           fontWeight: FontWeight.bold,
                      //                           fontColor: AppColors.textColorApp,
                      //                           textAlign: TextAlign.center
                      //                       ),
                      //                       TextWidget(
                      //                           text: 'Mo. remaining',
                      //                           fontSize: 10,
                      //                           fontWeight: FontWeight.bold,
                      //                           fontColor: AppColors.primarySecondaryColor.withOpacity(.7),
                      //                           textAlign: TextAlign.center
                      //                       )
                      //                     ],
                      //                   ),
                      //                 )),
                      //                 Container(
                      //                   width: Get.width * .002,
                      //                   height: Get.height * .04,
                      //                   decoration: BoxDecoration(
                      //                       color: AppColors.blackColor.withOpacity(.4)
                      //                   ),
                      //                 ),
                      //                 Expanded(child: SizedBox(
                      //                   height: Get.height * .06,
                      //                   child: Column(
                      //                     mainAxisAlignment: MainAxisAlignment.center,
                      //                     crossAxisAlignment: CrossAxisAlignment.center,
                      //                     children: [
                      //                       TextWidget(
                      //                           text: '\$${UtilMethods().formatNumberWithCommas(monthlyAmount)}',
                      //                           fontSize: 14,
                      //                           fontWeight: FontWeight.bold,
                      //                           fontColor: AppColors.textColorApp,
                      //                           textAlign: TextAlign.center
                      //                       ),
                      //                       TextWidget(
                      //                           text: 'Per month',
                      //                           fontSize: 10,
                      //                           fontWeight: FontWeight.bold,
                      //                           fontColor: AppColors.primarySecondaryColor.withOpacity(.7),
                      //                           textAlign: TextAlign.center
                      //                       )
                      //                     ],
                      //                   ),
                      //                 )),
                      //
                      //               ],
                      //             ),
                      //           ],
                      //         ).paddingAll(8)
                      //     ).marginOnly(top: 8):
                      //     Container(
                      //         decoration: BoxDecoration(
                      //             borderRadius: BorderRadius.circular(10),
                      //             color: AppColors.liabilityItemsBackgroundColor.withOpacity(.4)
                      //         ),
                      //         child: Column(
                      //           crossAxisAlignment: CrossAxisAlignment.end,
                      //           children: [
                      //             Row(
                      //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //               children: [
                      //                 Row(
                      //                   children: [
                      //                     Container(
                      //                       width: 24,
                      //                       height: 24,
                      //                       decoration: const BoxDecoration(
                      //                           color: AppColors.whiteColor,
                      //                           shape: BoxShape.circle
                      //                       ),
                      //                       child: Center(
                      //                         child: TextWidget(
                      //                             text: itemNumber.toString(),
                      //                             fontSize: 10,
                      //                             fontWeight: FontWeight.bold,
                      //                             fontColor: AppColors.secondaryColor,
                      //                             textAlign: TextAlign.center),
                      //                       ),
                      //                     ),
                      //                   ],
                      //                 ),
                      //
                      //                 Row(
                      //                   children: [
                      //                     Container(
                      //                         decoration:  BoxDecoration(
                      //                             color: AppColors.whiteColor,
                      //                             borderRadius: BorderRadius.circular(1000)
                      //                         ),
                      //                         child: Text(liability['verifyStatus'],style: TextStyle(fontWeight: FontWeight.bold,
                      //                             color: liability['verifyStatus'] == 'Verified'?AppColors.greenColor:AppColors.secondaryColor
                      //                         ),).paddingSymmetric(horizontal: 4)),
                      //
                      //                   ],
                      //                 )
                      //
                      //               ],
                      //             ),
                      //             Row(
                      //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //               children: [
                      //                 Flexible(
                      //                   child: Align(
                      //                     alignment: Alignment.centerLeft,
                      //                     child: TextWidget(
                      //                         text: liability['name'],
                      //                         fontSize: 14,
                      //                         fontWeight: FontWeight.bold,
                      //                         fontColor: AppColors.textColorApp,
                      //                         textAlign: TextAlign.center
                      //                     ),
                      //                   ),
                      //                 ),
                      //                 Flexible(
                      //                   child: Align(
                      //                     alignment: Alignment.centerRight,
                      //                     child: TextWidget(
                      //                         text: liability['type'],
                      //                         fontSize: 14,
                      //                         fontWeight: FontWeight.bold,
                      //                         fontColor: AppColors.textColorApp,
                      //                         textAlign: TextAlign.center
                      //                     ),
                      //                   ),
                      //                 ),
                      //
                      //               ],
                      //             ).paddingOnly(top: 12),
                      //             Row(
                      //               mainAxisAlignment: MainAxisAlignment.center,
                      //               children: [
                      //                 Expanded(child: SizedBox(
                      //                   height: Get.height * .06,
                      //                   child: Column(
                      //                     mainAxisAlignment: MainAxisAlignment.center,
                      //                     crossAxisAlignment: CrossAxisAlignment.center,
                      //                     children: [
                      //                       TextWidget(
                      //                           text: '\$${UtilMethods().formatNumberWithCommas(balanceAmount)}',
                      //                           fontSize: 14,
                      //                           fontWeight: FontWeight.bold,
                      //                           fontColor: AppColors.textColorApp,
                      //                           textAlign: TextAlign.center
                      //                       ),
                      //                       TextWidget(
                      //                           text: 'Balance',
                      //                           fontSize: 10,
                      //                           fontWeight: FontWeight.bold,
                      //                           fontColor: AppColors.primarySecondaryColor.withOpacity(.7),
                      //                           textAlign: TextAlign.center
                      //                       )
                      //                     ],
                      //                   ),
                      //                 )),
                      //                 Container(
                      //                   width: Get.width * .002,
                      //                   height: Get.height * .04,
                      //                   decoration: BoxDecoration(
                      //                       color: AppColors.blackColor.withOpacity(.4)
                      //                   ),
                      //                 ),
                      //                 Expanded(child: SizedBox(
                      //                   height: Get.height * .06,
                      //                   child: Column(
                      //                     mainAxisAlignment: MainAxisAlignment.center,
                      //                     crossAxisAlignment: CrossAxisAlignment.center,
                      //                     children: [
                      //                       TextWidget(
                      //                           text: liability['monthRemaining'] != ''? liability['monthRemaining']:'N/A',
                      //                           fontSize: 13,
                      //                           fontWeight: FontWeight.bold,
                      //                           fontColor: AppColors.textColorApp,
                      //                           textAlign: TextAlign.center
                      //                       ),
                      //                       TextWidget(
                      //                           text: 'Mo. remaining',
                      //                           fontSize: 10,
                      //                           fontWeight: FontWeight.bold,
                      //                           fontColor: AppColors.primarySecondaryColor.withOpacity(.7),
                      //                           textAlign: TextAlign.center
                      //                       )
                      //                     ],
                      //                   ),
                      //                 )),
                      //                 Container(
                      //                   width: Get.width * .002,
                      //                   height: Get.height * .04,
                      //                   decoration: BoxDecoration(
                      //                       color: AppColors.blackColor.withOpacity(.4)
                      //                   ),
                      //                 ),
                      //                 Expanded(child: SizedBox(
                      //                   height: Get.height * .06,
                      //                   child: Column(
                      //                     mainAxisAlignment: MainAxisAlignment.center,
                      //                     crossAxisAlignment: CrossAxisAlignment.center,
                      //                     children: [
                      //                       TextWidget(
                      //                           text: '\$${UtilMethods().formatNumberWithCommas(monthlyAmount)}',
                      //                           fontSize: 14,
                      //                           fontWeight: FontWeight.bold,
                      //                           fontColor: AppColors.textColorApp,
                      //                           textAlign: TextAlign.center
                      //                       ),
                      //                       TextWidget(
                      //                           text: 'Per month',
                      //                           fontSize: 10,
                      //                           fontWeight: FontWeight.bold,
                      //                           fontColor: AppColors.primarySecondaryColor.withOpacity(.7),
                      //                           textAlign: TextAlign.center
                      //                       )
                      //                     ],
                      //                   ),
                      //                 )),
                      //               ],
                      //             ),
                      //             liability['verifyStatus'] == 'Verified'?Align(alignment: Alignment.centerLeft,child: Text('This liability is verified by ZAPA Mortgage Team. This liability is Included.', style: TextStyle(fontSize: 10),)):
                      //             liability['executionReason'] == 'To Be Paid'? Align(alignment: Alignment.centerLeft,child: Text('Excluded (To Be Paid - Payoff \$${UtilMethods().formatNumberWithCommas(double.parse(liability['balanceAmount']))} at Closing)', style: TextStyle(fontSize: 10),)):
                      //             liability['executionReason'] == 'Paid by Others'? Align(alignment: Alignment.centerLeft,child: Text('Excluded (Paid by Others)', style: TextStyle(fontSize: 10),)):
                      //             liability['executionReason'] == 'Less than 10 Months Remaining'? Align(alignment: Alignment.centerLeft,child: Text('Excluded (Less than 10 Months Remaining)', style: TextStyle(fontSize: 10),)):
                      //             liability['executionReason'] == 'Court Ordered / Other'? Align(alignment: Alignment.centerLeft,child: Text('Excluded (Court Ordered / Other)', style: TextStyle(fontSize: 10),)):const Text('')
                      //           ],
                      //         ).paddingAll(8)
                      //     ).marginOnly(top: 8);
                      //   },
                      // ).paddingSymmetric(horizontal: 16);
                    },
                  ),
                ),
              ),
            ],
          ),
        );
        }
    );
  }

}