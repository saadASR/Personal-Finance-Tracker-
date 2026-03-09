import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'app_settings_model.g.dart';

@HiveType(typeId: 3)
class AppSettingsModel extends Equatable {
  @HiveField(0)
  final bool isDarkMode;

  @HiveField(1)
  final String currency;

  @HiveField(2)
  final String currencySymbol;

  @HiveField(3)
  final String languageCode;

  const AppSettingsModel({
    this.isDarkMode = false,
    this.currency = 'USD',
    this.currencySymbol = '\$',
    this.languageCode = 'en',
  });

  Locale get locale => Locale(languageCode);

  AppSettingsModel copyWith({
    bool? isDarkMode,
    String? currency,
    String? currencySymbol,
    String? languageCode,
  }) {
    return AppSettingsModel(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      currency: currency ?? this.currency,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      languageCode: languageCode ?? this.languageCode,
    );
  }

  @override
  List<Object?> get props => [isDarkMode, currency, currencySymbol, languageCode];
}
