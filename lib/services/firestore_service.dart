import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zapa_mortgage_admin_web/utils/constants.dart';
import 'package:zapa_mortgage_admin_web/utils/dialogs/otp_dialog.dart';

enum SignResponseReturns {
  loginSuccess,
  emailNotFound,
  wrongPassword,
  otherException,
  accountNotActive
}

class FirestoreService extends GetxService {
  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  final box = GetStorage();

  addNewBorrower(String borrowerName,String phoneNumber) async {
    DocumentReference newDocRef = FirebaseFirestore.instance.collection('users').doc();
    String newUserId = newDocRef.id;
    await newDocRef.set({
      'userId': newUserId,
      'phoneNumber': phoneNumber,
      'accountCreatedDate': DateTime.now(),
      'userName' : borrowerName,
      'nickName' : '',
      'userImage' : '',
      'assignedTo' : '',
      'borrowerActiveLastDateTime' : DateTime.now(),
      'lastViewedBy' : '',
      'lastViewTimeBy' : '',
      'doNotCall' : 'no',
      'lastEngagement' : '',
      'nextEngagement' : '',
      'customerAgent' : '',
      'ourAgent' : '',
      'agentCheckBorrower' : '',
    });
    Get.back();
  }
  phoneAuthService(String borrowerName,String phoneNumber) async {
    try{
      // await FirebaseAuth.instance.verifyPhoneNumber(
      //   phoneNumber: phoneNumber,
      //   verificationCompleted: (PhoneAuthCredential credential) async {
      //     // await auth.signInWithCredential(credential);
      //   },
      //   verificationFailed: (FirebaseAuthException e) {
      //     if (e.code == 'invalid-phone-number') {
      //       print(e.code.toString());
      //     }
      //   },
      //   codeSent: (String verificationId, int? resendToken) {
      //     OtpDialog().otpDialog(borrowerName,verificationId);
      //   },
      //   codeAutoRetrievalTimeout: (String verificationId) {
      //   },
      // );
      ConfirmationResult confirmationResult = await auth.signInWithPhoneNumber(phoneNumber);
      print(confirmationResult.verificationId);
      OtpDialog().otpDialog(borrowerName, confirmationResult.verificationId,confirmationResult,auth);
      // verifyOtpCode(confirmationResult.verificationId, 'otpCode', borrowerName,confirmationResult);
    }catch(e){
      print(e.toString());
    }

  }
  verifyOtpCode(String verificationId, String otpCode,String borrowerName, ConfirmationResult confirmationResult, FirebaseAuth auth) async {
    UserCredential userCredential = await confirmationResult.confirm(otpCode);
    String userId = userCredential.user!.uid;
    String? userPhoneNumber = userCredential.user!.phoneNumber;
    await FirebaseFirestore.instance.collection('users').doc(userId).set({
      'userId': userId,
      'phoneNumber': userPhoneNumber,
      'accountCreatedDate': DateTime.now(),
      'userName' : borrowerName,
      'nickName' : '',
      'userImage' : '',
      'assignedTo' : '',
      'borrowerActiveLastDateTime' : '',
      'lastViewedBy' : '',
      'lastViewTimeBy' : '',
      'doNotCall' : 'no',
      'lastEngagement' : '',
      'nextEngagement' : '',
      'customerAgent' : '',
      'ourAgent' : '',
      'agentCheckBorrower' : '',
    });
    await auth.signOut();
    Get.back();
    Get.back();
    // try {
    //   final credentials = PhoneAuthProvider.credential(
    //     verificationId: verificationId,
    //     smsCode: otpCode,
    //   );
    //   await auth.signInWithCredential(credentials);
    //   String userId = auth.currentUser!.uid;
    //   String? userPhoneNumber = auth.currentUser!.phoneNumber;
    //     await FirebaseFirestore.instance.collection('users').doc(userId).set({
    //       'userId': userId,
    //       'phoneNumber': userPhoneNumber,
    //       'accountCreatedDate': DateTime.now(),
    //       'userName' : borrowerName,
    //       'nickName' : '',
    //       'userImage' : '',
    //       'assignedTo' : '',
    //       'borrowerActiveLastDateTime' : '',
    //       'lastViewedBy' : '',
    //       'lastViewTimeBy' : '',
    //       'doNotCall' : 'no',
    //       'lastEngagement' : '',
    //       'nextEngagement' : '',
    //       'customerAgent' : '',
    //       'ourAgent' : '',
    //       'agentCheckBorrower' : '',
    //     });

    // } catch (error) {
    //   Get.back();
    //   print(error.toString());
    // }
  }

  Future<String> getAccountStatus(String docId) async {
    try {
      var documentSnapshot = await firestore.collection('AdminMembers').doc(docId).get();
      if (documentSnapshot.exists) {
        var data = documentSnapshot.data() as Map<String, dynamic>;
        return data['loginStatus'];
      } else {
        return 'false'; // Document doesn't exist
      }
    } catch (error) {
      return 'false';
    }
  }
  Stream<String> getAccountStatusStream(String docId) {
    return FirebaseFirestore.instance.collection('AdminMembers').doc(docId).snapshots().map((documentSnapshot) {
      if (documentSnapshot.exists) {
        var data = documentSnapshot.data() as Map<String, dynamic>;
        return data['accountStatus'].toString();
      } else {
        return 'inActive'; // Document doesn't exist
      }
    });
  }

  Future<SignResponseReturns> signInWithEmailPassword(
      String email,
      String password) async {
    try {
      final QuerySnapshot<
          Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('AdminMembers')
          .where('email', isEqualTo: email.trim())
          .get();
      if (snapshot.size == 1) {
        final userDocument = snapshot.docs[0];
        final String storedEmail = userDocument['email'];
        final String name = userDocument['name'];
        final String storedPassword = userDocument['password'];
        final String uid = userDocument['uid'];
        final String accountStatus = userDocument['accountStatus'];

        if (storedPassword == password) {

          if(accountStatus == 'active'){
            final box = GetStorage();
            await box.write(Constants.USER_ID, uid);
            await box.write(Constants.USER_NAME, name);
            await box.write(Constants.USER_EMAIL, email.trim());
            setLoginStatus(uid,'true');
            await FirebaseFirestore.instance
                .collection('AdminMembers').doc(uid).update({'loginStatus': 'true'});
            return SignResponseReturns.loginSuccess;
          }
          return SignResponseReturns.accountNotActive;
        } else {
          return SignResponseReturns.wrongPassword;
        }
      } else {
        return SignResponseReturns.emailNotFound;
      }
    } catch (e) {
      print(e.toString());
      return SignResponseReturns.otherException;
    }
  }
  setLoginStatus(String uid,String status)async{
    await FirebaseFirestore.instance
        .collection('AdminMembers').doc(uid).update({'loginStatus': status});
  }
  setLastEngagementDateTime(String uid,String dateTime)async{
    await FirebaseFirestore.instance
        .collection('users').doc(uid).update({'lastEngagement': dateTime});
  }
  setNextEngagementDateTime(String uid,String dateTime)async{
    await FirebaseFirestore.instance
        .collection('users').doc(uid).update({'nextEngagement': dateTime});

  }
  setLastViewedBy(String uid,String name, DateTime dateTime)async{
    await FirebaseFirestore.instance
        .collection('users').doc(uid).update({
      'lastViewedBy': name,
      'lastViewTimeBy':dateTime.toString()
        });
  }
  setUserAssignedTo(String uid,String name)async{
    await FirebaseFirestore.instance
        .collection('users').doc(uid).update({'assignedTo': name});
  }
  Future<List<String>> fetchAdminUsers() async {
    List<String> items = [];
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('AdminMembers').get();
    snapshot.docs.forEach((doc) {
      String itemName = doc['name'];
      items.add(itemName);
    });
    return items;
  }
  Future<List<String>> fetchAdminFilter() async {
    List<String> items = [];
    items.add('All');
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('AdminMembers').get();
    snapshot.docs.forEach((doc) {
      String itemName = doc['name'];
      items.add(itemName);
    });
    return items;
  }
  getUsers(String value){
    if(value.isEmpty || value == 'All'){
      Query<Map<String, dynamic>> users = FirebaseFirestore.instance.collection('users');
      return users;
    }else{
      Query<Map<String, dynamic>> users = FirebaseFirestore.instance.collection('users')
          .where('assignedTo',isEqualTo: value);
      return users;
    }

  }

