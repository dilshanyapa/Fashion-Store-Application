import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; 
import 'package:firebase_auth/firebase_auth.dart'; // 👈 මෙය අලුතින් එකතු කළා
import 'firebase_options.dart'; 
import 'screens/login_signup/login_screen.dart';
import 'screens/home_screen.dart'; // 👈 ඔයාගේ Home Screen එක තියෙන path එක දෙන්න

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  print("🔥 Firebase Connection Successful!");

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
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF008B9A)), 
        useMaterial3: true,
      ),
      // 👈 මෙන්න මෙතැනයි අපි "Auth State" එක පරීක්ෂා කරන්නේ
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Firebase දත්ත ලැබෙන තෙක් රැඳී සිටින විට
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          
          // පරිශීලකයා ලොග් වී සිටී නම් Home Screen පෙන්වන්න
          if (snapshot.hasData) {
            return const HomeScreen(); // 👈 මෙතැනට ඔයාගේ Home screen class එකේ නම දෙන්න
          }
          
          // පරිශීලකයා ලොග් වී නැත්නම් Login Screen පෙන්වන්න
          return const LoginScreen();
        },
      ),
    );
  }
}