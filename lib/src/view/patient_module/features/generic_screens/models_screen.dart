import 'package:flutter/material.dart';

class CategoryItem {
  final IconData icon;
  final String label;
  final Color color;
  final Gradient gradient;

  CategoryItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.gradient,
  });
}

class PromoModel {
  final String title;
  final String description;
  final String buttonText;
  final Color color1;
  final Color color2;
  final IconData icon;

  PromoModel({
    required this.title,
    required this.description,
    required this.buttonText,
    required this.color1,
    required this.color2,
    required this.icon,
  });
}

class DoctorModel {
  final String id;
  final String name;
  final String specialty;
  final String imageUrl;
  final double rating;
  final String distance;

  DoctorModel({
    required this.id,
    required this.name,
    required this.specialty,
    required this.imageUrl,
    required this.rating,
    required this.distance,
  });
}

class ArticleModel {
  final String id;
  final String title;
  final String imageUrl;
  final String date;
  final String category;

  ArticleModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.date,
    required this.category,
  });
}
