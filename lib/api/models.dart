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
    return Animal(
      id: json['id'],
      tag: json['tag'],
      dob: DateTime.parse(json['dob']),
      latestWeight: json['latest_weight'] != null ? double.tryParse(json['latest_weight'].toString()) : null,
      animalType: json['animal_type'],
      status: json['status'],
      sex: json['sex'],
      categoryTitle: json['category_title'],
      purchaseCost: json['purchase_cost'] != null ? double.tryParse(json['purchase_cost'].toString()) : null,
      imagePath: json['image_url'] != null ? baseUrl + json['image_url'] : null,
    );
  }
}


class AnimalResponse {
  final List<Animal> animals;
  final Map<String, String> animalTypes;

  AnimalResponse({required this.animals, required this.animalTypes});
}
