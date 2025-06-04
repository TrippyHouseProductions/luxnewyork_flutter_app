class Product {
  final String name;
  final String category;
  final String price;
  final String imagePath;
  final String description;

  Product({
    required this.name,
    required this.category,
    required this.price,
    required this.imagePath,
    required this.description,
  });
}

List<Product> products = [
  Product(
    name: "LNY V-1",
    category: "Unisex Sunglasses",
    price: "\$52.00",
    imagePath: "../assets/images/1.webp",
    description:
        "The LNY V-1 is a stylish unisex sunglass with a modern design perfect for outdoor activities and casual wear.",
  ),
  Product(
    name: "LNY D-6",
    category: "Unisex Sunglasses",
    price: "\$104.00",
    imagePath: "assets/images/2.webp",
    description:
        "The LNY D-6 offers an elegant and sophisticated look with superior UV protection for all-day comfort.",
  ),
  Product(
    name: "LNY G-9",
    category: "Unisex Sunglasses",
    price: "\$64.99",
    imagePath: "assets/images/3.webp",
    description:
        "The LNY G-9 features a lightweight frame and high-quality lenses, designed for all-day wear.",
  ),
  Product(
    name: "LNY C-5",
    category: "Unisex Sunglasses",
    price: "\$118.00",
    imagePath: "assets/images/4.webp",
    description:
        "The LNY C-5 provides a bold and classic design for those who want to stand out in the crowd.",
  ),
  Product(
    name: "LNY LE",
    category: "Unisex Sunglasses",
    price: "\$48.00",
    imagePath: "assets/images/5.webp",
    description:
        "The LNY LE combines comfort and style, with a minimalist design that's perfect for everyday wear.",
  ),
  Product(
    name: "LNY L-88",
    category: "Unisex Sunglasses",
    price: "\$78.90",
    imagePath: "assets/images/6.webp",
    description:
        "The LNY L-88 is a perfect blend of luxury and sport, offering excellent UV protection and a sleek design.",
  ),
  Product(
    name: "LNY Origin",
    category: "Unisex Sunglasses",
    price: "\$60.00",
    imagePath: "assets/images/7.webp",
    description:
        "The LNY Origin has a timeless design, suitable for both men and women, with top-notch lenses for eye protection.",
  ),
  Product(
    name: "LNY G-2",
    category: "Unisex Sunglasses",
    price: "\$122.99",
    imagePath: "assets/images/8.webp",
    description:
        "The LNY G-2 delivers premium performance with high-quality materials, designed to fit every style.",
  ),
  Product(
    name: "LNY PL",
    category: "Unisex Sunglasses",
    price: "\$152.00",
    imagePath: "assets/images/9.webp",
    description:
        "The LNY PL is the epitome of elegance and class, featuring polarized lenses for ultimate eye protection.",
  ),
  Product(
    name: "LNY R-6",
    category: "Unisex Sunglasses",
    price: "\$80.00",
    imagePath: "assets/images/10.webp",
    description:
        "The LNY R-6 is designed for active individuals who need a durable and stylish pair of sunglasses.",
  ),
];
