import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../model/lab5_product.dart';
import 'product_dao.dart';

class SqfliteProductDAO extends ProductDAO {
  SqfliteProductDAO({this.databaseName = 'lab5_products.db'});

  final String databaseName;
  Future<Database>? _databaseFuture;

  @override
  Future<List<Lab5Product>> getAll({
    String? category,
    String? query,
    bool favoritesOnly = false,
  }) async {
    final db = await _database;
    final whereParts = <String>[];
    final whereArgs = <Object?>[];

    if (category != null &&
        category.isNotEmpty &&
        category != Lab5Product.allCategory) {
      whereParts.add('category = ?');
      whereArgs.add(category);
    }

    final keyword = query?.trim();
    if (keyword != null && keyword.isNotEmpty) {
      whereParts.add(
        '(LOWER(name) LIKE ? OR LOWER(category) LIKE ? OR LOWER(description) LIKE ?)',
      );
      final pattern = '%${keyword.toLowerCase()}%';
      whereArgs.addAll([pattern, pattern, pattern]);
    }

    if (favoritesOnly) {
      whereParts.add('is_favorite = ?');
      whereArgs.add(1);
    }

    final rows = await db.query(
      Lab5Product.tableName,
      where: whereParts.isEmpty ? null : whereParts.join(' AND '),
      whereArgs: whereArgs,
      orderBy: 'id ASC',
    );

    return rows.map(Lab5Product.fromMap).toList();
  }

  @override
  Future<List<String>> getCategories() async {
    final db = await _database;
    final rows = await db.query(
      Lab5Product.tableName,
      columns: ['category'],
      distinct: true,
      orderBy: 'category ASC',
    );
    final categories = {
      ...Lab5Product.categories,
      for (final row in rows)
        if ((row['category']?.toString().trim() ?? '').isNotEmpty)
          row['category'].toString(),
    }.toList();

    categories.sort();
    return categories;
  }

  @override
  Future<Lab5Product?> getById(int id) async {
    final db = await _database;
    final rows = await db.query(
      Lab5Product.tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (rows.isEmpty) {
      return null;
    }

    return Lab5Product.fromMap(rows.first);
  }

  @override
  Future<int> insert(Lab5Product product) async {
    final db = await _database;
    return db.insert(
      Lab5Product.tableName,
      product.toMap(includeId: false),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<int> update(Lab5Product product) async {
    final id = product.id;
    if (id == null) {
      return 0;
    }

    final db = await _database;
    return db.update(
      Lab5Product.tableName,
      product.toMap(includeId: false),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<int> delete(int id) async {
    final db = await _database;
    return db.delete(Lab5Product.tableName, where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<Lab5Product?> toggleFavorite(int id) async {
    final product = await getById(id);
    if (product == null) {
      return null;
    }

    final updated = product.copyWith(isFavorite: !product.isFavorite);
    await update(updated);

    return updated;
  }

  Future<Database> get _database {
    _databaseFuture ??= _openDatabase();
    return _databaseFuture!;
  }

  Future<Database> _openDatabase() async {
    final databasePath = p.join(await getDatabasesPath(), databaseName);
    final db = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE ${Lab5Product.tableName} (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            category TEXT NOT NULL,
            description TEXT NOT NULL,
            price REAL NOT NULL,
            quantity INTEGER NOT NULL,
            rating REAL NOT NULL,
            image_asset TEXT NOT NULL,
            is_favorite INTEGER NOT NULL DEFAULT 0,
            created_at TEXT NOT NULL
          )
        ''');
      },
    );

    await _seedIfEmpty(db);
    return db;
  }

  Future<void> _seedIfEmpty(Database db) async {
    final rows = await db.rawQuery(
      'SELECT COUNT(*) AS count FROM ${Lab5Product.tableName}',
    );
    final count = Sqflite.firstIntValue(rows) ?? 0;
    if (count > 0) {
      return;
    }

    final batch = db.batch();
    for (final product in Lab5Product.seedProducts()) {
      batch.insert(Lab5Product.tableName, product.toMap(includeId: false));
    }

    await batch.commit(noResult: true);
  }
}
