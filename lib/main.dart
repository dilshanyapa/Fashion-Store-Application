import 'package:flutter/material.dart';
// මෙතන 'login_screen.dart' කියන්නේ ඔයා login UI එක save කරපු file එකේ නම.
// ඔයා ඒක වෙනම file එකක (screens folder එකේ) දාන්න ඕනේ.
import 'screens/login_signup/login_screen.dart';

void main() {
  runApp(const FashionApp());
}

class FashionApp extends StatelessWidget {
  const FashionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dilshan Fashion',

      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),

      home: const LoginScreen(),
    );
  }
}