  addRemarksAndNotes(String remarkAndNote) async {
    DocumentReference docRef = await firestore.collection('RemarksAndNotes').add({
      'remarkAndNote': remarkAndNote,
      'addedDateTime': DateTime.now(),
      'addedBy': box.read(Constants.USER_NAME),
      'userId': box.read(Constants.USER_ID),
    });
    String docId = docRef.id;
    await docRef.update({'id': docId});
    Get.back();
  }
  // addMessage(String borrowerId,String message) async {
  //   DocumentReference docRef = await firestore.collection('users').doc(borrowerId).set({
  //     'message': message,
  //     'addedDateTime': DateTime.now(),
  //     'addedBy': box.read(Constants.USER_NAME),
  //     'userId': box.read(Constants.USER_ID),
  //   });
  //   String docId = docRef.id;
  //   await docRef.update({'id': docId});
  //   Get.back();
  // }
  Future<void> addMessage(String borrowerId, String message) async {
    try {
      DocumentReference userDocRef =
      firestore.collection('users').doc(borrowerId);

      CollectionReference messagesCollectionRef =
      userDocRef.collection('Messages');

      DocumentReference docRef = messagesCollectionRef.doc();

      await docRef.set({
        'message': message,
        'addedDateTime': DateTime.now(),
        'addedBy': box.read(Constants.USER_NAME),
        'adminId': box.read(Constants.USER_ID),
        'borrowerId': borrowerId,
      });

      await docRef.update({'id': docRef.id});

      Get.back();
    } catch (error) {
      print('Error adding message: $error');
      // Handle the error here
    }
  }

  void editRemarksAndNotes(String documentId, Map<String, dynamic> updatedData) async {
    CollectionReference collectionReference = FirebaseFirestore.instance.collection('RemarksAndNotes');
    DocumentReference docReference = collectionReference.doc(documentId);
    try {
      await docReference.update(updatedData);
      print('Document updated successfully');
      Get.back();
    } catch (e) {
      print('Error updating document: $e');
    }
  }
  void editMessage(String borrowerId,String id, Map<String, dynamic> updatedData) async {
    CollectionReference collectionReference = FirebaseFirestore.instance.collection('users').doc(borrowerId).collection('Messages');
    DocumentReference docReference = collectionReference.doc(id);
    try {
      await docReference.update(updatedData);
      print('Document updated successfully');
      Get.back();
    } catch (e) {
      print('Error updating document: $e');
    }
  }
  Stream<DocumentSnapshot<Map<String, dynamic>>> getIncome(String borrowerId) async* {
    yield* FirebaseFirestore.instance
        .collection('users')
        .doc(borrowerId)
        .snapshots()
        .map((snapshot) => snapshot);
  }
  Future<void> updateIncomeStatus(String borrowerId,int index, String newStatus) async {
    String userId = borrowerId;
    CollectionReference usersCollection =
    FirebaseFirestore.instance.collection('users');

    DocumentSnapshot<Object?> snapshot =
    await usersCollection.doc(userId).get();

    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    List<dynamic> liabilities = data['incomes'];
    liabilities[index]['status'] = newStatus;

    await usersCollection.doc(userId).update({
      'incomes': liabilities,
    });
    // Get.put(HomeScreenController()).setTotal();
  }
  Future<void> updateIncomeIncludeItStatus(String borrowerId,int index, bool newStatus) async {
    String userId = borrowerId;
    CollectionReference usersCollection =
    FirebaseFirestore.instance.collection('users');

    DocumentSnapshot<Object?> snapshot =
    await usersCollection.doc(userId).get();

    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    List<dynamic> incomes = data['incomes'];
    incomes[index]['includeIt'] = newStatus;

    await usersCollection.doc(userId).update({
      'incomes': incomes,
    });
    // Get.put(HomeScreenController()).setTotal();
  }
  void deleteRemarksAndNotes(String documentId) async {
    CollectionReference collectionReference = firestore.collection('RemarksAndNotes');
    DocumentReference docReference = collectionReference.doc(documentId);
    try {
      await docReference.delete();
      print('Document deleted successfully');
      Get.back();
    } catch (e) {
      print('Error deleting document: $e');
    }
  }
  void deleteMessage(String id,String borrowerID) async {
    CollectionReference collectionReference = firestore.collection('users').doc(borrowerID).collection('Messages');
    DocumentReference docReference = collectionReference.doc(id);
    try {
      await docReference.delete();
      print('Document deleted successfully');
      Get.back();
    } catch (e) {
      print('Error deleting document: $e');
    }
  }
  getRemarksAndNotes(){
    CollectionReference remarksAndNotes = FirebaseFirestore.instance.collection('RemarksAndNotes');
    return remarksAndNotes.orderBy('addedDateTime', descending: true);
  }
  getMessages(String borrowerId){
    CollectionReference remarksAndNotes = FirebaseFirestore.instance.collection('users').doc(borrowerId).collection('Messages');
    return remarksAndNotes.orderBy('addedDateTime', descending: true);
  }
  void addEditUserNickName(String userId, Map<String, dynamic> updatedData, String nickName, String userName, String phoneNumber) async {
    CollectionReference collectionReference = FirebaseFirestore.instance.collection('users');
    DocumentReference docReference = collectionReference.doc(userId);
    try {
      await docReference.update(updatedData);
      print('Document updated successfully');
      await historyDataAdd("${box.read(Constants.USER_NAME)} has change nick name to ${nickName.isEmpty?'N/A':nickName} of ${userName.isEmpty?phoneNumber:userName}");
      Get.back();
    } catch (e) {
      print('Error updating document: $e');
    }
  }
  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserDataNameStream(String userId) {
    return FirebaseFirestore.instance.collection('users').doc(userId).snapshots();
  }

