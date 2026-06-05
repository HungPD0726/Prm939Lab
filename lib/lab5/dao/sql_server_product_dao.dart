import 'dart:io';

import 'package:sql_conn/sql_conn.dart';

import '../config/sql_server_config.dart';
import '../model/lab5_product.dart';
import 'product_dao.dart';

class SqlServerProductDAO extends ProductDAO {
  SqlServerProductDAO({required SqlServerConfig config}) : _config = config;

  final SqlServerConfig _config;
  final Set<int> _favoriteIds = <int>{};
  Future<void>? _connectionFuture;

  @override
  Future<List<Lab5Product>> getAll({
    String? category,
    String? query,
    bool favoritesOnly = false,
  }) async {
    await _ensureConnected();

    final whereParts = <String>[];
    final params = <Object?>[];

    if (category != null &&
        category.isNotEmpty &&
        category != Lab5Product.allCategory) {
      whereParts.add('c.CategoryName = ?');
      params.add(category);
    }

    final keyword = query?.trim();
    if (keyword != null && keyword.isNotEmpty) {
      whereParts.add(
        '(b.BookName LIKE ? OR c.CategoryName LIKE ? OR b.Description LIKE ?)',
      );
      final searchValue = '%$keyword%';
      params.addAll([searchValue, searchValue, searchValue]);
    }

    final sql = StringBuffer(_selectBooksSql);
    if (whereParts.isNotEmpty) {
      sql.write(' WHERE ${whereParts.join(' AND ')}');
    }
    sql.write(' ORDER BY b.BookID DESC');

    final rows = await SqlConn.read(
      _config.connectionId,
      sql.toString(),
      params: params,
    );
    final products = rows.map(_productFromBookRow).toList();

    if (favoritesOnly) {
      return products
          .where(
            (product) =>
                product.id != null && _favoriteIds.contains(product.id),
          )
          .toList();
    }

    return products;
  }

  @override
  Future<List<String>> getCategories() async {
    await _ensureConnected();

    final rows = await SqlConn.read(_config.connectionId, '''
      SELECT CategoryName
      FROM dbo.Category
      ORDER BY CategoryName
      ''');

    final categories = rows
        .map((row) => row['CategoryName']?.toString().trim() ?? '')
        .where((category) => category.isNotEmpty)
        .toList();

    return categories.isEmpty ? Lab5Product.categories : categories;
  }

  @override
  Future<Lab5Product?> getById(int id) async {
    await _ensureConnected();

    final rows = await SqlConn.read(
      _config.connectionId,
      '$_selectBooksSql WHERE b.BookID = ?',
      params: [id],
    );

    if (rows.isEmpty) {
      return null;
    }

    return _productFromBookRow(rows.first);
  }

  @override
  Future<int> insert(Lab5Product product) async {
    await _ensureConnected();

    final categoryId = await _getOrCreateCategoryId(product.category);
    final publisherId = await _getOrCreatePublisherId('Default Publisher');

    final idRows = await SqlConn.read(
      _config.connectionId,
      '''
      INSERT INTO dbo.Book
        (BookName, Quantity, Available, CategoryID, PublisherID, Description, ShelfLocation, ImageUrl)
      OUTPUT INSERTED.BookID
      VALUES (?, ?, ?, ?, ?, ?, ?, ?)
      ''',
      params: [
        product.name,
        product.quantity,
        product.quantity,
        categoryId,
        publisherId,
        product.description,
        'Lab 5',
        _imageUrlForSqlServer(product.imageAsset),
      ],
    );
    final bookId = _toInt(idRows.first['BookID']);

    await _insertBookPrice(bookId, product.price);

    return 1;
  }

