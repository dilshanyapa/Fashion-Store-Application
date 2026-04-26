import 'package:flutter/material.dart';
import 'product_list_screen.dart';
import 'profile_screen.dart';
import 'cart_screen.dart';
import 'product_details.dart';
import '../data/product_data.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F7),


      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 100,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
        ),
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: const TextField(
            decoration: InputDecoration(
              hintText: "Search Here",
              hintStyle: TextStyle(fontSize: 14),
              prefixIcon: Icon(Icons.search, size: 20),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(onPressed: () {

              }, icon: const Icon(Icons.shopping_cart, color: Colors.black)),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(color: Colors.cyan, shape: BoxShape.circle),
                  child: const Text('2', style: TextStyle(fontSize: 10, color: Colors.white)),
                ),
              )
            ],
          ),
          const SizedBox(width: 10),
        ],
      ),


      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),

            Center(
              child: SizedBox(
                height: 100,
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  children: [
                    _buildCategoryItem("NEW IN", 'assets/images/new.png', isSelected: true),
                    _buildCategoryItem("MEN", 'assets/images/men.png'),
                    _buildCategoryItem("WOMEN", 'assets/images/woman.png'),
                    _buildCategoryItem("ACCESSORIES", 'assets/images/acc.png'),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/banner.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: 20,
                      top: 30,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("COLLECTION 2026", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                          const Text("Elevate Your\nStyle Canvas.", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan, shape: StadiumBorder()),
                            child: const Text("Shop Now", style: TextStyle(color: Colors.white)),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),

   
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Curated For You", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text("Bespoke selections from our atelier", style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                  TextButton(onPressed: () {}, child: const Text("View All", style: TextStyle(color: Colors.cyan))),
                ],
              ),
            ),


            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              padding: const EdgeInsets.all(15),
              childAspectRatio: 0.7,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,


              children: ProductData.allProducts.map((item) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailsScreen(product: item),
                      ),
                    );
                  },
                  child: ProductCard(
                    name: item.name,
                    price: item.price,
                    image: item.image,
                  ),
                );
              }).toList(),
            ),
      ],
    ),
      ),


      bottomNavigationBar: BottomNavigationBar(
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
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ""),
        ],
      ),
    );
  }


  Widget _buildCategoryItem(String title, String img, {bool isSelected = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: isSelected ? Colors.cyan : Colors.transparent, width: 2),
            ),
            child: CircleAvatar(radius: 30, backgroundImage: AssetImage(img)),
          ),
          const SizedBox(height: 5),
          Text(title, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isSelected ? Colors.cyan : Colors.black)),
        ],
      ),
    );
  }
}


class ProductCard extends StatelessWidget {
  final String name;
  final String price;
  final String image;

  const ProductCard({super.key, required this.name, required this.price, required this.image});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
                ),
              ),
              const Positioned(
                top: 10, right: 10,
                child: Icon(Icons.favorite_border, color: Colors.white),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Rs. $price", style: const TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold)),
            Container(
              decoration: BoxDecoration(color: Colors.cyan.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.add, color: Colors.cyan, size: 20),
            )
          ],
        )
      ],
    );
  }
}
