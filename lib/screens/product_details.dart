import 'package:flutter/material.dart';
import '../../models/product_model.dart';
import 'cart_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  String selectedSize = 'M';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF008B9A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Dilshan Fashion",
            style: TextStyle(color: Color(0xFF008B9A), fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CartScreen())),
            icon: const Icon(Icons.shopping_bag_outlined, color: Color(0xFF008B9A)),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // PRODUCT IMAGE
                Image.asset(widget.product.image, height: 400, width: double.infinity, fit: BoxFit.cover),

                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("NEW COLLECTION",
                              style: TextStyle(color: Color(0xFF008B9A), fontWeight: FontWeight.bold, fontSize: 12)),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.black87, size: 16),
                              const SizedBox(width: 4),
                              Text("${widget.product.rating}", style: const TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(widget.product.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text("\$${widget.product.price}",
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF008B9A))),
                          const SizedBox(width: 10),
                          Text("\$${widget.product.originalPrice}",
                              style: const TextStyle(fontSize: 14, color: Colors.grey, decoration: TextDecoration.lineThrough)),
                        ],
                      ),
                      const SizedBox(height: 25),
                      const Text("DESCRIPTION", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
                      const SizedBox(height: 10),
                      Text(widget.product.description, style: TextStyle(color: Colors.grey[700], height: 1.5)),
                      const SizedBox(height: 30),
                      const Text("SELECT SIZE", style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: widget.product.sizes.map((size) => _buildSizeButton(size)).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(alignment: Alignment.bottomCenter, child: _buildAddToCartBar()),
        ],
      ),
    );
  }

  Widget _buildSizeButton(String size) {
    bool isSelected = selectedSize == size;
    return GestureDetector(
      onTap: () => setState(() => selectedSize = size),
      child: Container(
        width: 60, height: 50,
        decoration: BoxDecoration(
          color: isSelected ? Colors.cyan : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? Colors.transparent : Colors.grey[300]!),
        ),
        child: Center(
          child: Text(size, style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black87)),
        ),
      ),
    );
  }

  Widget _buildAddToCartBar() {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: Colors.white.withOpacity(0.9),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey[300]!), borderRadius: BorderRadius.circular(15)),
            child: const Icon(Icons.favorite_border),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Container(
              height: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: const LinearGradient(colors: [Color(0xFF008B9A), Color(0xFF00D4E5)]),
              ),
              child: MaterialButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CartScreen()),
                      );
                },
                child: const Text("ADD TO CART", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          )
        ],
      ),
    );
  }
}