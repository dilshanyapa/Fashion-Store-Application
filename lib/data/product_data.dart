import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class ProductData {

  static List<Product> allProducts = [];

  static List<Map<String, dynamic>> globalCartItems = [];

  static Stream<List<Product>> getFirebaseProducts() {
    return FirebaseFirestore.instance
        .collection('products')
        .snapshots()
        .map((snapshot) {
  
      return snapshot.docs.map((doc) {
        var data = doc.data();
        return Product(
          name: data['name'] ?? 'No Name',
          price: data['price']?.toString() ?? '0', 
          originalPrice: data['originalPrice'] ?? '0',
          image: data['imageUrl'] ?? '',  
          description: data['description'] ?? '',
        );
      }).toList();
    });
  }
}