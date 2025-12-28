
import 'package:flutter/material.dart';

import '../../core/theme/app_colours.dart';


class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:AppColours.Bg,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           RichText(text: const TextSpan(
             style: TextStyle(
               fontSize: 32,
               fontWeight: FontWeight.bold,
               color: Colors.white,
               letterSpacing:  1.2,
             ),
             children: [
               TextSpan(text: "Foodify"),
             ]
           )),
            const SizedBox(height:4),
            RichText(text: const TextSpan(
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
              children: [
                TextSpan(text: "           "), // aligns under "Assist"
                TextSpan(text: "Book Tables instantly"),
              ],
            ),
            ),
            const SizedBox(height: 40),

            // 🔹 Loader
            const CircularProgressIndicator(
              color: Color(0xFFE07A5F),
              strokeWidth: 2.5,
            ),
          ],
        ),
      ),
    );
  }
}