  Stream<DocumentSnapshot> getFicoScoreReal(String borrowerId) async* {
    yield* FirebaseFirestore.instance
        .collection('users')
        .doc(borrowerId)
        .snapshots();
  }
  Stream<double> calculateTotalVerifiedIncomesListener(String borrowerId) async* {
    String userId = borrowerId ;
    var userRef = FirebaseFirestore.instance.collection('users').doc(userId);
    var userSnapshotStream = userRef.snapshots();

    await for (var snapshot in userSnapshotStream) {
      if (!snapshot.exists || snapshot.data() == null) {
        yield 0.0;
        continue;
      }

      List<dynamic>? liabilities = snapshot.data()!['incomes'];
      if (liabilities == null || liabilities.isEmpty) {
        yield 0.0;
        continue;
      }

      double totalAmount = 0.0;
      for (var liability in liabilities) {
        String? addedBy = liability['addedBy'];
        String? verifyStatus = liability['verifyStatus'];
        String? monthlyAmountStr = liability['monthlyIncome']?.toString();
        if (addedBy != null && verifyStatus != null && monthlyAmountStr != null){
          if (addedBy == 'processor' && verifyStatus == "Verified"){
            double amount = double.tryParse(monthlyAmountStr) ?? 0.0;
            totalAmount += amount;
          }
        }
      }
      yield double.parse(totalAmount.toStringAsFixed(2));
    }
  }
  Stream<double> calculateTotalIncludedIncomeListener(String borrowerId) async* {
    String userId = borrowerId;
    var userRef = FirebaseFirestore.instance.collection('users').doc(userId);
    var userSnapshotStream = userRef.snapshots();

    await for (var snapshot in userSnapshotStream) {
      if (!snapshot.exists || snapshot.data() == null) {
        yield 0.0;
        continue;
      }

      List<dynamic>? incomes = snapshot.data()!['incomes'];
      if (incomes == null || incomes.isEmpty) {
        yield 0.0;
        continue;
      }

      double totalAmount = 0.0;
      for (var income in incomes) {
        String? addedBy = income['addedBy'];
        String? status = income['status'];
        String? monthlyAmountStr = income['monthlyIncome']?.toString();
        if (addedBy != null && status != null && monthlyAmountStr != null){
          if (addedBy == 'customer' && status == 'Include' || income['type'] == 'business'&& status == 'Exclude'  && income['greaterOrLessThen2Years'] == 'false' && income['includeIt'] == true){
            double amount = double.tryParse(monthlyAmountStr) ?? 0.0;
            totalAmount += amount;
          }
        }
      }
      yield double.parse(totalAmount.toStringAsFixed(2));
    }
  }

  Stream<double> calculateTotalVerifiedLiabilityListener(String borrowerId) async* {
    String userId = borrowerId;
    var userRef = FirebaseFirestore.instance.collection('users').doc(userId);
    var userSnapshotStream = userRef.snapshots();

    await for (var snapshot in userSnapshotStream) {
      if (!snapshot.exists || snapshot.data() == null) {
        yield 0.0;
        continue;
      }

      List<dynamic>? liabilities = snapshot.data()!['liability'];
      if (liabilities == null || liabilities.isEmpty) {
        yield 0.0;
        continue;
      }

      double totalAmount = 0.0;
      for (var liability in liabilities) {
        String? addedBy = liability['addedBy'];
        String? verifyStatus = liability['verifyStatus'];
        String? monthlyAmountStr = liability['monthlyAmount']?.toString();
        if (addedBy != null && verifyStatus != null && monthlyAmountStr != null){
          if (addedBy == 'processor' && verifyStatus == "Verified"){
            double amount = double.tryParse(monthlyAmountStr) ?? 0.0;
            totalAmount += amount;
          }
        }
      }
      yield double.parse(totalAmount.toStringAsFixed(2));
    }
  }
  Stream<double> calculateTotalIncludedLiabilityListener(String borrowerId) async* {
    String userId = borrowerId;
    var userRef = FirebaseFirestore.instance.collection('users').doc(userId);
    var userSnapshotStream = userRef.snapshots();

    await for (var snapshot in userSnapshotStream) {
      if (!snapshot.exists || snapshot.data() == null) {
        yield 0.0;
        continue;
      }

      List<dynamic>? liabilities = snapshot.data()!['liability'];
      if (liabilities == null || liabilities.isEmpty) {
        yield 0.0;
        continue;
      }

      double totalAmount = 0.0;
      for (var liability in liabilities) {
        String? addedBy = liability['addedBy'];
        String? status = liability['status'];
        String? monthlyAmountStr = liability['monthlyAmount']?.toString();
        if (addedBy != null && status != null && monthlyAmountStr != null){
          if (addedBy == 'customer' && status == "Include"){
            double amount = double.tryParse(monthlyAmountStr) ?? 0.0;
            totalAmount += amount;
          }
        }
      }
      yield double.parse(totalAmount.toStringAsFixed(2));
    }
  }

  Stream<double> calculateTotalVerifiedFundsListener(String borrowerId) async* {
    String userId = borrowerId;
    var userRef = FirebaseFirestore.instance.collection('users').doc(userId);
    var userSnapshotStream = userRef.snapshots();

    await for (var snapshot in userSnapshotStream) {
      if (!snapshot.exists || snapshot.data() == null) {
        yield 0.0;
        continue;
      }

      List<dynamic>? liabilities = snapshot.data()!['funds'];
      if (liabilities == null || liabilities.isEmpty) {
        yield 0.0;
        continue;
      }

      double totalAmount = 0.0;
      for (var liability in liabilities) {
        String? addedBy = liability['addedBy'];
        String? verifyStatus = liability['verifyStatus'];
        String? monthlyAmountStr = liability['currentBalance']?.toString();
        String? assetType = liability['assetType']?.toString();
        String? userVerifiedFund = liability['userVerifiedFund']?.toString();
        if (addedBy != null && verifyStatus != null && monthlyAmountStr != null){
          if (addedBy == 'processor' && verifyStatus == "Verified" || addedBy == 'customer' && assetType == "Gift Funds - from Donor" && userVerifiedFund == "true"){
            double amount = double.tryParse(monthlyAmountStr) ?? 0.0;
            totalAmount += amount;
          }
        }
      }
      yield double.parse(totalAmount.toStringAsFixed(2));
    }
  }
  Stream<double> calculateTotalIncludedFundsListener(String borrowerId) async* {
    String userId = borrowerId;
    var userRef = FirebaseFirestore.instance.collection('users').doc(userId);
    var userSnapshotStream = userRef.snapshots();

    await for (var snapshot in userSnapshotStream) {
      if (!snapshot.exists || snapshot.data() == null) {
        yield 0.0;
        continue;
      }

      List<dynamic>? liabilities = snapshot.data()!['funds'];
      if (liabilities == null || liabilities.isEmpty) {
        yield 0.0;
        continue;
      }

      double totalAmount = 0.0;
      for (var liability in liabilities) {
        String? addedBy = liability['addedBy'];
        String? status = liability['status'];
        String? monthlyAmountStr = liability['currentBalance']?.toString();
        if (addedBy != null && status != null && monthlyAmountStr != null) {
          if (addedBy == 'customer' && status == "Include") {
            double amount = double.tryParse(monthlyAmountStr) ?? 0.0;
            totalAmount += amount;
          }
        }
      }

      print(totalAmount.toString());
      yield double.parse(totalAmount.toStringAsFixed(2));
    }
  }
  addFicoScore(String borrowerId,String ficoScore,String type) async {
    String userId = borrowerId;
    DocumentSnapshot userSnapshot = await firestore.collection('users').doc(userId).get();
    Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;
    if(type == 'borrower'){
      if (userData == null) {
        userData = {
          'fico': {
            'userScore': ficoScore,
          },
        };
      } else {
        userData['fico'] = {
          ...(userData['fico'] as Map<String, dynamic>? ?? {}),
          'userScore': ficoScore,
        };
      }
      await firestore.collection('users').doc(userId).set(userData);
    }else{
      if (userData == null) {
        userData = {
          'fico': {
            'zapaScore': ficoScore,
          },
        };
      } else {
        userData['fico'] = {
          ...(userData['fico'] as Map<String, dynamic>? ?? {}),
          'zapaScore': ficoScore,
        };
      }
      await firestore.collection('users').doc(userId).set(userData);
    }


  }
  Stream<DocumentSnapshot<Map<String, dynamic>>> getLiabilities(String borrowerId) async* {
    yield* FirebaseFirestore.instance
        .collection('users')
        .doc(borrowerId)
        .snapshots()
        .map((snapshot) => snapshot);
  }
  Stream<DocumentSnapshot<Map<String, dynamic>>> getFunds(String borrowerId, String searchFilter) async* {
    yield* FirebaseFirestore.instance
        .collection('users')
        .doc(borrowerId)
        .snapshots()
        .map((snapshot) => snapshot);
  }

