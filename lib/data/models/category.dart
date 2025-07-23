import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';

part 'category.g.dart';

@HiveType(typeId: 3)
enum CategoryType {
  @HiveField(0)
  income,
  @HiveField(1)
  donation,
}

@HiveType(typeId: 2)
class Category extends Equatable {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final CategoryType type;
  
  @HiveField(3)
  final String? color;

  const Category({
    required this.id,
    required this.name,
    required this.type,
    this.color,
  });

  Category copyWith({
    String? id,
    String? name,
    CategoryType? type,
    String? color,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      color: color ?? this.color,
    );
  }

  @override
  List<Object?> get props => [id, name, type, color];
}

