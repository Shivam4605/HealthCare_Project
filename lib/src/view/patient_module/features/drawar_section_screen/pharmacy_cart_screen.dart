import 'package:flutter/material.dart';

enum ItemType { medicine, equipment }

class CartItem {
  final String id;
  final String name;
  final ItemType type;
  final double price;
  int quantity;
  final String? imageUrl;
  final String manufacturer;
  final bool inStock;
  final int maxQuantity;
  final bool requiresPrescription;
  final double? discountPercentage;

  CartItem({
    required this.id,
    required this.name,
    required this.type,
    required this.price,
    required this.quantity,
    this.imageUrl,
    required this.manufacturer,
    required this.inStock,
    this.maxQuantity = 10,
    this.requiresPrescription = false,
    this.discountPercentage,
  });
}

class PharmacyCartScreen extends StatefulWidget {
  const PharmacyCartScreen({super.key});

  @override
  State<PharmacyCartScreen> createState() => _PharmacyCartScreenState();
}

class _PharmacyCartScreenState extends State<PharmacyCartScreen> {
  // Sample cart data
  final List<CartItem> _cartItems = [
    CartItem(
      id: '1',
      name: 'Paracetamol 500mg',
      type: ItemType.medicine,
      price: 45.00,
      quantity: 2,
      manufacturer: 'Cipla',
      inStock: true,
      requiresPrescription: false,
      discountPercentage: 10,
    ),
    CartItem(
      id: '2',
      name: 'Blood Pressure Monitor',
      type: ItemType.equipment,
      price: 2499.00,
      quantity: 1,
      manufacturer: 'Omron',
      inStock: true,
      requiresPrescription: false,
    ),
    CartItem(
      id: '3',
      name: 'Amoxicillin 250mg',
      type: ItemType.medicine,
      price: 120.00,
      quantity: 1,
      manufacturer: 'Sun Pharma',
      inStock: true,
      requiresPrescription: true,
    ),
  ];

  Address? _selectedAddress;
  DeliverySlot? _selectedSlot;
  Coupon? _appliedCoupon;

