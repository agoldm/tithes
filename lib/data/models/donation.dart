import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';

part 'donation.g.dart';

@HiveType(typeId: 1)
class Donation extends Equatable {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final double amount;
  
  @HiveField(2)
  final String categoryId;
  
  @HiveField(3)
  final DateTime date;
  
  @HiveField(4)
  final String? description;

  const Donation({
    required this.id,
    required this.amount,
    required this.categoryId,
    required this.date,
    this.description,
  });

  Donation copyWith({
    String? id,
    double? amount,
    String? categoryId,
    DateTime? date,
    String? description,
  }) {
    return Donation(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      categoryId: categoryId ?? this.categoryId,
      date: date ?? this.date,
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props => [id, amount, categoryId, date, description];
}