  @override
  Future<int> update(Lab5Product product) async {
    await _ensureConnected();

    final id = product.id;
    if (id == null) {
      throw ArgumentError('A product id is required for update.');
    }

    final categoryId = await _getOrCreateCategoryId(product.category);
    final rowsAffected = await SqlConn.write(
      _config.connectionId,
      '''
      UPDATE dbo.Book
      SET BookName = ?,
          Quantity = ?,
          Available = ?,
          CategoryID = ?,
          Description = ?,
          ImageUrl = ?
      WHERE BookID = ?
      ''',
      params: [
        product.name,
        product.quantity,
        product.quantity,
        categoryId,
        product.description,
        _imageUrlForSqlServer(product.imageAsset),
        id,
      ],
    );

    await _updateLatestBookPrice(id, product.price);

    return rowsAffected;
  }

  @override
  Future<int> delete(int id) async {
    await _ensureConnected();

    await SqlConn.write(
      _config.connectionId,
      'DELETE FROM dbo.BookPrice WHERE BookID = ?',
      params: [id],
    );

    return SqlConn.write(
      _config.connectionId,
      'DELETE FROM dbo.Book WHERE BookID = ?',
      params: [id],
    );
  }

  @override
  Future<Lab5Product?> toggleFavorite(int id) async {
    final product = await getById(id);
    if (product == null) {
      return null;
    }

    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id);
    } else {
      _favoriteIds.add(id);
    }

    return product.copyWith(isFavorite: _favoriteIds.contains(id));
  }

  Future<void> _ensureConnected() {
    _connectionFuture ??= _connect();
    return _connectionFuture!;
  }

  Future<void> _connect() async {
    if (!Platform.isAndroid) {
      throw UnsupportedError(
        'SQL Server direct connection uses sql_conn and only runs on Android. '
        'Run on an Android emulator/device, or set LAB5_USE_SQL_SERVER=false '
        'to use the local SQLite DAO.',
      );
    }

    if (!_config.hasCredentials) {
      throw StateError(
        'Missing SQL Server credentials. Run with '
        '--dart-define=LAB5_DB_USER=your_user '
        '--dart-define=LAB5_DB_PASSWORD=your_password',
      );
    }

    final connected = await SqlConn.connect(
      connectionId: _config.connectionId,
      host: _config.host,
      port: _config.port,
      database: _config.database,
      username: _config.username,
      password: _config.password,
      ssl: _config.ssl,
      trustServerCertificate: _config.trustServerCertificate,
    );

    if (!connected) {
      throw StateError('Could not connect to SQL Server ${_config.database}.');
    }
  }

  Lab5Product _productFromBookRow(Map<String, Object?> row) {
    final id = _toNullableInt(row['id']);

    return Lab5Product(
      id: id,
      name: row['name']?.toString() ?? '',
      category: row['category']?.toString() ?? 'Uncategorized',
      description: row['description']?.toString() ?? '',
      price: _toDouble(row['price']),
      quantity: _toInt(row['quantity']),
      rating: _toDouble(row['rating']),
      imageAsset: _imageAssetFromSqlServer(row['image_asset']),
      isFavorite: id != null && _favoriteIds.contains(id),
      createdAt: DateTime.now(),
    );
  }

  Future<int> _getOrCreateCategoryId(String categoryName) async {
    final rows = await SqlConn.read(
      _config.connectionId,
      'SELECT CategoryID FROM dbo.Category WHERE CategoryName = ?',
      params: [categoryName],
    );

    if (rows.isNotEmpty) {
      return _toInt(rows.first['CategoryID']);
    }

    await SqlConn.write(
      _config.connectionId,
      'INSERT INTO dbo.Category (CategoryName) VALUES (?)',
      params: [categoryName],
    );

    final inserted = await SqlConn.read(
      _config.connectionId,
      'SELECT CategoryID FROM dbo.Category WHERE CategoryName = ?',
      params: [categoryName],
    );

    return _toInt(inserted.first['CategoryID']);
  }

  Future<int> _getOrCreatePublisherId(String publisherName) async {
    final rows = await SqlConn.read(
      _config.connectionId,
      'SELECT PublisherID FROM dbo.Publisher WHERE PublisherName = ?',
      params: [publisherName],
    );

    if (rows.isNotEmpty) {
      return _toInt(rows.first['PublisherID']);
    }

    await SqlConn.write(
      _config.connectionId,
      'INSERT INTO dbo.Publisher (PublisherName) VALUES (?)',
      params: [publisherName],
    );

    final inserted = await SqlConn.read(
      _config.connectionId,
      'SELECT PublisherID FROM dbo.Publisher WHERE PublisherName = ?',
      params: [publisherName],
    );

    return _toInt(inserted.first['PublisherID']);
  }

  Future<void> _insertBookPrice(int bookId, double price) async {
    final priceRows = await SqlConn.read(
      _config.connectionId,
      '''
      INSERT INTO dbo.Price (Amount, Currency, Note)
      OUTPUT INSERTED.PriceID
      VALUES (?, ?, ?)
      ''',
      params: [price, 'VND', 'Lab 5 product price'],
    );
    final priceId = _toInt(priceRows.first['PriceID']);

    await SqlConn.write(
      _config.connectionId,
      '''
      INSERT INTO dbo.BookPrice (BookID, PriceID, StartDate)
      VALUES (?, ?, CAST(GETDATE() AS date))
      ''',
      params: [bookId, priceId],
    );
  }

  Future<void> _updateLatestBookPrice(int bookId, double price) async {
    final rowsAffected = await SqlConn.write(
      _config.connectionId,
      '''
      UPDATE p
      SET p.Amount = ?
      FROM dbo.Price p
      INNER JOIN dbo.BookPrice bp ON bp.PriceID = p.PriceID
      WHERE bp.BookID = ?
        AND bp.StartDate = (
          SELECT MAX(StartDate)
          FROM dbo.BookPrice
          WHERE BookID = ?
        )
      ''',
      params: [price, bookId, bookId],
    );

    if (rowsAffected == 0) {
      await _insertBookPrice(bookId, price);
    }
  }

  String _imageUrlForSqlServer(String imageAsset) {
    if (imageAsset == 'assets/cr7.jpg') {
      return '';
    }

    return imageAsset;
  }

  String _imageAssetFromSqlServer(Object? value) {
    final raw = value?.toString().trim() ?? '';
    if (raw.isEmpty) {
      return 'assets/cr7.jpg';
    }

    return raw;
  }

  static const _selectBooksSql = '''
    SELECT
      b.BookID AS id,
      b.BookName AS name,
      COALESCE(c.CategoryName, 'Uncategorized') AS category,
      COALESCE(b.Description, '') AS description,
      COALESCE(priceData.Amount, 0) AS price,
      b.Quantity AS quantity,
      COALESCE(reviewData.Rating, 0) AS rating,
      COALESCE(b.ImageUrl, '') AS image_asset
    FROM dbo.Book b
    LEFT JOIN dbo.Category c ON c.CategoryID = b.CategoryID
    OUTER APPLY (
      SELECT TOP 1 p.Amount
      FROM dbo.BookPrice bp
      INNER JOIN dbo.Price p ON p.PriceID = bp.PriceID
      WHERE bp.BookID = b.BookID
      ORDER BY bp.StartDate DESC, p.PriceID DESC
    ) priceData
    OUTER APPLY (
      SELECT AVG(CAST(br.Rating AS float)) AS Rating
      FROM dbo.BookReview br
      WHERE br.BookID = b.BookID
    ) reviewData
  ''';

  int? _toNullableInt(Object? value) {
    if (value == null) {
      return null;
    }

    return _toInt(value);
  }

  int _toInt(Object? value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.parse(value.toString());
  }

  double _toDouble(Object? value) {
    if (value is double) {
      return value;
    }

    if (value is num) {
      return value.toDouble();
    }

    if (value == null || value.toString().trim().isEmpty) {
      return 0;
    }

    return double.parse(value.toString());
  }
}
