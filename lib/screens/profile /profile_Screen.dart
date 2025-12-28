  import 'package:flutter/material.dart';
  import 'package:get/get.dart';
  import '../../core/theme/app_colours.dart';
  import '../dashboard /dashboard_controller.dart';

  class ProfileScreen extends StatelessWidget {
    const ProfileScreen({super.key});

    @override
    Widget build(BuildContext context) {
      final controller = Get.find<DashboardController>();


      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.purple,
          centerTitle: true,
          title: const Text(
            "Profile",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              onPressed: () {
                controller.logout();
              },
              icon: const Icon(Icons.logout),

            )
          ],
        ),

        body: Obx(() {
          if (controller.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColours.kPrimaryPurple,
              ),
            );
          }

          if (controller.user.value == null) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_off, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text("User not found",
                      style: TextStyle(fontSize: 16, color: Colors.grey)),
                ],
              ),
            );
          }

          final user = controller.user.value!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---------- Profile Header ----------
                Row(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundColor:
                      AppColours.kPrimaryPurple.withValues(alpha: 0.1),
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: AppColours.kPrimaryPurple,
                      ),
                    ),
                    const SizedBox(width: 16),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.name,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600)),
                          Text(
                            user.email,
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 14),
                          ),
                          Text(
                            "Member since ${DateTime.now().year}",
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // ---------- Account Section ----------
                _buildSection(
                  title: "Account Information",
                  icon: Icons.account_circle_outlined,
                  children: [
                    _buildTextField(
                      label: "Name",
                      controller: controller.nameTextController,   // <-- FIX
                      onChanged: (v) => controller.nameController.value = v,
                      suffixIcon: Icons.edit_outlined,
                    ),
                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: controller.updateName,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColours.kPrimaryPurple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.save, size: 18),
                        label: const Text(
                          "Update Name",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // ---------- Security Section ----------
                _buildSection(
                  title: "Security",
                  icon: Icons.security_outlined,
                  children: [

                    _buildTextField(
                      label: "Current Password",
                      obscureText: true,
                      controller: controller.currentPasswordTextController,
                      suffixIcon: Icons.lock_outline,
                    ),
                    SizedBox(height: 8,),
                    _buildTextField(
                      label: "New Password",
                      obscureText: true,
                      controller: controller.passwordTextController,
                      onChanged: (v) => controller.passwordController.value = v,
                      suffixIcon: Icons.lock_outline,
                    ),

                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: controller.changePassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.lock_reset, size: 18),
                        label: const Text(
                          "Change Password",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      );
    }

    // ---------- Reusable Section Card ----------
    Widget _buildSection({
      required String title,
      required IconData icon,
      required List<Widget> children,
    }) {
      return Card(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColours.kPrimaryPurple.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon,
                        color: AppColours.kPrimaryPurple, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Text(title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w700)),
                ],
              ),
              const SizedBox(height: 20),
              ...children,
            ],
          ),
        ),
      );
    }

    // ---------- Reusable TextField ----------
    Widget _buildTextField({
      required String label,
      required TextEditingController controller,
      void Function(String)? onChanged,
      bool readOnly = false,
      bool obscureText = false,
      IconData? suffixIcon,
    }) {
      return TextField(
        controller: controller,
        onChanged: onChanged,
        readOnly: readOnly,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          suffixIcon:
          suffixIcon != null ? Icon(suffixIcon, color: Colors.grey) : null,
        ),
      );
    }
  }
