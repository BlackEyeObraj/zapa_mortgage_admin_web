import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zapa_mortgage_admin_web/services/firestore_service.dart';
import 'package:zapa_mortgage_admin_web/utils/snack_bar.dart';
import 'package:zapa_mortgage_admin_web/utils/utils_mehtods.dart';

import '../../res/app_colors.dart';

class ChatDialog{

  chatDialog(String agentId, String borrowerId, String agentName){
    final messageController = TextEditingController();
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
                      Align(alignment: Alignment.centerLeft,child: Text('Chat of Agent: $agentName',
                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 28,color: AppColors.primaryColor),)),
                      Expanded(
                        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: FirebaseFirestore.instance.collection('users').doc(borrowerId).collection('AgentChat').doc(agentId).collection('Messages').orderBy('addedDateTime', descending: true).snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              // While the data is loading, show a loading indicator.
                              return Center(child: CircularProgressIndicator());
                            }

                            if (snapshot.hasError) {
                              // Handle any errors that occurred while fetching the data.
                              print(snapshot.error);
                              return Text('Error: ${snapshot.error}');
                            }

                            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                              // If there is no data, display a message.
                              return Center(child: Text('No messages found.'));
                            }

                            // If the data is loaded successfully, process and display it.
                            final List<QueryDocumentSnapshot<Map<String, dynamic>>> documents = snapshot.data!.docs;

                            // Use the 'documents' list to display user data.
                            return ListView.builder(
                              reverse: true, // Start from the bottom
                              itemCount: documents.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final userData = documents[index].data();
                                final from = userData['from'];
                                final message = userData['message'];
                                final addedDateTime = userData['addedDateTime'];
                                // Determine the alignment based on the sender (admin or user)
                                final alignment = from == 'admin' ? Alignment.centerRight : Alignment.centerLeft;

                                // Display user information in ListTile or any other widget.
                                return Align(
                                  alignment: alignment,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: from == 'admin' ? AppColors.primaryColor : Colors.grey.withOpacity(.4), // Customize the color
                                    ),
                                    padding: EdgeInsets.all(8),
                                    margin: EdgeInsets.symmetric(vertical: 4),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          message,
                                          style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16,
                                            color: from == 'admin' ? Colors.white : Colors.black, // Customize the text color
                                          ),
                                        ),
                                        SizedBox(height: 8), // Add some spacing
                                        Text(
                                          'Added on: ${UtilMethods().parseFirestoreTimestamp(addedDateTime)}', // Display the addedDateTime below the message
                                          style: TextStyle(
                                            fontSize: 8,
                                            color: from == 'admin' ? Colors.white : Colors.black.withOpacity(.6), // Customize the text color
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ).paddingOnly(bottom: 16),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: messageController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Type Message Here...'
                              ),
                            ),
                          ),
                          IconButton(onPressed: (){
                            if(messageController.text.isEmpty){
                              SnackBarApp().errorSnack('Form Error ', 'Please enter a message to send');
                            }else{
                              FirestoreService().sendMessage(agentId,messageController.text,borrowerId);
                              messageController.clear();
                            }
                          }, icon: Icon(Icons.send))
                        ],
                      )

                    ],
                  ).marginAll(16),
                )
            )
        )
    );
  }
}