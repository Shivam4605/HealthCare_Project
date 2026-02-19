// import 'package:flutter/material.dart';
// import 'package:healthcare/src/model/drawar_section_model/favorites_item_model.dart';
// import 'package:healthcare/src/util/app_color.dart';
// import 'package:shimmer/shimmer.dart';

// enum FavoriteType { doctor, pharmacy, hospital, ambulance }

// class PatientFavoritesScreen extends StatefulWidget {
//   const PatientFavoritesScreen({super.key});

//   @override
//   State<PatientFavoritesScreen> createState() => _PatientFavoritesScreenState();
// }

// class _PatientFavoritesScreenState extends State<PatientFavoritesScreen>
//     with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
//   @override
//   bool get wantKeepAlive => true;

//   late final TabController _tabController;
//   late final AnimationController _animationController;
//   late final AnimationController _searchController;
//   late final Animation<Offset> _slideAnimation;
//   late final Animation<double> _fadeAnimation;

//   bool _isLoading = true;
//   bool _isSearching = false;
//   final TextEditingController _searchTextController = TextEditingController();
//   final FocusNode _searchFocusNode = FocusNode();

//   List<FavoriteItem> _allFavorites = [];
//   Map<FavoriteType, List<FavoriteItem>> _categorizedFavorites = {
//     FavoriteType.doctor: [],
//     FavoriteType.pharmacy: [],
//     FavoriteType.hospital: [],
//     FavoriteType.ambulance: [],
//   };

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 4, vsync: this);
//     _initializeAnimations();
//     _loadFavorites();
//     _tabController.addListener(_handleTabChange);
//     _searchTextController.addListener(_handleSearchChange);
//   }

//   void _initializeAnimations() {
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );

//     _searchController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );

//     _slideAnimation =
//         Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
//           CurvedAnimation(
//             parent: _animationController,
//             curve: Curves.easeOutCubic,
//           ),
//         );

//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
//     );

//     _animationController.forward();
//   }

//   void _handleTabChange() {
//     if (_tabController.indexIsChanging) {
//       setState(() {});
//     }
//   }

//   void _handleSearchChange() {
//     setState(() {});
//   }

//   Future<void> _loadFavorites() async {
//     await Future.delayed(const Duration(milliseconds: 800));

//     if (mounted) {
//       setState(() {
//         _allFavorites = _generateSampleData();
//         _categorizedFavorites = _categorizeFavorites(_allFavorites);
//         _isLoading = false;
//       });
//     }
//   }

//   List<FavoriteItem> _generateSampleData() {
//     return [
//       // Doctors
//       FavoriteItem(
//         id: 'd1',
//         name: 'Dr. Sarah Johnson',
//         specialty: 'Cardiologist',
//         imageUrl: '',
//         rating: 4.9,
//         distance: '0.8 km',
//         address: '123 Medical Center Blvd',
//         isOpen: true,
//         openingHours: '9:00 AM - 5:00 PM',
//         type: FavoriteType.doctor,
//         tags: ['Heart Specialist', '15+ years'],
//         reviewCount: 128,
//         isVerified: true,
//       ),
//       FavoriteItem(
//         id: 'd2',
//         name: 'Dr. Michael Chen',
//         specialty: 'Neurologist',
//         imageUrl: '',
//         rating: 4.8,
//         distance: '1.2 km',
//         address: '456 Brain Health Center',
//         isOpen: true,
//         openingHours: '10:00 AM - 6:00 PM',
//         type: FavoriteType.doctor,
//         tags: ['Brain Specialist', '10+ years'],
//         reviewCount: 95,
//         isVerified: true,
//       ),
//       FavoriteItem(
//         id: 'd3',
//         name: 'Dr. Emily Rodriguez',
//         specialty: 'Pediatrician',
//         imageUrl: '',
//         rating: 4.9,
//         distance: '0.5 km',
//         address: '789 Children\'s Care Ave',
//         isOpen: false,
//         openingHours: '8:00 AM - 4:00 PM',
//         type: FavoriteType.doctor,
//         tags: ['Child Care', '20+ years'],
//         reviewCount: 203,
//         isVerified: true,
//       ),

//       // Pharmacies
//       FavoriteItem(
//         id: 'p1',
//         name: 'City Pharmacy',
//         specialty: '24/7 Pharmacy',
//         imageUrl: '',
//         rating: 4.7,
//         distance: '0.3 km',
//         address: '789 Main Street',
//         isOpen: true,
//         openingHours: '24 hours',
//         type: FavoriteType.pharmacy,
//         tags: ['24/7', 'Free Delivery'],
//         reviewCount: 256,
//         isVerified: true,
//       ),
//       FavoriteItem(
//         id: 'p2',
//         name: 'MedPlus Pharmacy',
//         specialty: 'Online Delivery',
//         imageUrl: '',
//         rating: 4.6,
//         distance: '1.5 km',
//         address: '321 Health Avenue',
//         isOpen: false,
//         openingHours: '8:00 AM - 10:00 PM',
//         type: FavoriteType.pharmacy,
//         tags: ['Discounts', 'Insurance'],
//         reviewCount: 189,
//         isVerified: true,
//       ),

//       // Hospitals
//       FavoriteItem(
//         id: 'h1',
//         name: 'City General Hospital',
//         specialty: 'Multi-Specialty',
//         imageUrl: '',
//         rating: 4.5,
//         distance: '2.1 km',
//         address: '1000 Healthcare Parkway',
//         isOpen: true,
//         openingHours: '24 hours',
//         type: FavoriteType.hospital,
//         tags: ['Emergency', 'ICU', 'Trauma'],
//         reviewCount: 512,
//         isVerified: true,
//       ),
//       FavoriteItem(
//         id: 'h2',
//         name: 'St. Mary\'s Medical Center',
//         specialty: 'Specialized Care',
//         imageUrl: '',
//         rating: 4.8,
//         distance: '3.5 km',
//         address: '2000 Medical Plaza',
//         isOpen: true,
//         openingHours: '24 hours',
//         type: FavoriteType.hospital,
//         tags: ['Cancer Center', 'Surgery', 'Radiology'],
//         reviewCount: 678,
//         isVerified: true,
//       ),

