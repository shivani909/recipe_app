import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:recipe_app/app/routes/app_routes.dart';
import 'package:recipe_app/modules/analytics/bindings/analytics_binding.dart';
import 'package:recipe_app/modules/analytics/views/analytics_view.dart';
import 'package:recipe_app/modules/auth/bindings/auth_binding.dart';
import 'package:recipe_app/modules/auth/bindings/home_binding.dart';
import 'package:recipe_app/modules/auth/views/home_view.dart';
import 'package:recipe_app/modules/auth/views/login_view.dart';
import 'package:recipe_app/modules/auth/views/recipe_view.dart';
import 'package:recipe_app/modules/auth/views/splash_view.dart';
import 'package:recipe_app/modules/explore/bindings/recipe_binding.dart';
import 'package:recipe_app/modules/map/bindings/map_binding.dart';
import 'package:recipe_app/modules/map/views/map_view.dart';

class AppPages {
  static const initial = Routes.splash;


  static final routes = [

    GetPage(
      name: Routes.splash,
      page: () => const SplashView(),
    ),
GetPage(
      name: Routes.login,
      page: () => const LoginScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),

    GetPage(
    name: Routes.recipe,
    page: ()=>const RecipeView(),
    binding: RecipeBinding(),
),
GetPage(
  name: Routes.analytics,
  page: () => const AnalyticsView(),
  binding: AnalyticsBinding(),
),
GetPage(
  name: Routes.map,
  page: () => const MapView(),
  binding: MapBinding(),
),


  ];
}