import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';

part 'budget_model.g.dart';

@HiveType(typeId: 2)
class BudgetModel extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String categoryId;

  @HiveField(2)
  final double limit;

  @HiveField(3)
  final int month;

  @HiveField(4)
  final int year;

  @HiveField(5)
  final bool alertEnabled;

  @HiveField(6)
  final double alertThreshold;

  const BudgetModel({
    required this.id,
    required this.categoryId,
    required this.limit,
    required this.month,
    required this.year,
    this.alertEnabled = true,
    this.alertThreshold = 0.8,
  });

  BudgetModel copyWith({
    String? id,
    String? categoryId,
    double? limit,
    int? month,
    int? year,
    bool? alertEnabled,
    double? alertThreshold,
  }) {
    return BudgetModel(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      limit: limit ?? this.limit,
      month: month ?? this.month,
      year: year ?? this.year,
      alertEnabled: alertEnabled ?? this.alertEnabled,
      alertThreshold: alertThreshold ?? this.alertThreshold,
    );
  }

  @override
  List<Object?> get props => [id, categoryId, limit, month, year, alertEnabled, alertThreshold];
}