  // Stream<QuerySnapshot<Map<String, dynamic>>> getFunds(String borrowerId, String searchFilter) {
  //   final controller = StreamController<QuerySnapshot<Map<String, dynamic>>>();
  //   FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(borrowerId)
  //       .snapshots()
  //       .listen((snapshot) {
  //     if (snapshot.exists) {
  //       final borrowerData = snapshot.data();
  //       final value = borrowerData!['addedBy']; // Replace 'yourFieldValue' with the actual field name you want to filter on
  //
  //       FirebaseFirestore.instance
  //           .collection('users')
  //           .where(searchFilter == 'All'?'':searchFilter == 'LOA'?'processor':searchFilter == 'Borrower'?'customer':'', isEqualTo: value) // Replace 'yourFieldName' with the actual field name you want to filter on
  //           .snapshots()
  //           .listen((filteredSnapshot) {
  //         controller.add(filteredSnapshot);
  //       });
  //     } else {
  //       // Handle the case where the borrowerId document doesn't exist
  //       // You can add an error message to the controller or close it here
  //       controller.addError('Borrower ID document not found');
  //     }
  //   });
  //
  //   return controller.stream;
  // }


  Future<void> updateUserVerifyFundValue(String borrowerId,int index, bool selectedAssetTypeEnable) async {
    String userId = borrowerId;
    CollectionReference usersCollection =
    FirebaseFirestore.instance.collection('users');

    DocumentSnapshot<Object?> snapshot =
    await usersCollection.doc(userId).get();

    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    List<dynamic> funds = data['funds'];
    funds[index]['userVerifiedFund'] = selectedAssetTypeEnable;

    await usersCollection.doc(userId).update({
      'funds': funds,
    });
    // await Get.put(HomeScreenController()).setTotal();

  }
  addFunds(String selectedAddedBy,String borrowerId,String assetType, String nameOfBank, String accountNumber, String currentBalance, bool userVerifiedFund, String verifyStatus, String addedByName)async{
    await firestore
        .collection('users')
        .doc(borrowerId)
        .update({
      'funds': FieldValue.arrayUnion([
        {
          'addedBy': selectedAddedBy,
          'assetType': assetType,
          'bankName': nameOfBank,
          'accountNumber': accountNumber,
          'currentBalance': currentBalance,
          'status':userVerifiedFund == true?'Include':'Exclude',
          'timestamp':DateTime.now(),
          'userVerifiedFund':userVerifiedFund,
          'verifyStatus':verifyStatus,
          'addedByName':addedByName
        }
      ])
    });
    // Get.put(HomeScreenController()).setTotal();
    Get.back();
  }
  Future<void> updateFundValues(String selectedAddedBy,String borrowerId,int index, String bankName, String accountNumber, String currentBalance, String assetType, bool selectedAssetTypeEnable, String status, String verifyStatus) async {
    String userId = borrowerId;
    CollectionReference usersCollection =
    FirebaseFirestore.instance.collection('users');

    DocumentSnapshot<Object?> snapshot =
    await usersCollection.doc(userId).get();

    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    List<dynamic> liabilities = data['funds'];
    liabilities[index]['addedBy'] = selectedAddedBy;
    liabilities[index]['accountNumber'] = accountNumber;
    liabilities[index]['assetType'] = assetType;
    liabilities[index]['bankName'] = bankName;
    liabilities[index]['currentBalance'] = currentBalance;
    liabilities[index]['userVerifiedFund'] = selectedAssetTypeEnable;
    liabilities[index]['status'] = status;
    liabilities[index]['verifyStatus'] = verifyStatus;

    await usersCollection.doc(userId).update({
      'funds': liabilities,
    });
    Get.back();
  }
  Future<void> removeFunds(int index, String borrowerID) async {
      CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
      DocumentSnapshot<Object?> snapshot =
      await usersCollection.doc(borrowerID).get();
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      List<dynamic> liabilities = data['funds'];
      liabilities.removeAt(index);

      await usersCollection.doc(borrowerID).update({
        'funds': liabilities,
      });
      // await Get.put(HomeScreenController()).setTotal();
      Get.back();

  }

  Stream<double> calculateTotalTotalGiftFundsListener(String borrowerId) async* {
    String userId = borrowerId;
    var userRef = FirebaseFirestore.instance.collection('users').doc(userId);
    var userSnapshotStream = userRef.snapshots();

    await for (var snapshot in userSnapshotStream) {
      if (!snapshot.exists || snapshot.data() == null) {
        yield 0.0;
        continue;
      }

      List<dynamic>? liabilities = snapshot.data()!['funds'];
      if (liabilities == null || liabilities.isEmpty) {
        yield 0.0;
        continue;
      }

      double totalAmount = 0.0;
      for (var liability in liabilities) {
        String? addedBy = liability['addedBy'];
        String? verifyStatus = liability['verifyStatus'];
        String? monthlyAmountStr = liability['currentBalance']?.toString();
        String? assetType = liability['assetType']?.toString();
        String? userVerifiedFund = liability['userVerifiedFund']?.toString();
        if (addedBy != null && verifyStatus != null && monthlyAmountStr != null){
          if (addedBy == 'customer' && assetType == "Gift Funds - from Donor" && userVerifiedFund == "true"){
            double amount = double.tryParse(monthlyAmountStr) ?? 0.0;
            totalAmount += amount;
          }
        }
      }
      yield double.parse(totalAmount.toStringAsFixed(2));
    }
  }

