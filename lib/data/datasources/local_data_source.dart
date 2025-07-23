import 'package:hive_flutter/hive_flutter.dart';
import 'package:tithes/core/constants/app_constants.dart';
import 'package:tithes/data/models/income.dart';
import 'package:tithes/data/models/donation.dart';
import 'package:tithes/data/models/category.dart';

class LocalDataSource {
  static Future<void> initialize() async {
    await Hive.initFlutter();
    
    // Register adapters (will be generated)
    Hive.registerAdapter(IncomeAdapter());
    Hive.registerAdapter(DonationAdapter());
    Hive.registerAdapter(CategoryAdapter());
    Hive.registerAdapter(CategoryTypeAdapter());
    
    // Open boxes
    await Hive.openBox<Income>(AppConstants.incomeBoxName);
    await Hive.openBox<Donation>(AppConstants.donationBoxName);
    await Hive.openBox<Category>(AppConstants.categoryBoxName);
    
    // Initialize default categories if empty
    await _initializeDefaultCategories();
  }
  
  static Future<void> _initializeDefaultCategories() async {
    final categoryBox = Hive.box<Category>(AppConstants.categoryBoxName);
    
    if (categoryBox.isEmpty) {
      // Add default income categories
      for (int i = 0; i < AppConstants.defaultIncomeCategories.length; i++) {
        final category = Category(
          id: 'income_${i + 1}',
          name: AppConstants.defaultIncomeCategories[i],
          type: CategoryType.income,
        );
        await categoryBox.put(category.id, category);
      }
      
      // Add default donation categories
      for (int i = 0; i < AppConstants.defaultDonationCategories.length; i++) {
        final category = Category(
          id: 'donation_${i + 1}',
          name: AppConstants.defaultDonationCategories[i],
          type: CategoryType.donation,
        );
        await categoryBox.put(category.id, category);
      }
    }
  }
  
  // Income operations
  static Box<Income> get incomeBox => Hive.box<Income>(AppConstants.incomeBoxName);
  
  static Future<void> addIncome(Income income) async {
    await incomeBox.put(income.id, income);
  }
  
  static Future<void> updateIncome(Income income) async {
    await incomeBox.put(income.id, income);
  }
  
  static Future<void> deleteIncome(String id) async {
    await incomeBox.delete(id);
  }
  
  static List<Income> getAllIncomes() {
    return incomeBox.values.toList();
  }
  
  // Donation operations
  static Box<Donation> get donationBox => Hive.box<Donation>(AppConstants.donationBoxName);
  
  static Future<void> addDonation(Donation donation) async {
    await donationBox.put(donation.id, donation);
  }
  
  static Future<void> updateDonation(Donation donation) async {
    await donationBox.put(donation.id, donation);
  }
  
  static Future<void> deleteDonation(String id) async {
    await donationBox.delete(id);
  }
  
  static List<Donation> getAllDonations() {
    return donationBox.values.toList();
  }
  
  // Category operations
  static Box<Category> get categoryBox => Hive.box<Category>(AppConstants.categoryBoxName);
  
  static Future<void> addCategory(Category category) async {
    await categoryBox.put(category.id, category);
  }
  
  static Future<void> updateCategory(Category category) async {
    await categoryBox.put(category.id, category);
  }
  
  static Future<void> deleteCategory(String id) async {
    await categoryBox.delete(id);
  }
  
  static List<Category> getAllCategories() {
    return categoryBox.values.toList();
  }
  
  static List<Category> getCategoriesByType(CategoryType type) {
    return categoryBox.values.where((cat) => cat.type == type).toList();
  }
}