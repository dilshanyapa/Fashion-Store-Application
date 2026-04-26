import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'product_list_screen.dart';
import 'profile_screen.dart';
import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Map<String, dynamic>> cartItems = [
    {
      "name": "POLO T-shirt",
      "price": 245.00,
      "size": "L",
      "color": "Ivory",
      "quantity": 1,
      "image": "assets/images/polo.jpg"
    },
    {
      "name": "Atelier Trench Coat",
      "price": 189.00,
      "size": "M",
      "color": "White",
      "quantity": 1,
      "image": "assets/images/img.png"
    },
  ];

  double shipping = 15.00;
  double discount = 00.00;


  double get subtotal => cartItems.fold(0, (sum, item) => sum + (item['price'] * item['quantity']));
  double get total => (subtotal + shipping) - discount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF008B9A)),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
          },
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
              const Icon(Icons.shopping_cart, color: Color(0xFF008B9A)),
              Positioned(
                right: -2, top: 12,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(color: Colors.cyan, shape: BoxShape.circle),
                  child: Text('${cartItems.length}', style: const TextStyle(fontSize: 10, color: Colors.white)),
                ),
              )
            ],
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Your Bag", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),

              cartItems.isEmpty
                  ? const Center(child: Text("Your bag is empty"))
                  : Column(
                children: cartItems.asMap().entries.map((entry) {
                  int index = entry.key;
                  var item = entry.value;
                  return _buildCartItem(item, index);
                }).toList(),
              ),

              const SizedBox(height: 30),

              _buildOrderSummary(),

              const SizedBox(height: 30),

              _buildCheckoutButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),


      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2, // Highlight Search or Cart index
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.cyan,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          if (index == 0) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
          if (index == 1) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ProductListScreen()));
          if (index == 2) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const CartScreen()));
          if (index == 3) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ""),
        ],
      ),
    );
  }

  // REUSABLE CART ITEM WIDGET
  Widget _buildCartItem(Map<String, dynamic> item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // Item Image
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(item['image'], width: 80, height: 100, fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(width: 80, height: 100, color: Colors.grey[200]),
            ),
          ),
          const SizedBox(width: 15),
          // Item Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.grey, size: 20),
                      onPressed: () => setState(() => cartItems.removeAt(index)),
                    )
                  ],
                ),
                Text("Size: ${item['size']} • Color: ${item['color']}", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("\$${item['price']}", style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF008B9A))),
                    // Quantity Selector
                    Container(
                      decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove, size: 16),
                            onPressed: () => setState(() {
                              if (item['quantity'] > 1) item['quantity']--;
                            }),
                          ),
                          Text("${item['quantity']}", style: const TextStyle(fontWeight: FontWeight.bold)),
                          IconButton(
                            icon: const Icon(Icons.add, size: 16),
                            onPressed: () => setState(() => item['quantity']++),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  //ORDER SUMMARY WIDGET
  Widget _buildOrderSummary() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: const Color(0xFFE9EAEB),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("ORDER SUMMARY", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1)),
          const SizedBox(height: 20),
          _summaryRow("Subtotal", "\$${subtotal.toStringAsFixed(2)}"),
          _summaryRow("Shipping", "\$${shipping.toStringAsFixed(2)}"),
          _summaryRow("Discount", "-\$${discount.toStringAsFixed(2)}", isDiscount: true),
          const Divider(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              Text("\$${total.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Color(0xFF008B9A))),
            ],
          )
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isDiscount = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: isDiscount ? Colors.cyan : Colors.black)),
        ],
      ),
    );
  }

  Widget _buildCheckoutButton() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: const LinearGradient(colors: [Color(0xFF006D77), Color(0xFF00D4E5)]),
      ),
      child: MaterialButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CheckoutScreen()),
              );
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("PROCEED TO CHECKOUT", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            SizedBox(width: 10),
            Icon(Icons.arrow_forward, color: Colors.white),
          ],
        ),
      ),
    );
  }
}