  @override
  Widget build(BuildContext context) {
    if (_cartItems.isEmpty) {
      return _buildEmptyCart();
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildDeliveryAddress(),
                  const SizedBox(height: 8),
                  _buildMedicineSection(),
                  _buildEquipmentSection(),
                  const SizedBox(height: 8),
                  _buildPriceBreakdown(),
                  const SizedBox(height: 8),
                  _buildDeliverySlot(),
                  const SizedBox(height: 8),
                  _buildPrescriptionReminder(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          _buildCheckoutBar(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      title: const Text(
        'Pharmacy Cart',
        style: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black87),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.black87),
          onPressed: () => _showCartOptions(),
        ),
      ],
    );
  }

  Widget _buildDeliveryAddress() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap: () {},
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.location_on, color: Colors.green, size: 20),
        ),
        title: Text(
          _selectedAddress != null
              ? 'Deliver to: ${_selectedAddress!.name}'
              : 'Select Delivery Address',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: _selectedAddress != null
            ? Text(
                _selectedAddress!.fullAddress,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      ),
    );
  }

  Widget _buildMedicineSection() {
    final medicines = _cartItems
        .where((item) => item.type == ItemType.medicine)
        .toList();

    if (medicines.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Medicines', Icons.medical_services),
        ...medicines.map((item) => _buildCartItemCard(item)),
      ],
    );
  }

  Widget _buildEquipmentSection() {
    final equipments = _cartItems
        .where((item) => item.type == ItemType.equipment)
        .toList();

    if (equipments.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Healthcare Equipment', Icons.health_and_safety),
        ...equipments.map((item) => _buildCartItemCard(item)),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.green, size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItemCard(CartItem item) {
    final double discountedPrice = item.discountPercentage != null
        ? item.price * (1 - item.discountPercentage! / 100)
        : item.price;
    final double totalPrice = discountedPrice * item.quantity;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    item.type == ItemType.medicine
                        ? Icons.medical_services
                        : Icons.health_and_safety,
                    color: Colors.green,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 12),

                // Product Details
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
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, size: 20),
                            onPressed: () {},
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.manufacturer,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 8),

                      // Price and Quantity Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Price
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (item.discountPercentage != null) ...[
                                Text(
                                  '₹${item.price.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                Text(
                                  '₹${discountedPrice.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ] else
                                Text(
                                  '₹${item.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                            ],
                          ),

                          // Quantity Controls
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove, size: 18),
                                  onPressed: item.quantity > 1 ? () {} : null,
                                  padding: const EdgeInsets.all(4),
                                  constraints: const BoxConstraints(),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: Text(
                                    '${item.quantity}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add, size: 18),
                                  onPressed: item.quantity < item.maxQuantity
                                      ? () {}
                                      : null,
                                  padding: const EdgeInsets.all(4),
                                  constraints: const BoxConstraints(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Prescription Required Badge
                      if (item.requiresPrescription)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.orange.shade200),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.description_outlined,
                                  size: 14,
                                  color: Colors.orange.shade700,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Prescription Required',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.orange.shade700,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (item.requiresPrescription)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                border: Border(top: BorderSide(color: Colors.orange.shade100)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Upload prescription to proceed',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange.shade800,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      minimumSize: Size.zero,
                      backgroundColor: Colors.orange.shade100,
                    ),
                    child: Text(
                      'Upload',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange.shade800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPriceBreakdown() {
    final subtotal = _cartItems.fold(0.0, (sum, item) {
      final price = item.discountPercentage != null
          ? item.price * (1 - item.discountPercentage! / 100)
          : item.price;
      return sum + (price * item.quantity);
    });

    final discount = _cartItems.fold(0.0, (sum, item) {
      if (item.discountPercentage != null) {
        return sum +
            (item.price * item.quantity * item.discountPercentage! / 100);
      }
      return sum;
    });

    final gst = subtotal * 0.12; // Assuming 12% GST
    final deliveryCharges = subtotal >= 500 ? 0.0 : 40.0;
    final total = subtotal + gst + deliveryCharges - discount;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Price Breakdown',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Icon(Icons.info_outline, size: 18, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 16),

          _buildPriceRow('Subtotal', '₹${subtotal.toStringAsFixed(2)}'),
          if (discount > 0)
            _buildPriceRow(
              'Discount',
              '-₹${discount.toStringAsFixed(2)}',
              isDiscount: true,
            ),
          _buildPriceRow('GST (12%)', '₹${gst.toStringAsFixed(2)}'),
          _buildPriceRow(
            'Delivery Charges',
            deliveryCharges == 0
                ? 'Free'
                : '₹${deliveryCharges.toStringAsFixed(2)}',
            isFree: deliveryCharges == 0,
          ),

          const Divider(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Amount',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '₹${total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),

          if (subtotal < 500)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.local_shipping,
                      size: 16,
                      color: Colors.blue.shade700,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Add ₹${(500 - subtotal).toStringAsFixed(2)} more for free delivery',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(
    String label,
    String value, {
    bool isDiscount = false,
    bool isFree = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: isDiscount ? Colors.green : Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isFree
                  ? Colors.green
                  : (isDiscount ? Colors.green : Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliverySlot() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.access_time, color: Colors.green, size: 20),
              SizedBox(width: 8),
              Text(
                'Delivery Slot',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildSlotChip('Today', '6:00 - 8:00 PM', true),
                _buildSlotChip('Tomorrow', '9:00 - 11:00 AM', false),
                _buildSlotChip('Tomorrow', '2:00 - 4:00 PM', false),
                _buildSlotChip('Wed, 18 Feb', '10:00 - 12:00 PM', false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlotChip(String day, String time, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              day,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            Text(time, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
          ],
        ),
        selected: isSelected,
        onSelected: (selected) {},
        backgroundColor: Colors.grey[100],
        selectedColor: Colors.green.withOpacity(0.1),
        checkmarkColor: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: isSelected ? Colors.green : Colors.grey.shade300,
          ),
        ),
      ),
    );
  }

  Widget _buildPrescriptionReminder() {
    final hasPrescriptionItems = _cartItems.any(
      (item) => item.requiresPrescription,
    );

    if (!hasPrescriptionItems) return const SizedBox();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.orange.shade700, size: 20),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Prescription required for medicines. Please upload before checkout.',
              style: TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutBar() {
    final canCheckout = _selectedAddress != null && _selectedSlot != null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '₹${_calculateTotal().toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 3,
              child: ElevatedButton(
                onPressed: canCheckout ? () {} : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey.shade300,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Proceed to Checkout',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shopping_cart_outlined,
                size: 60,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Your cart is empty',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Browse medicines and healthcare equipment',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Browse Products'),
            ),
          ],
        ),
      ),
    );
  }

  double _calculateTotal() {
    final subtotal = _cartItems.fold(0.0, (sum, item) {
      final price = item.discountPercentage != null
          ? item.price * (1 - item.discountPercentage! / 100)
          : item.price;
      return sum + (price * item.quantity);
    });

    final discount = _cartItems.fold(0.0, (sum, item) {
      if (item.discountPercentage != null) {
        return sum +
            (item.price * item.quantity * item.discountPercentage! / 100);
      }
      return sum;
    });

    final gst = subtotal * 0.12;
    final deliveryCharges = subtotal >= 500 ? 0.0 : 40.0;

    return subtotal + gst + deliveryCharges - discount;
  }

  void _showCartOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.share, color: Colors.blue),
              ),
              title: const Text('Share Cart'),
              onTap: () {
                Navigator.pop(ctx);
                _showSnackBar('Share feature coming soon!');
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.save, color: Colors.orange),
              ),
              title: const Text('Save for Later'),
              onTap: () {
                Navigator.pop(ctx);
                _showSnackBar('Saved for later');
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.delete, color: Colors.red),
              ),
              title: const Text(
                'Clear Cart',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(ctx);
                _showClearCartDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showClearCartDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear Cart'),
        content: const Text(
          'Are you sure you want to remove all items from your cart?',
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _cartItems.clear();
              });
              _showSnackBar('Cart cleared');
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

class Address {
  final String name;
  final String fullAddress;

  Address({required this.name, required this.fullAddress});
}

class DeliverySlot {
  final String day;
  final String time;

  DeliverySlot({required this.day, required this.time});
}

class Coupon {
  final String code;
  final double discount;

  Coupon({required this.code, required this.discount});
}