//       // Ambulances
//       FavoriteItem(
//         id: 'a1',
//         name: 'Rapid Response Ambulance',
//         specialty: 'Emergency Service',
//         imageUrl: '',
//         rating: 4.9,
//         distance: '0.5 km',
//         address: 'Station 5, Emergency Hub',
//         isOpen: true,
//         openingHours: '24 hours',
//         type: FavoriteType.ambulance,
//         tags: ['ACLS', 'BLS', 'ICU'],
//         reviewCount: 67,
//         isVerified: true,
//       ),
//       FavoriteItem(
//         id: 'a2',
//         name: 'LifeLine Emergency',
//         specialty: 'Critical Care Transport',
//         imageUrl: '',
//         rating: 4.8,
//         distance: '1.2 km',
//         address: 'Station 12, Central District',
//         isOpen: true,
//         openingHours: '24 hours',
//         type: FavoriteType.ambulance,
//         tags: ['Ventilator', 'Cardiac', 'Trauma'],
//         reviewCount: 45,
//         isVerified: true,
//       ),
//     ];
//   }

//   Map<FavoriteType, List<FavoriteItem>> _categorizeFavorites(
//     List<FavoriteItem> items,
//   ) {
//     return {
//       FavoriteType.doctor: items
//           .where((item) => item.type == FavoriteType.doctor)
//           .toList(),
//       FavoriteType.pharmacy: items
//           .where((item) => item.type == FavoriteType.pharmacy)
//           .toList(),
//       FavoriteType.hospital: items
//           .where((item) => item.type == FavoriteType.hospital)
//           .toList(),
//       FavoriteType.ambulance: items
//           .where((item) => item.type == FavoriteType.ambulance)
//           .toList(),
//     };
//   }

//   List<FavoriteItem> _getFilteredFavorites() {
//     final currentType = FavoriteType.values[_tabController.index];
//     final favorites = _categorizedFavorites[currentType] ?? [];

//     if (_searchTextController.text.isEmpty) {
//       return favorites;
//     }

//     final searchQuery = _searchTextController.text.toLowerCase();
//     return favorites
//         .where(
//           (item) =>
//               item.name.toLowerCase().contains(searchQuery) ||
//               item.specialty.toLowerCase().contains(searchQuery) ||
//               item.tags.any((tag) => tag.toLowerCase().contains(searchQuery)),
//         )
//         .toList();
//   }

//   void _toggleSearch() {
//     setState(() {
//       _isSearching = !_isSearching;
//       if (!_isSearching) {
//         _searchTextController.clear();
//         _searchFocusNode.unfocus();
//       } else {
//         _searchFocusNode.requestFocus();
//       }
//     });

//     if (_isSearching) {
//       _searchController.forward();
//     } else {
//       _searchController.reverse();
//     }
//   }

//   void _removeFavorite(FavoriteItem item) {
//     setState(() {
//       _allFavorites.removeWhere((f) => f.id == item.id);
//       _categorizedFavorites = _categorizeFavorites(_allFavorites);
//     });

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             const Icon(Icons.check_circle, color: Colors.white),
//             const SizedBox(width: 12),
//             Expanded(child: Text('${item.name} removed from favorites')),
//           ],
//         ),
//         backgroundColor: Colors.red,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         margin: const EdgeInsets.all(16),
//         duration: const Duration(seconds: 2),
//         action: SnackBarAction(
//           label: 'UNDO',
//           textColor: Colors.white,
//           onPressed: () {
//             setState(() {
//               _allFavorites.add(item);
//               _categorizedFavorites = _categorizeFavorites(_allFavorites);
//             });
//           },
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     _animationController.dispose();
//     _searchController.dispose();
//     _searchTextController.dispose();
//     _searchFocusNode.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     super.build(context);

//     return Scaffold(
//       backgroundColor: const Color(0xFFF8FAFC),
//       body: SafeArea(
//         child: CustomScrollView(
//           physics: const BouncingScrollPhysics(),
//           slivers: [
//             _buildSliverAppBar(),
//             _buildSearchBar(),
//             SliverToBoxAdapter(child: _buildCategories()),
//             _buildStatsBar(),
//             _buildFavoritesList(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSliverAppBar() {
//     return SliverAppBar(
//       expandedHeight: 100,
//       floating: true,
//       pinned: true,
//       backgroundColor: Colors.white,
//       elevation: 0,
//       surfaceTintColor: Colors.white,
//       flexibleSpace: FlexibleSpaceBar(
//         titlePadding: const EdgeInsets.only(left: 20, bottom: 16, right: 20),
//         title: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 gradient: const LinearGradient(
//                   colors: [Color(0xFFFF6B6B), Color(0xFFEE5A6F)],
//                 ),
//                 shape: BoxShape.circle,
//                 boxShadow: [
//                   BoxShadow(
//                     color: const Color(0xFFFF6B6B).withOpacity(0.3),
//                     blurRadius: 12,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: const Icon(
//                 Icons.favorite_rounded,
//                 color: Colors.white,
//                 size: 20,
//               ),
//             ),
//             const SizedBox(width: 12),
//             const Expanded(
//               child: Text(
//                 'My Favorites',
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF2E3E5C),
//                 ),
//               ),
//             ),
//           ],
//         ),
//         background: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [Colors.white, const Color(0xFFF8FAFC).withOpacity(0.5)],
//             ),
//           ),
//         ),
//       ),
//       actions: [
//         IconButton(
//           icon: AnimatedContainer(
//             duration: const Duration(milliseconds: 300),
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: _isSearching
//                   ? AppColors.midblue
//                   : AppColors.midblue.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Icon(
//               _isSearching ? Icons.close_rounded : Icons.search_rounded,
//               color: _isSearching ? Colors.white : AppColors.midblue,
//               size: 20,
//             ),
//           ),
//           onPressed: _toggleSearch,
//           tooltip: _isSearching ? 'Close search' : 'Search favorites',
//         ),
//         const SizedBox(width: 8),
//       ],
//     );
//   }

//   Widget _buildSearchBar() {
//     return SliverToBoxAdapter(
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOutCubic,
//         height: _isSearching ? 80 : 0,
//         child: _isSearching
//             ? Padding(
//                 padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(16),
//                     boxShadow: [
//                       BoxShadow(
//                         color: AppColors.midblue.withOpacity(0.1),
//                         blurRadius: 20,
//                         offset: const Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   child: TextField(
//                     controller: _searchTextController,
//                     focusNode: _searchFocusNode,
//                     decoration: InputDecoration(
//                       hintText: 'Search by name, specialty, or tags...',
//                       hintStyle: TextStyle(
//                         color: Colors.grey[400],
//                         fontSize: 14,
//                       ),
//                       prefixIcon: const Icon(
//                         Icons.search_rounded,
//                         color: AppColors.midblue,
//                       ),
//                       suffixIcon: _searchTextController.text.isNotEmpty
//                           ? IconButton(
//                               icon: Icon(
//                                 Icons.clear_rounded,
//                                 color: Colors.grey[400],
//                               ),
//                               onPressed: () {
//                                 _searchTextController.clear();
//                               },
//                             )
//                           : null,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(16),
//                         borderSide: BorderSide.none,
//                       ),
//                       filled: false,
//                       contentPadding: const EdgeInsets.symmetric(
//                         vertical: 16,
//                         horizontal: 16,
//                       ),
//                     ),
//                   ),
//                 ),
//               )
//             : const SizedBox.shrink(),
//       ),
//     );
//   }

