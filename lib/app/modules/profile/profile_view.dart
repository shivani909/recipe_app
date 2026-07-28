import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_app/app/modules/profile/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile"), centerTitle: true),
      body: Obx(() {
        final user = controller.user;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),

              GestureDetector(
                onTap: controller.pickProfileImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage: controller.profileImage != null
                      ? FileImage(controller.profileImage!)
                      : (user?.photoURL != null
                                ? NetworkImage(user!.photoURL!)
                                : null)
                            as ImageProvider?,
                  child:
                      controller.profileImage == null && user?.photoURL == null
                      ? const Icon(Icons.person, size: 60, color: Colors.white)
                      : null,
                ),
              ),

              const SizedBox(height: 16),

              Text(
                user?.displayName ?? "Guest User",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                user?.email ?? "",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: controller.pickProfileImage,
                  icon: const Icon(Icons.photo),
                  label: const Text("Edit Profile"),
                ),
              ),

              const SizedBox(height: 15),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: controller.logout,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text(
                    "Logout",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
