import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/fico_view_controller.dart';
import '../../res/app_colors.dart';
import '../../services/firestore_service.dart';
import '../../utils/dialogs/fico_dialog.dart';
import '../../utils/widgets/text_widget.dart';

class FicoView extends GetView<FicoViewController>{
  final String borrowerId;
  FicoView({required this.borrowerId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: FicoViewController(),
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
                    'FICO',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      color: AppColors.textColorWhite
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text('Verified FICO Score',style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold,color: AppColors.secondaryColor),).marginOnly(top: 16),
                          Expanded(
                            child: StreamBuilder<DocumentSnapshot>(
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
                                return Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(zapaScoreValue ?? '0',
                                        style: TextStyle(fontSize: 100,fontWeight: FontWeight.bold,color: AppColors.primaryColor),),
                                      IconButton(onPressed: (){
                                        FicoDialog().addFicoDialogue(borrowerId,zapaScoreValue ?? '0','zapa');
                                      }, icon: Icon(Icons.edit,color: AppColors.secondaryColor,))
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),

                        ],
                      ),
                    ),
                    Container(
                      height: Get.height * 1,
                      width: 1,
                      color: Colors.grey.withOpacity(.4),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text('Borrower FICO Score',style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold,color: AppColors.secondaryColor),).marginOnly(top: 16),
                          Expanded(
                            child: StreamBuilder<DocumentSnapshot>(
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
                                return Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(userScoreValue?? '0',
                                        style: TextStyle(fontSize: 100,fontWeight: FontWeight.bold,color: AppColors.primaryColor),),
                                      IconButton(onPressed: (){
                                        FicoDialog().addFicoDialogue(borrowerId,userScoreValue ?? '0','borrower');

                                      }, icon: Icon(Icons.edit,color: AppColors.secondaryColor,))
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
        }
    );
  }

}