//   Widget _buildCategories() {
//     return Container(
//       margin: const EdgeInsets.fromLTRB(20, 16, 20, 8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: TabBar(
//         controller: _tabController,
//         indicator: BoxDecoration(
//           gradient: const LinearGradient(
//             colors: [Color(0xFF13BDAC), Color(0xFF0FA394)],
//           ),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         indicatorSize: TabBarIndicatorSize.tab,
//         dividerColor: Colors.transparent,
//         labelColor: Colors.white,
//         unselectedLabelColor: const Color(0xFF64748B),
//         labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
//         unselectedLabelStyle: const TextStyle(
//           fontSize: 11,
//           fontWeight: FontWeight.w500,
//         ),
//         padding: const EdgeInsets.all(4),
//         tabs: [
//           _buildCategoryTab(Icons.medical_services_rounded, 'Doctors'),
//           _buildCategoryTab(Icons.medication_rounded, 'Pharmacy'),
//           _buildCategoryTab(Icons.local_hospital_rounded, 'Hospitals'),
//           _buildCategoryTab(Icons.local_shipping_rounded, 'Ambulance'),
//         ],
//       ),
//     );
//   }

//   Widget _buildCategoryTab(IconData icon, String label) {
//     return Tab(
//       height: 44,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(icon, size: 16),
//           const SizedBox(width: 4),
//           Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatsBar() {
//     final filteredFavorites = _getFilteredFavorites();
//     final currentType = FavoriteType.values[_tabController.index];
//     final totalInCategory = _categorizedFavorites[currentType]?.length ?? 0;

