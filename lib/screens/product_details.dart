import 'package:flutter/material.dart';
import '../../models/product_model.dart';
import 'cart_screen.dart';
import '../data/product_data.dart'; 
import '../utils/page_transitions.dart'; 

class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  String selectedSize = 'M';
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    
    final double productRating = widget.product.rating ?? 4.5;
    final List<String> productSizes = widget.product.sizes.isEmpty 
        ? ['S', 'M', 'L', 'XL'] 
        : widget.product.sizes;

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
            onPressed: () => Navigator.push(context, createSmoothRoute(const CartScreen())),
            icon: const Icon(Icons.shopping_cart, color: Color(0xFF008B9A)),
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
                
                Image.network(
                  widget.product.image, 
                  height: 400, 
                  width: double.infinity, 
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                   
                    return Image.asset('assets/images/user_avatar.png', height: 400, width: double.infinity, fit: BoxFit.cover);
                  },
                ),

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
                              Text("$productRating", style: const TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(widget.product.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          
                          Text("LKR ${widget.product.price}",
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF008B9A))),
                          const SizedBox(width: 10),
                          Text("LKR ${widget.product.originalPrice}",
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
                       
                        children: productSizes.map((size) => _buildSizeButton(size)).toList(),
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

void _addToCartLogic() {
    int index = ProductData.globalCartItems.indexWhere((item) => 
        item['name'] == widget.product.name && item['size'] == selectedSize);

    if (index != -1) {
      ProductData.globalCartItems[index]['quantity']++;
    } else {
      ProductData.globalCartItems.add({
        "name": widget.product.name,
        "price": double.tryParse(widget.product.price.replaceAll(',', '')) ?? 0.0,
        "size": selectedSize,
        "color": "Standard",
        "quantity": 1,
        "image": widget.product.image
      });
    }
  }

 
  Widget _buildAddToCartBar() {
    return Container(
      height: 85,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      color: Colors.white.withOpacity(0.95),
      child: Row(
        children: [
          // FAVORITE BUTTON
          GestureDetector(
            onTap: () {
              setState(() {
                isFavorite = !isFavorite;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!), 
                borderRadius: BorderRadius.circular(15),
                color: isFavorite ? Colors.red.withOpacity(0.1) : Colors.transparent,
              ),
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.black87,
              ),
            ),
          ),
          const SizedBox(width: 10),

          // ADD TO CART BUTTON
          Expanded(
            child: Container(
              height: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFF008B9A), width: 1.5),
                color: Colors.white, 
              ),
              child: MaterialButton(
                onPressed: () {
                  setState(() {
                    _addToCartLogic(); 
                  });

                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("${widget.product.name} ($selectedSize) Added to Bag!"),
                      backgroundColor: Colors.teal,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                child: const Text(
                  "ADD TO CART", 
                  style: TextStyle(color: Color(0xFF008B9A), fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // BUY NOW BUTTON 
          Expanded(
            child: Container(
              height: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: const LinearGradient(colors: [Color(0xFF008B9A), Color(0xFF00D4E5)]),
              ),
              child: MaterialButton(
                onPressed: () {
                  setState(() {
                    _addToCartLogic(); 
                  });

               
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartScreen()),
                  );
                },
                child: const Text(
                  "BUY NOW", 
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}