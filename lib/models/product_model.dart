import 'package:flutter/material.dart';
import '../screens/home_screen.dart'; // Import your home screen

class AuthService {
  // This function handles the "Work"
  static Future<void> handleLoginLogic(BuildContext context, Function(bool) setLoading) async {
    // 1. Start the loading spinner in the UI
    setLoading(true);

    // 2. Simulate the network delay (Wait 2 seconds)
    await Future.delayed(const Duration(seconds: 2));

    // 3. Stop the loading spinner
    setLoading(false);

    // 4. Navigate to the Home Screen
    // pushReplacement ensures the user can't go "back" to the login screen after logging in
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }
}



class Product {
  final String name;
  final String price;
  final String originalPrice;
  final String image;
  final String description;
  final double rating;
  final List<String> sizes;

  Product({
    required this.name,
    required this.price,
    required this.originalPrice,
    required this.image,
    required this.description,
    this.rating = 4.9,
    this.sizes = const ['S', 'M', 'L', 'XL'],
  }
  );
}