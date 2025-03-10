import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PageNotFound extends StatelessWidget {
  const PageNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LottieBuilder.asset('assets/lottie/404.json',
                width: 300,
                height: 300,
                fit: BoxFit.cover,
                repeat: true, errorBuilder: (context, error, stackTrace) {
              return const Text('Error loading animation');
            }),
            const SizedBox(height: 20),
            const Text(
              'Seems like you\'ve hit a dead end, huh?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
