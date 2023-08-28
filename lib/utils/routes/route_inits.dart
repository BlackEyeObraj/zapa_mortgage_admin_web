import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:zapa_mortgage_admin_web/pages/dash_board_page.dart';
import 'package:zapa_mortgage_admin_web/pages/sign_in_page.dart';
import 'package:zapa_mortgage_admin_web/pages/user_detail_page.dart';
import 'package:zapa_mortgage_admin_web/pages/views/borrower_discussion_view.dart';
import 'package:zapa_mortgage_admin_web/utils/routes/route_name.dart';

class RouteInits{
  static appRoutes() => [
    GetPage(
        name: RouteName.signIn,
        page: () => const SignInPage(),
        transition: Transition.noTransition,
    ),
    GetPage(
        name: RouteName.dashboard,
        page: () => const DashBoardPage(),
        transition: Transition.noTransition,
    ),
    GetPage(
        name: RouteName.userDetailScreen,
        page: () => const UserDetailPage(),
        transition: Transition.noTransition,
          // middlewares: [UserDetailRouteMiddleware()]
    ),
  ];
}
