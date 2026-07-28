import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_app/app/core/theme/app_colors.dart';
import 'package:recipe_app/app/modules/profile/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
 
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.scaffoldBackground,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: Obx(() {
        final user = controller.user;

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          child: Column(
            children: [
       
              GestureDetector(
                onTap: controller.pickProfileImage,
                child: Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(.18),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 56,
                        backgroundColor: AppColors.cardBackground,
                        backgroundImage: controller.profileImage != null
                            ? FileImage(controller.profileImage!)
                            : (user?.photoURL != null
                                      ? NetworkImage(user!.photoURL!)
                                      : null)
                                  as ImageProvider?,
                        child:
                            controller.profileImage == null &&
                                user?.photoURL == null
                            ? const Icon(
                                Icons.person,
                                size: 52,
                                color: AppColors.primary,
                              )
                            : null,
                      ),
                    ),
                    Positioned(
                      bottom: 2,
                      right: 2,
                      child: Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                          border: Border.all(color: Colors.white, width: 2.5),
                        ),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          size: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Text(
                user?.displayName ?? "Guest User",
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                user?.email ?? "",
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14.5,
                ),
              ),

              const SizedBox(height: 32),


              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: controller.pickProfileImage,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: AppColors.border, width: 1.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(Icons.edit_outlined, size: 19),
                  label: const Text(
                    "Edit Profile",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                ),
              ),

              const SizedBox(height: 12),

          
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: controller.logout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(Icons.logout_rounded, size: 19),
                  label: const Text(
                    "Logout",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                ),
              ),

              const SizedBox(height: 60),

       
              Text(
                "Recipe Explorer · v1.0.0",
                style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
              ),
            ],
          ),
        );
      }),
    );
  }
}
