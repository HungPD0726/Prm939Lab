import '../config/sql_server_config.dart';
import '../model/lab5_product.dart';
import 'sql_server_product_dao.dart';

abstract class ProductDAO {
  const ProductDAO();

  factory ProductDAO.sqlServer({SqlServerConfig? config}) {
    return SqlServerProductDAO(
      config: config ?? SqlServerConfig.fromEnvironment(),
    );
  }

  factory ProductDAO.defaultDao() {
    return ProductDAO.sqlServer();
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
