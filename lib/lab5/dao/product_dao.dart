import '../model/lab5_product.dart';
import 'sqflite_product_dao.dart';

abstract class ProductDAO {
  const ProductDAO();

  factory ProductDAO.defaultDao() {
    return SqfliteProductDAO();
  }

  Future<List<Lab5Product>> getAll({
    String? category,
    String? query,
    bool favoritesOnly = false,
  });

  Future<List<String>> getCategories();

  Future<Lab5Product?> getById(int id);

  Future<int> insert(Lab5Product product);

  Future<int> update(Lab5Product product);

  Future<int> delete(int id);

  Future<Lab5Product?> toggleFavorite(int id);
}
