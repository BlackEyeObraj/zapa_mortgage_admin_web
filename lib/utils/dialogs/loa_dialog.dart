import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zapa_mortgage_admin_web/res/app_colors.dart';

import '../../models/loa_model.dart';

class LOADialog {
  Future showLOA() {
    return Get.defaultDialog(
      title: 'Select LOA to Filter',
      titleStyle: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryColor),
      content: Container(
        height: 500,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('AdminMembers').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            final adminMembers = snapshot.data?.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return AdminMember(name: data['name']); // Adjust fields accordingly
            }).toList();

            return ListView.builder(
              itemCount: adminMembers?.length ?? 0,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final adminMember = adminMembers![index];
                return Text(adminMember.name);
              },
            );
          },
        ),
      ),
    );
  }

}
