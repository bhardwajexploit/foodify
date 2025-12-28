
import 'package:flutter/material.dart';
import 'package:foodify/screens/Register/register_controller.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colours.dart';

class RegisterPage extends StatelessWidget{
   RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
  final c=Get.find<RegisterController>();
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
                  height: MediaQuery.of(context).size.height * 0.54,
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: c.email,
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
                      TextField(
                        controller: c.name,
                        keyboardType:
                        TextInputType.name, // email keyboard
                        textInputAction:
                        TextInputAction.next, // show "next" button
                        decoration: InputDecoration(
                          labelText: 'Enter FullName',
                          hintText: 'Harry',
                          prefixIcon: const Icon(Icons.person_2),
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
                        controller: c.password,
                        obscureText: !c.isPasswordVisible.value,  // Hide by default
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.password, color: AppColours.Bg),
                          labelText: "Enter Password",
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
                          suffixIcon: IconButton(
                            icon: Icon(c.isPasswordVisible.value ? Icons.visibility : Icons.visibility_off),
                            onPressed: () => c.isPasswordVisible.value = !c.isPasswordVisible.value,
                          ),
                        ),
                      )),
                      SizedBox(height: 40,),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(onPressed: () {
                          c.createUser();
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
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(0, 3);

    // your first curve (unchanged)
    final firstControlPoint = Offset(size.width * 0.25, -10);
    final firstEndPoint = Offset(size.width * 0.5, 40);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    // second curve: just smooth the tail, no new big wave
    // second curve – creates a rounded drop on the right
    final secondControlPoint = Offset(size.width * 0.75, 80); // lower than 100
    final secondEndPoint = Offset(size.width, 10); // also lowery lower
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}