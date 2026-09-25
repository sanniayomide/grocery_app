import 'package:cloud_firestore/cloud_firestore.dart';

enum CategoryId {
  all,
  vegetables,
  fruits,
  dairy,
  meat,
  bakery,
  drinks,
  pantry,
  snacks,
}

class ProductCategory {
  final CategoryId id;
  final String name;
  final int iconCodePoint;
  final int bgColorHex;
  final int displayOrder;

  const ProductCategory({
    required this.id,
    required this.name,
    required this.iconCodePoint,
    required this.bgColorHex,
    required this.displayOrder,
  });

  String get idString => id.name;

  static const ProductCategory all = ProductCategory(
    id: CategoryId.all,
    name: 'All',
    iconCodePoint: 0xE8EF,
    bgColorHex: 0xFFEDE7F6,
    displayOrder: 0,
  );

  static const List<ProductCategory> seed = [
    all,
    ProductCategory(
      id: CategoryId.vegetables,
      name: 'Vegetables',
      iconCodePoint: 0xE56E,
      bgColorHex: 0xFFE8F5E9,
      displayOrder: 1,
    ),
    ProductCategory(
      id: CategoryId.fruits,
      name: 'Fruits',
      iconCodePoint: 0xF527,
      bgColorHex: 0xFFFFF3E0,
      displayOrder: 2,
    ),
    ProductCategory(
      id: CategoryId.dairy,
      name: 'Dairy',
      iconCodePoint: 0xF04D,
      bgColorHex: 0xFFE3F2FD,
      displayOrder: 3,
    ),
    ProductCategory(
      id: CategoryId.meat,
      name: 'Meat',
      iconCodePoint: 0xF20B,
      bgColorHex: 0xFFFFEBEE,
      displayOrder: 4,
    ),
    ProductCategory(
      id: CategoryId.bakery,
      name: 'Bakery',
      iconCodePoint: 0xF24A,
      bgColorHex: 0xFFFFF8E1,
      displayOrder: 5,
    ),
    ProductCategory(
      id: CategoryId.drinks,
      name: 'Drinks',
      iconCodePoint: 0xE8EF,
      bgColorHex: 0xFFE8F5E9,
      displayOrder: 6,
    ),
    ProductCategory(
      id: CategoryId.pantry,
      name: 'Pantry',
      iconCodePoint: 0xEF49,
      bgColorHex: 0xFFF3E5F5,
      displayOrder: 7,
    ),
    ProductCategory(
      id: CategoryId.snacks,
      name: 'Snacks',
      iconCodePoint: 0xE47C,
      bgColorHex: 0xFFFFFDE7,
      displayOrder: 8,
    ),
  ];

  factory ProductCategory.fromFirestore(Map<String, dynamic> map) {
    return ProductCategory(
      id: categoryIdFromString(map['id'] as String? ?? 'all'),
      name: map['name'] as String? ?? 'Category',
      iconCodePoint: map['iconCodePoint'] as int? ?? 0xE8EF,
      bgColorHex: map['bgColorHex'] as int? ?? 0xFFEDE7F6,
      displayOrder: map['displayOrder'] as int? ?? 99,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': idString,
      'name': name,
      'iconCodePoint': iconCodePoint,
      'bgColorHex': bgColorHex,
      'displayOrder': displayOrder,
    };
  }
}

CategoryId categoryIdFromString(String value) {
  return CategoryId.values.firstWhere(
    (category) => category.name == value,
    orElse: () => CategoryId.vegetables,
  );
}

