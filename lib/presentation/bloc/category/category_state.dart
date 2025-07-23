import 'package:equatable/equatable.dart';
import 'package:tithes/data/models/category.dart';

abstract class CategoryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<Category> categories;
  final List<Category> incomeCategories;
  final List<Category> donationCategories;

  CategoryLoaded({
    required this.categories,
    required this.incomeCategories,
    required this.donationCategories,
  });

  @override
  List<Object?> get props => [categories, incomeCategories, donationCategories];

  CategoryLoaded copyWith({
    List<Category>? categories,
    List<Category>? incomeCategories,
    List<Category>? donationCategories,
  }) {
    return CategoryLoaded(
      categories: categories ?? this.categories,
      incomeCategories: incomeCategories ?? this.incomeCategories,
      donationCategories: donationCategories ?? this.donationCategories,
    );
  }
}

class CategoryError extends CategoryState {
  final String message;

  CategoryError(this.message);

  @override
  List<Object?> get props => [message];
}