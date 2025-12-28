

import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_colours.dart';
import '../Register/register.dart';
import 'logincontroller.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
   final c=Get.find<Logincontroller>();
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/core/assets/5179557.jpg'),
            filterQuality: FilterQuality.high,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(),
              ClipPath(
                clipper: WaveClipper(),
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.50,
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Sign In",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: c.emailController,
                        keyboardType:
                            TextInputType.emailAddress, // email keyboard
                        textInputAction:
                            TextInputAction.next, // show "next" button
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'demo@email.com',
                          prefixIcon: const Icon(Icons.email_outlined),
                          prefixIconColor: AppColours.Bg,
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),

                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.black54),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: AppColours.Bg,
                              width: 1.5,
                            ),
                          ),

                        ),
                      ),
                      SizedBox(height: 40),
                      Obx(() => TextField(
                        controller: c.passwordController,
                        obscureText: !c.isPasswordVisible.value,  // GetX reactive
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.password, color: AppColours.Bg),
                          labelText: "Enter Password",
                          suffixIcon: IconButton(  // Toggle button
                            icon: Icon(c.isPasswordVisible.value
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () => c.isPasswordVisible.value = !c.isPasswordVisible.value,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.black54),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: AppColours.Bg, width: 1.5),
                          ),
                        ),
                      )),
                      SizedBox(height: 40,),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(onPressed: () {
                          c.loginUser();
                        },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white70,
                              elevation: 1,

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              )
                            ),
                            child:Text("Continue")),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
