import '../models/product_model.dart';

class ProductSearchController {
  static List<Product> filterProducts({
    required List<Product> allProducts,
    required String query,
  }) {
    if (query.isEmpty) {
      return allProducts; 
    }
    
    return allProducts.where((product) {
      final nameLower = product.name.toLowerCase();
      final searchLower = query.toLowerCase();
      return nameLower.contains(searchLower);
    }).toList();
  }
}