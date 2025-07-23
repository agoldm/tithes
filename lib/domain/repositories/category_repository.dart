import 'package:tithes/data/models/category.dart';

abstract class CategoryRepository {
  Future<void> addCategory(Category category);
  Future<void> updateCategory(Category category);
  Future<void> deleteCategory(String id);
  List<Category> getAllCategories();
  List<Category> getCategoriesByType(CategoryType type);
}