import 'package:flutter/material.dart';
import 'dart:ui';
import 'signup_screen.dart';
import '../home_screen.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();



  final _formKey = GlobalKey<FormState>();


  void _onLoginButtonPressed() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );

      print('Initiating login logic for: $email');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Attempting to login: $email')),
      );
    }
  }


  void _onSocialLoginPressed(String platform) {
    print('Starting $platform authentication logic...');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          Positioned.fill(
            child: Image.asset(
              'assets/images/Background.png',
              fit: BoxFit.cover,
            ),
          ),

          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                color: Colors.black.withOpacity(0.01),
              ),
            ),
          ),

          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 100.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Form(
                    key: _formKey,
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(

                          color: Colors.white.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(35.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [

                              Image.asset(
                                'assets/images/logo.png',
                                height: 100,
                                errorBuilder: (context, error, stackTrace) {

                                  return const Icon(Icons.checkroom_outlined, size: 80, color: Colors.grey);
                                },
                              ),
                              const SizedBox(height: 10),


                              // EMAIL FIELD
                              _buildInputFieldWithLabel(
                                controller: _emailController,
                                label: 'EMAIL ADDRESS',
                                icon: Icons.email_outlined,
                                placeholder: 'Email',
                                keyboardType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 2),

                              // PASSWORD FIELD
                              _buildPasswordInputField(context, controller: _passwordController),
                              const SizedBox(height: 15),

                              // LOGIN BUTTON
                              _buildLoginButton(),
                              const SizedBox(height: 10),

                              _buildSeparator(),
                              const SizedBox(height: 30),

                              // SOCIAL BUTTONS
                              _buildSocialLoginRow(),
                              const SizedBox(height: 40),

                              // SIGN UP LINK
                              _buildSignUpPrompt(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // REUSABLE UI WIDGETS

  Widget _buildInputFieldWithLabel({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String placeholder,
    required TextInputType keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.grey)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF2F2F2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.withOpacity(0.5)),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: placeholder,
              prefixIcon: Icon(icon, color: Colors.grey.withOpacity(0.5)),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            validator: (value) => (value == null || value.isEmpty) ? 'Required' : null,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordInputField(BuildContext context, {required TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('PASSWORD', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.grey)),
            TextButton(
              onPressed: () {},
              child: const Text('FORGOT?', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF00A2B1))),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF2F2F2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.withOpacity(0.5)),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Password',
              prefixIcon: Icon(Icons.lock_outline, color: Colors.grey.withOpacity(0.5)),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            validator: (value) => (value == null || value.isEmpty) ? 'Required' : null,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(colors: [Color(0xFF00C7D9), Color(0xFF00A2B1)]),
      ),
      child: MaterialButton(
        onPressed: _onLoginButtonPressed,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Login', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward_outlined, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSeparator() {
    return const Row(
      children: [
        Expanded(child: Divider(color: Color(0xFFE0E0E0))),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text('OR CONTINUE WITH', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
        ),
        Expanded(child: Divider(color: Color(0xFFE0E0E0))),
      ],
    );
  }

  Widget _buildSocialLoginRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildSocialButton(iconData: Icons.g_mobiledata, platform: 'Google'),
        _buildSocialButton(iconData: Icons.facebook, platform: 'Facebook'),
        _buildSocialButton(iconData: Icons.clear_outlined, platform: 'X'),
      ],
    );
  }

  Widget _buildSocialButton({required IconData iconData, required String platform}) {
    return Container(
      height: 50, width: 50,
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: MaterialButton(
        onPressed: () => _onSocialLoginPressed(platform),
        padding: EdgeInsets.zero,
        child: Icon(iconData, size: 30, color: Colors.grey[700]),
      ),
    );
  }

  Widget _buildSignUpPrompt() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('New User? ', style: TextStyle(color: Colors.grey, fontSize: 14)),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SignupScreen(),
              ),
            );
          },
          child: const Text('Sign Up', style: TextStyle(color: Color(0xFF00A2B1), fontSize: 14, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}