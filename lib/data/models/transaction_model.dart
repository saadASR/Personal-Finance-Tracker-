import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';

part 'transaction_model.g.dart';

enum TransactionType { income, expense }

@HiveType(typeId: 0)
class TransactionModel extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final String categoryId;

  @HiveField(4)
  final DateTime date;

  @HiveField(5)
  final String note;

  @HiveField(6)
  final int typeIndex;

  const TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.categoryId,
    required this.date,
    this.note = '',
    required this.typeIndex,
  });

  TransactionType get type => TransactionType.values[typeIndex];

  TransactionModel copyWith({
    String? id,
    String? title,
    double? amount,
    String? categoryId,
    DateTime? date,
    String? note,
    int? typeIndex,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      categoryId: categoryId ?? this.categoryId,
      date: date ?? this.date,
      note: note ?? this.note,
      typeIndex: typeIndex ?? this.typeIndex,
    );
  }

  @override
  List<Object?> get props => [id, title, amount, categoryId, date, note, typeIndex];
}
