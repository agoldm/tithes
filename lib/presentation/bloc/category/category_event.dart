import 'package:equatable/equatable.dart';
import 'package:tithes/data/models/category.dart';

abstract class CategoryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadCategories extends CategoryEvent {}

class AddCategory extends CategoryEvent {
  final Category category;

  AddCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class UpdateCategory extends CategoryEvent {
  final Category category;

  UpdateCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class DeleteCategory extends CategoryEvent {
  final String id;

  DeleteCategory(this.id);

  @override
  List<Object?> get props => [id];
}

class FilterCategoriesByType extends CategoryEvent {
  final CategoryType? type;

  FilterCategoriesByType(this.type);

  @override
  List<Object?> get props => [type];
}