import 'package:flutter/material.dart';
import 'login_signup/login_screen.dart';
import 'home_screen.dart';
import 'product_list_screen.dart';
import 'cart_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = user?.displayName ?? "";
  }

  // නම Update කිරීම සඳහා වන Function එක
  Future<void> _updateName() async {
    try {
      // 1. Firebase එකේ නම Update කරන්න
      await user?.updateDisplayName(_nameController.text.trim());
      await user?.reload();

      // 2. Dialog එක පමණක් වසන්න
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        setState(() {}); // UI එක Refresh කරන්න
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile Name Updated Successfully!")),
        );
      }
    } catch (e) {
      print("Error updating name: $e");
    }
  }

  // පින්තූරය Upload කිරීම සඳහා වන Function එක
  Future<void> _pickAndUploadImage() async {
    final ImagePicker picker = ImagePicker();
    
    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
      );
      
      if (image == null) return;

      // Loading Indicator පෙන්වීම
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      File file = File(image.path);
      String uid = FirebaseAuth.instance.currentUser!.uid;

      // Firebase Storage එකට පින්තූරය Upload කිරීම
      Reference ref = FirebaseStorage.instance.ref().child('profile_pics/$uid.jpg');
      await ref.putFile(file);
      
      // URL එක ලබාගෙන Profile එක Update කිරීම
      String downloadURL = await ref.getDownloadURL();
      await FirebaseAuth.instance.currentUser!.updatePhotoURL(downloadURL);
      await FirebaseAuth.instance.currentUser!.reload();
      
      if (mounted) {
        // Loading Dialog එක පමණක් වසා දමන්න (White screen වීම වැළැක්වීමට)
        Navigator.of(context, rootNavigator: true).pop();
        setState(() {}); 
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile Picture Updated!")),
        );
      }
    } catch (e) {
      if (mounted) Navigator.of(context, rootNavigator: true).pop();
      print("🔥 Storage Error: $e");
    }
  }

  void _showEditNameDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Name"),
        content: TextField(
          controller: _nameController,
          decoration: const InputDecoration(hintText: "Enter your name"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: _updateName,
            child: const Text("Save", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Logout"),
          content: const Text("Are you sure you want to log out of Dilshan Fashion?"),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("No", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
              child: const Text("Yes, Logout",
                  style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          ),
        ),
        title: const Text(
          "Dilshan Fashion",
          style: TextStyle(color: Color(0xFF008B9A), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.shopping_cart, color: Color(0xFF008B9A))),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(color: Colors.cyan, shape: BoxShape.circle),
                  child: const Text('2', style: TextStyle(fontSize: 10, color: Colors.white)),
                ),
              )
            ],
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundColor: const Color(0xFF2D3436),
                    child: CircleAvatar(
                      radius: 65,
                      backgroundColor: Colors.white,
                      backgroundImage: currentUser?.photoURL != null
                          ? NetworkImage(currentUser!.photoURL!) as ImageProvider
                          : const AssetImage('assets/images/user_avatar.png'),
                      child: currentUser?.photoURL == null
                          ? const Icon(Icons.person, size: 65, color: Colors.grey)
                          : null,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 5,
                    child: GestureDetector(
                      onTap: _pickAndUploadImage,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration:
                            const BoxDecoration(color: Colors.cyan, shape: BoxShape.circle),
                        child: const Icon(Icons.edit, color: Colors.white, size: 20),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 15),
            GestureDetector(
              onTap: _showEditNameDialog,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    currentUser?.displayName ?? "Fashion User",
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2D3436)),
                  ),
                  const SizedBox(width: 5),
                  const Icon(Icons.edit, size: 18, color: Colors.grey),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Text(
              currentUser?.email ?? "No Email Found",
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _showEditNameDialog,
                    child: _buildProfileMenu(Icons.person_outline, "Edit Profile Information"),
                  ),
                  _buildProfileMenu(Icons.history, "Order History"),
                  _buildProfileMenu(Icons.location_on_outlined, "Saved Addresses"),
                  _buildProfileMenu(Icons.account_balance_wallet_outlined, "Payment Methods"),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () => _showLogoutConfirmation(context),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE9E9E9),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey.withOpacity(0.2)),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout, color: Colors.redAccent),
                          SizedBox(width: 10),
                          Text("Logout",
                              style: TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.cyan,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => const HomeScreen()));
          }
          if (index == 1) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => const ProductListScreen()));
          }
          if (index == 2) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => const CartScreen()));
          }
          if (index == 3) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
        ],
      ),
    );
  }

  Widget _buildProfileMenu(IconData icon, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 5))
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: const Color(0xFFEAF9FA), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: const Color(0xFF008B9A), size: 22),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Text(title,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    );
  }
}