class Animal {
  final int id;
  final String tag;
  final DateTime dob;
  final double? latestWeight; // latestWeight can be null
  final String animalType;
  final String status;
  final String sex;
  final String categoryTitle;
  final double? purchaseCost; // purchaseCost can be null
  final String? imagePath; // imagePath can be null

  Animal({
    required this.id,
    required this.tag,
    required this.dob,
    this.latestWeight,
    required this.animalType,
    required this.status,
    required this.sex,
    required this.categoryTitle,
    this.purchaseCost,
    this.imagePath,
  });

  factory Animal.fromJson(Map<String, dynamic> json) {
    String baseUrl = 'http://farmapp.channab.com';
    String imagePath = json['image'] as String? ?? '';
    String fullImagePath = imagePath.isNotEmpty ? baseUrl + imagePath : 'default_image_url_here';
    return Animal(
      id: json['id'] ?? 0,  // Assuming 0 as a default id, or handle appropriately
      tag: json['tag'] ?? 'Unknown',  // Providing a default value if tag is null
      dob: DateTime.parse(json['dob'] ?? '1900-01-01'),  // Default to a fallback date
      latestWeight: json['latest_weight'] != null ? double.tryParse(json['latest_weight'].toString()) : null,
      animalType: json['animal_type'] ?? 'Unknown',  // Default type
      status: json['status'] ?? 'Unknown',  // Default status
      sex: json['sex'] ?? 'Unknown',  // Default sex
      categoryTitle: json['category_title'] ?? 'Unknown',  // Default category title
      purchaseCost: json['purchase_cost'] != null ? double.tryParse(json['purchase_cost'].toString()) : null,
      imagePath: fullImagePath,
    );
  }


}


