import 'package:flutter/material.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {

  bool isCardSelected = true;
  bool useSavedAddress = true;


  String selectedDay = "20";
  String selectedMonth = "February";
  String selectedYear = "2026";

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
          const Icon(Icons.shopping_cart, color: Color(0xFF008B9A)),
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
            const SizedBox(height: 120), // Extra space for the floating button
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
          ),
        ),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 3, child: _buildLabelAndField("CARD NUMBER", "**** **** **** ****")),
            const SizedBox(width: 15),
            Expanded(flex: 1, child: _buildLabelAndField("CVC", "***")),
          ],
        ),
        _buildLabelAndField("CARD HOLDER NAME", "Joshua Hernandez"),
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


  Widget _buildLabelAndField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
        const SizedBox(height: 8),
        TextField(
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
          _buildLabelAndField("FULL NAME", "Your Name"),
          _buildLabelAndField("STREET ADDRESS", "House No, Street Name"),
          Row(
            children: [
              Expanded(child: _buildLabelAndField("CITY", "Colombo")),
              const SizedBox(width: 10),
              Expanded(child: _buildLabelAndField("STATE", "Western")),
            ],
          ),
          _buildLabelAndField("ZIP Code", "00000"),
          _buildLabelAndField("Mobile Number", "+94 xxx xxx xxx"),
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
          _buildReviewItem("POLO T-Shirt", "LKR 8,500", 'assets/images/polo.jpg'),
          const Divider(),
          _buildReviewItem("Atelier Trench Coat", "LKR 12,200", 'assets/images/img.png'),
          const SizedBox(height: 15),
          _summaryRow("Subtotal", "LKR 20,700"),
          _summaryRow("Shipping Fee", "LKR 450"),
          _summaryRow("Discount", "- LKR 2,070", isRed: true),
          const Divider(height: 30),
          const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("Total Amount", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), Text("LKR 19,080", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFF006D77)))]),
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

  Widget _buildReviewItem(String title, String price, String img) {
    return Row(
      children: [
        ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.asset(img, width: 50, height: 50, fit: BoxFit.cover)),
        const SizedBox(width: 15),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)), const Text("Qty: 01", style: TextStyle(color: Colors.grey, fontSize: 10))])),
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
          onPressed: () {
            // Logic for order success
            print("Order Placed!");
          },
          child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text("Place Order", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), SizedBox(width: 10), Icon(Icons.arrow_forward, color: Colors.white)]),
        ),
      ),
    );
  }
}