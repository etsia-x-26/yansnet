import 'package:flutter/material.dart';

class NoConnectionIllustration extends StatelessWidget {
  const NoConnectionIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/wifi_off.png', // Replace with your image path
      width: 100, // Adjust size to match your design
      height: 100, // Adjust size to match your design
      fit: BoxFit.contain, // Ensures the image fits without distortion
    );
  }
}