  Stream<double> calculateTotalExcludedPayOffBalanceListener(String borrowerId) async* {
    String userId = borrowerId;
    var userRef = FirebaseFirestore.instance.collection('users').doc(userId);
    var userSnapshotStream = userRef.snapshots();

    await for (var snapshot in userSnapshotStream) {
      if (!snapshot.exists || snapshot.data() == null) {
        yield 0.0;
        continue;
      }

      List<dynamic>? liabilities = snapshot.data()!['liability'];
      if (liabilities == null || liabilities.isEmpty) {
        yield 0.0;
        continue;
      }

      double totalAmount = 0.0;
      for (var liability in liabilities) {
        String? addedBy = liability['addedBy'];
        String? verifyStatus = liability['verifyStatus'];
        String? monthlyAmountStr = liability['balanceAmount']?.toString();
        String? executionReason = liability['executionReason']?.toString();
        if (addedBy != null && verifyStatus != null && monthlyAmountStr != null && executionReason != null){
          if (addedBy == 'processor' && verifyStatus == "Verified But Excluded" && executionReason == "To Be Paid"){
            double amount = double.tryParse(monthlyAmountStr) ?? 0.0;
            totalAmount += amount;
          }
        }
      }
      yield double.parse(totalAmount.toStringAsFixed(2));
    }
  }

  Stream<double> calculateTotalVerifiedButExcludedMonthlyLiabilityListener(String borrowerId) async* {
    String userId = borrowerId;
    var userRef = FirebaseFirestore.instance.collection('users').doc(userId);
    var userSnapshotStream = userRef.snapshots();

    await for (var snapshot in userSnapshotStream) {
      if (!snapshot.exists || snapshot.data() == null) {
        yield 0.0;
        continue;
      }

      List<dynamic>? liabilities = snapshot.data()!['liability'];
      if (liabilities == null || liabilities.isEmpty) {
        yield 0.0;
        continue;
      }

      double totalAmount = 0.0;
      for (var liability in liabilities) {
        String? addedBy = liability['addedBy'];
        String? verifyStatus = liability['verifyStatus'];
        String? monthlyAmountStr = liability['monthlyAmount']?.toString();
        if (addedBy != null && verifyStatus != null && monthlyAmountStr != null){
          if (addedBy == 'processor' && verifyStatus == "Verified But Excluded"){
            double amount = double.tryParse(monthlyAmountStr) ?? 0.0;
            totalAmount += amount;
          }
        }
      }
      yield double.parse(totalAmount.toStringAsFixed(2));
    }
  }

  Stream<double> calculateTotalVerifiedBalanceListener(String borrowerId) async* {
    String userId = borrowerId;
    var userRef = FirebaseFirestore.instance.collection('users').doc(userId);
    var userSnapshotStream = userRef.snapshots();

    await for (var snapshot in userSnapshotStream) {
      if (!snapshot.exists || snapshot.data() == null) {
        yield 0.0;
        continue;
      }

      List<dynamic>? liabilities = snapshot.data()!['liability'];
      if (liabilities == null || liabilities.isEmpty) {
        yield 0.0;
        continue;
      }

      double totalAmount = 0.0;
      for (var liability in liabilities) {
        String? addedBy = liability['addedBy'];
        String? verifyStatus = liability['verifyStatus'];
        String? monthlyAmountStr = liability['balanceAmount']?.toString();
        if (addedBy != null && verifyStatus != null && monthlyAmountStr != null){
          if (addedBy == 'processor' && verifyStatus == "Verified"){
            double amount = double.tryParse(monthlyAmountStr) ?? 0.0;
            totalAmount += amount;
          }
        }
      }
      yield double.parse(totalAmount.toStringAsFixed(2));
    }
  }

  Stream<double> calculateTotalBalanceLiabilityListener(String borrowerId) async* {
    String userId = borrowerId;
    var userRef = FirebaseFirestore.instance.collection('users').doc(userId);
    var userSnapshotStream = userRef.snapshots();

    await for (var snapshot in userSnapshotStream) {
      if (!snapshot.exists || snapshot.data() == null) {
        yield 0.0;
        continue;
      }

      List<dynamic>? liabilities = snapshot.data()!['liability'];
      if (liabilities == null || liabilities.isEmpty) {
        yield 0.0;
        continue;
      }

      double totalAmount = 0.0;
      for (var liability in liabilities) {
        String? addedBy = liability['addedBy'];
        String? status = liability['status'];
        String? balanceAmount = liability['balanceAmount']?.toString();
        if (addedBy != null && status != null && balanceAmount != null){
          if (addedBy == 'customer' && status == "Include"){
            double amount = double.tryParse(balanceAmount) ?? 0.0;
            totalAmount += amount;
          }
        }
      }
      yield double.parse(totalAmount.toStringAsFixed(2));
    }
  }

