import 'package:tithes/data/datasources/local_data_source.dart';
import 'package:tithes/data/models/category.dart';
import 'package:tithes/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  @override
  Future<void> addCategory(Category category) async {
    await LocalDataSource.addCategory(category);
  }

  @override
  Future<void> updateCategory(Category category) async {
    await LocalDataSource.updateCategory(category);
  }

  @override
  Future<void> deleteCategory(String id) async {
    await LocalDataSource.deleteCategory(id);
  }

  @override
  List<Category> getAllCategories() {
    return LocalDataSource.getAllCategories();
  }

  @override
  List<Category> getCategoriesByType(CategoryType type) {
    return LocalDataSource.getCategoriesByType(type);
  }
}