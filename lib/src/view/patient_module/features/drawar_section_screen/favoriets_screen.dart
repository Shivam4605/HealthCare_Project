import 'package:flutter/material.dart';
import 'package:healthcare/src/model/drawar_section_model/favorites_item_model.dart';
import 'package:healthcare/src/util/app_color.dart';
import 'package:shimmer/shimmer.dart';

enum FavoriteType { doctor, pharmacy, hospital, ambulance }

class PatientFavoritesScreen extends StatefulWidget {
  const PatientFavoritesScreen({super.key});

  @override
  State<PatientFavoritesScreen> createState() => _PatientFavoritesScreenState();
}

class _PatientFavoritesScreenState extends State<PatientFavoritesScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late final TabController _tabController;
  late final AnimationController _animationController;
  late final AnimationController _searchController;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  bool _isLoading = true;
  bool _isSearching = false;
  final TextEditingController _searchTextController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  List<FavoriteItem> _allFavorites = [];
  Map<FavoriteType, List<FavoriteItem>> _categorizedFavorites = {
    FavoriteType.doctor: [],
    FavoriteType.pharmacy: [],
    FavoriteType.hospital: [],
    FavoriteType.ambulance: [],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _initializeAnimations();
    _loadFavorites();
    _tabController.addListener(_handleTabChange);
    _searchTextController.addListener(_handleSearchChange);
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _searchController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      setState(() {});
    }
  }

  void _handleSearchChange() {
    setState(() {});
  }

  Future<void> _loadFavorites() async {
    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      setState(() {
        _allFavorites = _generateSampleData();
        _categorizedFavorites = _categorizeFavorites(_allFavorites);
        _isLoading = false;
      });
    }
  }

  List<FavoriteItem> _generateSampleData() {
    return [
      // Doctors
      FavoriteItem(
        id: 'd1',
        name: 'Dr. Sarah Johnson',
        specialty: 'Cardiologist',
        imageUrl: '',
        rating: 4.9,
        distance: '0.8 km',
        address: '123 Medical Center Blvd',
        isOpen: true,
        openingHours: '9:00 AM - 5:00 PM',
        type: FavoriteType.doctor,
        tags: ['Heart Specialist', '15+ years'],
        reviewCount: 128,
        isVerified: true,
      ),
      FavoriteItem(
        id: 'd2',
        name: 'Dr. Michael Chen',
        specialty: 'Neurologist',
        imageUrl: '',
        rating: 4.8,
        distance: '1.2 km',
        address: '456 Brain Health Center',
        isOpen: true,
        openingHours: '10:00 AM - 6:00 PM',
        type: FavoriteType.doctor,
        tags: ['Brain Specialist', '10+ years'],
        reviewCount: 95,
        isVerified: true,
      ),
      FavoriteItem(
        id: 'd3',
        name: 'Dr. Emily Rodriguez',
        specialty: 'Pediatrician',
        imageUrl: '',
        rating: 4.9,
        distance: '0.5 km',
        address: '789 Children\'s Care Ave',
        isOpen: false,
        openingHours: '8:00 AM - 4:00 PM',
        type: FavoriteType.doctor,
        tags: ['Child Care', '20+ years'],
        reviewCount: 203,
        isVerified: true,
      ),

      // Pharmacies
      FavoriteItem(
        id: 'p1',
        name: 'City Pharmacy',
        specialty: '24/7 Pharmacy',
        imageUrl: '',
        rating: 4.7,
        distance: '0.3 km',
        address: '789 Main Street',
        isOpen: true,
        openingHours: '24 hours',
        type: FavoriteType.pharmacy,
        tags: ['24/7', 'Free Delivery'],
        reviewCount: 256,
        isVerified: true,
      ),
      FavoriteItem(
        id: 'p2',
        name: 'MedPlus Pharmacy',
        specialty: 'Online Delivery',
        imageUrl: '',
        rating: 4.6,
        distance: '1.5 km',
        address: '321 Health Avenue',
        isOpen: false,
        openingHours: '8:00 AM - 10:00 PM',
        type: FavoriteType.pharmacy,
        tags: ['Discounts', 'Insurance'],
        reviewCount: 189,
        isVerified: true,
      ),

      // Hospitals
      FavoriteItem(
        id: 'h1',
        name: 'City General Hospital',
        specialty: 'Multi-Specialty',
        imageUrl: '',
        rating: 4.5,
        distance: '2.1 km',
        address: '1000 Healthcare Parkway',
        isOpen: true,
        openingHours: '24 hours',
        type: FavoriteType.hospital,
        tags: ['Emergency', 'ICU', 'Trauma'],
        reviewCount: 512,
        isVerified: true,
      ),
      FavoriteItem(
        id: 'h2',
        name: 'St. Mary\'s Medical Center',
        specialty: 'Specialized Care',
        imageUrl: '',
        rating: 4.8,
        distance: '3.5 km',
        address: '2000 Medical Plaza',
        isOpen: true,
        openingHours: '24 hours',
        type: FavoriteType.hospital,
        tags: ['Cancer Center', 'Surgery', 'Radiology'],
        reviewCount: 678,
        isVerified: true,
      ),

      // Ambulances
      FavoriteItem(
        id: 'a1',
        name: 'Rapid Response Ambulance',
        specialty: 'Emergency Service',
        imageUrl: '',
        rating: 4.9,
        distance: '0.5 km',
        address: 'Station 5, Emergency Hub',
        isOpen: true,
        openingHours: '24 hours',
        type: FavoriteType.ambulance,
        tags: ['ACLS', 'BLS', 'ICU'],
        reviewCount: 67,
        isVerified: true,
      ),
      FavoriteItem(
        id: 'a2',
        name: 'LifeLine Emergency',
        specialty: 'Critical Care Transport',
        imageUrl: '',
        rating: 4.8,
        distance: '1.2 km',
        address: 'Station 12, Central District',
        isOpen: true,
        openingHours: '24 hours',
        type: FavoriteType.ambulance,
        tags: ['Ventilator', 'Cardiac', 'Trauma'],
        reviewCount: 45,
        isVerified: true,
      ),
    ];
  }

  Map<FavoriteType, List<FavoriteItem>> _categorizeFavorites(
    List<FavoriteItem> items,
  ) {
    return {
      FavoriteType.doctor: items
          .where((item) => item.type == FavoriteType.doctor)
          .toList(),
      FavoriteType.pharmacy: items
          .where((item) => item.type == FavoriteType.pharmacy)
          .toList(),
      FavoriteType.hospital: items
          .where((item) => item.type == FavoriteType.hospital)
          .toList(),
      FavoriteType.ambulance: items
          .where((item) => item.type == FavoriteType.ambulance)
          .toList(),
    };
  }

  List<FavoriteItem> _getFilteredFavorites() {
    final currentType = FavoriteType.values[_tabController.index];
    final favorites = _categorizedFavorites[currentType] ?? [];

    if (_searchTextController.text.isEmpty) {
      return favorites;
    }

    final searchQuery = _searchTextController.text.toLowerCase();
    return favorites
        .where(
          (item) =>
              item.name.toLowerCase().contains(searchQuery) ||
              item.specialty.toLowerCase().contains(searchQuery) ||
              item.tags.any((tag) => tag.toLowerCase().contains(searchQuery)),
        )
        .toList();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchTextController.clear();
        _searchFocusNode.unfocus();
      } else {
        _searchFocusNode.requestFocus();
      }
    });

    if (_isSearching) {
      _searchController.forward();
    } else {
      _searchController.reverse();
    }
  }

  void _removeFavorite(FavoriteItem item) {
    setState(() {
      _allFavorites.removeWhere((f) => f.id == item.id);
      _categorizedFavorites = _categorizeFavorites(_allFavorites);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text('${item.name} removed from favorites')),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              _allFavorites.add(item);
              _categorizedFavorites = _categorizeFavorites(_allFavorites);
            });
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    _searchController.dispose();
    _searchTextController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildSliverAppBar(),
            _buildSearchBar(),
            SliverToBoxAdapter(child: _buildCategories()),
            _buildStatsBar(),
            _buildFavoritesList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 100,
      floating: true,
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 20, bottom: 16, right: 20),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF6B6B), Color(0xFFEE5A6F)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF6B6B).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.favorite_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'My Favorites',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E3E5C),
                ),
              ),
            ),
          ],
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, const Color(0xFFF8FAFC).withOpacity(0.5)],
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _isSearching
                  ? AppColors.midblue
                  : AppColors.midblue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _isSearching ? Icons.close_rounded : Icons.search_rounded,
              color: _isSearching ? Colors.white : AppColors.midblue,
              size: 20,
            ),
          ),
          onPressed: _toggleSearch,
          tooltip: _isSearching ? 'Close search' : 'Search favorites',
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildSearchBar() {
    return SliverToBoxAdapter(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
        height: _isSearching ? 80 : 0,
        child: _isSearching
            ? Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.midblue.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchTextController,
                    focusNode: _searchFocusNode,
                    decoration: InputDecoration(
                      hintText: 'Search by name, specialty, or tags...',
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                      ),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: AppColors.midblue,
                      ),
                      suffixIcon: _searchTextController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(
                                Icons.clear_rounded,
                                color: Colors.grey[400],
                              ),
                              onPressed: () {
                                _searchTextController.clear();
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      filled: false,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildCategories() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 8),
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
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF13BDAC), Color(0xFF0FA394)],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: const Color(0xFF64748B),
        labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
        padding: const EdgeInsets.all(4),
        tabs: [
          _buildCategoryTab(Icons.medical_services_rounded, 'Doctors'),
          _buildCategoryTab(Icons.medication_rounded, 'Pharmacy'),
          _buildCategoryTab(Icons.local_hospital_rounded, 'Hospitals'),
          _buildCategoryTab(Icons.local_shipping_rounded, 'Ambulance'),
        ],
      ),
    );
  }

  Widget _buildCategoryTab(IconData icon, String label) {
    return Tab(
      height: 44,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 4),
          Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }

  Widget _buildStatsBar() {
    final filteredFavorites = _getFilteredFavorites();
    final currentType = FavoriteType.values[_tabController.index];
    final totalInCategory = _categorizedFavorites[currentType]?.length ?? 0;

    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 12, 20, 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.midblue.withOpacity(0.1),
              AppColors.midblue.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.midblue.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.midblue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getIconForType(currentType),
                color: AppColors.midblue,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _searchTextController.text.isEmpty
                        ? 'Total $_getCategoryName'
                        : 'Search Results',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _searchTextController.text.isEmpty
                        ? '$totalInCategory saved'
                        : '${filteredFavorites.length} found',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E3E5C),
                    ),
                  ),
                ],
              ),
            ),
            if (totalInCategory > 0)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.midblue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$totalInCategory',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String get _getCategoryName {
    switch (FavoriteType.values[_tabController.index]) {
      case FavoriteType.doctor:
        return 'Doctors';
      case FavoriteType.pharmacy:
        return 'Pharmacies';
      case FavoriteType.hospital:
        return 'Hospitals';
      case FavoriteType.ambulance:
        return 'Ambulances';
    }
  }

  Widget _buildFavoritesList() {
    final filteredFavorites = _getFilteredFavorites();

    if (_isLoading) {
      return SliverPadding(
        padding: const EdgeInsets.all(20),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => _buildShimmerItem(),
            childCount: 3,
          ),
        ),
      );
    }

    if (filteredFavorites.isEmpty) {
      return SliverFillRemaining(child: _buildEmptyState());
    }

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          return TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 400 + (index * 50)),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              final clampedValue = value.clamp(0.0, 1.0);
              return Opacity(
                opacity: clampedValue,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - clampedValue)),
                  child: child,
                ),
              );
            },
            child: _buildFavoriteCard(filteredFavorites[index]),
          );
        }, childCount: filteredFavorites.length),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              _searchTextController.text.isEmpty
                  ? Icons.favorite_border_rounded
                  : Icons.search_off_rounded,
              size: 60,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            _searchTextController.text.isEmpty
                ? 'No favorites yet'
                : 'No results found',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E3E5C),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              _searchTextController.text.isEmpty
                  ? 'Items you favorite will appear here'
                  : 'Try searching with different keywords',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ),
          if (_searchTextController.text.isNotEmpty) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                _searchTextController.clear();
              },
              icon: const Icon(Icons.clear_rounded),
              label: const Text('Clear Search'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.midblue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFavoriteCard(FavoriteItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _getColorForType(item.type).withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: _getColorForType(item.type).withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Opening ${item.name}'),
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                duration: const Duration(seconds: 1),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAvatar(item),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2E3E5C),
                                  ),
                                ),
                              ),
                              if (item.isVerified)
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: AppColors.midblue.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.verified_rounded,
                                    color: AppColors.midblue,
                                    size: 16,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.specialty,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildRatingRow(item),
                          const SizedBox(height: 8),
                          _buildInfoRow(item),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildTagsRow(item),
                const SizedBox(height: 12),
                _buildActionButtons(item),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(FavoriteItem item) {
    return Hero(
      tag: 'favorite_${item.id}',
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _getGradientForType(item.type),
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: _getColorForType(item.type).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: item.imageUrl.isNotEmpty
              ? Image.network(
                  item.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildAvatarPlaceholder(item.type);
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return _buildAvatarPlaceholder(item.type);
                  },
                )
              : _buildAvatarPlaceholder(item.type),
        ),
      ),
    );
  }

  Widget _buildAvatarPlaceholder(FavoriteType type) {
    return Container(
      color: Colors.white.withOpacity(0.2),
      child: Icon(_getIconForType(type), color: Colors.white, size: 32),
    );
  }

  Widget _buildRatingRow(FavoriteItem item) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFFFB800).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.star_rounded,
                color: Color(0xFFFFB800),
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                item.rating.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E3E5C),
                  fontSize: 13,
                ),
              ),
              Text(
                ' (${item.reviewCount})',
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: item.isOpen ? Colors.green : Colors.red,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: (item.isOpen ? Colors.green : Colors.red)
                        .withOpacity(0.3),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            Text(
              item.isOpen ? 'Open Now' : 'Closed',
              style: TextStyle(
                fontSize: 12,
                color: item.isOpen ? Colors.green : Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoRow(FavoriteItem item) {
    return Row(
      children: [
        Icon(Icons.location_on_rounded, size: 14, color: Colors.grey[400]),
        const SizedBox(width: 4),
        Text(
          item.distance,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        const SizedBox(width: 12),
        Icon(Icons.access_time_rounded, size: 14, color: Colors.grey[400]),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            item.openingHours,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildTagsRow(FavoriteItem item) {
    return SizedBox(
      height: 28,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: item.tags.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getColorForType(item.type).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _getColorForType(item.type).withOpacity(0.3),
              ),
            ),
            child: Text(
              item.tags[index],
              style: TextStyle(
                fontSize: 11,
                color: _getColorForType(item.type),
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionButtons(FavoriteItem item) {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            icon: Icons.directions_rounded,
            label: 'Directions',
            color: AppColors.midblue,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Opening directions...'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionButton(
            icon: Icons.phone_rounded,
            label: 'Call',
            color: const Color(0xFF13BDAC),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Calling...'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF6B6B), Color(0xFFEE5A6F)],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF6B6B).withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => _removeFavorite(item),
              child: Container(
                padding: const EdgeInsets.all(12),
                child: const Icon(
                  Icons.favorite_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerItem() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      height: 240,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  Color _getColorForType(FavoriteType type) {
    switch (type) {
      case FavoriteType.doctor:
        return const Color(0xFF13BDAC);
      case FavoriteType.pharmacy:
        return const Color(0xFFFF6B6B);
      case FavoriteType.hospital:
        return const Color(0xFF6B5CE7);
      case FavoriteType.ambulance:
        return const Color(0xFFFFA07A);
    }
  }

  List<Color> _getGradientForType(FavoriteType type) {
    switch (type) {
      case FavoriteType.doctor:
        return const [Color(0xFF13BDAC), Color(0xFF0FA394)];
      case FavoriteType.pharmacy:
        return const [Color(0xFFFF6B6B), Color(0xFFEE5A6F)];
      case FavoriteType.hospital:
        return const [Color(0xFF6B5CE7), Color(0xFF8B7BFF)];
      case FavoriteType.ambulance:
        return const [Color(0xFFFFA07A), Color(0xFFFF8E8E)];
    }
  }

  IconData _getIconForType(FavoriteType type) {
    switch (type) {
      case FavoriteType.doctor:
        return Icons.medical_services_rounded;
      case FavoriteType.pharmacy:
        return Icons.medication_rounded;
      case FavoriteType.hospital:
        return Icons.local_hospital_rounded;
      case FavoriteType.ambulance:
        return Icons.local_shipping_rounded;
    }
  }
}
