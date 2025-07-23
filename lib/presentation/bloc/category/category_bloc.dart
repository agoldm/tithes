import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tithes/data/models/category.dart';
import 'package:tithes/domain/repositories/category_repository.dart';
import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository categoryRepository;

  CategoryBloc({required this.categoryRepository}) : super(CategoryInitial()) {
    on<LoadCategories>(_onLoadCategories);
    on<AddCategory>(_onAddCategory);
    on<UpdateCategory>(_onUpdateCategory);
    on<DeleteCategory>(_onDeleteCategory);
    on<FilterCategoriesByType>(_onFilterCategoriesByType);
  }

  void _onLoadCategories(LoadCategories event, Emitter<CategoryState> emit) {
    try {
      emit(CategoryLoading());
      final categories = categoryRepository.getAllCategories();
      final incomeCategories = categories.where((c) => c.type == CategoryType.income).toList();
      final donationCategories = categories.where((c) => c.type == CategoryType.donation).toList();
      
      emit(CategoryLoaded(
        categories: categories,
        incomeCategories: incomeCategories,
        donationCategories: donationCategories,
      ));
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  void _onAddCategory(AddCategory event, Emitter<CategoryState> emit) async {
    try {
      await categoryRepository.addCategory(event.category);
      add(LoadCategories());
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  void _onUpdateCategory(UpdateCategory event, Emitter<CategoryState> emit) async {
    try {
      await categoryRepository.updateCategory(event.category);
      add(LoadCategories());
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  void _onDeleteCategory(DeleteCategory event, Emitter<CategoryState> emit) async {
    try {
      await categoryRepository.deleteCategory(event.id);
      add(LoadCategories());
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  void _onFilterCategoriesByType(FilterCategoriesByType event, Emitter<CategoryState> emit) {
    if (state is CategoryLoaded) {
      // This event is mainly for future use or specific filtering needs
      // The loaded state already contains filtered categories
    }
  }
}