import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.7),
      body: Center(
        child: Lottie.network(
          'https://lottie.host/40f95892-81c3-41c6-8d14-096dc1fae2cd/NMVcfp2VH6.json',
          height: 600,
          width: 600,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
