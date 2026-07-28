import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:recipe_app/app/routes/app_routes.dart';
import 'package:recipe_app/app/modules/analytics/analytics_binding.dart';

import 'package:recipe_app/app/modules/auth/auth_binding.dart';
import 'package:recipe_app/app/modules/root/home_binding.dart';
import 'package:recipe_app/app/modules/root/root_view.dart';
import 'package:recipe_app/app/modules/auth/auth_view.dart';
import 'package:recipe_app/app/modules/recipe/recipe_details.dart';
import 'package:recipe_app/app/core/widgets/splash_screen.dart';
import 'package:recipe_app/app/modules/recipe/recipe_binding.dart';
import 'package:recipe_app/app/modules/map/map_binding.dart';
import 'package:recipe_app/app/modules/map/map_view.dart';
import 'package:recipe_app/app/modules/profile/profile_binding.dart';
import 'package:recipe_app/app/modules/profile/profile_view.dart';

class AppPages {
  static const initial = Routes.splash;


  static final routes = [

    GetPage(
      name: Routes.splash,
      page: () => const SplashView(),
    ),
GetPage(
      name: Routes.login,
      page: () => const AuthScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),

    GetPage(
    name: Routes.recipe,
    page: ()=>const RecipeDetails(),
    binding: RecipeBinding(),
),

GetPage(
  name: Routes.map,
  page: () => const GroceryFinderView(),
  binding: MapBinding(),
),

GetPage(
  name: Routes.profile,
  page: () => const ProfileView(),
  binding: ProfileBinding(),
),


  ];
}