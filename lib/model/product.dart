class Product {
  final int? id;
  final String name;
  final int quantity;
  final double price;
  final String category;
  final String? imagePath;
  final DateTime createdAt;

  Product({
    this.id,
    required this.name,
    required this.quantity,
    required this.price,
    required this.category,
    this.imagePath,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Convert Product to Map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'price': price,
      'category': category,
      'imagePath': imagePath,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Convert Map to Product
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      quantity: map['quantity'],
      price: map['price'],
      category: map['category'],
      imagePath: map['imagePath'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

// Copy with updated fields
  Product copyWith({
    int? id,
    String? name,
    int? quantity,
    double? price,
    String? category,
    String? imagePath,
    DateTime? createdAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      category: category ?? this.category,
      imagePath: imagePath ?? this.imagePath,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}