  Future<void> updateLiabilityStatus(int index, String newStatus,String borrowerID) async {
    String userId = borrowerID;
    CollectionReference usersCollection =
    FirebaseFirestore.instance.collection('users');

    DocumentSnapshot<Object?> snapshot =
    await usersCollection.doc(userId).get();

    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    List<dynamic> liabilities = data['liability'];
    liabilities[index]['status'] = newStatus;

    await usersCollection.doc(userId).update({
      'liability': liabilities,
    });
    // Get.put(HomeScreenController()).setTotal();
  }
  addLiability(String selectedAddedBy,String borrowerId,String liabilityName, String monthlyAmount, String selectedLiabilityType, String balanceAmount, String monthRemaining, String verifyStatus, String selectedExcludedReason, String addedByName, bool idoKnow, bool idoNotKnow) async {
    await firestore
        .collection('users')
        .doc(borrowerId)
        .update({
      'liability': FieldValue.arrayUnion([
        {
          'addedBy':selectedAddedBy,
          'name': liabilityName,
          'type':selectedLiabilityType,
          'monthlyAmount': monthlyAmount,
          'balanceAmount': balanceAmount,
          'monthRemaining': monthRemaining,
          'status':'Include',
          'verifyStatus':verifyStatus,
          'executionReason':selectedExcludedReason,
          'timestamp':DateTime.now(),
          'addedByName':addedByName,
          'iKnow':idoKnow,
          'iDoNotKnow':idoNotKnow,
        }
      ])
    });
    // Get.put(HomeScreenController()).setTotal();
    Get.back();
  }
  Future<void> updateLiabilityValues(int index, String selectedAddedBy,String borrowerId,String liabilityName, String monthlyAmount, String selectedLiabilityType, String balanceAmount, String monthRemaining, String verifyStatus, String selectedExcludedReason, bool idoKnow, bool idoNotKnow) async {
    CollectionReference usersCollection =
    FirebaseFirestore.instance.collection('users');

    DocumentSnapshot<Object?> snapshot =
    await usersCollection.doc(borrowerId).get();

    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    List<dynamic> liabilities = data['liability'];
    liabilities[index]['addedBy'] = selectedAddedBy;
    liabilities[index]['name'] = liabilityName;
    liabilities[index]['type'] = selectedLiabilityType;
    liabilities[index]['balanceAmount'] = balanceAmount;
    liabilities[index]['monthRemaining'] = monthRemaining;
    liabilities[index]['monthlyAmount'] = monthlyAmount;
    liabilities[index]['verifyStatus'] = verifyStatus;
    liabilities[index]['executionReason'] = selectedExcludedReason;
    liabilities[index]['iKnow'] = idoKnow;
    liabilities[index]['iDoNotKnow'] = idoNotKnow;

    await usersCollection.doc(borrowerId).update({
      'liability': liabilities,
    });
    Get.back();
    // Get.put(HomeScreenController()).setTotal();

  }
  Future<void> updateFundStatus(String borrowerId,int index, String newStatus) async {
    String userId = borrowerId;
    CollectionReference usersCollection =
    FirebaseFirestore.instance.collection('users');

    DocumentSnapshot<Object?> snapshot =
    await usersCollection.doc(userId).get();

    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    List<dynamic> funds = data['funds'];
    funds[index]['status'] = newStatus;

    await usersCollection.doc(userId).update({
      'funds': funds,
    });
    // Get.put(HomeScreenController()).setTotal();
  }
  updateCoBorrower(String id,String coBorrowerFICO, String coBorrowerIncome, String coBorrowerLiability)async{
    await firestore.collection('CoBorrowers').doc(id).update({
      'coBorrowerVerifiedFICO': coBorrowerFICO.isEmpty?'0':coBorrowerFICO,
      'coBorrowerVerifiedIncome': coBorrowerIncome.isEmpty?'0.00':coBorrowerIncome,
      'coBorrowerVerifiedLiability': coBorrowerLiability.isEmpty?'0.00':coBorrowerLiability,
    });
    Get.back();
  }
  getCoBorrower(String phoneNumber){
    return FirebaseFirestore.instance.collection('CoBorrowers').where('borrowerPhoneNumber',isEqualTo: phoneNumber).snapshots();
  }
  Stream<DocumentSnapshot> getCoBorrowerFICO(String coBorrowerId) async* {
    yield* FirebaseFirestore.instance
        .collection('users')
        .doc(coBorrowerId)
        .snapshots();
  }
  Stream<double> calculateTotalIncludedCoBorrowerIncomeListener(String coBorrowerId) async* {
    var userRef = FirebaseFirestore.instance.collection('users').doc(coBorrowerId);
    var userSnapshotStream = userRef.snapshots();

    await for (var snapshot in userSnapshotStream) {
      if (!snapshot.exists || snapshot.data() == null) {
        yield 0.0;
        continue;
      }

      List<dynamic>? incomes = snapshot.data()!['incomes'];
      if (incomes == null || incomes.isEmpty) {
        yield 0.0;
        continue;
      }

      double totalAmount = 0.0;
      for (var income in incomes) {
        String? addedBy = income['addedBy'];
        String? status = income['status'];
        String? monthlyAmountStr = income['monthlyIncome']?.toString();
        if (addedBy != null && status != null && monthlyAmountStr != null){
          if (addedBy == 'customer' && status == 'Include' || income['type'] == 'business'&& status == 'Exclude'  && income['greaterOrLessThen2Years'] == 'false' && income['includeIt'] == true){
            double amount = double.tryParse(monthlyAmountStr) ?? 0.0;
            totalAmount += amount;
          }
        }
      }
      yield double.parse(totalAmount.toStringAsFixed(2));
    }
  }
  Stream<double> calculateTotalCoBorrowerIncludedLiabilityListener(String coBorrowerId) async* {
    var userRef = FirebaseFirestore.instance.collection('users').doc(coBorrowerId);
    var userSnapshotStream = userRef.snapshots();

    await for (var snapshot in userSnapshotStream) {
      if (!snapshot.exists || snapshot.data() == null) {
        yield 0.0;
        continue;
      }

      List<dynamic>? liabilities = snapshot.data()!['liability'];
      if (liabilities == null || liabilities.isEmpty) {
        yield 0.0;
        continue;
      }

      double totalAmount = 0.0;
      for (var liability in liabilities) {
        String? addedBy = liability['addedBy'];
        String? status = liability['status'];
        String? monthlyAmountStr = liability['monthlyAmount']?.toString();
        if (addedBy != null && status != null && monthlyAmountStr != null){
          if (addedBy == 'customer' && status == "Include"){
            double amount = double.tryParse(monthlyAmountStr) ?? 0.0;
            totalAmount += amount;
          }
        }
      }
      yield double.parse(totalAmount.toStringAsFixed(2));
    }
  }
  Stream<double> calculateTotalVerifiedCoBorrowerIncomesListener(String coBorrowerId) async* {
    var userRef = FirebaseFirestore.instance.collection('users').doc(coBorrowerId);
    var userSnapshotStream = userRef.snapshots();

    await for (var snapshot in userSnapshotStream) {
      if (!snapshot.exists || snapshot.data() == null) {
        yield 0.0;
        continue;
      }

      List<dynamic>? liabilities = snapshot.data()!['incomes'];
      if (liabilities == null || liabilities.isEmpty) {
        yield 0.0;
        continue;
      }

      double totalAmount = 0.0;
      for (var liability in liabilities) {
        String? addedBy = liability['addedBy'];
        String? verifyStatus = liability['verifyStatus'];
        String? monthlyAmountStr = liability['monthlyIncome']?.toString();
        if (addedBy != null && verifyStatus != null && monthlyAmountStr != null){
          if (addedBy == 'processor' && verifyStatus == "Verified"){
            double amount = double.tryParse(monthlyAmountStr) ?? 0.0;
            totalAmount += amount;
          }
        }
      }
      yield double.parse(totalAmount.toStringAsFixed(2));
    }
  }
  Stream<double> calculateTotalCoBorrowerVerifiedLiabilityListener(String coBorrowerId) async* {
    var userRef = FirebaseFirestore.instance.collection('users').doc(coBorrowerId);
    var userSnapshotStream = userRef.snapshots();

    await for (var snapshot in userSnapshotStream) {
      if (!snapshot.exists || snapshot.data() == null) {
        yield 0.0;
        continue;
      }

      List<dynamic>? liabilities = snapshot.data()!['liability'];
      if (liabilities == null || liabilities.isEmpty) {
        yield 0.0;
        continue;
      }

      double totalAmount = 0.0;
      for (var liability in liabilities) {
        String? addedBy = liability['addedBy'];
        String? verifyStatus = liability['verifyStatus'];
        String? monthlyAmountStr = liability['monthlyAmount']?.toString();
        if (addedBy != null && verifyStatus != null && monthlyAmountStr != null){
          if (addedBy == 'processor' && verifyStatus == "Verified"){
            double amount = double.tryParse(monthlyAmountStr) ?? 0.0;
            totalAmount += amount;
          }
        }
      }
      yield double.parse(totalAmount.toStringAsFixed(2));
    }
  }
  addIncomeManual(String addedBy,String verifyStatus,String borrowerId,String companyName, String grossAnnualIncome, String monthlyIncome, String startDate, String endDate, String employerIncomeType, String baseYear, String w2year, String priorW2Year, String addedByName)async{
    await firestore
        .collection('users')
        .doc(borrowerId)
        .update({
      'incomes': FieldValue.arrayUnion([
        {
          'type':'income',
          'addedBy':addedBy,
          'companyName': companyName,
          'grossAnnualIncome': grossAnnualIncome,
          'monthlyIncome': monthlyIncome,
          'startDate': startDate,
          'endDate': endDate,
          'status':'Include',
          'addedType': 'manual',
          'employerIncomeType': employerIncomeType,
          'timestamp':DateTime.now(),
          'salaryCycle':'Monthly',
          'baseYear':baseYear,
          'w2Year':w2year,
          'priorW2Year':priorW2Year,
          'verifyStatus':verifyStatus,
          'addedByName':addedByName
        }
      ])
    });
    // Get.put(HomeScreenController()).setTotal();
    Get.back();
    Get.back();
  }
  addBusinessManual(String borrowerId,String businessName, String netProfitLoss, String monthlyIncome, String startDate, String businessIncomeType,String currentlyActive, String baseYear, String w2year, String priorW2Year, String businessStartDateStamp, String greaterOrLessThen2Years, String addedBy, String verifyStatus, String addedByName)async{
    await firestore
        .collection('users')
        .doc(borrowerId)
        .update({
      'incomes': FieldValue.arrayUnion([
        {
          'type':'business',
          'addedBy':addedBy,
          'addedByName':addedByName,
          'companyName': businessName,
          'grossAnnualIncome': netProfitLoss,
          'monthlyIncome': monthlyIncome,
          'startDate': startDate,
          'currentlyActive': currentlyActive,
          'status':currentlyActive == 'true' && greaterOrLessThen2Years ==  'true'?'Include':'Exclude',
          'addedType': 'manual',
          'employerIncomeType': businessIncomeType,
          'timestamp':DateTime.now(),
          'salaryCycle':'Monthly',
          'baseYear':baseYear,
          'w2Year':w2year,
          'priorW2Year':priorW2Year,
          'businessStartDateStamp':businessStartDateStamp,
          'greaterOrLessThen2Years':greaterOrLessThen2Years,
          'includeIt':greaterOrLessThen2Years ==  'true'?true:false,
          'verifyStatus':verifyStatus
        }
      ])
    });
    // Get.put(HomeScreenController()).setTotal();
    Get.back();
    Get.back();
  }
  Future<double> getDepreciationRateForLatestYear(String year) async {
    double rate = 0.0;
    try {
      QuerySnapshot querySnapshot =
      await firestore.collection('depreciationRates').where('year', isEqualTo: year).get();
      if (querySnapshot.docs.isNotEmpty) {
        rate =double.parse(querySnapshot.docs.first['rate']) ;
      }
    } catch (e) {
      print('Error fetching depreciation rate: $e');
    }
    return rate;
  }
  Future<double> getDepreciationRateForPriorYear(String year) async {
    double rate = 0.0;
    try {
      QuerySnapshot querySnapshot =
      await firestore.collection('depreciationRates').where('year', isEqualTo: year).get();
      if (querySnapshot.docs.isNotEmpty) {
        rate =double.parse(querySnapshot.docs.first['rate']);
      }
    } catch (e) {
      print('Error fetching depreciation rate: $e');
    }
    return rate;
  }