//     return SliverToBoxAdapter(
//       child: Container(
//         margin: const EdgeInsets.fromLTRB(20, 12, 20, 8),
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               AppColors.midblue.withOpacity(0.1),
//               AppColors.midblue.withOpacity(0.05),
//             ],
//           ),
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: AppColors.midblue.withOpacity(0.2)),
//         ),
//         child: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: AppColors.midblue.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Icon(
//                 _getIconForType(currentType),
//                 color: AppColors.midblue,
//                 size: 20,
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     _searchTextController.text.isEmpty
//                         ? 'Total $_getCategoryName'
//                         : 'Search Results',
//                     style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//                   ),
//                   const SizedBox(height: 2),
//                   Text(
//                     _searchTextController.text.isEmpty
//                         ? '$totalInCategory saved'
//                         : '${filteredFavorites.length} found',
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF2E3E5C),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             if (totalInCategory > 0)
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 12,
//                   vertical: 6,
//                 ),
//                 decoration: BoxDecoration(
//                   color: AppColors.midblue,
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Text(
//                   '$totalInCategory',
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 14,
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   String get _getCategoryName {
//     switch (FavoriteType.values[_tabController.index]) {
//       case FavoriteType.doctor:
//         return 'Doctors';
//       case FavoriteType.pharmacy:
//         return 'Pharmacies';
//       case FavoriteType.hospital:
//         return 'Hospitals';
//       case FavoriteType.ambulance:
//         return 'Ambulances';
//     }
//   }

//   Widget _buildFavoritesList() {
//     final filteredFavorites = _getFilteredFavorites();

//     if (_isLoading) {
//       return SliverPadding(
//         padding: const EdgeInsets.all(20),
//         sliver: SliverList(
//           delegate: SliverChildBuilderDelegate(
//             (context, index) => _buildShimmerItem(),
//             childCount: 3,
//           ),
//         ),
//       );
//     }

//     if (filteredFavorites.isEmpty) {
//       return SliverFillRemaining(child: _buildEmptyState());
//     }

//     return SliverPadding(
//       padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
//       sliver: SliverList(
//         delegate: SliverChildBuilderDelegate((context, index) {
//           return TweenAnimationBuilder<double>(
//             tween: Tween<double>(begin: 0.0, end: 1.0),
//             duration: Duration(milliseconds: 400 + (index * 50)),
//             curve: Curves.easeOutCubic,
//             builder: (context, value, child) {
//               final clampedValue = value.clamp(0.0, 1.0);
//               return Opacity(
//                 opacity: clampedValue,
//                 child: Transform.translate(
//                   offset: Offset(0, 20 * (1 - clampedValue)),
//                   child: child,
//                 ),
//               );
//             },
//             child: _buildFavoriteCard(filteredFavorites[index]),
//           );
//         }, childCount: filteredFavorites.length),
//       ),
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             width: 120,
//             height: 120,
//             decoration: BoxDecoration(
//               color: Colors.grey[100],
//               shape: BoxShape.circle,
//             ),
//             child: Icon(
//               _searchTextController.text.isEmpty
//                   ? Icons.favorite_border_rounded
//                   : Icons.search_off_rounded,
//               size: 60,
//               color: Colors.grey[400],
//             ),
//           ),
//           const SizedBox(height: 24),
//           Text(
//             _searchTextController.text.isEmpty
//                 ? 'No favorites yet'
//                 : 'No results found',
//             style: const TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF2E3E5C),
//             ),
//           ),
//           const SizedBox(height: 8),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 40),
//             child: Text(
//               _searchTextController.text.isEmpty
//                   ? 'Items you favorite will appear here'
//                   : 'Try searching with different keywords',
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 14, color: Colors.grey[500]),
//             ),
//           ),
//           if (_searchTextController.text.isNotEmpty) ...[
//             const SizedBox(height: 24),
//             ElevatedButton.icon(
//               onPressed: () {
//                 _searchTextController.clear();
//               },
//               icon: const Icon(Icons.clear_rounded),
//               label: const Text('Clear Search'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.midblue,
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 24,
//                   vertical: 12,
//                 ),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   Widget _buildFavoriteCard(FavoriteItem item) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//           color: _getColorForType(item.type).withOpacity(0.1),
//           width: 1,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: _getColorForType(item.type).withOpacity(0.08),
//             blurRadius: 20,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           borderRadius: BorderRadius.circular(20),
//           onTap: () {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text('Opening ${item.name}'),
//                 behavior: SnackBarBehavior.floating,
//                 margin: const EdgeInsets.all(16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 duration: const Duration(seconds: 1),
//               ),
//             );
//           },
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _buildAvatar(item),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   item.name,
//                                   style: const TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                     color: Color(0xFF2E3E5C),
//                                   ),
//                                 ),
//                               ),
//                               if (item.isVerified)
//                                 Container(
//                                   padding: const EdgeInsets.all(4),
//                                   decoration: BoxDecoration(
//                                     color: AppColors.midblue.withOpacity(0.1),
//                                     shape: BoxShape.circle,
//                                   ),
//                                   child: const Icon(
//                                     Icons.verified_rounded,
//                                     color: AppColors.midblue,
//                                     size: 16,
//                                   ),
//                                 ),
//                             ],
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             item.specialty,
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: Colors.grey[600],
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           _buildRatingRow(item),
//                           const SizedBox(height: 8),
//                           _buildInfoRow(item),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 12),
//                 _buildTagsRow(item),
//                 const SizedBox(height: 12),
//                 _buildActionButtons(item),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildAvatar(FavoriteItem item) {
//     return Hero(
//       tag: 'favorite_${item.id}',
//       child: Container(
//         width: 70,
//         height: 70,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: _getGradientForType(item.type),
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: _getColorForType(item.type).withOpacity(0.3),
//               blurRadius: 12,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(16),
//           child: item.imageUrl.isNotEmpty
//               ? Image.network(
//                   item.imageUrl,
//                   fit: BoxFit.cover,
//                   errorBuilder: (context, error, stackTrace) {
//                     return _buildAvatarPlaceholder(item.type);
//                   },
//                   loadingBuilder: (context, child, loadingProgress) {
//                     if (loadingProgress == null) return child;
//                     return _buildAvatarPlaceholder(item.type);
//                   },
//                 )
//               : _buildAvatarPlaceholder(item.type),
//         ),
//       ),
//     );
//   }

//   Widget _buildAvatarPlaceholder(FavoriteType type) {
//     return Container(
//       color: Colors.white.withOpacity(0.2),
//       child: Icon(_getIconForType(type), color: Colors.white, size: 32),
//     );
//   }

//   Widget _buildRatingRow(FavoriteItem item) {
//     return Row(
//       children: [
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//           decoration: BoxDecoration(
//             color: const Color(0xFFFFB800).withOpacity(0.1),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Icon(
//                 Icons.star_rounded,
//                 color: Color(0xFFFFB800),
//                 size: 16,
//               ),
//               const SizedBox(width: 4),
//               Text(
//                 item.rating.toString(),
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF2E3E5C),
//                   fontSize: 13,
//                 ),
//               ),
//               Text(
//                 ' (${item.reviewCount})',
//                 style: TextStyle(color: Colors.grey[500], fontSize: 12),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(width: 12),
//         Row(
//           children: [
//             Container(
//               width: 8,
//               height: 8,
//               decoration: BoxDecoration(
//                 color: item.isOpen ? Colors.green : Colors.red,
//                 shape: BoxShape.circle,
//                 boxShadow: [
//                   BoxShadow(
//                     color: (item.isOpen ? Colors.green : Colors.red)
//                         .withOpacity(0.3),
//                     blurRadius: 4,
//                     spreadRadius: 1,
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(width: 6),
//             Text(
//               item.isOpen ? 'Open Now' : 'Closed',
//               style: TextStyle(
//                 fontSize: 12,
//                 color: item.isOpen ? Colors.green : Colors.red,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildInfoRow(FavoriteItem item) {
//     return Row(
//       children: [
//         Icon(Icons.location_on_rounded, size: 14, color: Colors.grey[400]),
//         const SizedBox(width: 4),
//         Text(
//           item.distance,
//           style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//         ),
//         const SizedBox(width: 12),
//         Icon(Icons.access_time_rounded, size: 14, color: Colors.grey[400]),
//         const SizedBox(width: 4),
//         Expanded(
//           child: Text(
//             item.openingHours,
//             style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildTagsRow(FavoriteItem item) {
//     return SizedBox(
//       height: 28,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: item.tags.length,
//         itemBuilder: (context, index) {
//           return Container(
//             margin: const EdgeInsets.only(right: 8),
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//             decoration: BoxDecoration(
//               color: _getColorForType(item.type).withOpacity(0.1),
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(
//                 color: _getColorForType(item.type).withOpacity(0.3),
//               ),
//             ),
//             child: Text(
//               item.tags[index],
//               style: TextStyle(
//                 fontSize: 11,
//                 color: _getColorForType(item.type),
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildActionButtons(FavoriteItem item) {
//     return Row(
//       children: [
//         Expanded(
//           child: _buildActionButton(
//             icon: Icons.directions_rounded,
//             label: 'Directions',
//             color: AppColors.midblue,
//             onTap: () {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                   content: Text('Opening directions...'),
//                   duration: Duration(seconds: 1),
//                 ),
//               );
//             },
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: _buildActionButton(
//             icon: Icons.phone_rounded,
//             label: 'Call',
//             color: const Color(0xFF13BDAC),
//             onTap: () {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                   content: Text('Calling...'),
//                   duration: Duration(seconds: 1),
//                 ),
//               );
//             },
//           ),
//         ),
//         const SizedBox(width: 12),
//         Container(
//           decoration: BoxDecoration(
//             gradient: const LinearGradient(
//               colors: [Color(0xFFFF6B6B), Color(0xFFEE5A6F)],
//             ),
//             borderRadius: BorderRadius.circular(12),
//             boxShadow: [
//               BoxShadow(
//                 color: const Color(0xFFFF6B6B).withOpacity(0.3),
//                 blurRadius: 8,
//                 offset: const Offset(0, 4),
//               ),
//             ],
//           ),
//           child: Material(
//             color: Colors.transparent,
//             child: InkWell(
//               borderRadius: BorderRadius.circular(12),
//               onTap: () => _removeFavorite(item),
//               child: Container(
//                 padding: const EdgeInsets.all(12),
//                 child: const Icon(
//                   Icons.favorite_rounded,
//                   color: Colors.white,
//                   size: 20,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildActionButton({
//     required IconData icon,
//     required String label,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(12),
//         child: Container(
//           padding: const EdgeInsets.symmetric(vertical: 12),
//           decoration: BoxDecoration(
//             color: color.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: color.withOpacity(0.2)),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(icon, color: color, size: 18),
//               const SizedBox(width: 6),
//               Text(
//                 label,
//                 style: TextStyle(
//                   color: color,
//                   fontWeight: FontWeight.w600,
//                   fontSize: 13,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildShimmerItem() {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       height: 240,
//       child: Shimmer.fromColors(
//         baseColor: Colors.grey[300]!,
//         highlightColor: Colors.grey[100]!,
//         child: Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(20),
//           ),
//         ),
//       ),
//     );
//   }

//   Color _getColorForType(FavoriteType type) {
//     switch (type) {
//       case FavoriteType.doctor:
//         return const Color(0xFF13BDAC);
//       case FavoriteType.pharmacy:
//         return const Color(0xFFFF6B6B);
//       case FavoriteType.hospital:
//         return const Color(0xFF6B5CE7);
//       case FavoriteType.ambulance:
//         return const Color(0xFFFFA07A);
//     }
//   }

//   List<Color> _getGradientForType(FavoriteType type) {
//     switch (type) {
//       case FavoriteType.doctor:
//         return const [Color(0xFF13BDAC), Color(0xFF0FA394)];
//       case FavoriteType.pharmacy:
//         return const [Color(0xFFFF6B6B), Color(0xFFEE5A6F)];
//       case FavoriteType.hospital:
//         return const [Color(0xFF6B5CE7), Color(0xFF8B7BFF)];
//       case FavoriteType.ambulance:
//         return const [Color(0xFFFFA07A), Color(0xFFFF8E8E)];
//     }
//   }

//   IconData _getIconForType(FavoriteType type) {
//     switch (type) {
//       case FavoriteType.doctor:
//         return Icons.medical_services_rounded;
//       case FavoriteType.pharmacy:
//         return Icons.medication_rounded;
//       case FavoriteType.hospital:
//         return Icons.local_hospital_rounded;
//       case FavoriteType.ambulance:
//         return Icons.local_shipping_rounded;
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:healthcare/src/model/drawar_section_model/favorites_item_model.dart';
import 'package:healthcare/src/util/app_color.dart';
import 'package:shimmer/shimmer.dart';

enum FavoriteType { doctor, pharmacy, hospital, ambulance }

enum SortBy { nearest, rating, alphabetical, recent }

enum ViewMode { grid, list, compact }

class PatientFavoritesScreenEnhanced extends StatefulWidget {
  const PatientFavoritesScreenEnhanced({super.key});

  @override
  State<PatientFavoritesScreenEnhanced> createState() =>
      _PatientFavoritesScreenEnhancedState();
}

class _PatientFavoritesScreenEnhancedState
    extends State<PatientFavoritesScreenEnhanced>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late final TabController _tabController;
  late final AnimationController _fabAnimationController;
  late final AnimationController _headerAnimationController;
  late final AnimationController _filterAnimationController;

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  bool _isLoading = true;
  ViewMode _viewMode = ViewMode.grid;
  SortBy _sortBy = SortBy.nearest;
  bool _showOnlyOpen = false;
  bool _showFilterPanel = false;

  List<FavoriteItem> _allFavorites = [];
  List<FavoriteItem> _filteredFavorites = [];
  Map<FavoriteType, List<FavoriteItem>> _categorizedFavorites = {};

  final List<String> _quickFilters = ['All', 'Open Now', 'Nearby', 'Top Rated'];
  String _selectedQuickFilter = 'All';

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadFavorites();
    _scrollController.addListener(_onScroll);
    _searchController.addListener(_filterFavorites);
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  void _initializeAnimations() {
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _filterAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fabAnimationController.forward();
    _headerAnimationController.forward();
  }

  void _onScroll() {
    if (_scrollController.offset > 100 && _fabAnimationController.value == 1) {
      _fabAnimationController.reverse();
    } else if (_scrollController.offset <= 100 &&
        _fabAnimationController.value == 0) {
      _fabAnimationController.forward();
    }
  }

  void _onTabChanged() {
    setState(() {
      _filterFavorites();
    });
  }

  Future<void> _loadFavorites() async {
    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      setState(() {
        _allFavorites = _generateSampleData();
        _categorizedFavorites = _categorizeFavorites(_allFavorites);
        _filteredFavorites = _allFavorites;
        _isLoading = false;
      });
    }
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

  void _filterFavorites() {
    final query = _searchController.text.toLowerCase();
    List<FavoriteItem> filtered = _allFavorites;

    // Filter by tab
    if (_tabController.index > 0) {
      final type = FavoriteType.values[_tabController.index - 1];
      filtered = filtered.where((item) => item.type == type).toList();
    }

    // Filter by search
    if (query.isNotEmpty) {
      filtered = filtered.where((item) {
        return item.name.toLowerCase().contains(query) ||
            item.specialty.toLowerCase().contains(query) ||
            item.tags.any((tag) => tag.toLowerCase().contains(query)) ||
            item.address.toLowerCase().contains(query);
      }).toList();
    }

    // Filter by open status
    if (_showOnlyOpen) {
      filtered = filtered.where((item) => item.isOpen).toList();
    }

    // Quick filters
    switch (_selectedQuickFilter) {
      case 'Open Now':
        filtered = filtered.where((item) => item.isOpen).toList();
        break;
      case 'Nearby':
        filtered.sort(
          (a, b) =>
              _parseDistance(a.distance).compareTo(_parseDistance(b.distance)),
        );
        break;
      case 'Top Rated':
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }

    // Apply sorting
    _applySorting(filtered);

    setState(() {
      _filteredFavorites = filtered;
    });
  }

  double _parseDistance(String distance) {
    return double.tryParse(distance.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
  }

  void _applySorting(List<FavoriteItem> items) {
    switch (_sortBy) {
      case SortBy.nearest:
        items.sort(
          (a, b) =>
              _parseDistance(a.distance).compareTo(_parseDistance(b.distance)),
        );
        break;
      case SortBy.rating:
        items.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case SortBy.alphabetical:
        items.sort((a, b) => a.name.compareTo(b.name));
        break;
      case SortBy.recent:
        // Keep original order
        break;
    }
  }

  List<FavoriteItem> _generateSampleData() {
    return [
      // Doctors
      FavoriteItem(
        id: 'd1',
        name: 'Dr. Sarah Johnson',
        specialty: 'Cardiologist • Heart Specialist',
        imageUrl: '',
        rating: 4.9,
        distance: '0.8 km',
        address: '123 Medical Center Blvd, Downtown',
        isOpen: true,
        openingHours: 'Mon-Sat: 9:00 AM - 5:00 PM',
        type: FavoriteType.doctor,
        tags: ['Heart', '15+ yrs', 'AIIMS', 'Emergency'],
        reviewCount: 1284,
        isVerified: true,
      ),
      FavoriteItem(
        id: 'd2',
        name: 'Dr. Michael Chen',
        specialty: 'Neurologist • Brain Specialist',
        imageUrl: '',
        rating: 4.8,
        distance: '1.2 km',
        address: '456 Brain Health Center',
        isOpen: true,
        openingHours: 'Mon-Fri: 10:00 AM - 6:00 PM',
        type: FavoriteType.doctor,
        tags: ['Brain', '10+ yrs', 'Gold Medalist'],
        reviewCount: 956,
        isVerified: true,
      ),
      FavoriteItem(
        id: 'd3',
        name: 'Dr. Emily Rodriguez',
        specialty: 'Pediatrician • Child Care',
        imageUrl: '',
        rating: 4.9,
        distance: '0.5 km',
        address: '789 Children\'s Care Ave',
        isOpen: false,
        openingHours: 'Mon-Sat: 8:00 AM - 4:00 PM',
        type: FavoriteType.doctor,
        tags: ['Child', '20+ yrs', 'Ex-Harvard'],
        reviewCount: 2031,
        isVerified: true,
      ),
      FavoriteItem(
        id: 'd4',
        name: 'Dr. James Wilson',
        specialty: 'Orthopedic Surgeon',
        imageUrl: '',
        rating: 4.7,
        distance: '2.3 km',
        address: '234 Bone & Joint Clinic',
        isOpen: true,
        openingHours: 'Mon-Sat: 9:00 AM - 7:00 PM',
        type: FavoriteType.doctor,
        tags: ['Orthopedic', '12+ yrs', 'Sports Med'],
        reviewCount: 673,
        isVerified: true,
      ),

      // Pharmacies
      FavoriteItem(
        id: 'p1',
        name: 'City Pharmacy 24/7',
        specialty: 'Round the Clock Service',
        imageUrl: '',
        rating: 4.7,
        distance: '0.3 km',
        address: '789 Main Street Plaza',
        isOpen: true,
        openingHours: 'Open 24 Hours',
        type: FavoriteType.pharmacy,
        tags: ['24/7', 'Free Delivery', '20% Off'],
        reviewCount: 2567,
        isVerified: true,
      ),
      FavoriteItem(
        id: 'p2',
        name: 'MedPlus Pharmacy',
        specialty: 'Online Delivery • Insurance',
        imageUrl: '',
        rating: 4.6,
        distance: '1.5 km',
        address: '321 Health Avenue',
        isOpen: false,
        openingHours: 'Mon-Sun: 8:00 AM - 10:00 PM',
        type: FavoriteType.pharmacy,
        tags: ['Online', 'Insurance', 'Express'],
        reviewCount: 1894,
        isVerified: true,
      ),
      FavoriteItem(
        id: 'p3',
        name: 'Apollo Pharmacy',
        specialty: 'Trusted Healthcare Partner',
        imageUrl: '',
        rating: 4.8,
        distance: '0.9 km',
        address: '567 Apollo Complex',
        isOpen: true,
        openingHours: 'Mon-Sun: 7:00 AM - 11:00 PM',
        type: FavoriteType.pharmacy,
        tags: ['Trusted', 'Fast', 'Offers'],
        reviewCount: 3421,
        isVerified: true,
      ),

      // Hospitals
      FavoriteItem(
        id: 'h1',
        name: 'City General Hospital',
        specialty: 'Multi-Specialty • 500+ Beds',
        imageUrl: '',
        rating: 4.5,
        distance: '2.1 km',
        address: '1000 Healthcare Parkway',
        isOpen: true,
        openingHours: 'Emergency 24/7',
        type: FavoriteType.hospital,
        tags: ['Emergency', 'ICU', 'Trauma', 'NABH'],
        reviewCount: 5123,
        isVerified: true,
      ),
      FavoriteItem(
        id: 'h2',
        name: 'St. Mary\'s Medical Center',
        specialty: 'Specialized Care • NABH Accredited',
        imageUrl: '',
        rating: 4.8,
        distance: '3.5 km',
        address: '2000 Medical Plaza',
        isOpen: true,
        openingHours: 'Open 24 Hours',
        type: FavoriteType.hospital,
        tags: ['Cancer', 'Surgery', 'Radiology'],
        reviewCount: 6789,
        isVerified: true,
      ),

      // Ambulances
      FavoriteItem(
        id: 'a1',
        name: 'Rapid Response Ambulance',
        specialty: 'Emergency Medical Services',
        imageUrl: '',
        rating: 4.9,
        distance: '0.5 km',
        address: 'Station 5, Emergency Hub',
        isOpen: true,
        openingHours: 'Available 24/7',
        type: FavoriteType.ambulance,
        tags: ['ACLS', 'BLS', 'ICU', 'Ventilator'],
        reviewCount: 678,
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
        openingHours: 'Always Ready',
        type: FavoriteType.ambulance,
        tags: ['Cardiac', 'Trauma', 'Ventilator'],
        reviewCount: 452,
        isVerified: true,
      ),
    ];
  }

  void _removeFavorite(FavoriteItem item) {
    setState(() {
      _allFavorites.removeWhere((f) => f.id == item.id);
      _categorizedFavorites = _categorizeFavorites(_allFavorites);
      _filterFavorites();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_rounded,
                color: Color(0xFFFF6B6B),
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Removed from favorites',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    item.name,
                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF2E3E5C),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: const Color(0xFF13BDAC),
          onPressed: () {
            setState(() {
              _allFavorites.add(item);
              _categorizedFavorites = _categorizeFavorites(_allFavorites);
              _filterFavorites();
            });
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _fabAnimationController.dispose();
    _headerAnimationController.dispose();
    _filterAnimationController.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildModernHeader(),
              _buildSearchBar(),
              _buildQuickFilters(),
              _buildCategoryTabs(),
              _buildStatsAndSort(),
              _buildFilterPanel(),
              _buildContent(),
              const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
            ],
          ),
          _buildFloatingActions(),
        ],
      ),
    );
  }

  Widget _buildModernHeader() {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.midblue,
                AppColors.midblue.withOpacity(0.9),
                const Color(0xFF6B5CE7).withOpacity(0.8),
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                        child: const Icon(
                          Icons.favorite_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      Row(
                        children: [
                          _buildHeaderBadge(
                            Icons.bookmark_rounded,
                            '${_allFavorites.length}',
                          ),
                          const SizedBox(width: 8),
                          _buildHeaderBadge(
                            Icons.online_prediction_rounded,
                            '${_allFavorites.where((f) => f.isOpen).length}',
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Text(
                    'My Favorites',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -1,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.health_and_safety_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'Your trusted healthcare partners',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderBadge(IconData icon, String count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 4),
          Text(
            count,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.midblue.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            decoration: InputDecoration(
              hintText: 'Search doctors, hospitals, pharmacies...',
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
              prefixIcon: Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.midblue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.search_rounded,
                  color: AppColors.midblue,
                  size: 20,
                ),
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear_rounded, color: Colors.grey[400]),
                      onPressed: () {
                        _searchController.clear();
                        _searchFocusNode.unfocus();
                      },
                    )
                  : IconButton(
                      icon: Icon(
                        _showFilterPanel
                            ? Icons.filter_alt_rounded
                            : Icons.filter_alt_outlined,
                        color: _showFilterPanel
                            ? AppColors.midblue
                            : Colors.grey[400],
                      ),
                      onPressed: () {
                        setState(() {
                          _showFilterPanel = !_showFilterPanel;
                        });
                        if (_showFilterPanel) {
                          _filterAnimationController.forward();
                        } else {
                          _filterAnimationController.reverse();
                        }
                      },
                    ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickFilters() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 50,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: _quickFilters.length,
          itemBuilder: (context, index) {
            final filter = _quickFilters[index];
            final isSelected = _selectedQuickFilter == filter;

            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedQuickFilter = filter;
                      _filterFavorites();
                    });
                  },
                  borderRadius: BorderRadius.circular(25),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? LinearGradient(
                              colors: [
                                AppColors.midblue,
                                const Color(0xFF6B5CE7),
                              ],
                            )
                          : null,
                      color: isSelected ? null : Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: isSelected
                            ? Colors.transparent
                            : Colors.grey.shade300,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppColors.midblue.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getQuickFilterIcon(filter),
                          size: 16,
                          color: isSelected ? Colors.white : Colors.grey[600],
                        ),
                        const SizedBox(width: 6),
                        Text(
                          filter,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey[700],
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  IconData _getQuickFilterIcon(String filter) {
    switch (filter) {
      case 'All':
        return Icons.dashboard_rounded;
      case 'Open Now':
        return Icons.access_time_rounded;
      case 'Nearby':
        return Icons.near_me_rounded;
      case 'Top Rated':
        return Icons.star_rounded;
      default:
        return Icons.filter_alt_rounded;
    }
  }

  Widget _buildCategoryTabs() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.midblue, const Color(0xFF6B5CE7)],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          labelColor: Colors.white,
          unselectedLabelColor: const Color(0xFF64748B),
          labelStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          padding: const EdgeInsets.all(4),
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.dashboard_rounded, size: 16),
                  const SizedBox(width: 4),
                  const Text('All'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.medical_services_rounded, size: 16),
                  const SizedBox(width: 4),
                  const Text('Doctors'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.medication_rounded, size: 16),
                  const SizedBox(width: 4),
                  const Text('Pharmacy'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.local_hospital_rounded, size: 16),
                  const SizedBox(width: 4),
                  const Text('Hospitals'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.local_shipping_rounded, size: 16),
                  const SizedBox(width: 4),
                  const Text('Ambulance'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsAndSort() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.midblue.withOpacity(0.1),
                      AppColors.midblue.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.midblue.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.midblue.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.favorite_rounded,
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
                            'Showing Results',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${_filteredFavorites.length} of ${_allFavorites.length}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2E3E5C),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
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
              child: Material(
                color: Colors.transparent,
                child: PopupMenuButton<SortBy>(
                  icon: Container(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Icon(
                          Icons.sort_rounded,
                          color: AppColors.midblue,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_drop_down_rounded,
                          color: AppColors.midblue,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  onSelected: (value) {
                    setState(() {
                      _sortBy = value;
                      _filterFavorites();
                    });
                  },
                  itemBuilder: (context) => [
                    _buildSortMenuItem(
                      SortBy.nearest,
                      Icons.near_me_rounded,
                      'Nearest',
                    ),
                    _buildSortMenuItem(
                      SortBy.rating,
                      Icons.star_rounded,
                      'Top Rated',
                    ),
                    _buildSortMenuItem(
                      SortBy.alphabetical,
                      Icons.sort_by_alpha_rounded,
                      'A to Z',
                    ),
                    _buildSortMenuItem(
                      SortBy.recent,
                      Icons.access_time_rounded,
                      'Recently Added',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<SortBy> _buildSortMenuItem(
    SortBy value,
    IconData icon,
    String label,
  ) {
    final isSelected = _sortBy == value;
    return PopupMenuItem<SortBy>(
      value: value,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.midblue.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: isSelected ? AppColors.midblue : Colors.grey[600],
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? AppColors.midblue : Colors.grey[800],
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          if (isSelected) ...[
            const Spacer(),
            Icon(
              Icons.check_circle_rounded,
              color: AppColors.midblue,
              size: 20,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFilterPanel() {
    if (!_showFilterPanel) return const SliverToBoxAdapter(child: SizedBox());

    return SliverToBoxAdapter(
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.tune_rounded, color: AppColors.midblue, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    'Advanced Filters',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E3E5C),
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _showOnlyOpen = false;
                        _selectedQuickFilter = 'All';
                        _sortBy = SortBy.nearest;
                        _filterFavorites();
                      });
                    },
                    child: const Text('Reset'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text(
                  'Show only open now',
                  style: TextStyle(fontSize: 14),
                ),
                subtitle: Text(
                  '${_allFavorites.where((f) => f.isOpen).length} available',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                value: _showOnlyOpen,
                onChanged: (value) {
                  setState(() {
                    _showOnlyOpen = value;
                    _filterFavorites();
                  });
                },
                activeColor: AppColors.midblue,
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_filteredFavorites.isEmpty) {
      return SliverFillRemaining(child: _buildEmptyState());
    }

    switch (_viewMode) {
      case ViewMode.grid:
        return _buildGridView();
      case ViewMode.list:
        return _buildListView();
      case ViewMode.compact:
        return _buildCompactView();
    }
  }

  Widget _buildLoadingState() {
    return SliverPadding(
      padding: const EdgeInsets.all(20),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          childCount: 6,
        ),
      ),
    );
  }

  Widget _buildGridView() {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          return TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 400 + (index * 50)),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Opacity(opacity: value, child: child),
              );
            },
            child: _buildEnhancedCard(_filteredFavorites[index]),
          );
        }, childCount: _filteredFavorites.length),
      ),
    );
  }

  Widget _buildListView() {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          return TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 300 + (index * 30)),
            curve: Curves.easeOut,
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: Opacity(opacity: value, child: child),
              );
            },
            child: _buildListCard(_filteredFavorites[index]),
          );
        }, childCount: _filteredFavorites.length),
      ),
    );
  }

  Widget _buildCompactView() {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => _buildCompactCard(_filteredFavorites[index]),
          childCount: _filteredFavorites.length,
        ),
      ),
    );
  }

  Widget _buildEnhancedCard(FavoriteItem item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: _getColorForType(item.type).withOpacity(0.1),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: _getColorForType(item.type).withOpacity(0.12),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Navigate to details
          },
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status Badge & Favorite
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: item.isOpen
                            ? Colors.green.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: item.isOpen ? Colors.green : Colors.red,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: item.isOpen ? Colors.green : Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            item.isOpen ? 'Open' : 'Closed',
                            style: TextStyle(
                              color: item.isOpen ? Colors.green : Colors.red,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _removeFavorite(item),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF6B6B).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.favorite_rounded,
                            color: Color(0xFFFF6B6B),
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Avatar with gradient
                Center(
                  child: Hero(
                    tag: 'favorite_${item.id}',
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: _getGradientForType(item.type),
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: _getColorForType(item.type).withOpacity(0.4),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Icon(
                        _getIconForType(item.type),
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Name & Verification
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E3E5C),
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (item.isVerified)
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.midblue.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.verified_rounded,
                          color: AppColors.midblue,
                          size: 14,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),

                // Specialty
                Text(
                  item.specialty.split('•')[0].trim(),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),

                // Rating & Reviews
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFB800).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Color(0xFFFFB800),
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item.rating.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Color(0xFF2E3E5C),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${_formatReviewCount(item.reviewCount)})',
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Distance
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(
                        Icons.location_on_rounded,
                        size: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        item.distance,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                // Tags
                SizedBox(
                  height: 24,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: item.tags.take(2).length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(right: 6),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              _getColorForType(item.type).withOpacity(0.15),
                              _getColorForType(item.type).withOpacity(0.05),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _getColorForType(item.type).withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          item.tags[index],
                          style: TextStyle(
                            fontSize: 9,
                            color: _getColorForType(item.type),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: _buildCardActionButton(
                        icon: Icons.directions_car_rounded,
                        label: 'Route',
                        color: AppColors.midblue,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildCardActionButton(
                        icon: Icons.call_rounded,
                        label: 'Call',
                        color: const Color(0xFF13BDAC),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardActionButton({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListCard(FavoriteItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _getColorForType(item.type).withOpacity(0.1),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: _getColorForType(item.type).withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Avatar
                Hero(
                  tag: 'favorite_${item.id}',
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: _getGradientForType(item.type),
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
                    child: Icon(
                      _getIconForType(item.type),
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Details
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
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (item.isVerified)
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: AppColors.midblue.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.verified_rounded,
                                color: AppColors.midblue,
                                size: 14,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.specialty,
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
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
                                  size: 12,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${item.rating}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.location_on_rounded,
                            size: 14,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            item.distance,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: item.isOpen ? Colors.green : Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            item.isOpen ? 'Open' : 'Closed',
                            style: TextStyle(
                              fontSize: 11,
                              color: item.isOpen ? Colors.green : Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),

                // Actions
                Column(
                  children: [
                    _buildIconButton(
                      Icons.directions_car_rounded,
                      AppColors.midblue,
                    ),
                    const SizedBox(height: 8),
                    _buildIconButton(
                      Icons.call_rounded,
                      const Color(0xFF13BDAC),
                    ),
                    const SizedBox(height: 8),
                    _buildIconButton(
                      Icons.favorite_rounded,
                      const Color(0xFFFF6B6B),
                      onTap: () => _removeFavorite(item),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompactCard(FavoriteItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _getColorForType(item.type).withOpacity(0.1)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _getGradientForType(item.type),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getIconForType(item.type),
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
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
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2E3E5C),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (item.isVerified)
                            Icon(
                              Icons.verified_rounded,
                              color: AppColors.midblue,
                              size: 14,
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: Color(0xFFFFB800),
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${item.rating}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.location_on_rounded,
                            size: 12,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            item.distance,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.favorite_rounded,
                    color: Color(0xFFFF6B6B),
                    size: 20,
                  ),
                  onPressed: () => _removeFavorite(item),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, Color color, {VoidCallback? onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  AppColors.midblue.withOpacity(0.2),
                  Colors.transparent,
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _searchController.text.isEmpty
                  ? Icons.favorite_border_rounded
                  : Icons.search_off_rounded,
              size: 70,
              color: AppColors.midblue.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            _searchController.text.isEmpty
                ? 'No favorites yet'
                : 'No results found',
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E3E5C),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Text(
              _searchController.text.isEmpty
                  ? 'Start saving your favorite doctors, hospitals and pharmacies'
                  : 'Try different keywords or adjust your filters',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
          ),
          if (_searchController.text.isNotEmpty ||
              _selectedQuickFilter != 'All' ||
              _showOnlyOpen) ...[
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _searchController.clear();
                  _selectedQuickFilter = 'All';
                  _showOnlyOpen = false;
                  _filterFavorites();
                });
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Clear All Filters'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.midblue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFloatingActions() {
    return Positioned(
      bottom: 24,
      right: 24,
      child: ScaleTransition(
        scale: CurvedAnimation(
          parent: _fabAnimationController,
          curve: Curves.easeOutCubic,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // View Mode Switcher
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: PopupMenuButton<ViewMode>(
                  icon: Container(
                    padding: const EdgeInsets.all(14),
                    child: Icon(
                      _viewMode == ViewMode.grid
                          ? Icons.grid_view_rounded
                          : _viewMode == ViewMode.list
                          ? Icons.view_list_rounded
                          : Icons.view_compact_rounded,
                      color: AppColors.midblue,
                      size: 22,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  onSelected: (value) {
                    setState(() {
                      _viewMode = value;
                    });
                  },
                  itemBuilder: (context) => [
                    _buildViewMenuItem(
                      ViewMode.grid,
                      Icons.grid_view_rounded,
                      'Grid View',
                    ),
                    _buildViewMenuItem(
                      ViewMode.list,
                      Icons.view_list_rounded,
                      'List View',
                    ),
                    _buildViewMenuItem(
                      ViewMode.compact,
                      Icons.view_compact_rounded,
                      'Compact View',
                    ),
                  ],
                ),
              ),
            ),

            // Scroll to Top
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.midblue, const Color(0xFF6B5CE7)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.midblue.withOpacity(0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    _scrollController.animateTo(
                      0,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOutCubic,
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: const Icon(
                      Icons.arrow_upward_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<ViewMode> _buildViewMenuItem(
    ViewMode value,
    IconData icon,
    String label,
  ) {
    final isSelected = _viewMode == value;
    return PopupMenuItem<ViewMode>(
      value: value,
      child: Row(
        children: [
          Icon(
            icon,
            color: isSelected ? AppColors.midblue : Colors.grey[600],
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? AppColors.midblue : Colors.grey[800],
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          if (isSelected) ...[
            const Spacer(),
            Icon(
              Icons.check_circle_rounded,
              color: AppColors.midblue,
              size: 18,
            ),
          ],
        ],
      ),
    );
  }

  String _formatReviewCount(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return count.toString();
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
