import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'Finance Tracker';
  
  static const List<Map<String, dynamic>> availableIcons = [
    {'name': 'work', 'icon': Icons.work},
    {'name': 'home', 'icon': Icons.home},
    {'name': 'shopping_cart', 'icon': Icons.shopping_cart},
    {'name': 'restaurant', 'icon': Icons.restaurant},
    {'name': 'directions_car', 'icon': Icons.directions_car},
    {'name': 'local_hospital', 'icon': Icons.local_hospital},
    {'name': 'school', 'icon': Icons.school},
    {'name': 'movie', 'icon': Icons.movie},
    {'name': 'flight', 'icon': Icons.flight},
    {'name': 'fitness_center', 'icon': Icons.fitness_center},
    {'name': 'pets', 'icon': Icons.pets},
    {'name': 'child_care', 'icon': Icons.child_care},
    {'name': 'savings', 'icon': Icons.savings},
    {'name': 'attach_money', 'icon': Icons.attach_money},
    {'name': 'trending_up', 'icon': Icons.trending_up},
    {'name': 'card_giftcard', 'icon': Icons.card_giftcard},
    {'name': 'receipt_long', 'icon': Icons.receipt_long},
    {'name': 'wifi', 'icon': Icons.wifi},
    {'name': 'phone_android', 'icon': Icons.phone_android},
    {'name': 'electric_bolt', 'icon': Icons.electric_bolt},
    {'name': 'water_drop', 'icon': Icons.water_drop},
    {'name': 'checkroom', 'icon': Icons.checkroom},
    {'name': 'sports_esports', 'icon': Icons.sports_esports},
    {'name': 'music_note', 'icon': Icons.music_note},
    {'name': 'local_cafe', 'icon': Icons.local_cafe},
    {'name': 'local_bar', 'icon': Icons.local_bar},
    {'name': 'sports', 'icon': Icons.sports},
    {'name': 'pool', 'icon': Icons.pool},
    {'name': 'beach_access', 'icon': Icons.beach_access},
    {'name': 'church', 'icon': Icons.church},
  ];

  static const List<Color> availableColors = [
    Color(0xFFEF4444),
    Color(0xFFF97316),
    Color(0xFFF59E0B),
    Color(0xFF84CC16),
    Color(0xFF22C55E),
    Color(0xFF14B8A6),
    Color(0xFF06B6D4),
    Color(0xFF0EA5E9),
    Color(0xFF3B82F6),
    Color(0xFF6366F1),
    Color(0xFF8B5CF6),
    Color(0xFFA855F7),
    Color(0xFFD946EF),
    Color(0xFFEC4899),
    Color(0xFFF43F5E),
    Color(0xFF78716C),
  ];

  static const List<Map<String, String>> currencies = [
    {'code': 'USD', 'symbol': '\$', 'name': 'US Dollar'},
    {'code': 'EUR', 'symbol': '€', 'name': 'Euro'},
    {'code': 'GBP', 'symbol': '£', 'name': 'British Pound'},
    {'code': 'JPY', 'symbol': '¥', 'name': 'Japanese Yen'},
    {'code': 'INR', 'symbol': '₹', 'name': 'Indian Rupee'},
    {'code': 'CAD', 'symbol': 'C\$', 'name': 'Canadian Dollar'},
    {'code': 'AUD', 'symbol': 'A\$', 'name': 'Australian Dollar'},
    {'code': 'CHF', 'symbol': 'CHF', 'name': 'Swiss Franc'},
    {'code': 'CNY', 'symbol': '¥', 'name': 'Chinese Yuan'},
    {'code': 'SGD', 'symbol': 'S\$', 'name': 'Singapore Dollar'},
  ];
}
