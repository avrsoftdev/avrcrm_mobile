import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _search = '';
  String _selectedCategory = 'All';
  String _selectedStockStatus = 'All';

  Future<void> _deleteProduct(String id) async {
    await _firestore.collection('inventory').doc(id).delete();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product deleted successfully')),
      );
    }
  }

  void _openProductForm({DocumentSnapshot? product}) {
    showDialog(
      context: context,
      builder: (_) => ProductFormDialog(product: product),
    );
  }

  Color _stockColor(String status, ColorScheme scheme) {
    switch (status) {
      case 'In Stock':
        return Colors.green;
      case 'Low Stock':
        return Colors.orange;
      case 'Out of Stock':
        return Colors.red;
      default:
        return scheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? scheme.surface
          : const Color(0xFFF5F8FC),
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 24,
        title: const Row(
          children: [
            Icon(Icons.inventory_2_rounded),
            SizedBox(width: 10),
            Text(
              'Inventory',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: () => setState(() {}),
            icon: const Icon(Icons.refresh_rounded),
          ),
          const SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: FilledButton.icon(
              onPressed: () => _openProductForm(),
              icon: const Icon(Icons.add),
              label: const Text('Add Product'),
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('inventory')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Unable to load inventory.\n${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final docs = snapshot.data?.docs ?? [];

          final products = docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;

            final name =
                (data['productName'] ?? '').toString().toLowerCase();
            final sku = (data['sku'] ?? '').toString().toLowerCase();
            final category =
                (data['category'] ?? '').toString();

            final stock = _calculateStockStatus(data);

            final matchesSearch =
                name.contains(_search.toLowerCase()) ||
                sku.contains(_search.toLowerCase());

            final matchesCategory =
                _selectedCategory == 'All' ||
                    category == _selectedCategory;

            final matchesStock =
                _selectedStockStatus == 'All' ||
                    stock == _selectedStockStatus;

            return matchesSearch &&
                matchesCategory &&
                matchesStock;
          }).toList();

          final totalProducts = docs.length;

          int totalQuantity = 0;
          int lowStock = 0;
          int outOfStock = 0;

          for (final doc in docs) {
            final data = doc.data() as Map<String, dynamic>;
            final quantity =
                (data['quantity'] ?? 0) is num
                    ? (data['quantity'] ?? 0) as num
                    : 0;

            totalQuantity += quantity.toInt();

            final status = _calculateStockStatus(data);

            if (status == 'Low Stock') lowStock++;
            if (status == 'Out of Stock') outOfStock++;
          }

          final categories = <String>{
            'All',
            ...docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return (data['category'] ?? 'Other').toString();
            }),
          };

          return Column(
            children: [
              // ==============================
              // SUMMARY CARDS
              // ==============================
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final cardWidth =
                        (constraints.maxWidth - 36) / 4;

                    return Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _SummaryCard(
                          width: cardWidth,
                          title: 'Total Products',
                          value: '$totalProducts',
                          icon: Icons.inventory_2_rounded,
                          color: scheme.primary,
                        ),
                        _SummaryCard(
                          width: cardWidth,
                          title: 'Total Quantity',
                          value: '$totalQuantity',
                          icon: Icons.warehouse_rounded,
                          color: Colors.blue,
                        ),
                        _SummaryCard(
                          width: cardWidth,
                          title: 'Low Stock',
                          value: '$lowStock',
                          icon: Icons.warning_amber_rounded,
                          color: Colors.orange,
                        ),
                        _SummaryCard(
                          width: cardWidth,
                          title: 'Out of Stock',
                          value: '$outOfStock',
                          icon: Icons.remove_shopping_cart_rounded,
                          color: Colors.red,
                        ),
                      ],
                    );
                  },
                ),
              ),

              // ==============================
              // SEARCH / FILTERS
              // ==============================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Card(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        SizedBox(
                          width: 350,
                          child: TextField(
                            onChanged: (value) {
                              setState(() => _search = value);
                            },
                            decoration: InputDecoration(
                              hintText:
                                  'Search product or SKU...',
                              prefixIcon:
                                  const Icon(Icons.search_rounded),
                              filled: true,
                              fillColor: isDark
                                  ? scheme.surfaceContainerHighest
                                  : const Color(0xFFF7F9FC),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),

                        DropdownButtonFormField<String>(
                          initialValue: _selectedCategory,
                          decoration: const InputDecoration(
                            labelText: 'Category',
                            border: OutlineInputBorder(),
                          ),
                          items: categories
                              .map(
                                (category) =>
                                    DropdownMenuItem(
                                  value: category,
                                  child: Text(category),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value == null) return;
                            setState(() {
                              _selectedCategory = value;
                            });
                          },
                        ),

                        DropdownButtonFormField<String>(
                          initialValue: _selectedStockStatus,
                          decoration: const InputDecoration(
                            labelText: 'Stock Status',
                            border: OutlineInputBorder(),
                          ),
                          items: const [
                            'All',
                            'In Stock',
                            'Low Stock',
                            'Out of Stock',
                          ]
                              .map(
                                (status) =>
                                    DropdownMenuItem(
                                  value: status,
                                  child: Text(status),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value == null) return;
                            setState(() {
                              _selectedStockStatus = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // ==============================
              // PRODUCT LIST
              // ==============================
              Expanded(
                child: products.isEmpty
                    ? _EmptyInventory(
                        onAdd: () => _openProductForm(),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(
                          24,
                          8,
                          24,
                          30,
                        ),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final doc = products[index];
                          final data =
                              doc.data() as Map<String, dynamic>;

                          final status =
                              _calculateStockStatus(data);

                          final stockColor =
                              _stockColor(status, scheme);

                          return Card(
                            elevation: 0,
                            margin:
                                const EdgeInsets.only(bottom: 10),
                            child: InkWell(
                              borderRadius:
                                  BorderRadius.circular(16),
                              onTap: () =>
                                  _openProductForm(product: doc),
                              child: Padding(
                                padding:
                                    const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 52,
                                      width: 52,
                                      decoration: BoxDecoration(
                                        color: scheme.primary
                                            .withValues(alpha: 0.10),
                                        borderRadius:
                                            BorderRadius.circular(
                                          14,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.inventory_2_rounded,
                                        color: scheme.primary,
                                      ),
                                    ),

                                    const SizedBox(width: 16),

                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data['productName'] ??
                                                'Unnamed Product',
                                            style:
                                                const TextStyle(
                                              fontSize: 16,
                                              fontWeight:
                                                  FontWeight.w700,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            'SKU: ${data['sku'] ?? '-'}',
                                            style:
                                                TextStyle(
                                              color: theme
                                                  .textTheme
                                                  .bodySmall
                                                  ?.color,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Expanded(
                                      flex: 2,
                                      child: _InfoColumn(
                                        title: 'Category',
                                        value:
                                            data['category'] ??
                                                '-',
                                      ),
                                    ),

                                    Expanded(
                                      flex: 2,
                                      child: _InfoColumn(
                                        title: 'Stock',
                                        value:
                                            '${data['quantity'] ?? 0} ${data['unit'] ?? ''}',
                                      ),
                                    ),

                                    Expanded(
                                      flex: 2,
                                      child: _InfoColumn(
                                        title: 'Selling Price',
                                        value:
                                            '₹${data['sellingPrice'] ?? '0'}',
                                      ),
                                    ),

                                    Container(
                                      padding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: stockColor
                                            .withValues(alpha: 0.10),
                                        borderRadius:
                                            BorderRadius.circular(
                                          20,
                                        ),
                                      ),
                                      child: Text(
                                        status,
                                        style: TextStyle(
                                          color: stockColor,
                                          fontWeight:
                                              FontWeight.w700,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),

                                    PopupMenuButton<String>(
                                      onSelected: (value) {
                                        if (value == 'edit') {
                                          _openProductForm(
                                            product: doc,
                                          );
                                        }

                                        if (value == 'delete') {
                                          _deleteProduct(doc.id);
                                        }
                                      },
                                      itemBuilder: (_) => const [
                                        PopupMenuItem(
                                          value: 'edit',
                                          child: ListTile(
                                            leading:
                                                Icon(Icons.edit),
                                            title: Text('Edit'),
                                          ),
                                        ),
                                        PopupMenuItem(
                                          value: 'delete',
                                          child: ListTile(
                                            leading: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            title: Text('Delete'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _calculateStockStatus(Map<String, dynamic> data) {
    final quantity = data['quantity'] is num
        ? (data['quantity'] as num).toDouble()
        : double.tryParse(
              '${data['quantity'] ?? 0}',
            ) ??
            0;

    final reorderLevel = data['reorderLevel'] is num
        ? (data['reorderLevel'] as num).toDouble()
        : double.tryParse(
              '${data['reorderLevel'] ?? 0}',
            ) ??
            0;

    if (quantity <= 0) {
      return 'Out of Stock';
    }

    if (reorderLevel > 0 && quantity <= reorderLevel) {
      return 'Low Stock';
    }

    return 'In Stock';
  }
}

// ==========================================================
// SUMMARY CARD
// ==========================================================

class _SummaryCard extends StatelessWidget {
  final double width;
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.width,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width < 200 ? 180 : width,
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================================
// INFO COLUMN
// ==========================================================

class _InfoColumn extends StatelessWidget {
  final String title;
  final String value;

  const _InfoColumn({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .bodySmall,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================================
// EMPTY STATE
// ==========================================================

class _EmptyInventory extends StatelessWidget {
  final VoidCallback onAdd;

  const _EmptyInventory({
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 70,
            color: Theme.of(context)
                .colorScheme
                .primary,
          ),
          const SizedBox(height: 16),
          const Text(
            'No inventory items found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add your first product to start managing inventory.',
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: const Text('Add Product'),
          ),
        ],
      ),
    );
  }
}

// ==========================================================
// PRODUCT FORM
// ==========================================================

class ProductFormDialog extends StatefulWidget {
  final DocumentSnapshot? product;

  const ProductFormDialog({
    super.key,
    this.product,
  });

  @override
  State<ProductFormDialog> createState() =>
      _ProductFormDialogState();
}

class _ProductFormDialogState
    extends State<ProductFormDialog> {
  final _formKey = GlobalKey<FormState>();

  final _productName = TextEditingController();
  final _sku = TextEditingController();
  final _barcode = TextEditingController();
  final _description = TextEditingController();
  final _category = TextEditingController();
  final _brand = TextEditingController();
  final _hsn = TextEditingController();

  final _quantity = TextEditingController();
  final _unit = TextEditingController(text: 'Nos');
  final _reorderLevel = TextEditingController();

  final _purchasePrice = TextEditingController();
  final _sellingPrice = TextEditingController();
  final _mrp = TextEditingController();

  final _gst = TextEditingController(text: '18');

  final _warehouse = TextEditingController();
  final _rack = TextEditingController();
  final _bin = TextEditingController();

  final _supplier = TextEditingController();

  @override
  void initState() {
    super.initState();

    final data =
        widget.product?.data() as Map<String, dynamic>?;

    if (data != null) {
      _productName.text =
          data['productName']?.toString() ?? '';
      _sku.text = data['sku']?.toString() ?? '';
      _barcode.text =
          data['barcode']?.toString() ?? '';
      _description.text =
          data['description']?.toString() ?? '';
      _category.text =
          data['category']?.toString() ?? '';
      _brand.text =
          data['brand']?.toString() ?? '';
      _hsn.text =
          data['hsn']?.toString() ?? '';

      _quantity.text =
          data['quantity']?.toString() ?? '0';
      _unit.text =
          data['unit']?.toString() ?? 'Nos';
      _reorderLevel.text =
          data['reorderLevel']?.toString() ?? '0';

      _purchasePrice.text =
          data['purchasePrice']?.toString() ?? '';
      _sellingPrice.text =
          data['sellingPrice']?.toString() ?? '';
      _mrp.text =
          data['mrp']?.toString() ?? '';

      _gst.text =
          data['gst']?.toString() ?? '18';

      _warehouse.text =
          data['warehouse']?.toString() ?? '';
      _rack.text =
          data['rack']?.toString() ?? '';
      _bin.text =
          data['bin']?.toString() ?? '';

      _supplier.text =
          data['supplier']?.toString() ?? '';
    }
  }

  @override
  void dispose() {
    for (final controller in [
      _productName,
      _sku,
      _barcode,
      _description,
      _category,
      _brand,
      _hsn,
      _quantity,
      _unit,
      _reorderLevel,
      _purchasePrice,
      _sellingPrice,
      _mrp,
      _gst,
      _warehouse,
      _rack,
      _bin,
      _supplier,
    ]) {
      controller.dispose();
    }

    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final firestore =
        FirebaseFirestore.instance;

    final data = {
      'productName': _productName.text.trim(),
      'sku': _sku.text.trim(),
      'barcode': _barcode.text.trim(),
      'description': _description.text.trim(),
      'category': _category.text.trim(),
      'brand': _brand.text.trim(),
      'hsn': _hsn.text.trim(),

      'quantity':
          double.tryParse(_quantity.text) ?? 0,
      'unit': _unit.text.trim(),
      'reorderLevel':
          double.tryParse(_reorderLevel.text) ?? 0,

      'purchasePrice':
          double.tryParse(_purchasePrice.text) ?? 0,
      'sellingPrice':
          double.tryParse(_sellingPrice.text) ?? 0,
      'mrp':
          double.tryParse(_mrp.text) ?? 0,

      'gst':
          double.tryParse(_gst.text) ?? 0,

      'warehouse': _warehouse.text.trim(),
      'rack': _rack.text.trim(),
      'bin': _bin.text.trim(),

      'supplier': _supplier.text.trim(),

      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (widget.product == null) {
      data['createdAt'] =
          FieldValue.serverTimestamp();

      await firestore
          .collection('inventory')
          .add(data);
    } else {
      await firestore
          .collection('inventory')
          .doc(widget.product!.id)
          .update(data);
    }

    if (mounted) {
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.product == null
                ? 'Product added successfully'
                : 'Product updated successfully',
          ),
        ),
      );
    }
  }

  InputDecoration _decoration(
    String label, {
    IconData? icon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon:
          icon == null ? null : Icon(icon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.product != null;

    return Dialog(
      insetPadding:
          const EdgeInsets.all(24),
      child: SizedBox(
        width: 900,
        height: 720,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                24,
                20,
                16,
                12,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.inventory_2_rounded,
                    color: Theme.of(context)
                        .colorScheme
                        .primary,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    isEditing
                        ? 'Edit Product'
                        : 'Add Product',
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () =>
                        Navigator.pop(context),
                    icon:
                        const Icon(Icons.close),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      _sectionTitle(
                        context,
                        'Basic Product Information',
                        Icons.inventory_2_outlined,
                      ),

                      const SizedBox(height: 14),

                      _grid([
                        TextFormField(
                          controller:
                              _productName,
                          decoration: _decoration(
                            'Product Name *',
                            icon: Icons
                                .inventory_2_outlined,
                          ),
                          validator: (value) =>
                              value == null ||
                                      value.trim().isEmpty
                                  ? 'Required'
                                  : null,
                        ),
                        TextFormField(
                          controller: _sku,
                          decoration: _decoration(
                            'SKU / Product Code *',
                            icon:
                                Icons.qr_code_2,
                          ),
                          validator: (value) =>
                              value == null ||
                                      value.trim().isEmpty
                                  ? 'Required'
                                  : null,
                        ),
                        TextFormField(
                          controller: _barcode,
                          decoration: _decoration(
                            'Barcode',
                            icon: Icons
                                .qr_code_scanner,
                          ),
                        ),
                        TextFormField(
                          controller: _brand,
                          decoration:
                              _decoration('Brand'),
                        ),
                        TextFormField(
                          controller: _category,
                          decoration:
                              _decoration('Category'),
                        ),
                        TextFormField(
                          controller: _hsn,
                          decoration: _decoration(
                            'HSN / SAC Code',
                          ),
                        ),
                      ]),

                      const SizedBox(height: 18),

                      TextFormField(
                        controller:
                            _description,
                        maxLines: 3,
                        decoration: _decoration(
                          'Product Description',
                        ),
                      ),

                      const SizedBox(height: 28),

                      _sectionTitle(
                        context,
                        'Stock & Warehouse',
                        Icons.warehouse_outlined,
                      ),

                      const SizedBox(height: 14),

                      _grid([
                        TextFormField(
                          controller: _quantity,
                          keyboardType:
                              TextInputType.number,
                          decoration: _decoration(
                            'Current Quantity',
                          ),
                        ),
                        TextFormField(
                          controller: _unit,
                          decoration:
                              _decoration('Unit'),
                        ),
                        TextFormField(
                          controller:
                              _reorderLevel,
                          keyboardType:
                              TextInputType.number,
                          decoration: _decoration(
                            'Reorder Level',
                          ),
                        ),
                        TextFormField(
                          controller:
                              _warehouse,
                          decoration: _decoration(
                            'Warehouse',
                          ),
                        ),
                        TextFormField(
                          controller: _rack,
                          decoration:
                              _decoration('Rack'),
                        ),
                        TextFormField(
                          controller: _bin,
                          decoration:
                              _decoration('Bin'),
                        ),
                      ]),

                      const SizedBox(height: 28),

                      _sectionTitle(
                        context,
                        'Pricing & Tax',
                        Icons.currency_rupee_rounded,
                      ),

                      const SizedBox(height: 14),

                      _grid([
                        TextFormField(
                          controller:
                              _purchasePrice,
                          keyboardType:
                              TextInputType.number,
                          decoration: _decoration(
                            'Purchase Price',
                          ),
                        ),
                        TextFormField(
                          controller:
                              _sellingPrice,
                          keyboardType:
                              TextInputType.number,
                          decoration: _decoration(
                            'Selling Price',
                          ),
                        ),
                        TextFormField(
                          controller: _mrp,
                          keyboardType:
                              TextInputType.number,
                          decoration:
                              _decoration('MRP'),
                        ),
                        TextFormField(
                          controller: _gst,
                          keyboardType:
                              TextInputType.number,
                          decoration: _decoration(
                            'GST %',
                          ),
                        ),
                      ]),

                      const SizedBox(height: 28),

                      _sectionTitle(
                        context,
                        'Supplier Information',
                        Icons.business_outlined,
                      ),

                      const SizedBox(height: 14),

                      TextFormField(
                        controller: _supplier,
                        decoration: _decoration(
                          'Supplier / Vendor',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const Divider(height: 1),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () =>
                        Navigator.pop(context),
                    child:
                        const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  FilledButton.icon(
                    onPressed: _save,
                    icon:
                        const Icon(Icons.save),
                    label:
                        Text(isEditing
                            ? 'Update Product'
                            : 'Save Product'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(
    BuildContext context,
    String title,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context)
              .colorScheme
              .primary,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Widget _grid(List<Widget> children) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width =
            constraints.maxWidth > 700
                ? (constraints.maxWidth - 16) / 2
                : constraints.maxWidth;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: children
              .map(
                (child) => SizedBox(
                  width: width,
                  child: child,
                ),
              )
              .toList(),
        );
      },
    );
  }
}