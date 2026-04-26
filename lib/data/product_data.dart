import '../models/product_model.dart';

class ProductData {
  static List<Product> allProducts = [
    Product(
      name: "Atelier Trench Coat",
      price: "3,500",
      originalPrice: "5,000",
      image: 'assets/images/img.png',
      description: "Crafted from premium fabric, this Atelier Trench Coat offers a timeless silhouette for the modern wardrobe.",
    ),
    Product(
      name: "POLO T-shirt",
      price: "1,950",
      originalPrice: "2,500",
      image: 'assets/images/polo.jpg',
      description: "A cozy and stylish knit sweater in a vibrant azure blue.",
    ),
    Product(
      name: "Woman Collection",
      price: "8,900",
      originalPrice: "10,500",
      image: 'assets/images/woman.png',
      description: "Elegant wear designed specifically for modern feminine styles.",
    ),
    Product(
      name: "Azure Knit Sweater",
      price: "8,900",
      originalPrice: "10,500",
      image: 'assets/images/men2.jpg',
      description: "A cozy and stylish knit sweater in a vibrant azure blue.",
    ),
  ];
}