  addFixedIncomeCalculator(String borrowerId,String employerName, String employerStartDate, String employerEndDate, String dateOfPayCheck, String payPeriodEndDate, String salaryCycle, String payRatePerCycle, String baseIncomeYearToDate, String latestYearsW2Box5Income, String priorYearsW2Box5Income, String additionalW2IncomeTypes, double baseOverTime, double w2overTime, double priorW2OverTime, double baseBonus, double w2bonus, double priorW2Bonus, double baseCommission, double w2commission, double priorW2Commission, double baseTips, double w2tips, double priorW2Tips, double baseOthers, double w2others, double priorW2Others, String incomeType, String calculatedMonthlyIncomeFixed, String totalOverTime, String totalBonus, String totalCommission, String totalTips, String totalOthers, String summaryTotalSample, String baseYear, String w2Year, String priorW2Year, String selectedPayPeriodEndDateDay, String selectedPayPeriodEndDateMonth, String verifyStatus, String selectedAddedBy)async{
    if(additionalW2IncomeTypes != 'true'){
      await firestore
          .collection('users')
          .doc(await borrowerId)
          .update({
        'incomes': FieldValue.arrayUnion([
          {
            'type':'income',
            'addedBy':selectedAddedBy,
            'companyName': employerName,
            'startDate': employerStartDate,
            'endDate': employerEndDate,
            'dateOfPayCheck':dateOfPayCheck,
            'payPeriodEndDate':payPeriodEndDate,
            'salaryCycle':salaryCycle,
            'additionalW2IncomeTypesAdded':additionalW2IncomeTypes,
            'grossAnnualIncome':payRatePerCycle,
            'monthlyIncome': summaryTotalSample,
            // 'payRatePerCycle':payRatePerCycle,
            'baseIncomeYearToDate':baseIncomeYearToDate,
            'latestYearsW2Box5Income':latestYearsW2Box5Income,
            'priorYearsW2Box5Income':priorYearsW2Box5Income,
            'status':'Include',
            'addedType': 'calculator',
            'employerIncomeType': incomeType,
            'timestamp':DateTime.now(),
            'baseYear':baseYear,
            'w2Year':w2Year,
            'priorW2Year':priorW2Year,
            'selectedPayPeriodEndDateDay':selectedPayPeriodEndDateDay,
            'selectedPayPeriodEndDateMonth':selectedPayPeriodEndDateMonth,
            'verifyStatus':verifyStatus

          }
        ])
      });
      // Get.put(HomeScreenController()).setTotal();
      Get.back();
      Get.back();
    }else{
      await firestore
          .collection('users')
          .doc(borrowerId)
          .update({
        'incomes': FieldValue.arrayUnion([
          {
            'type':'income',
            'addedBy':selectedAddedBy,
            'companyName': employerName,
            'startDate': employerStartDate,
            'endDate': employerEndDate,
            'dateOfPayCheck':dateOfPayCheck,
            'payPeriodEndDate':payPeriodEndDate,
            'salaryCycle':salaryCycle,
            'additionalW2IncomeTypesAdded':additionalW2IncomeTypes,
            'grossAnnualIncome':payRatePerCycle,
            'monthlyIncome': calculatedMonthlyIncomeFixed,
            // 'payRatePerCycle':payRatePerCycle,
            'baseIncomeYearToDate':baseIncomeYearToDate,
            'latestYearsW2Box5Income':latestYearsW2Box5Income,
            'priorYearsW2Box5Income':priorYearsW2Box5Income,
            'status':'Include',
            'addedType': 'calculator',
            'employerIncomeType': incomeType,
            'timestamp':DateTime.now(),
            'baseOvertime':baseOverTime,
            'w2Overtime':w2overTime,
            'priorW2Overtime':priorW2OverTime,
            'baseBonus':baseBonus,
            'w2Bonus':w2bonus,
            'priorW2Bonus':priorW2Bonus,
            'baseCommission':baseCommission,
            'w2Commission':w2commission,
            'priorW2Commission':priorW2Commission,
            'baseTip':baseTips,
            'w2Tip':w2tips,
            'priorW2Tip':priorW2Tips,
            'baseOther':baseOthers,
            'w2Other':w2others,
            'priorW2Other':priorW2Others,
            'baseYear':baseYear,
            'w2Year':w2Year,
            'priorW2Year':priorW2Year,
            'selectedPayPeriodEndDateDay':selectedPayPeriodEndDateDay,
            'selectedPayPeriodEndDateMonth':selectedPayPeriodEndDateMonth,
            'verifyStatus':verifyStatus
          }
        ])
      });
      // Get.put(HomeScreenController()).setTotal();
      Get.back();
      Get.back();
    }
  }
  addVariableIncomeCalculator(String borrowerId,String employerName, String employerStartDate, String employerEndDate, String payPeriodEndDate, String salaryCycle, String payRatePerCycle, double baseIncome, double w2income, double priorW2Income, double baseOverTime, double w2overTime, double priorW2OverTime, double baseBonus, double w2bonus, double priorW2Bonus, double baseCommission, double w2commission, double priorW2Commission, double baseTips, double w2tips, double priorW2Tips, double baseOthers, double w2others, double priorW2Others, String summaryTotal, String incomeType, String baseYear, String w2Year, String priorW2Year, String selectedPayPeriodEndDateMonth, String selectedPayPeriodEndDateDay, String verifyStatus, String selectedAddedBy)async{
    await firestore
        .collection('users')
        .doc(borrowerId)
        .update({
      'incomes': FieldValue.arrayUnion([
        {
          'type':'income',
          'addedBy':selectedAddedBy,
          'companyName': employerName,
          'startDate': employerStartDate,
          'endDate': employerEndDate,
          'payPeriodEndDate':payPeriodEndDate,
          'salaryCycle':salaryCycle,
          'grossAnnualIncome':payRatePerCycle,
          'monthlyIncome': summaryTotal,
          'status':'Include',
          'addedType': 'calculator',
          'employerIncomeType': incomeType,
          'timestamp':DateTime.now(),
          'baseIncome':baseIncome,
          'w2Income':w2income,
          'priorW2Income':priorW2Income,
          'baseOvertime':baseOverTime,
          'w2Overtime':w2overTime,
          'priorW2Overtime':priorW2OverTime,
          'baseBonus':baseBonus,
          'w2Bonus':w2bonus,
          'priorW2Bonus':priorW2Bonus,
          'baseCommission':baseCommission,
          'w2Commission':w2commission,
          'priorW2Commission':priorW2Commission,
          'baseTip':baseTips,
          'w2Tip':w2tips,
          'priorW2Tip':priorW2Tips,
          'baseOther':baseOthers,
          'w2Other':w2others,
          'priorW2Other':priorW2Others,
          'baseYear':baseYear,
          'w2Year':w2Year,
          'priorW2Year':priorW2Year,
          'selectedPayPeriodEndDateDay':selectedPayPeriodEndDateDay,
          'selectedPayPeriodEndDateMonth':selectedPayPeriodEndDateMonth,
          'verifyStatus':verifyStatus
        }
      ])
    });
    // Get.put(HomeScreenController()).setTotal();
    Get.back();
    Get.back();
  }
  addScheduleCBusinessIncomeCalculator(
      String borrowerId,
      String nameOfProprietor,
      String principalBusinessOrProfession,
      String businessNameType,
      String businessStartDate,
      String incomeType,
      String currentlyActive,
      String netProfitLossPrior,
      String nonRecurringPrior,
      String depletionPrior,
      String depreciationPrior,
      String mealsAndEntertainmentExclusionPrior,
      String businessUseOfHomePrior,
      String amortizationCasualtyLossOneTimeExpensePrior,
      String businessMilesPrior,
      String netProfitLossRecent,
      String nonRecurringRecent,
      String depletionRecent,
      String depreciationRecent,
      String mealsAndEntertainmentExclusionRecent,
      String businessUseOfHomeRecent,
      String amortizationCasualtyLossOneTimeExpenseRecent,
      String businessMilesRecent,
      String numberOfMonths,
      String baseYear,
      String w2year,
      String priorW2Year,
      String businessStartDateStamp,
      String greaterOrLessThen2Years, double subtotalPrior, double subtotalRecent, double monthlyIncome, String verifyStatus, String selectedAddedBy
      )async{
    await firestore
        .collection('users')
        .doc(borrowerId)
        .update({
      'incomes': FieldValue.arrayUnion([
        {
          'type':'business',
          'addedBy':selectedAddedBy,
          'nameOfProprietor': nameOfProprietor,
          'principalBusinessOrProfession': principalBusinessOrProfession,
          'companyName': businessNameType,
          'netProfitLossPrior': netProfitLossPrior,
          'nonRecurringPrior': nonRecurringPrior,
          'depletionPrior': depletionPrior,
          'depreciationPrior': depreciationPrior,
          'mealsAndEntertainmentExclusionPrior': mealsAndEntertainmentExclusionPrior,
          'businessUseOfHomePrior': businessUseOfHomePrior,
          'amortizationCasualtyLossOneTimeExpensePrior': amortizationCasualtyLossOneTimeExpensePrior,
          'businessMilesPrior': businessMilesPrior,
          'netProfitLossRecent': netProfitLossRecent,
          'nonRecurringRecent': nonRecurringRecent,
          'depletionRecent': depletionRecent,
          'depreciationRecent': depreciationRecent,
          'mealsAndEntertainmentExclusionRecent': mealsAndEntertainmentExclusionRecent,
          'businessUseOfHomeRecent': businessUseOfHomeRecent,
          'amortizationCasualtyLossOneTimeExpenseRecent': amortizationCasualtyLossOneTimeExpenseRecent,
          'businessMilesRecent': businessMilesRecent,
          'numberOfMonths': numberOfMonths,
          'grossAnnualIncome': '${subtotalRecent + subtotalPrior}'.toString(),
          'monthlyIncome': monthlyIncome.toString(),
          'startDate': businessStartDate,
          'currentlyActive': currentlyActive,
          'status':currentlyActive == 'true' && greaterOrLessThen2Years ==  'true'?'Include':'Exclude',
          'addedType': 'calculator',
          'employerIncomeType': incomeType,
          'timestamp':DateTime.now(),
          'salaryCycle':'Monthly',
          'baseYear':baseYear,
          'w2Year':w2year,
          'priorW2Year':priorW2Year,
          'businessStartDateStamp':businessStartDateStamp,
          'greaterOrLessThen2Years':greaterOrLessThen2Years,
          'includeIt':greaterOrLessThen2Years ==  'true'?true:false,
          'verifyStatus':verifyStatus
        }
      ])
    });
    Get.back();
    Get.back();
  }

  historyDataAdd(String message)async{
    await firestore.collection('History').add({
      'message':message,
      'timestamp':DateTime.now()
    });
  }
}
