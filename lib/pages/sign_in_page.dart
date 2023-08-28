import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zapa_mortgage_admin_web/controllers/sign_in_page_controller.dart';
import 'package:zapa_mortgage_admin_web/res/app_images.dart';
import 'package:zapa_mortgage_admin_web/services/firestore_service.dart';

import '../res/app_colors.dart';
import '../utils/routes/route_name.dart';
import '../utils/snack_bar.dart';

class SignInPage extends GetView<SignInPageController>{
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: SignInPageController(),
        builder: (controller){
        return Scaffold(
          body: Container(
            width: Get.width * 1,
            height: Get.height * 1,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    AppColors.primaryColor,
                    AppColors.primarySecondaryColor,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  tileMode: TileMode.clamp),
            ),
            child: Row(
              children: [
                const Expanded(
                  flex: 6,
                  child: Image(
                    height: 120,
                    image: AssetImage(AppImages.appLogo),
                    filterQuality: FilterQuality.high,),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    width: Get.width * .3,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20)),
                      color: AppColors.whiteColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 20.0, // soften the shadow
                          spreadRadius: 2.0, //extend the shadow
                        )
                      ],

                    ),
                    child:  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Login.',style: TextStyle(fontSize: 48,fontWeight: FontWeight.w900,
                        color: AppColors.primaryColor),),
                        const SizedBox(height: 24,),
                        const Text('Email',style: TextStyle(fontSize: 14,fontWeight: FontWeight.normal,
                            color: AppColors.primaryColor),),
                        SizedBox(
                          width: Get.width * 1,
                          height: 42,
                          child: TextFormField(
                            controller: controller.emailTextController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                                hintText: 'Enter your email',
                                hintStyle: TextStyle(fontSize: 12),
                                border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24,),
                        const Text('Password',style: TextStyle(fontSize: 14,fontWeight: FontWeight.normal,
                            color: AppColors.primaryColor),),
                        SizedBox(
                          width: Get.width * 1,
                          height: 42,
                          child: TextFormField(
                            controller: controller.passwordTextController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              hintText: 'Enter your password',
                              hintStyle: TextStyle(fontSize: 12),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 28,),
                        SizedBox(
                          width: Get.width * 1,
                            height: 40,
                            child: ElevatedButton(onPressed: ()async{
                              if(controller.emailTextController.text.isEmpty){
                                SnackBarApp().errorSnack('Authentication Error', 'Please enter your email address.');
                              }else if(!GetUtils.isEmail(controller.emailTextController.text)){
                                SnackBarApp().errorSnack('Authentication Error', 'Please enter valid email address.');
                              }else if(controller.passwordTextController.text.isEmpty){
                                SnackBarApp().errorSnack('Authentication Error', 'Please enter your password.');
                              }else{
                                controller.setLoading(true);
                               SignResponseReturns response =await  FirestoreService().signInWithEmailPassword(
                                   controller.emailTextController.text,
                                   controller.passwordTextController.text);
                               if(response == SignResponseReturns.loginSuccess){
                                 SnackBarApp().successSnack('Authentication Success', 'You have successfully logged in.');
                                 Get.offAndToNamed(RouteName.dashboard);
                                 controller.setLoading(false);
                               }else if(response == SignResponseReturns.accountNotActive){
                                 SnackBarApp().errorSnack('Authentication Error', 'Your account is not active.');
                                 controller.setLoading(false);
                               }else if(response == SignResponseReturns.emailNotFound){
                                 SnackBarApp().errorSnack('Authentication Error', 'Your provided email does not exist.');
                                 controller.setLoading(false);
                               }else if(response == SignResponseReturns.wrongPassword){
                                 SnackBarApp().errorSnack('Authentication Error', 'Your provided password is Incorrect.');
                                 controller.setLoading(false);
                               }else{
                                 SnackBarApp().errorSnack('Authentication Error', 'Something went wrong please try again later.');
                                 controller.setLoading(false);
                               }

                              }
                            }, child: Obx(() => !controller.isLoading? const Text('Continue',style: TextStyle(fontWeight: FontWeight.bold),):const Center(child: SizedBox(height: 24,width: 24,child: CircularProgressIndicator(color: AppColors.whiteColor)),))
                            )
                        )
                      ],
                    ).paddingSymmetric(horizontal: 120)
                  ),
                )
              ],
            ),
          ),
        );
        }
    );
  }

}