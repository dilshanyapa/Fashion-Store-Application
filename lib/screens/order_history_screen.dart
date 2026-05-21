import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

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
        title: const Text("Order History", style: TextStyle(color: Color(0xFF008B9A), fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .orderBy('order_date', descending: true) 
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.cyan));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history_toggle_off, size: 60, color: Colors.grey),
                  SizedBox(height: 10),
                  Text("No previous orders found.", style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

 
          var orders = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              var order = orders[index].data() as Map<String, dynamic>;
              

              DateTime orderDate = (order['order_date'] as Timestamp).toDate();
              String formattedDate = "${orderDate.day}/${orderDate.month}/${orderDate.year}";

              return Container(
                margin: const EdgeInsets.only(bottom: 15),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5, spreadRadius: 1)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Order #${orders[index].id.substring(0, 7).toUpperCase()}", // කෙටි ID එකක් පෙන්වයි
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.teal.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            order['status'] ?? 'Pending',
                            style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text("Date: $formattedDate", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    const Divider(height: 20),
                    
                  
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: (order['items'] as List).map((item) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text("• ${item['name']} (${item['size']}) x${item['quantity']}",
                              style: const TextStyle(color: Colors.black87, fontSize: 13)),
                        );
                      }).toList(),
                    ),
                    
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Total Amount:", style: TextStyle(color: Colors.grey, fontSize: 13)),
                        Text("LKR ${order['total_amount'].toStringAsFixed(2)}",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF006D77))),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}