enum UnitType { each, kg, g, l, ml, pack, bunch }

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? originalPrice;
  final CategoryId categoryId;
  final String? imageUrl;
  final String emojiFallback;
  final String unitLabel;
  final UnitType unitType;
  final double? weightGrams;
  final bool isFeatured;
  final bool isOrganic;
  final int stockQuantity;
  final int salesCount;
  final double rating;
  final int ratingCount;
  final DateTime? createdAt;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    required this.categoryId,
    this.imageUrl,
    required this.emojiFallback,
    required this.unitLabel,
    required this.unitType,
    this.weightGrams,
    this.isFeatured = false,
    this.isOrganic = false,
    this.stockQuantity = 50,
    this.salesCount = 0,
    this.rating = 4.8,
    this.ratingCount = 12,
    this.createdAt,
  });

  bool get isOnSale => originalPrice != null && originalPrice! > price;

  bool get inStock => stockQuantity > 0;

  double get discountPercent {
    if (!isOnSale) return 0;
    return ((originalPrice! - price) / originalPrice!) * 100;
  }

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? originalPrice,
    CategoryId? categoryId,
    String? imageUrl,
    String? emojiFallback,
    String? unitLabel,
    UnitType? unitType,
    double? weightGrams,
    bool? isFeatured,
    bool? isOrganic,
    int? stockQuantity,
    int? salesCount,
    double? rating,
    int? ratingCount,
    DateTime? createdAt,
    bool clearOriginalPrice = false,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      originalPrice:
          clearOriginalPrice ? null : originalPrice ?? this.originalPrice,
      categoryId: categoryId ?? this.categoryId,
      imageUrl: imageUrl ?? this.imageUrl,
      emojiFallback: emojiFallback ?? this.emojiFallback,
      unitLabel: unitLabel ?? this.unitLabel,
      unitType: unitType ?? this.unitType,
      weightGrams: weightGrams ?? this.weightGrams,
      isFeatured: isFeatured ?? this.isFeatured,
      isOrganic: isOrganic ?? this.isOrganic,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      salesCount: salesCount ?? this.salesCount,
      rating: rating ?? this.rating,
      ratingCount: ratingCount ?? this.ratingCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'originalPrice': originalPrice,
      'categoryId': categoryId.name,
      'imageUrl': imageUrl,
      'emojiFallback': emojiFallback,
      'unitLabel': unitLabel,
      'unitType': unitType.name,
      'weightGrams': weightGrams,
      'isFeatured': isFeatured,
      'isOrganic': isOrganic,
      'stockQuantity': stockQuantity,
      'salesCount': salesCount,
      'rating': rating,
      'ratingCount': ratingCount,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory Product.fromFirestore(
    Map<String, dynamic> map, [
    String? documentId,
  ]) {
    return Product(
      id: documentId ?? map['id'] as String? ?? 'product-unknown',
      name: map['name'] as String? ?? 'Product',
      description: map['description'] as String? ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0,
      originalPrice: (map['originalPrice'] as num?)?.toDouble(),
      categoryId: categoryIdFromString(
        map['categoryId'] as String? ?? CategoryId.vegetables.name,
      ),
      imageUrl: map['imageUrl'] as String?,
      emojiFallback: map['emojiFallback'] as String? ?? '🥬',
      unitLabel: map['unitLabel'] as String? ?? 'each',
      unitType: UnitType.values.firstWhere(
        (unit) => unit.name == (map['unitType'] as String?),
        orElse: () => UnitType.each,
      ),
      weightGrams: (map['weightGrams'] as num?)?.toDouble(),
      isFeatured: map['isFeatured'] as bool? ?? false,
      isOrganic: map['isOrganic'] as bool? ?? false,
      stockQuantity: map['stockQuantity'] as int? ?? 0,
      salesCount: map['salesCount'] as int? ?? 0,
      rating: (map['rating'] as num?)?.toDouble() ?? 4.5,
      ratingCount: map['ratingCount'] as int? ?? 0,
      createdAt: _parseDate(map['createdAt']),
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  static List<Product> demoProducts() {
    return const [
      Product(
        id: 'broccoli_organic',
        name: 'Organic Broccoli',
        description: 'Fresh organic broccoli sourced from trusted local farms.',
        price: 6.99,
        originalPrice: 8.49,
        categoryId: CategoryId.vegetables,
        emojiFallback: '🥦',
        unitLabel: '1 bunch',
        unitType: UnitType.bunch,
        isFeatured: true,
        isOrganic: true,
        stockQuantity: 24,
        salesCount: 110,
        rating: 4.9,
        ratingCount: 48,
      ),
      Product(
        id: 'avocado_hass',
        name: 'Hass Avocado',
        description: 'Creamy ripe avocados perfect for toast, salads, or smoothies.',
        price: 2.49,
        categoryId: CategoryId.fruits,
        emojiFallback: '🥑',
        unitLabel: 'each',
        unitType: UnitType.each,
        isFeatured: true,
        stockQuantity: 40,
        salesCount: 132,
        rating: 4.8,
        ratingCount: 64,
      ),
      Product(
        id: 'farm_eggs',
        name: 'Farm Fresh Eggs',
        description: 'A dozen rich and nutritious farm eggs.',
        price: 5.99,
        categoryId: CategoryId.dairy,
        emojiFallback: '🥚',
        unitLabel: '12 pcs',
        unitType: UnitType.pack,
        stockQuantity: 36,
        salesCount: 90,
        rating: 4.7,
        ratingCount: 38,
      ),
      Product(
        id: 'whole_milk',
        name: 'Whole Milk',
        description: 'Creamy full-fat milk, chilled and ready for delivery.',
        price: 4.19,
        categoryId: CategoryId.dairy,
        emojiFallback: '🥛',
        unitLabel: '1L',
        unitType: UnitType.l,
        stockQuantity: 18,
        salesCount: 70,
        rating: 4.6,
        ratingCount: 24,
      ),
      Product(
        id: 'banana_bunch',
        name: 'Sweet Banana',
        description: 'Naturally sweet bananas sold in a fresh bunch.',
        price: 3.49,
        categoryId: CategoryId.fruits,
        emojiFallback: '🍌',
        unitLabel: '1 bunch',
        unitType: UnitType.bunch,
        isFeatured: true,
        stockQuantity: 30,
        salesCount: 140,
        rating: 4.9,
        ratingCount: 72,
      ),
      Product(
        id: 'carrot_pack',
        name: 'Crunchy Carrots',
        description: 'Bright and crunchy carrots for soups, salads, and snacks.',
        price: 4.29,
        categoryId: CategoryId.vegetables,
        emojiFallback: '🥕',
        unitLabel: '500g pack',
        unitType: UnitType.pack,
        weightGrams: 500,
        stockQuantity: 26,
        salesCount: 84,
        rating: 4.7,
        ratingCount: 30,
      ),
      Product(
        id: 'sourdough_loaf',
        name: 'Sourdough Bread',
        description: 'Artisan baked sourdough loaf with a golden crust.',
        price: 7.89,
        categoryId: CategoryId.bakery,
        emojiFallback: '🍞',
        unitLabel: '1 loaf',
        unitType: UnitType.each,
        stockQuantity: 14,
        salesCount: 41,
        rating: 4.8,
        ratingCount: 20,
      ),
      Product(
        id: 'orange_juice',
        name: 'Orange Juice',
        description: 'Cold pressed orange juice with no added sugar.',
        price: 5.59,
        categoryId: CategoryId.drinks,
        emojiFallback: '🍊',
        unitLabel: '1L',
        unitType: UnitType.l,
        stockQuantity: 22,
        salesCount: 55,
        rating: 4.6,
        ratingCount: 19,
      ),
      Product(
        id: 'chicken_breast',
        name: 'Chicken Breast',
        description: 'Lean skinless chicken breast, trimmed and ready to cook.',
        price: 12.99,
        originalPrice: 14.49,
        categoryId: CategoryId.meat,
        emojiFallback: '🍗',
        unitLabel: '1kg',
        unitType: UnitType.kg,
        isFeatured: true,
        stockQuantity: 12,
        salesCount: 52,
        rating: 4.8,
        ratingCount: 22,
      ),
      Product(
        id: 'granola_mix',
        name: 'Granola Mix',
        description: 'A wholesome snack blend of oats, nuts, and dried fruit.',
        price: 6.49,
        categoryId: CategoryId.snacks,
        emojiFallback: '🥣',
        unitLabel: '350g',
        unitType: UnitType.pack,
        weightGrams: 350,
        stockQuantity: 19,
        salesCount: 28,
        rating: 4.5,
        ratingCount: 16,
      ),
    ];
  }
}
