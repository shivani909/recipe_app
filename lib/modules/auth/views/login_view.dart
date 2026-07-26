import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:recipe_app/modules/auth/controllers/auth_controller.dart';

class LoginScreen extends GetView<AuthController> {

  const LoginScreen({super.key});

  @override

  Widget build(BuildContext context) {
    return Scaffold(
     
      body: Center(
        child: Padding(padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.restaurant_menu, size: 90),

            const SizedBox(height: 20),

            const Text(
              'Recipe Explorer',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            const Text(
              'Discover and share amazing recipes!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 50),

            Obx(() {
              if(controller.isLoading.value) {
                return const CircularProgressIndicator();

              }

              return SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: controller.signInWithGoogle,
                  icon: const Icon(Icons.login),
                  label: const Text('Sign in with Google'),
                ),
              );
              
            })
          ],)
        
        ))
    );
  }
  
}