class Product {
  // ... other fields ...

  final String? salePrice;
  final String? purchasePrice;
  final String? quantity;

  // ... constructor ...

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      imageUrl: json['image_url'] != null
          ? 'http://app.channab.com' + json['image_url']
          : 'assets/images/default_image.png',
      salePrice: json['sale_price']?.toString(),
      purchasePrice: json['purchase_price']?.toString(),
      quantity: json['current_stock']?.toString(),
      // ... other fields ...
    );
  }
}
