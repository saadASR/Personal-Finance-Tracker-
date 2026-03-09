import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';

part 'app_settings_model.g.dart';

@HiveType(typeId: 3)
class AppSettingsModel extends Equatable {
  @HiveField(0)
  final bool isDarkMode;

  @HiveField(1)
  final String currency;

  @HiveField(2)
  final String currencySymbol;

  const AppSettingsModel({
    this.isDarkMode = false,
    this.currency = 'USD',
    this.currencySymbol = '\$',
  });

  AppSettingsModel copyWith({
    bool? isDarkMode,
    String? currency,
    String? currencySymbol,
  }) {
    return AppSettingsModel(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      currency: currency ?? this.currency,
      currencySymbol: currencySymbol ?? this.currencySymbol,
    );
  }

  @override
  List<Object?> get props => [isDarkMode, currency, currencySymbol];
}
