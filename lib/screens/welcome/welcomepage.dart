
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Pink pattern as full‑screen background (optional)
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/core/assets/5179557.jpg'),
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(), // lets the white card start lower (like design)
              // White curved card (this is what you see as the bottom part)
              ClipPath(
                clipper: WaveClipper(), // curve at TOP
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.35,
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 40),
                      const Text(
                        'Welcome',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 3),
                      const SizedBox(width: 5),
                      const Text(
                        'Book tables in seconds',
                        style: TextStyle(color: Colors.black, height: 1.4),
                      ),
                      const Spacer(),
                      // Align(
                      //   alignment: Alignment.centerRight,
                      //   child: Container(
                      //     height: 56,
                      //     width: 56,
                      //     decoration: BoxDecoration(
                      //       color: AppColours.Bg,
                      //       shape: BoxShape.circle,
                      //     ),
                      //     child: IconButton(
                      //       onPressed: () => Get.toNamed('/login'),
                      //       icon: const Icon(
                      //         Icons.arrow_forward,
                      //         color: Colors.white,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      SizedBox(
                        width:double.infinity,
                        child: ElevatedButton(onPressed: () {
                          Get.toNamed('/login');
                        },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white60,
                                foregroundColor: Colors.purpleAccent,
                                side: BorderSide(
                                  color: Colors.purple,
                                  width: 2,
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)
                                )
                            ),
                            child: Text("Sign In")),
                      ),
                      SizedBox(height: 5,),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(onPressed:() {
                          Get.toNamed('/register');
                        },
                          style:ElevatedButton.styleFrom(
                              backgroundColor:Colors.purpleAccent,
                              foregroundColor: Colors.white,
                              side: BorderSide(
                                color: Colors.purpleAccent,
                                width: 1,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              )

                          ),child:Text("Sign Up"),
                        ),
                      ),
                      
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

/// White card with a wave at the TOP edge
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
