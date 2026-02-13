import 'dart:async';
import 'package:flutter/material.dart';
import 'package:healthcare/src/util/app_color.dart';

class HospitalsScreen extends StatefulWidget {
  const HospitalsScreen({super.key});

  @override
  State<HospitalsScreen> createState() => _HospitalsScreenState();
}

class _HospitalsScreenState extends State<HospitalsScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  bool _showLoading = true;
  bool _isSearching = false;
  String _selectedFilter = 'All';
  String _selectedSort = 'Distance';
  int _selectedIndex = 0;
  bool _showFilters = false;

  final List<String> _filters = [
    'All',
    'Multi-specialty',
    'Government',
    'Private',
    'Teaching',
  ];
  final List<String> _sortOptions = ['Distance', 'Rating', 'Name', 'Beds'];
  final List<String> _specialties = [
    'Cardiology',
    'Neurology',
    'Orthopedics',
    'Pediatrics',
    'Oncology',
    'General Surgery',
    'Emergency',
    'ICU',
  ];

  late AnimationController _loadingAnimationController;
  late Animation<double> _loadingScaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeLoadingAnimation();
    _startLoadingTimer();
  }

  void _initializeLoadingAnimation() {
    _loadingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _loadingScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _loadingAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    _loadingAnimationController.forward();
  }

  void _startLoadingTimer() {
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _loadingAnimationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: _showLoading ? null : _buildAppBar(),
      body: _showLoading
          ? _buildLoadingScreen()
          : Column(
              children: [
                _buildSearchAndFilter(),
                _buildSpecialtiesSection(),
                _buildHospitalsSection(),
              ],
            ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.transparent,
      title: const Text(
        'Hospitals',
        style: TextStyle(
          color: Color(0xFF2E3E5C),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated hospital icon
          ScaleTransition(
            scale: _loadingScaleAnimation,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.midblue, Color(0xFF0FA394)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.midblue.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.local_hospital_rounded,
                  size: 60,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          // Loading text
          const Text(
            'Loading Hospitals',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E3E5C),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Fetching hospital information...',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 40),
          // Circular progress indicator with custom styling
          SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              children: [
                Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.midblue.withOpacity(0.2),
                    ),
                    strokeWidth: 6,
                  ),
                ),
                Center(
                  child: CircularProgressIndicator(
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.midblue,
                    ),
                    strokeWidth: 6,
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Loading percentage
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 100.0),
            duration: const Duration(seconds: 2),
            builder: (context, value, child) {
              return Text(
                '${value.toInt()}%',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.midblue,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[200]!, width: 1),
            ),
            child: Row(
              children: [
                Icon(Icons.search_rounded, color: Colors.grey[400], size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search hospitals, specialties...',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _isSearching = value.isNotEmpty;
                      });
                    },
                  ),
                ),
                if (_isSearching)
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _isSearching = false);
                    },
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Filter Chips and Sort Button
          Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _filters.map((filter) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(filter),
                          selected: _selectedFilter == filter,
                          selectedColor: AppColors.midblue.withOpacity(0.1),
                          backgroundColor: Colors.grey[100],
                          labelStyle: TextStyle(
                            color: _selectedFilter == filter
                                ? AppColors.midblue
                                : Colors.grey[700],
                            fontWeight: _selectedFilter == filter
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                          onSelected: (selected) {
                            setState(() => _selectedFilter = filter);
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: _selectedFilter == filter
                                  ? AppColors.midblue
                                  : Colors.grey[300]!,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.filter_list_rounded),
                onPressed: () {
                  setState(() => _showFilters = !_showFilters);
                },
              ),
            ],
          ),
          // Sort Options (Expandable)
          if (_showFilters)
            Container(
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sort by:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E3E5C),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _sortOptions.map((sort) {
                      return ChoiceChip(
                        label: Text(sort),
                        selected: _selectedSort == sort,
                        selectedColor: AppColors.midblue,
                        backgroundColor: Colors.white,
                        labelStyle: TextStyle(
                          color: _selectedSort == sort
                              ? Colors.white
                              : Colors.grey[700],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: _selectedSort == sort
                                ? AppColors.midblue
                                : Colors.grey[300]!,
                          ),
                        ),
                        onSelected: (selected) {
                          setState(() => _selectedSort = sort);
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSpecialtiesSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Specialties',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E3E5C),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _specialties.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedIndex = index);
                  },
                  child: Container(
                    width: 100,
                    margin: EdgeInsets.only(
                      right: index == _specialties.length - 1 ? 0 : 12,
                    ),
                    decoration: BoxDecoration(
                      color: _selectedIndex == index
                          ? AppColors.midblue.withOpacity(0.1)
                          : Colors.grey[50],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _selectedIndex == index
                            ? AppColors.midblue
                            : Colors.grey[200]!,
                        width: _selectedIndex == index ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: _selectedIndex == index
                                ? AppColors.midblue
                                : Colors.grey[200],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _getSpecialtyIcon(_specialties[index]),
                            color: _selectedIndex == index
                                ? Colors.white
                                : Colors.grey[600],
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            _specialties[index],
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: _selectedIndex == index
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                              color: _selectedIndex == index
                                  ? AppColors.midblue
                                  : Color(0xFF2E3E5C),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHospitalsSection() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hospitals Nearby',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E3E5C),
              ),
            ),
            const SizedBox(height: 12),
            // Map View
            Container(
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey[200],
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://maps.googleapis.com/maps/api/staticmap?center=New+York&zoom=13&size=600x300&maptype=roadmap&markers=color:blue%7Clabel:H%7C40.7128,-74.0060&key=YOUR_API_KEY',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.5),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Text(
                      '${_hospitals.length} hospitals in your area',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.my_location_rounded, size: 16),
                          SizedBox(width: 4),
                          Text('Live View'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Hospitals List
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: _hospitals.length,
                itemBuilder: (context, index) {
                  return _buildHospitalCard(_hospitals[index], index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHospitalCard(HospitalModel hospital, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Hospital Image and Basic Info
          Stack(
            children: [
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(hospital.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.6),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hospital.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      hospital.address,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: hospital.type == 'Government'
                        ? Colors.green
                        : hospital.type == 'Private'
                        ? Colors.orange
                        : Colors.purple,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    hospital.type,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Hospital Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Ratings and Distance
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: Color(0xFFFFB800),
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          hospital.rating.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2E3E5C),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${hospital.reviews} reviews)',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          color: AppColors.midblue,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          hospital.distance,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF2E3E5C),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Specialties Tags
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: hospital.specialties.take(4).map((specialty) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.midblue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.midblue.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        specialty,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.midblue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                if (hospital.specialties.length > 4)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      '+${hospital.specialties.length - 4} more',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                const SizedBox(height: 16),
                // Facilities and Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        _buildFacilityIcon(
                          Icons.local_hospital_rounded,
                          '${hospital.beds} Beds',
                        ),
                        const SizedBox(width: 16),
                        _buildFacilityIcon(
                          Icons.emergency_rounded,
                          hospital.hasEmergency ? 'ER' : 'No ER',
                        ),
                        const SizedBox(width: 16),
                        _buildFacilityIcon(
                          Icons.local_parking_outlined,
                          hospital.hasParking ? 'Parking' : 'No Parking',
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to hospital details
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.midblue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      child: const Text('View Details'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFacilityIcon(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.midblue, size: 20),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }

  IconData _getSpecialtyIcon(String specialty) {
    switch (specialty) {
      case 'Cardiology':
        return Icons.favorite_rounded;
      case 'Neurology':
        return Icons.psychology_rounded;
      case 'Orthopedics':
      // return Icons.bone_rounded;
      case 'Pediatrics':
        return Icons.child_care_rounded;
      case 'Oncology':
        return Icons.healing_rounded;
      case 'General Surgery':
        return Icons.medical_services_rounded;
      case 'Emergency':
        return Icons.emergency_rounded;
      case 'ICU':
        return Icons.monitor_heart_rounded;
      default:
        return Icons.local_hospital_rounded;
    }
  }
}

// Data Models
class HospitalModel {
  final String id;
  final String name;
  final String address;
  final String type;
  final double rating;
  final int reviews;
  final String distance;
  final String imageUrl;
  final int beds;
  final bool hasEmergency;
  final bool hasParking;
  final List<String> specialties;
  final List<String> facilities;

  HospitalModel({
    required this.id,
    required this.name,
    required this.address,
    required this.type,
    required this.rating,
    required this.reviews,
    required this.distance,
    required this.imageUrl,
    required this.beds,
    required this.hasEmergency,
    required this.hasParking,
    required this.specialties,
    required this.facilities,
  });
}

// Sample Data
final List<HospitalModel> _hospitals = [
  HospitalModel(
    id: '1',
    name: 'City General Hospital',
    address: '123 Medical Center Blvd, Healthcare City',
    type: 'Multi-specialty',
    rating: 4.8,
    reviews: 1245,
    distance: '2.3 km',
    imageUrl:
        'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80',
    beds: 500,
    hasEmergency: true,
    hasParking: true,
    specialties: [
      'Cardiology',
      'Neurology',
      'Orthopedics',
      'Oncology',
      'Pediatrics',
      'General Surgery',
      'Emergency Medicine',
      'ICU',
    ],
    facilities: ['MRI', 'CT Scan', '24/7 Pharmacy', 'Cafeteria', 'WiFi'],
  ),
  HospitalModel(
    id: '2',
    name: 'Mount Sinai Medical Center',
    address: '456 Health Avenue, Medical District',
    type: 'Teaching',
    rating: 4.9,
    reviews: 1890,
    distance: '3.5 km',
    imageUrl:
        'https://images.unsplash.com/photo-1516549655669-dfbf10d0c9b7?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80',
    beds: 750,
    hasEmergency: true,
    hasParking: true,
    specialties: [
      'Cardiology',
      'Neurology',
      'Oncology',
      'Transplant',
      'Research',
      'ICU',
    ],
    facilities: [
      'Research Lab',
      'Advanced ICU',
      'Transplant Center',
      'Library',
      'Auditorium',
    ],
  ),
  HospitalModel(
    id: '3',
    name: 'Children\'s Health Institute',
    address: '789 Pediatric Street, Kids Zone',
    type: 'Private',
    rating: 4.7,
    reviews: 890,
    distance: '4.2 km',
    imageUrl:
        'https://images.unsplash.com/photo-1582750433449-648ed127bb54?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80',
    beds: 300,
    hasEmergency: true,
    hasParking: true,
    specialties: [
      'Pediatrics',
      'Neonatology',
      'Child Psychology',
      'Vaccination',
    ],
    facilities: [
      'Play Area',
      'Parent Lounge',
      'Child-friendly Wards',
      'Cafeteria',
    ],
  ),
  HospitalModel(
    id: '4',
    name: 'Government Medical College',
    address: '101 College Road, Education City',
    type: 'Government',
    rating: 4.6,
    reviews: 2100,
    distance: '5.0 km',
    imageUrl:
        'https://images.unsplash.com/photo-1532938911079-1b06ac7ceec7?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80',
    beds: 1000,
    hasEmergency: true,
    hasParking: true,
    specialties: [
      'All Specialties',
      'Medical Education',
      'Research',
      'Community Health',
    ],
    facilities: [
      'Medical College',
      'Research Center',
      'Large OPD',
      'Hostel',
      'Sports Complex',
    ],
  ),
  HospitalModel(
    id: '5',
    name: 'Sunrise Specialty Hospital',
    address: '222 Wellness Road, Uptown',
    type: 'Private',
    rating: 4.5,
    reviews: 670,
    distance: '1.8 km',
    imageUrl:
        'https://images.unsplash.com/photo-1586773860418-dc22f8b874bc?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80',
    beds: 200,
    hasEmergency: false,
    hasParking: true,
    specialties: [
      'Cardiology',
      'Orthopedics',
      'Dermatology',
      'Cosmetic Surgery',
    ],
    facilities: ['Luxury Rooms', 'Spa', 'Gym', 'Fine Dining', 'Concierge'],
  ),
];
