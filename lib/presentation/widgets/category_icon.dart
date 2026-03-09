import 'package:flutter/material.dart';

class CategoryIcon extends StatelessWidget {
  final int iconCodePoint;
  final Color color;
  final double size;

  const CategoryIcon({
    super.key,
    required this.iconCodePoint,
    required this.color,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(size / 4),
      ),
      child: Icon(
        IconData(iconCodePoint, fontFamily: 'MaterialIcons'),
        color: color,
        size: size * 0.5,
      ),
    );
  }
}
