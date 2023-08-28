import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zapa_mortgage_admin_web/controllers/borrower_discussion_view_controller.dart';
import 'package:zapa_mortgage_admin_web/controllers/summary_view_controller.dart';
import 'package:zapa_mortgage_admin_web/pages/views/borrower_discussion_view.dart';
import 'package:zapa_mortgage_admin_web/res/app_colors.dart';
import 'package:zapa_mortgage_admin_web/utils/routes/route_name.dart';

import '../../services/firestore_service.dart';
import '../../utils/dialogs/nick_name_dialog.dart';
import '../../utils/utils_mehtods.dart';

class SummaryView extends GetView<SummaryViewController>{
  final String borrowerId;
  SummaryView({required this.borrowerId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: SummaryViewController(),
        builder: (controller){
        controller.setSummaryValue(borrowerId);
          return Scaffold(
          body: SizedBox(
            width: Get.width * 1,
            height: Get.height * 1,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: Get.width * 1,
                    height: 220,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(20),bottomLeft: Radius.circular(20))
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Borrower Name',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,
                                        color: AppColors.textColorWhite),),
                                    StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                                      stream: FirestoreService().getUserDataNameStream(borrowerId),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError) {
                                          return Text('Error: ${snapshot.error}');
                                        }
                                        if (!snapshot.hasData) {
                                          return Text('Loading ...');
                                        }
                                        var userData = snapshot.data!.data() as Map<String, dynamic>;
                                        var userName = userData['userName'] as String;
                                        return Text(userName.isEmpty ? 'N/A':userName,style: TextStyle(fontSize: 16,fontWeight: FontWeight.normal,
                                            color: AppColors.textColorWhite),);
                                      },
                                    )

                                  ],
                                )
                            ),
                            Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('Nick Name',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,
                                            color: AppColors.textColorWhite),),
                                        SizedBox(width: 8,),
                                        InkWell(
                                          onTap: (){
                                            NickNameDialog().addNickName(borrowerId,controller.nickName.value);

                                          },child: Icon(Icons.edit,color: AppColors.secondaryColor,size: 18,))
                                      ],
                                    ),
                                    StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                                      stream: FirestoreService().getUserDataNameStream(borrowerId),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError) {
                                          return Text('Error: ${snapshot.error}');
                                        }

                                        if (!snapshot.hasData) {
                                          return Text('Loading ...');
                                        }
                                        var userData = snapshot.data!.data() as Map<String, dynamic>;
                                        var nickName = userData['nickName'] as String;
                                        controller.nickName.value = nickName;
                                        return Text(nickName.isEmpty?'N/A':nickName ,style: TextStyle(fontSize: 16,fontWeight: FontWeight.normal,
                                            color: AppColors.textColorWhite),);
                                      },
                                    )
                                  ],
                                )
                            ),
                            Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Phone Number',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,
                                        color: AppColors.textColorWhite),),
                                    StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                                      stream: FirestoreService().getUserDataNameStream(borrowerId),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError) {
                                          return Text('Error: ${snapshot.error}');
                                        }

                                        if (!snapshot.hasData) {
                                          return Text('Loading ...');
                                        }
                                        var userData = snapshot.data!.data() as Map<String, dynamic>;
                                        var phoneNumber = userData['phoneNumber'] as String;
                                        return Text(phoneNumber ,style: TextStyle(fontSize: 16,fontWeight: FontWeight.normal,
                                            color: AppColors.textColorWhite),);
                                      },
                                    )
                                  ],
                                )
                            ),
                            Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Assigned To',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,
                                        color: AppColors.textColorWhite),),
                                    StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                                      stream: FirestoreService().getUserDataNameStream(borrowerId),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError) {
                                          return Text('Error: ${snapshot.error}');
                                        }

                                        if (!snapshot.hasData) {
                                          return Text('Loading ...');
                                        }
                                        var userData = snapshot.data!.data() as Map<String, dynamic>;
                                        var assignedTo = userData['assignedTo'] as String;
                                        return InkWell(
                                          onTap: ()async{
                                            List<String> adminUsers = await FirestoreService().fetchAdminUsers();
                                            print(adminUsers.length.toString());
                                            if(adminUsers.isNotEmpty){
                                              String? selectedItem = await showMenu(
                                                context: context,
                                                position: RelativeRect.fromLTRB(100, 100, 0, 0),
                                                items: adminUsers.map((item) {
                                                  return PopupMenuItem<String>(
                                                    value: item,
                                                    child: Text(item),
                                                  );
                                                }).toList(),
                                              );

                                              if (selectedItem != null) {
                                                print('Selected item: $selectedItem');
                                                // Handle the selected item here
                                                FirestoreService().setUserAssignedTo(borrowerId, selectedItem.toString());
                                              } else {
                                                print('No item selected');
                                                // Handle the case where no item is selected
                                              }

                                            }

                                          },
                                          child: Container(
                                            width: Get.width * .1,
                                            height: 28,
                                            decoration: BoxDecoration(
                                              color: AppColors.secondaryColor,
                                              borderRadius: BorderRadius.circular(1000)
                                            ),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(assignedTo.isEmpty ? 'Not Assigned Yet':assignedTo,style: TextStyle(fontSize: 12,fontWeight: FontWeight.normal,
                                                    color: AppColors.textColorWhite),),
                                              Icon(Icons.arrow_drop_down,color: AppColors.whiteColor,)
                                              ],
                                            ).paddingSymmetric(horizontal: 8),
                                          ),
                                        );
                                      },
                                    )
                                  ],
                                )
                            ),
                          ],
                        ),
                        Container(width: Get.width * 1,height:1,color: Colors.grey.withOpacity(.4),),
                        Row(
                          children: [
                            Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Borrower Last Active On',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,
                                        color: AppColors.textColorWhite),),
                                    StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                                      stream: FirestoreService().getUserDataNameStream(borrowerId),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError) {
                                          return Text('Error: ${snapshot.error}');
                                        }

                                        if (!snapshot.hasData) {
                                          return Text('Loading ...');
                                        }
                                        var userData = snapshot.data!.data() as Map<String, dynamic>;
                                        var borrowerActiveLastDateTime = userData['borrowerActiveLastDateTime'] as Timestamp;
                                        return Text(UtilMethods().parseFirestoreTimestamp(borrowerActiveLastDateTime),style: TextStyle(fontSize: 16,fontWeight: FontWeight.normal,
                                            color: AppColors.textColorWhite),);
                                      },
                                    )

                                  ],
                                )
                            ),
                            Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Last Viewed By',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,
                                        color: AppColors.textColorWhite),),
                                    StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                                      stream: FirestoreService().getUserDataNameStream(borrowerId),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError) {
                                          return Text('Error: ${snapshot.error}');
                                        }

                                        if (!snapshot.hasData) {
                                          return Text('Loading ...');
                                        }
                                        var userData = snapshot.data!.data() as Map<String, dynamic>;
                                        var lastViewedBy = userData['lastViewedBy'] as String;
                                        var lastViewedByTime = userData['lastViewTimeBy'] as String;
                                        return Row(
                                          children: [
                                            Text(lastViewedBy.isEmpty?'N/A':lastViewedBy ,style: TextStyle(fontSize: 16,fontWeight: FontWeight.normal,
                                                color: AppColors.textColorWhite),),
                                            Text(lastViewedBy.isNotEmpty? " [${UtilMethods().parseFirestoreTimestampString(lastViewedByTime).toString()} ]":'' ,style: TextStyle(fontSize: 14,fontWeight: FontWeight.normal,
                                                color: AppColors.textColorWhite),),
                                          ],
                                        );
                                      },
                                    )
                                  ],
                                )
                            ),
                            Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('Last Engagement',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,
                                            color: AppColors.textColorWhite),),
                                        SizedBox(width: 8,),
                                        InkWell(
                                          onTap: ()async{

                                            showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                //which date will display when user open the picker
                                                firstDate: DateTime(1950),
                                                //what will be the previous supported year in picker
                                                lastDate: DateTime
                                                    .now()) //what will be the up to supported date in picker
                                                .then((pickedDate) async{
                                              //then usually do the future job
                                              if (pickedDate != null) {
                                                final TimeOfDay? result = await showTimePicker(
                                                  context: context,
                                                  initialTime: TimeOfDay.now(),
                                                );

                                                if (result != null) {
                                                  String formattedDate = UtilMethods().formatDate(pickedDate);
                                                  String formattedTime = UtilMethods().formatTimeOfDay(result);
                                                  print(formattedDate);
                                                  print(formattedTime);
                                                  String value = '${formattedDate} / ${formattedTime}';
                                                  FirestoreService().setLastEngagementDateTime(borrowerId, value);
                                                }
                                              }else{

                                              }
                                            });
                                          },
                                            child: Icon(Icons.calendar_month,color: AppColors.secondaryColor,))
                                      ],
                                    ),
                                    StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                                      stream: FirestoreService().getUserDataNameStream(borrowerId),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError) {
                                          return Text('Error: ${snapshot.error}');
                                        }

                                        if (!snapshot.hasData) {
                                          return Text('Loading ...');
                                        }
                                        var userData = snapshot.data!.data() as Map<String, dynamic>;
                                        var assignedTo = userData['lastEngagement'] as String;
                                        return Text(assignedTo.isEmpty ? 'N/A':assignedTo,style: TextStyle(fontSize: 16,fontWeight: FontWeight.normal,
                                            color: AppColors.textColorWhite),);
                                      },
                                    )
                                  ],
                                )
                            ),
                            Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('Next Engagement',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,
                                            color: AppColors.textColorWhite),),
                                        SizedBox(width: 8,),
                                        InkWell(
                                            onTap: ()async{

                                              showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  //which date will display when user open the picker
                                                  firstDate: DateTime.now(),
                                                  //what will be the previous supported year in picker
                                                  lastDate: DateTime(2100)
                                              ) //what will be the up to supported date in picker
                                                  .then((pickedDate) async{
                                                //then usually do the future job
                                                if (pickedDate != null) {
                                                  final TimeOfDay? result = await showTimePicker(
                                                    context: context,
                                                    initialTime: TimeOfDay.now(),
                                                  );

                                                  if (result != null) {
                                                    String formattedDate = UtilMethods().formatDate(pickedDate);
                                                    String formattedTime = UtilMethods().formatTimeOfDay(result);
                                                    print(formattedDate);
                                                    print(formattedTime);
                                                    String value = '${formattedDate} / ${formattedTime}';
                                                    FirestoreService().setNextEngagementDateTime(borrowerId, value);
                                                  }
                                                }else{

                                                }
                                              });
                                            },
                                            child: Icon(Icons.calendar_month,color: AppColors.secondaryColor,))
                                      ],
                                    ),
                                    StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                                      stream: FirestoreService().getUserDataNameStream(borrowerId),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError) {
                                          return Text('Error: ${snapshot.error}');
                                        }
                                        if (!snapshot.hasData) {
                                          return Text('Loading ...');
                                        }
                                        var userData = snapshot.data!.data() as Map<String, dynamic>;
                                        var assignedTo = userData['nextEngagement'] as String;
                                        // FirestoreService().checkTNextEngagementTime(assignedTo);
                                        return Text(assignedTo.isEmpty ? 'N/A':assignedTo,style: TextStyle(fontSize: 16,fontWeight: FontWeight.normal,
                                            color: AppColors.textColorWhite),);
                                      },
                                    )
                                  ],
                                )
                            ),
                          ],
                        ),
                        Container(width: Get.width * 1,height:1,color: Colors.grey.withOpacity(.4),),
                        Row(
                          children: [
                            Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Do Not Call',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,
                                        color: AppColors.textColorWhite),),
                                    StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                                      stream: FirestoreService().getUserDataNameStream(borrowerId),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError) {
                                          return Text('Error: ${snapshot.error}');
                                        }
                                        if (!snapshot.hasData) {
                                          return Text('Loading ...');
                                        }
                                        var userData = snapshot.data!.data() as Map<String, dynamic>;
                                        var doNotCall = userData['doNotCall'] as String;
                                        return Text(doNotCall ,style: TextStyle(fontSize: 16,fontWeight: FontWeight.normal,
                                            color: AppColors.textColorWhite),);
                                      },
                                    )
                                  ],
                                )
                            ),
                            Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Borrower RE Agent',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,
                                        color: AppColors.textColorWhite),),
                                    StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                                      stream: FirestoreService().getUserDataNameStream(borrowerId),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError) {
                                          return Text('Error: ${snapshot.error}');
                                        }
                                        if (!snapshot.hasData) {
                                          return Text('Loading ...');
                                        }
                                        var userData = snapshot.data!.data() as Map<String, dynamic>;
                                        var customerAgent = userData['customerAgent'] as String;
                                        return Text(customerAgent.isNotEmpty? customerAgent:'N/A' ,style: TextStyle(fontSize: 16,fontWeight: FontWeight.normal,
                                            color: AppColors.textColorWhite),);
                                      },
                                    )
                                  ],
                                )
                            ),
                            Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('LOA',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,
                                        color: AppColors.textColorWhite),),
                                    StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                                      stream: FirestoreService().getUserDataNameStream(borrowerId),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError) {
                                          return Text('Error: ${snapshot.error}');
                                        }
                                        if (!snapshot.hasData) {
                                          return Text('Loading ...');
                                        }
                                        var userData = snapshot.data!.data() as Map<String, dynamic>;
                                        var ourAgent = userData['assignedTo'] as String;
                                        return Text(ourAgent.isNotEmpty? ourAgent:'N/A' ,style: TextStyle(fontSize: 16,fontWeight: FontWeight.normal,
                                            color: AppColors.textColorWhite),);
                                      },
                                    )
                                  ],
                                )
                            ),
                            Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Agent checked the Borrower',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,
                                        color: AppColors.textColorWhite),),
                                    StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                                      stream: FirestoreService().getUserDataNameStream(borrowerId),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError) {
                                          return Text('Error: ${snapshot.error}');
                                        }
                                        if (!snapshot.hasData) {
                                          return Text('Loading ...');
                                        }
                                        var userData = snapshot.data!.data() as Map<String, dynamic>;
                                        var agentCheckBorrower = userData['agentCheckBorrower'] as String;
                                        return Text(agentCheckBorrower.isNotEmpty? agentCheckBorrower:'N/A' ,style: TextStyle(fontSize: 16,fontWeight: FontWeight.normal,
                                            color: AppColors.textColorWhite),);
                                      },
                                    )
                                  ],
                                )
                            ),

                          ],
                        ),
                      ],
                    ).paddingAll(16),
                  ),
                  SizedBox(height: 40,),
                  Row(
                    children: [
                      Expanded(
                          child: Column(
                            children: [
                              Text('Verified FICO Score',style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold,color: AppColors.secondaryColor),),
                              StreamBuilder<DocumentSnapshot>(
                                stream: FirestoreService().getFicoScoreReal(borrowerId),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  }
                                  if (!snapshot.hasData) {
                                    return Text('Loading ...');
                                  }

                                  dynamic ficoObject;
                                  try {
                                    ficoObject = snapshot.data?.get('fico');
                                  } catch (error) {
                                    ficoObject = null;
                                  }
                                  dynamic zapaScoreValue =
                                  ficoObject != null ? ficoObject['zapaScore'] ?? '0':'0';
                                  return Text(zapaScoreValue,
                                  style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold,color: AppColors.primaryColor),);
                                },
                              ),

                            ],
                          )
                      ),
                      Expanded(
                          child: Column(
                            children: [
                              Text('Borrower FICO Score',style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold,color: AppColors.secondaryColor),),
                              StreamBuilder<DocumentSnapshot>(
                                stream: FirestoreService().getFicoScoreReal(borrowerId),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  }
                                  if (!snapshot.hasData) {
                                    return Text('Loading ...');
                                  }

                                  dynamic ficoObject;
                                  try {
                                    ficoObject = snapshot.data?.get('fico');
                                  } catch (error) {
                                    ficoObject = null;
                                  }

                                  dynamic userScoreValue = ficoObject != null ? ficoObject['userScore'] : '0';
                                  return Text(userScoreValue,
                                  style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold,color: AppColors.primaryColor),);
                                },
                              ),

                            ],
                          )
                      ),
                    ],
                  ),
                  SizedBox(height: 40,),
                  Container(width: Get.width * 1,height:1,color: Colors.grey.withOpacity(.4),),
                  SizedBox(height: 40,),
                  Row(
                    children: [
                      Expanded(
                          child: Column(
                            children: [
                              Text('Verified Income',style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold,color: AppColors.secondaryColor),),
                              Obx(() => Text('\$${UtilMethods().formatNumberWithCommas(controller.totalVerifiedGrossIncome)}',style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold,color: AppColors.primaryColor),))

                            ],
                          )
                      ),
                      Expanded(
                          child: Column(
                            children: [
                              Text('Borrower Income',style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold,color: AppColors.secondaryColor),),
                              Obx(() => Text('\$${UtilMethods().formatNumberWithCommas(controller.totalGrossIncome)}',style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold,color: AppColors.primaryColor),))

                            ],
                          )
                      ),
                    ],
                  ),
                  SizedBox(height: 40,),
                  Container(width: Get.width * 1,height:1,color: Colors.grey.withOpacity(.4),),
                  SizedBox(height: 40,),
                  Row(
                    children: [
                      Expanded(
                          child: Column(
                            children: [
                              Text('Verified Liability',style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold,color: AppColors.secondaryColor),),
                              Obx(() => Text('\$${UtilMethods().formatNumberWithCommas(controller.totalVerifiedLiability)}',style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold,color: AppColors.primaryColor),))

                            ],
                          )
                      ),
                      Expanded(
                          child: Column(
                            children: [
                              Text('Borrower Liability',style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold,color: AppColors.secondaryColor),),
                              Obx(() => Text('\$${UtilMethods().formatNumberWithCommas(controller.totalLiability)}',style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold,color: AppColors.primaryColor),))

                            ],
                          )
                      ),

                    ],
                  ),
                  SizedBox(height: 40,),
                  Container(width: Get.width * 1,height:1,color: Colors.grey.withOpacity(.4),),
                  SizedBox(height: 40,),
                  Row(
                    children: [
                      Expanded(
                          child: Column(
                            children: [
                              Text('Verified Funds & Assets',style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold,color: AppColors.secondaryColor),),
                              Obx(() => Text('\$${UtilMethods().formatNumberWithCommas(controller.totalVerifiedFunds)}',style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold,color: AppColors.primaryColor),))
                            ],
                          )
                      ),
                      Expanded(
                          child: Column(
                            children: [
                              Text('Borrower Funds & Assets',style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold,color: AppColors.secondaryColor),),
                              Obx(() => Text('\$${UtilMethods().formatNumberWithCommas(controller.totalFunds)}',style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold,color: AppColors.primaryColor),))
                            ],
                          )
                      ),

                    ],
                  ).paddingOnly(bottom: 100),
                ],
              ),
            )
          ),
          );
        }
    );
  }

}