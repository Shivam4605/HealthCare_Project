import 'package:healthcare/src/view/patient_module/features/drawar_section_screen/favoriets_screen.dart';

class FavoriteItem {
  final String id;
  final String name;
  final String specialty;
  final String imageUrl;
  final double rating;
  final String distance;
  final String address;
  final bool isOpen;
  final String openingHours;
  final FavoriteType type;
  final List<String> tags;
  final int reviewCount;
  final bool isVerified;

  FavoriteItem({
    required this.id,
    required this.name,
    required this.specialty,
    required this.imageUrl,
    required this.rating,
    required this.distance,
    required this.address,
    required this.isOpen,
    required this.openingHours,
    required this.type,
    required this.tags,
    required this.reviewCount,
    required this.isVerified,
  });

  factory FavoriteItem.fromJson() {
    return FavoriteItem(
      id: '',
      name: '',
      specialty: '',
      imageUrl: '',
      rating: 0,
      distance: '',
      address: '',
      isOpen: true,
      openingHours: '',
      type: FavoriteType.doctor,
      tags: [],
      reviewCount: 0,
      isVerified: true,
    );
  }
}
