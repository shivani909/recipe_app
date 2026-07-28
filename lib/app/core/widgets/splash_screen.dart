import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../routes/app_routes.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {

  @override
  void initState() {

    super.initState();

    Future.delayed(
      const Duration(seconds: 2),
      () {

        final user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          Get.offAllNamed(Routes.home);
        } else {
          Get.offAllNamed(Routes.login);
        }

      },
    );

  }

  @override
  Widget build(BuildContext context) {

    return const Scaffold(

      body: Center(

        child: CircularProgressIndicator(),

      ),

    );

  }

}