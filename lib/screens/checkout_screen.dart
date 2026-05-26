import 'package:flutter/material.dart';
import 'home_screen.dart';
import '../data/product_data.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/notification_service.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool isCardSelected = true;
  bool useSavedAddress = true;


  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _phoneController = TextEditingController();

  String selectedDay = "20";
  String selectedMonth = "February";
  String selectedYear = "2026";


  List<Map<String, dynamic>> get checkoutItems => ProductData.globalCartItems;

  double shippingFee = 150.00; 
  double discountAmount = 0.00;


  double get subtotal => checkoutItems.fold(0, (sum, item) => sum + (item['price'] * item['quantity']));
  double get total => (subtotal + shippingFee) - discountAmount;

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _phoneController.dispose();
    super.dispose();
  }


  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.teal, size: 80),
            const SizedBox(height: 20),
            const Text("Order Placed Successfully!", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("Thank you for shopping with Dilshan Fashion. Your order of LKR ${total.toStringAsFixed(2)} has been received.", 
                textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan, shape: const StadiumBorder()),
                onPressed: () {

                  ProductData.globalCartItems.clear();
                  

                  Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(
                    context, 
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (route) => false
                  );
                },
                child: const Text("Back to Home", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }

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
        title: const Text("Checkout", style: TextStyle(color: Color(0xFF008B9A), fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search, color: Color(0xFF008B9A))),
          Stack(
            alignment: Alignment.center,
            children: [
              const Icon(Icons.shopping_cart, color: Color(0xFF008B9A)),
              Positioned(
                right: -2, top: 12,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(color: Colors.cyan, shape: BoxShape.circle),
                  child: Text('${checkoutItems.length}', style: const TextStyle(fontSize: 10, color: Colors.white)),
                ),
              )
            ],
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            _buildSectionHeader("1", "Shipping Address", true),
            _buildAddressSection(),
            const SizedBox(height: 20),

            _buildSectionHeader("2", "Payment Method", false),
            _buildPaymentSelection(),
            const SizedBox(height: 20),

            _buildSectionHeader("3", "Review Order", false),
            _buildOrderReview(),
            const SizedBox(height: 120), 
          ],
        ),
      ),
      bottomSheet: _buildPlaceOrderButton(),
    );
  }

  Widget _buildPaymentSelection() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Row(
            children: [
              _buildTabButton("Credit Card", Icons.credit_card, isCardSelected, () => setState(() => isCardSelected = true)),
              const SizedBox(width: 10),
              _buildTabButton("Cash on Delivery", Icons.money, !isCardSelected, () => setState(() => isCardSelected = false)),
            ],
          ),
          if (isCardSelected) ...[
            const SizedBox(height: 25),
            _buildCardInputForm(),
          ] else ...[
            const SizedBox(height: 20),
            const Text("You will pay when you receive the order.", style: TextStyle(color: Colors.grey, fontSize: 13)),
          ],
        ],
      ),
    );
  }

  Widget _buildCardInputForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Image.asset(
            'assets/images/payment_logo.png',
            height: 35,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.credit_card, size: 35, color: Colors.cyan),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 3, child: _buildLabelAndField("CARD NUMBER", "**** **** **** ****", isCardField: true)),
            const SizedBox(width: 15),
            Expanded(flex: 1, child: _buildLabelAndField("CVC", "***", isCardField: true)),
          ],
        ),
        _buildLabelAndField("CARD HOLDER NAME", "Joshua Hernandez", isCardField: true),
        const Text("EXPIRATION DATE", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1, color: Colors.black87)),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildDropdownItem(selectedDay, ["10", "15", "20", "25"], (val) => setState(() => selectedDay = val!)),
            const SizedBox(width: 10),
            _buildDropdownItem(selectedMonth, ["January", "February", "March", "April"], (val) => setState(() => selectedMonth = val!)),
            const SizedBox(width: 10),
            _buildDropdownItem(selectedYear, ["2026", "2027", "2028"], (val) => setState(() => selectedYear = val!)),
          ],
        ),
      ],
    );
  }


  Widget _buildLabelAndField(String label, String hint, {bool isCardField = false, TextEditingController? controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            filled: true,
            fillColor: const Color(0xFFF2F2F2),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildDropdownItem(String value, List<String> items, Function(String?) onChanged) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(color: const Color(0xFFF2F2F2), borderRadius: BorderRadius.circular(8)),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 18),
            style: const TextStyle(color: Colors.grey, fontSize: 13),
            items: items.map((String item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String number, String title, bool isDone) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          CircleAvatar(radius: 12, backgroundColor: const Color(0xFF006D77), child: Text(number, style: const TextStyle(color: Colors.white, fontSize: 12))),
          const SizedBox(width: 10),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const Spacer(),
          if (isDone) const Icon(Icons.check_circle_outline, color: Colors.teal, size: 20),
        ],
      ),
    );
  }

  Widget _buildAddressSection() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Row(
            children: [
              _buildTabButton("Saved Address", Icons.home, useSavedAddress, () => setState(() => useSavedAddress = true)),
              const SizedBox(width: 10),
              _buildTabButton("Add New", Icons.location_on, !useSavedAddress, () => setState(() => useSavedAddress = false)),
            ],
          ),
          const SizedBox(height: 20),

          _buildLabelAndField("FULL NAME", "Chanuka Dilshan", controller: _nameController),
          _buildLabelAndField("STREET ADDRESS", "SLTC Research University, Padukka", controller: _addressController),
          Row(
            children: [
              Expanded(child: _buildLabelAndField("CITY", "Colombo", controller: _cityController)),
              const SizedBox(width: 10),
              Expanded(child: _buildLabelAndField("STATE", "Western")),
            ],
          ),
          _buildLabelAndField("ZIP Code", "10500"),
          _buildLabelAndField("Mobile Number", "+94 7x xxx xxxx", controller: _phoneController),
        ],
      ),
    );
  }

  Widget _buildOrderReview() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [

          if (checkoutItems.isEmpty)
            const Text("No Items to Review", style: TextStyle(color: Colors.grey))
          else
            Column(
              children: checkoutItems.map((item) {
                return Column(
                  children: [
                    _buildReviewItem(
                      item['name'], 
                      "LKR ${item['price'] * item['quantity']}", 
                      item['image'],
                      item['quantity']
                    ),
                    const Divider(),
                  ],
                );
              }).toList(),
            ),
          const SizedBox(height: 15),

          _summaryRow("Subtotal", "LKR ${subtotal.toStringAsFixed(2)}"),
          _summaryRow("Shipping Fee", "LKR ${shippingFee.toStringAsFixed(2)}"),
          _summaryRow("Discount", "- LKR ${discountAmount.toStringAsFixed(2)}", isRed: true),
          const Divider(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, 
            children: [
              const Text("Total Amount", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), 
              Text("LKR ${total.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFF006D77)))
            ]
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isRed = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)), Text(value, style: TextStyle(color: isRed ? Colors.red : Colors.black, fontWeight: FontWeight.bold, fontSize: 13))]),
    );
  }

  Widget _buildTabButton(String label, IconData icon, bool isActive, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(color: isActive ? Colors.cyan : Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey[200]!)),
          child: Column(children: [Icon(icon, size: 18, color: isActive ? Colors.white : Colors.cyan), Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isActive ? Colors.white : Colors.black87))]),
        ),
      ),
    );
  }


  Widget _buildReviewItem(String title, String price, String img, int qty) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10), 
          child: Image.network(
            img, width: 50, height: 50, fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(width: 50, height: 50, color: Colors.grey[200], child: const Icon(Icons.image, size: 20)),
          )
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, 
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis), 
              Text("Qty: ${qty.toString().padLeft(2, '0')}", style: const TextStyle(color: Colors.grey, fontSize: 10))
            ]
          )
        ),
        Text(price, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF006D77))),
      ],
    );
  }

  Widget _buildPlaceOrderButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Container(
        width: double.infinity,
        height: 55,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), gradient: const LinearGradient(colors: [Color(0xFF006D77), Color(0xFF00D4E5)])),
        child: MaterialButton(
          onPressed: () async { 

            if (_nameController.text.isEmpty || _addressController.text.isEmpty || _cityController.text.isEmpty || _phoneController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Row(
                    children: [
                      Icon(Icons.warning_amber_rounded, color: Colors.white),
                      SizedBox(width: 10),
                      Text("Please fill out all address details!", style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  backgroundColor: Colors.orangeAccent,
                ),
              );
              return; 
            }


            if (checkoutItems.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Your cart is empty! Cannot place order."),
                  backgroundColor: Colors.redAccent,
                ),
              );
              return;
            }


            try {

              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const Center(child: CircularProgressIndicator(color: Colors.cyan)),
              );

              await FirebaseFirestore.instance.collection('orders').add({
                'buyer_name': _nameController.text.trim(),
                'address': "${_addressController.text.trim()}, ${_cityController.text.trim()}",
                'phone': _phoneController.text.trim(),
                'payment_method': isCardSelected ? "Credit Card" : "Cash on Delivery",
                'total_amount': total,
                'order_date': FieldValue.serverTimestamp(),
                'status': "Pending", 
                'items': checkoutItems.map((item) => {
                  'name': item['name'],
                  'price': item['price'],
                  'quantity': item['quantity'],
                  'size': item['size'],
                }).toList(),
              });

              Navigator.pop(context); 
              
              await NotificationService.showNotification(
                  id: 1,
                  title: "🛍️ Order Placed Successfully!",
                  body: "Hi ${_nameController.text}, your order of LKR ${total.toStringAsFixed(2)} has been confirmed!",
                );

              _showSuccessDialog();

            } catch (e) {
              Navigator.pop(context); 

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Database Error: Could not place order. $e"),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text("Place Order", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), SizedBox(width: 10), Icon(Icons.arrow_forward, color: Colors.white)]),
        ),
      ),
    );
  }
}
