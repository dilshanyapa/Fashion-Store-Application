import 'package:flutter/material.dart';
import '../screens/home_screen.dart'; 

class AuthService {
  // This function handles the "Work"
  static Future<void> handleLoginLogic(BuildContext context, Function(bool) setLoading) async {

    setLoading(true);

    await Future.delayed(const Duration(seconds: 2));


    setLoading(false);

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