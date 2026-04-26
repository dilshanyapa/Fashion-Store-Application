import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'cart_screen.dart';
import 'product_details.dart';
import '../data/product_data.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen())),
        ),
        title: const Text("Men's Collection", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search, color: Colors.black)),
          IconButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CartScreen())),
              icon: const Icon(Icons.shopping_cart, color: Colors.black)
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text("EXPLORE", style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 12)),
              const Text("Catalog", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),


              Row(
                children: [
                  _buildFilterButton(Icons.tune, "FILTER"),
                  const SizedBox(width: 10),
                  _buildFilterButton(Icons.swap_vert, "SORT"),
                ],
              ),
              const SizedBox(height: 25),


              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 0.6,
                mainAxisSpacing: 20,
                crossAxisSpacing: 15,

                children: ProductData.allProducts.map((item) {
                  return ProductItem(product: item);
                }).toList(),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.cyan,
        onTap: (index) {
          if (index == 0) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
          if (index == 2) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const CartScreen()));
          if (index == 3) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ""),
        ],
      ),
    );
  }

  Widget _buildFilterButton(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(20)),
      child: Row(children: [Icon(icon, size: 16), const SizedBox(width: 5), Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold))]),
    );
  }
}


class ProductItem extends StatelessWidget {
  final dynamic product;

  const ProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailsScreen(product: product)));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(image: AssetImage(product.image), fit: BoxFit.cover),
                  ),
                ),
                const Positioned(top: 10, right: 10, child: CircleAvatar(backgroundColor: Colors.white70, radius: 15, child: Icon(Icons.favorite_border, size: 18))),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
          Text("LKR ${product.price}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
        ],
      ),
    );
  }
}