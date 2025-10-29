import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:hng_storekeeper_app/model/product.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('storekeeper.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const intType = 'INTEGER NOT NULL';
    const realType = 'REAL NOT NULL';
    const textTypeNullable = 'TEXT';

    await db.execute('''
      CREATE TABLE products (
        id $idType,
        name $textType,
        quantity $intType,
        price $realType,
        category $textType,
        imagePath $textTypeNullable,
        createdAt $textType
      )
    ''');
  }

  // CREATE - Insert a product
  Future<Product> createProduct(Product product) async {
    final db = await instance.database;
    final id = await db.insert('products', product.toMap());
    return product.copyWith(id: id);
  }

  // READ - Get all products
  Future<List<Product>> getAllProducts() async {
    final db = await instance.database;
    const orderBy = 'createdAt DESC';
    final result = await db.query('products', orderBy: orderBy);
    return result.map((map) => Product.fromMap(map)).toList();
  }

  // READ - Get products by category
  Future<List<Product>> getProductsByCategory(String category) async {
    final db = await instance.database;
    final result = await db.query(
      'products',
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'createdAt DESC',
    );
    return result.map((map) => Product.fromMap(map)).toList();
  }

  // READ - Get single product
  Future<Product?> getProduct(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Product.fromMap(maps.first);
    } else {
      return null;
    }
  }

  // READ - Get all unique categories
  Future<List<String>> getAllCategories() async {
    final db = await instance.database;
    final result = await db.rawQuery(
      'SELECT DISTINCT category FROM products ORDER BY category',
    );
    return result.map((map) => map['category'] as String).toList();
  }

  // READ - Get product count by category
  Future<int> getProductCountByCategory(String category) async {
    final db = await instance.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM products WHERE category = ?',
      [category],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // UPDATE - Update a product
  Future<int> updateProduct(Product product) async {
    final db = await instance.database;
    return db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  // DELETE - Delete a product
  Future<int> deleteProduct(int id) async {
    final db = await instance.database;
    return await db.delete(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // DELETE - Delete all products in a category
  Future<int> deleteCategory(String category) async {
    final db = await instance.database;
    return await db.delete(
      'products',
      where: 'category = ?',
      whereArgs: [category],
    );
  }

  // Close database
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}