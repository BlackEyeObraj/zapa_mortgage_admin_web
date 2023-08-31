import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zapa_mortgage_admin_web/controllers/co_borrower_view_controller.dart';
import 'package:zapa_mortgage_admin_web/utils/dialogs/co_borrower_dialog.dart';
import 'package:zapa_mortgage_admin_web/utils/utils_mehtods.dart';

import '../../res/app_colors.dart';
import '../../services/firestore_service.dart';
import '../../utils/constants.dart';
import '../../utils/widgets/text_widget.dart';

class CoBorrowerView extends GetView<CoBorrowerViewController>{
  final String borrowerId;
  final String borrowerPhoneNumber;
  CoBorrowerView({required this.borrowerId, required this.borrowerPhoneNumber});
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: CoBorrowerViewController(),
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
                  child: Center(
                    child: Text(
                      'Co Borrowers',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                          color: AppColors.textColorWhite
                      ),
                    ),
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirestoreService().getCoBorrower(borrowerPhoneNumber),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
                    if (documents.isEmpty) {
                      return Center(
                        child:  const Text('No Co-Borrowers Added Yet.').paddingOnly(bottom: 24,top: 24),
                      );
                    }
                    return
                      GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Display two items in each row
                          mainAxisSpacing: 10.0, // Spacing between rows
                          crossAxisSpacing: 10.0, // Spacing between columns
                          childAspectRatio: 4 / 2.4,
                        ),
                        itemCount: documents.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          Map<String, dynamic> data = documents[index].data() as Map<String, dynamic>;
                          return  Container(
                            width: Get.width * 1,
                            decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        text: 'Co-Borrower Name: ',
                                        style: TextStyle(fontWeight: FontWeight.bold,
                                            color: AppColors.textColorWhite,fontSize: 16),
                                        children: <TextSpan>[
                                          TextSpan(text: data['coBorrowerName'], style: const TextStyle(fontWeight: FontWeight.normal)),
                                        ],
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        text: 'Phone Number: ',
                                        style: TextStyle(fontWeight: FontWeight.bold,
                                            color: AppColors.textColorWhite,fontSize: 16),
                                        children: <TextSpan>[
                                          TextSpan(text: data['coBorrowerPhoneNumber'], style: const TextStyle(fontWeight: FontWeight.normal)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Container(width: Get.width * 1,height: .4,color: AppColors.whiteColor.withOpacity(.4),).marginOnly(top: 16,bottom: 16),
                                Container(
                                  width: Get.width * 1,
                                  color: AppColors.secondaryColor,
                                  child: Text('Added By Borrower',style: TextStyle(fontWeight: FontWeight.bold,
                                      color: AppColors.textColorWhite,fontSize: 14)).paddingAll(4),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      children: [
                                        Text('FICO',style: TextStyle(fontWeight: FontWeight.bold,
                                            color: AppColors.textColorWhite,fontSize: 14)),
                                        SizedBox(height: 8,),
                                        Text(data['borrowerFICO'],style: TextStyle(fontWeight: FontWeight.bold,
                                            color: AppColors.textColorWhite,fontSize: 14))

                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text('Income',style: TextStyle(fontWeight: FontWeight.bold,
                                            color: AppColors.textColorWhite,fontSize: 14)),
                                        SizedBox(height: 8,),
                                        Text('\$${UtilMethods().formatNumberWithCommas(double.parse(data['borrowerIncome']))}',style: TextStyle(fontWeight: FontWeight.bold,
                                            color: AppColors.textColorWhite,fontSize: 14))
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text('Liability',style: TextStyle(fontWeight: FontWeight.bold,
                                            color: AppColors.textColorWhite,fontSize: 14)),
                                        SizedBox(height: 8,),
                                        Text('\$${UtilMethods().formatNumberWithCommas(double.parse(data['borrowerLiability']))}',style: TextStyle(fontWeight: FontWeight.bold,
                                            color: AppColors.textColorWhite,fontSize: 14))
                                      ],
                                    )
                                  ],
                                ).paddingAll(4),
                                const SizedBox(height: 8,),
                                Container(
                                  width: Get.width * 1,
                                  color: AppColors.secondaryColor,
                                  child: Text('Added By Co-Borrower',style: TextStyle(fontWeight: FontWeight.bold,
                                      color: AppColors.textColorWhite,fontSize: 14)).paddingAll(4),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      children: [
                                        Text('FICO',style: TextStyle(fontWeight: FontWeight.bold,
                                            color: AppColors.textColorWhite,fontSize: 14)),
                                        SizedBox(height: 8,),
                                        TextWidget(
                                            text: data['coBorrowerFICO'],
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            fontColor: AppColors.textColorWhite,
                                            textAlign: TextAlign.center)
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text('Income',style: TextStyle(fontWeight: FontWeight.bold,
                                            color: AppColors.textColorWhite,fontSize: 14)),
                                        SizedBox(height: 8,),
                                        TextWidget(
                                            text: '\$${UtilMethods().formatNumberWithCommas(double.parse(data['coBorrowerIncome']))}',
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            fontColor: AppColors.textColorWhite,
                                            textAlign: TextAlign.center)
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text('Liability',style: TextStyle(fontWeight: FontWeight.bold,
                                            color: AppColors.textColorWhite,fontSize: 14)),
                                        SizedBox(height: 8,),
                                        TextWidget(
                                            text: '\$${UtilMethods().formatNumberWithCommas(double.parse(data['coBorrowerLiability']))}',
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            fontColor: AppColors.textColorWhite,
                                            textAlign: TextAlign.center)
                                      ],
                                    )
                                  ],
                                ).paddingAll(4),
                                const SizedBox(height: 8,),
                                Container(
                                  width: Get.width * 1,
                                  color: AppColors.secondaryColor,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Added By ${Constants().appName}',style: TextStyle(fontWeight: FontWeight.bold,
                                          color: AppColors.textColorWhite,fontSize: 14)).paddingAll(4),
                                      InkWell(
                                        onTap: (){
                                          CoBorrowerDialog().editBorrower(data['id'], data['coBorrowerVerifiedFICO'], data['coBorrowerVerifiedIncome'], data['coBorrowerVerifiedLiability']);
                                        },
                                        child: Container(
                                            height: Get.height * .03,
                                            decoration: BoxDecoration(
                                                color: AppColors.whiteColor,
                                                borderRadius: BorderRadius.circular(10000)
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                const Icon(Icons.edit,color: AppColors.secondaryColor,size: 12,),
                                                SizedBox(width: Get.width * .01,),
                                                const Text('Edit',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.secondaryColor,fontSize: 10),)
                                              ],
                                            ).paddingSymmetric(horizontal: Get.width  * .01)
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      children: [
                                        Text('FICO',style: TextStyle(fontWeight: FontWeight.bold,
                                            color: AppColors.textColorWhite,fontSize: 14)),
                                        SizedBox(height: 8,),
                                        TextWidget(
                                            text: data['coBorrowerVerifiedFICO'],
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            fontColor: AppColors.textColorWhite,
                                            textAlign: TextAlign.center)

                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text('Income',style: TextStyle(fontWeight: FontWeight.bold,
                                            color: AppColors.textColorWhite,fontSize: 14)),
                                        SizedBox(height: 8,),
                                        data['coBorrowerSharedVerifiedData'] == true?
                                        TextWidget(
                                            text: '\$${UtilMethods().formatNumberWithCommas(double.parse(data['coBorrowerVerifiedIncome']))}',
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            fontColor: AppColors.textColorWhite,
                                            textAlign: TextAlign.center)
                                            :Text('\$0.00',style: TextStyle(fontWeight: FontWeight.bold,
                                            color: AppColors.textColorWhite,fontSize: 14))
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text('Liability',style: TextStyle(fontWeight: FontWeight.bold,
                                            color: AppColors.textColorWhite,fontSize: 14)),
                                        SizedBox(height: 8,),
                                        data['coBorrowerSharedVerifiedData'] == true?
                                        TextWidget(
                                            text: '\$${UtilMethods().formatNumberWithCommas(double.parse(data['coBorrowerVerifiedLiability']))}',
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            fontColor: AppColors.textColorWhite,
                                            textAlign: TextAlign.center)
                                            :Text('\$0.00',style: TextStyle(fontWeight: FontWeight.bold,
                                            color: AppColors.textColorWhite,fontSize: 14))
                                      ],
                                    )
                                  ],
                                ).paddingAll(4)
                              ],
                            ).paddingAll(8),
                          ).marginAll(16);
                        },
                      );
                    //   ListView.builder(
                    //   itemCount: documents.length,
                    //   shrinkWrap: true,
                    //   physics: const NeverScrollableScrollPhysics(),
                    //   itemBuilder: (context, index) {
                    //     Map<String, dynamic> data = documents[index].data() as Map<String, dynamic>;
                    //     return  Container(
                    //       width: Get.width * 1,
                    //       decoration: BoxDecoration(
                    //           color: AppColors.primaryColor,
                    //           borderRadius: BorderRadius.circular(10)
                    //       ),
                    //       child: Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           Row(
                    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //             children: [
                    //               RichText(
                    //                 text: TextSpan(
                    //                   text: 'Co-Borrower Name: ',
                    //                   style: TextStyle(fontWeight: FontWeight.bold,
                    //                       color: AppColors.textColorWhite,fontSize: 16),
                    //                   children: <TextSpan>[
                    //                     TextSpan(text: data['coBorrowerName'], style: const TextStyle(fontWeight: FontWeight.normal)),
                    //                   ],
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //           Container(width: Get.width * 1,height: .4,color: AppColors.whiteColor.withOpacity(.4),).marginOnly(top: 16,bottom: 16),
                    //           Container(
                    //             width: Get.width * 1,
                    //             color: AppColors.secondaryColor,
                    //             child: Row(
                    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //               children: [
                    //                 Row(
                    //                   children: [
                    //                     Text('Added By Borrower',style: TextStyle(fontWeight: FontWeight.bold,
                    //                         color: AppColors.textColorWhite,fontSize: 14)).paddingAll(4),
                    //                     const SizedBox(width: 16,),
                    //                   ],
                    //                 ),
                    //                 Checkbox(
                    //                     value: data['inUse'] == 'borrower'?true:false,
                    //                     checkColor: AppColors.primaryColor,
                    //                     activeColor: AppColors.whiteColor,
                    //                     onChanged: (value){
                    //                       // FirestoreService().updateCoBorrowerInUse(data['id'], 'borrower');
                    //                     }
                    //                 )
                    //               ],
                    //             ),
                    //           ),
                    //           Row(
                    //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //             children: [
                    //               Column(
                    //                 children: [
                    //                   Text('FICO',style: TextStyle(fontWeight: FontWeight.bold,
                    //                       color: AppColors.textColorWhite,fontSize: 12)),
                    //                   Text(data['borrowerFICO'],style: TextStyle(fontWeight: FontWeight.bold,
                    //                       color: AppColors.textColorWhite,fontSize: 12))
                    //
                    //                 ],
                    //               ),
                    //               Column(
                    //                 children: [
                    //                   Text('Income',style: TextStyle(fontWeight: FontWeight.bold,
                    //                       color: AppColors.textColorWhite,fontSize: 12)),
                    //                   Text('\$${UtilMethods().formatNumberWithCommas(double.parse(data['borrowerIncome']))}',style: TextStyle(fontWeight: FontWeight.bold,
                    //                       color: AppColors.textColorWhite,fontSize: 12))
                    //                 ],
                    //               ),
                    //               Column(
                    //                 children: [
                    //                   Text('Liability',style: TextStyle(fontWeight: FontWeight.bold,
                    //                       color: AppColors.textColorWhite,fontSize: 12)),
                    //                   Text('\$${UtilMethods().formatNumberWithCommas(double.parse(data['borrowerLiability']))}',style: TextStyle(fontWeight: FontWeight.bold,
                    //                       color: AppColors.textColorWhite,fontSize: 12))
                    //                 ],
                    //               )
                    //             ],
                    //           ).paddingAll(4),
                    //           const SizedBox(height: 8,),
                    //           Container(
                    //             width: Get.width * 1,
                    //             color: AppColors.secondaryColor,
                    //             child: Row(
                    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //               children: [
                    //                 Text('Shared By Co-Borrower',style: TextStyle(fontWeight: FontWeight.bold,
                    //                     color: AppColors.textColorWhite,fontSize: 14)).paddingAll(4),
                    //                 Checkbox(
                    //                     value: data['inUse'] == 'coBorrower'?true:false,
                    //                     checkColor: AppColors.primaryColor,
                    //                     activeColor: AppColors.whiteColor,
                    //                     onChanged: (value){
                    //                       // FirestoreService().updateCoBorrowerInUse(data['id'], 'coBorrower');
                    //                     })
                    //
                    //               ],
                    //             ),
                    //           ),
                    //           Row(
                    //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //             children: [
                    //               Column(
                    //                 children: [
                    //                   Text('FICO',style: TextStyle(fontWeight: FontWeight.bold,
                    //                       color: AppColors.textColorWhite,fontSize: 12)),
                    //                   data['coBorrowerSharedHisData'] == true? StreamBuilder<DocumentSnapshot>(
                    //                     stream: FirestoreService().getFicoScoreReal(borrowerId),
                    //                     builder: (context, snapshot) {
                    //                       if (snapshot.hasError) {
                    //                         return Text('Error: ${snapshot.error}');
                    //                       }
                    //
                    //                       if (!snapshot.hasData) {
                    //                         return  const TextWidget(
                    //                             text: 'Loading ...',
                    //                             fontSize: 10,
                    //                             fontWeight: FontWeight.bold,
                    //                             fontColor: AppColors.secondaryColor,
                    //                             textAlign: TextAlign.center);
                    //                       }
                    //
                    //                       dynamic ficoObject;
                    //                       try {
                    //                         ficoObject = snapshot.data?.get('fico');
                    //                       } catch (error) {
                    //                         ficoObject = null;
                    //                       }
                    //                       dynamic userScoreValue = ficoObject != null ? ficoObject['userScore'] : '0';
                    //
                    //                       return TextWidget(
                    //                           text: userScoreValue,
                    //                           fontSize: 12,
                    //                           fontWeight: FontWeight.bold,
                    //                           fontColor: AppColors.textColorWhite,
                    //                           textAlign: TextAlign.center);
                    //                       // Text(userScoreValue,style: TextStyle(fontWeight: FontWeight.bold,
                    //                       //   color: AppColors.textColorWhite,fontSize: 12.sp));
                    //                     },
                    //                   ):Text('0',style: TextStyle(fontWeight: FontWeight.bold,
                    //                       color: AppColors.textColorWhite,fontSize: 12)),
                    //                 ],
                    //               ),
                    //               Column(
                    //                 children: [
                    //                   Text('Income',style: TextStyle(fontWeight: FontWeight.bold,
                    //                       color: AppColors.textColorWhite,fontSize: 12)),
                    //                   data['coBorrowerSharedHisData'] == true?
                    //                   TextWidget(
                    //                       text: '\$${UtilMethods().formatNumberWithCommas(double.parse(data['coBorrowerIncome']))}',
                    //                       fontSize: 12,
                    //                       fontWeight: FontWeight.bold,
                    //                       fontColor: AppColors.textColorWhite,
                    //                       textAlign: TextAlign.center)
                    //                       :Text('\$0.00',style: TextStyle(fontWeight: FontWeight.bold,
                    //                       color: AppColors.textColorWhite,fontSize: 12))
                    //                 ],
                    //               ),
                    //               Column(
                    //                 children: [
                    //                   Text('Liability',style: TextStyle(fontWeight: FontWeight.bold,
                    //                       color: AppColors.textColorWhite,fontSize: 12)),
                    //                   data['coBorrowerSharedHisData'] == true?
                    //                   TextWidget(
                    //                       text: '\$${UtilMethods().formatNumberWithCommas(double.parse(data['coBorrowerLiability']))}',
                    //                       fontSize: 12,
                    //                       fontWeight: FontWeight.bold,
                    //                       fontColor: AppColors.textColorWhite,
                    //                       textAlign: TextAlign.center)
                    //                       :Text('\$0.00',style: TextStyle(fontWeight: FontWeight.bold,
                    //                       color: AppColors.textColorWhite,fontSize: 12))
                    //                 ],
                    //               )
                    //             ],
                    //           ).paddingAll(4),
                    //           const SizedBox(height: 8,),
                    //           Container(
                    //             width: Get.width * 1,
                    //             color: AppColors.secondaryColor,
                    //             child: Row(
                    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //               children: [
                    //                 Text('Added By ${Constants().appName}',style: TextStyle(fontWeight: FontWeight.bold,
                    //                     color: AppColors.textColorWhite,fontSize: 14)).paddingAll(4),
                    //                 // Radio(value: true, groupValue: 'select', onChanged: (val){
                    //                 //
                    //                 // }),
                    //                 Checkbox(
                    //                     value: data['inUse'] == 'zapa'?true:false,
                    //                     checkColor: AppColors.primaryColor,
                    //                     activeColor: AppColors.whiteColor,
                    //                     onChanged: (value){
                    //                       // FirestoreService().updateCoBorrowerInUse(data['id'], 'zapa');
                    //                     })
                    //               ],
                    //             ),
                    //           ),
                    //           Row(
                    //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //             children: [
                    //               Column(
                    //                 children: [
                    //                   Text('FICO',style: TextStyle(fontWeight: FontWeight.bold,
                    //                       color: AppColors.textColorWhite,fontSize: 12)),
                    //                   data['coBorrowerSharedVerifiedData'] == true? StreamBuilder<DocumentSnapshot>(
                    //                     stream: FirestoreService().getFicoScoreReal(borrowerId),
                    //                     builder: (context, snapshot) {
                    //                       if (snapshot.hasError) {
                    //                         return Text('Error: ${snapshot.error}');
                    //                       }
                    //
                    //                       if (!snapshot.hasData) {
                    //                         return  const TextWidget(
                    //                             text: 'Loading ...',
                    //                             fontSize: 10,
                    //                             fontWeight: FontWeight.bold,
                    //                             fontColor: AppColors.secondaryColor,
                    //                             textAlign: TextAlign.center);
                    //                       }
                    //
                    //                       dynamic ficoObject;
                    //                       try {
                    //                         ficoObject = snapshot.data?.get('fico');
                    //                       } catch (error) {
                    //                         ficoObject = null;
                    //                       }
                    //                       dynamic zapaScoreValue =
                    //                       ficoObject != null ? ficoObject['zapaScore'] ?? '0':'0';
                    //
                    //                       return TextWidget(
                    //                           text: zapaScoreValue,
                    //                           fontSize: 12,
                    //                           fontWeight: FontWeight.bold,
                    //                           fontColor: AppColors.textColorWhite,
                    //                           textAlign: TextAlign.center);
                    //
                    //                     },
                    //                   ):Text('0',style: TextStyle(fontWeight: FontWeight.bold,
                    //                       color: AppColors.textColorWhite,fontSize: 12)),
                    //
                    //                 ],
                    //               ),
                    //               Column(
                    //                 children: [
                    //                   Text('Income',style: TextStyle(fontWeight: FontWeight.bold,
                    //                       color: AppColors.textColorWhite,fontSize: 12)),
                    //                   data['coBorrowerSharedVerifiedData'] == true?
                    //                   TextWidget(
                    //                       text: '\$${UtilMethods().formatNumberWithCommas(double.parse(data['coBorrowerVerifiedIncome']))}',
                    //                       fontSize: 12,
                    //                       fontWeight: FontWeight.bold,
                    //                       fontColor: AppColors.textColorWhite,
                    //                       textAlign: TextAlign.center)
                    //                       :Text('\$0.00',style: TextStyle(fontWeight: FontWeight.bold,
                    //                       color: AppColors.textColorWhite,fontSize: 12))
                    //                 ],
                    //               ),
                    //               Column(
                    //                 children: [
                    //                   Text('Liability',style: TextStyle(fontWeight: FontWeight.bold,
                    //                       color: AppColors.textColorWhite,fontSize: 12)),
                    //                   data['coBorrowerSharedVerifiedData'] == true?
                    //                   TextWidget(
                    //                       text: '\$${UtilMethods().formatNumberWithCommas(double.parse(data['coBorrowerVerifiedLiability']))}',
                    //                       fontSize: 12,
                    //                       fontWeight: FontWeight.bold,
                    //                       fontColor: AppColors.textColorWhite,
                    //                       textAlign: TextAlign.center)
                    //                       :Text('\$0.00',style: TextStyle(fontWeight: FontWeight.bold,
                    //                       color: AppColors.textColorWhite,fontSize: 12))
                    //                 ],
                    //               )
                    //             ],
                    //           ).paddingAll(4)
                    //         ],
                    //       ).paddingAll(8),
                    //     ).marginAll(16);
                    //   },
                    // );
                  },
                ),
              ],
            ),
          );
        }
    );
  }

}