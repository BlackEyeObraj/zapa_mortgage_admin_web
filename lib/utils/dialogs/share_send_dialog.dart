import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zapa_mortgage_admin_web/controllers/borrower_discussion_view_controller.dart';
import 'package:zapa_mortgage_admin_web/services/firestore_service.dart';

import '../../res/app_colors.dart';

class ShareSendDialog{
  shareAndSend(String message, String borrowerId, String borrowerName, String borrowerPhoneNumber) {
    return Get.dialog(
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: 16.0, horizontal: Get.width * .18),
            child: Material(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20), // Rounded edges
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20)
                ),
                child: Column(
                  children: [
                    Align(alignment: Alignment.centerLeft,child: Text('Select Agent to send message',
                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 28,color: AppColors.primaryColor),)),
                    Expanded(
                      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance.collection('agent_test').snapshots(),
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            // While the data is loading, show a loading indicator.
                            return Center(child: CircularProgressIndicator());
                          }

                          if (snapshot.hasError) {
                            // Handle any errors that occurred while fetching the data.
                            return Text('Error: ${snapshot.error}');
                          }

                          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                            // If there is no data, display a message.
                            return Text('No users found.');
                          }

                          // If the data is loaded successfully, process and display it.
                          final List<QueryDocumentSnapshot<Map<String, dynamic>>> documents = snapshot.data!.docs;

                          // Use the 'documents' list to display user data.
                          return  ListView.builder(
                            itemCount: documents.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final userData = documents[index].data();
                              final agentId = userData['agentId'];
                              final agentName = userData['name'];

                              // Display user information in ListTile or any other widget.
                              return Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.primaryColor, width: 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(agentName, style: TextStyle(fontWeight: FontWeight.bold)).paddingAll(16),
                                    ElevatedButton(
                                        onPressed: (){
                                          FirestoreService().shareMessageWithAgent(message,borrowerId,borrowerName,borrowerPhoneNumber,agentId,agentName);
                                        },
                                        child: Row(
                                          children: [
                                            Text('Share'),
                                            SizedBox(width: 18,),
                                            Icon(Icons.send,color: AppColors.whiteColor,size: 16,)
                                          ],
                                        )
                                    ).marginOnly(right: 16),
                                  ],
                                ),
                              ).marginSymmetric(vertical: 8);
                            },
                          );
                        },
                      ),
                    ),

                  ],
                ).marginAll(16),
              )
            )
        )
    );
  }

  shareWithBorrower(String message, String borrowerId, String borrowerName, String borrowerPhoneNumber){
    FirestoreService().shareMessageWithBorrower(message,borrowerId,borrowerName,borrowerPhoneNumber);
  }
  shareWithBorrowerAndAgent(String message, String borrowerId, String borrowerName, String borrowerPhoneNumber){
    return Get.dialog(
        Padding(
            padding: EdgeInsets.symmetric(
                vertical: 16.0, horizontal: Get.width * .18),
            child: Material(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Rounded edges
                ),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: Column(
                    children: [
                      Align(alignment: Alignment.centerLeft,child: Text('Select Agent to send message',
                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 28,color: AppColors.primaryColor),)),
                      Expanded(
                        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: FirebaseFirestore.instance.collection('agent_test').snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              // While the data is loading, show a loading indicator.
                              return Center(child: CircularProgressIndicator());
                            }

                            if (snapshot.hasError) {
                              // Handle any errors that occurred while fetching the data.
                              return Text('Error: ${snapshot.error}');
                            }

                            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                              // If there is no data, display a message.
                              return Text('No users found.');
                            }

                            // If the data is loaded successfully, process and display it.
                            final List<QueryDocumentSnapshot<Map<String, dynamic>>> documents = snapshot.data!.docs;

                            // Use the 'documents' list to display user data.
                            return  ListView.builder(
                              itemCount: documents.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final userData = documents[index].data();
                                final agentId = userData['agentId'];
                                final agentName = userData['name'];

                                // Display user information in ListTile or any other widget.
                                return Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppColors.primaryColor, width: 1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(agentName, style: TextStyle(fontWeight: FontWeight.bold)).paddingAll(16),
                                      ElevatedButton(
                                          onPressed: (){
                                            FirestoreService().shareMessageWithBorrowerAndAgent(message,borrowerId,borrowerName,borrowerPhoneNumber,agentId,agentName);
                                          },
                                          child: Row(
                                            children: [
                                              Text('Share'),
                                              SizedBox(width: 18,),
                                              Icon(Icons.send,color: AppColors.whiteColor,size: 16,)
                                            ],
                                          )
                                      ).marginOnly(right: 16),
                                    ],
                                  ),
                                ).marginSymmetric(vertical: 8);
                              },
                            );
                          },
                        ),
                      ),

                    ],
                  ).marginAll(16),
                )
            )
        )
    );
  }

}