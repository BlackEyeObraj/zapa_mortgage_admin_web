import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_network/image_network.dart';
import 'package:zapa_mortgage_admin_web/controllers/agent_conversation_view_controller.dart';
import 'package:zapa_mortgage_admin_web/utils/dialogs/chat_dialog.dart';

import '../../res/app_colors.dart';

class AgentConversationView extends GetView<AgentConversationViewController>{
  final String borrowerId;
  final String borrowerPhoneNumber;
  final String borrowerName;
  AgentConversationView({required this.borrowerId, required this.borrowerPhoneNumber, required this.borrowerName});
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: AgentConversationViewController(),
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
                        'Conversation with Agent',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                            color: AppColors.textColorWhite
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text('Borrower Name: ',style: TextStyle(color: AppColors.textColorWhite,fontWeight: FontWeight.bold),),
                              Text(borrowerName.isNotEmpty?borrowerName:'N/A',style: TextStyle(color: AppColors.textColorWhite,fontWeight: FontWeight.normal),),
                            ],
                          ),
                          Row(
                            children: [
                              Text('Borrower PhoneNumber: ',style: TextStyle(color: AppColors.textColorWhite,fontWeight: FontWeight.bold),),
                              Text(borrowerPhoneNumber.isNotEmpty?borrowerPhoneNumber:'N/A',style: TextStyle(color: AppColors.textColorWhite,fontWeight: FontWeight.normal),),
                            ],
                          ),
                        ],
                      ).marginOnly(left: 16),
                    )
                  ],
                )

              ),
              Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('users').doc(borrowerId).collection('AgentChat').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
                      if (documents.isEmpty) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.cancel,size: 100,color: AppColors.greyColor,),
                            SizedBox(height: 16,),
                            Text('No Chat found yet.'),
                          ],
                        );
                      }
                      return ListView.builder(
                          itemCount: documents.length,
                          itemBuilder: (context, index){
                            Map<String, dynamic> data = documents[index].data() as Map<String, dynamic>;
                            return Container(
                              width: Get.width * 1,
                              decoration: BoxDecoration(
                                color: AppColors.whiteColor,
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 2.0
                                  )
                                ],
                                border: Border.all(color: AppColors.primaryColor,width: 1),
                                borderRadius: BorderRadius.circular(10),

                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      // ClipRRect(
                                      //   borderRadius: BorderRadius.circular(10000),
                                      //   child: data['borrowerImage'] != ''?
                                      //   ImageNetwork(image: data['borrowerImage'], height: 60, width: 60):
                                      //   Container(
                                      //       height: 60,
                                      //       width: 60,
                                      //       decoration: BoxDecoration(
                                      //           color: AppColors.primaryColor,
                                      //           shape: BoxShape.circle,
                                      //           border: Border.all(color: AppColors.primaryColor)
                                      //       ),
                                      //       child: Icon(Icons.person,color: AppColors.whiteColor,size: 28,).paddingAll(6)
                                      //   ),
                                      // ),
                                      // CircleAvatar(
                                      //     radius: Get.height * .04,
                                      //     backgroundColor: AppColors.primaryColor,
                                      //     backgroundImage: data['userImage'] != ''
                                      //         ?
                                      //         // ? Image(image: NetworkImage(data['userImage']))
                                      //         : const AssetImage(AppImages.noUserImage) as ImageProvider
                                      // ),

                                      SizedBox(width: Get.width * .01,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          data['chatWith'] == 'agent'?
                                          RichText(
                                            text: TextSpan(
                                              text: 'Chat Room of Agent: ',
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                              children: <TextSpan>[
                                                TextSpan(text: data['agentName'] != ''?data['agentName']:'N/A', style: TextStyle(fontWeight: FontWeight.normal)),
                                              ],
                                            ),
                                          ):RichText(
                                            text: TextSpan(
                                              text: 'Chat Room of: ',
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                              children: <TextSpan>[
                                                TextSpan(text: data['borrowerName'] != ''?data['borrowerName']:data['borrowerPhoneNumber'], style: TextStyle(fontWeight: FontWeight.normal)),
                                              ],
                                            ),
                                          ),

                                        ],
                                      ).paddingSymmetric(vertical: 8)
                                    ],
                                  ),
                                  SizedBox(
                                    child: ElevatedButton(onPressed: (){
                                      ChatDialog().chatDialog(data['agentId'],borrowerId,data['agentName']);
                                    }, child: Row(
                                      children: [
                                        Text('Enter Chat '),
                                        Icon(Icons.message,size: 16,),
                                      ],
                                    )),
                                  )
                                ],
                              ).paddingSymmetric(horizontal: 16),
                            ).paddingAll(16);
                          }
                      );
                    }
                  )
              )
            ],
          ),

        );
        }
    );
  }

}