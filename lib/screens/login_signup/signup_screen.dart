import 'package:flutter/material.dart';
import 'dart:ui';


class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();


  void _onSignupButtonPressed() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match!')),
        );
        return;
      }

      print('Registering user: ${_nameController.text}');

    }
  }

  void _onSocialLoginPressed(String platform) {
    print('Connecting via $platform...');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
              child: Container(color: Colors.black.withOpacity(0.01)),
            ),
          ),

          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60.0),
              child: Column(
                children: [

                  const SizedBox(height: 20),

                  Form(
                    key: _formKey,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10))
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/logo.png',
                              height: 90,
                              errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.checkroom_outlined, size: 70, color: Colors.grey),
                            ),

                            _buildInputField(
                              controller: _nameController,
                              label: 'FULL NAME',
                              placeholder: 'Full Name',
                              icon: Icons.person_outline,
                            ),
                            const SizedBox(height: 20),


                            _buildInputField(
                              controller: _emailController,
                              label: 'EMAIL ADDRESS',
                              placeholder: 'user@gmail.com',
                              icon: Icons.email_outlined,
                            ),
                            const SizedBox(height: 20),


                            _buildInputField(
                              controller: _passwordController,
                              label: 'PASSWORD',
                              placeholder: '● ● ● ● ● ● ● ●',
                              icon: Icons.lock_outline,
                              isPassword: true,
                            ),
                            const SizedBox(height: 20),


                            _buildInputField(
                              controller: _confirmPasswordController,
                              label: 'CONFIRM PASSWORD',
                              placeholder: '● ● ● ● ● ● ● ●',
                              icon: Icons.verified_user_outlined,
                              isPassword: true,
                            ),
                            const SizedBox(height: 30),


                            _buildSignupButton(),
                            const SizedBox(height: 25),


                            _buildSeparator(),
                            const SizedBox(height: 25),
                            _buildSocialRow(),
                            const SizedBox(height: 30),


                            _buildLoginPrompt(),
                          ],
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

  //REUSABLE WIDGETS

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String placeholder,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.blueGrey)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFE9E9E9),
            borderRadius: BorderRadius.circular(15),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: isPassword,
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
              suffixIcon: Icon(icon, color: Colors.grey, size: 20), // Icon on the right like your design
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
            validator: (value) => (value == null || value.isEmpty) ? 'Required' : null,
          ),
        ),
      ],
    );
  }

  Widget _buildSignupButton() {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: const LinearGradient(colors: [Color(0xFF008B9A), Color(0xFF00D4E5)]),
      ),
      child: MaterialButton(
        onPressed: _onSignupButtonPressed,
        child: const Text(
          'CREATE ACCOUNT',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
      ),
    );
  }

  Widget _buildSeparator() {
    return const Row(
      children: [
        Expanded(child: Divider(color: Color(0xFFEEEEEE))),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text("SOCIAL CONNECT", style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
        ),
        Expanded(child: Divider(color: Color(0xFFEEEEEE))),
      ],
    );
  }

  Widget _buildSocialRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _socialIcon(Icons.g_mobiledata, "Google"),
        _socialIcon(Icons.facebook, "Facebook"),
        _socialIcon(Icons.clear_outlined, "X"),
      ],
    );
  }

  Widget _socialIcon(IconData icon, String platform) {
    return InkWell(
      onTap: () => _onSocialLoginPressed(platform),
      child: Container(
        height: 50, width: 70,
        decoration: BoxDecoration(color: const Color(0xFFE9E9E9), borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: Colors.blueGrey),
      ),
    );
  }

  Widget _buildLoginPrompt() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Already have account? ", style: TextStyle(color: Colors.grey, fontSize: 13)),
        GestureDetector(
          onTap: () => Navigator.pop(context), // Goes back to Login screen
          child: const Text("Login", style: TextStyle(color: Color(0xFF008B9A), fontWeight: FontWeight.bold, fontSize: 13)),
        ),
      ],
    );
  }
}