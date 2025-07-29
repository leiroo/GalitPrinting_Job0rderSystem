import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'sidebar.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredInventory = [];
  
  // Controllers for Add/Edit Item dialog
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();
  final TextEditingController _reorderLevelController = TextEditingController();
  final TextEditingController _unitCostController = TextEditingController();
  final TextEditingController _leadTimeController = TextEditingController();
  final TextEditingController _stockAdjustmentController = TextEditingController();

  final List<Map<String, dynamic>> _allInventory = [
    {
      'id': 11,
      'name': 'Mugs',
      'description': 'Coffee Wedding...',
      'stock': 100.0,
      'unit': '100',
      'reorderLevel': 80.0,
      'unitCost': 150.00,
      'leadTime': 10,
      'status': 'Adequate',
    },
    {
      'id': 10,
      'name': 'Trophy Base (Marble)',
      'description': 'Marble base for trophy construction...',
      'stock': 3.0,
      'unit': 'pieces',
      'reorderLevel': 10.0,
      'unitCost': 150.00,
      'leadTime': 14,
      'status': 'Low Stock',
    },
    {
      'id': 9,
      'name': 'LED Module (5050)',
      'description': 'LED modules for signage lighting...',
      'stock': 50.0,
      'unit': 'pieces',
      'reorderLevel': 20.0,
      'unitCost': 25.00,
      'leadTime': 21,
      'status': 'Adequate',
    },
    {
      'id': 8,
      'name': 'DTF Transfer Film',
      'description': 'Direct-to-film transfer material...',
      'stock': 12.0,
      'unit': 'meters',
      'reorderLevel': 20.0,
      'unitCost': 95.00,
      'leadTime': 14,
      'status': 'Low Stock',
    },
    {
      'id': 7,
      'name': 'Vinyl Sticker Material',
      'description': 'Adhesive vinyl for stickers and decals...',
      'stock': 8.0,
      'unit': 'meters',
      'reorderLevel': 15.0,
      'unitCost': 75.00,
      'leadTime': 5,
      'status': 'Low Stock',
    },
    {
      'id': 6,
      'name': 'Sublimation Paper',
      'description': 'Transfer paper for sublimation printing...',
      'stock': 200.0,
      'unit': 'sheets',
      'reorderLevel': 50.0,
      'unitCost': 12.00,
      'leadTime': 7,
      'status': 'Adequate',
    },
    {
      'id': 5,
      'name': 'Cotton T-Shirt (White)',
      'description': 'Plain white cotton t-shirt for sublimation...',
      'stock': 100.0,
      'unit': 'pieces',
      'reorderLevel': 30.0,
      'unitCost': 85.00,
      'leadTime': 10,
      'status': 'Adequate',
    },
    {
      'id': 4,
      'name': 'Sintra Board (3mm)',
      'description': 'PVC foam board for signage...',
      'stock': 25.0,
      'unit': 'sheets',
      'reorderLevel': 10.0,
      'unitCost': 125.00,
      'leadTime': 5,
      'status': 'Adequate',
    },
  ];

  @override
  void initState() {
    super.initState();
    _filteredInventory = List.from(_allInventory);
    _searchController.addListener(_filterInventory);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _stockController.dispose();
    _unitController.dispose();
    _reorderLevelController.dispose();
    _unitCostController.dispose();
    _leadTimeController.dispose();
    _stockAdjustmentController.dispose();
    super.dispose();
  }

  void _filterInventory() {
    setState(() {
      final searchQuery = _searchController.text.toLowerCase();
      _filteredInventory = _allInventory.where((item) {
        return item['name'].toLowerCase().contains(searchQuery) ||
               item['description'].toLowerCase().contains(searchQuery);
      }).toList();
    });
  }

  void _clearControllers() {
    _nameController.clear();
    _descriptionController.clear();
    _stockController.clear();
    _unitController.clear();
    _reorderLevelController.clear();
    _unitCostController.clear();
    _leadTimeController.clear();
    _stockAdjustmentController.clear();
  }

  void _showAddItemDialog() {
    _clearControllers();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Item'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Item Name'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 2,
              ),
              TextField(
                controller: _stockController,
                decoration: const InputDecoration(labelText: 'Current Stock'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _unitController,
                decoration: const InputDecoration(labelText: 'Unit (pieces, meters, etc.)'),
              ),
              TextField(
                controller: _reorderLevelController,
                decoration: const InputDecoration(labelText: 'Reorder Level'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _unitCostController,
                decoration: const InputDecoration(labelText: 'Unit Cost (₱)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _leadTimeController,
                decoration: const InputDecoration(labelText: 'Lead Time (days)'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_nameController.text.isNotEmpty) {
                final newItem = {
                  'id': _allInventory.length + 1,
                  'name': _nameController.text,
                  'description': _descriptionController.text,
                  'stock': double.tryParse(_stockController.text) ?? 0.0,
                  'unit': _unitController.text,
                  'reorderLevel': double.tryParse(_reorderLevelController.text) ?? 0.0,
                  'unitCost': double.tryParse(_unitCostController.text) ?? 0.0,
                  'leadTime': int.tryParse(_leadTimeController.text) ?? 0,
                  'status': 'Adequate',
                };
                
                setState(() {
                  _allInventory.add(newItem);
                  _filterInventory();
                });
                Navigator.pop(context);
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${_nameController.text} added successfully!')),
                );
              }
            },
            child: const Text('Add Item'),
          ),
        ],
      ),
    );
  }

  void _showEditItemDialog(Map<String, dynamic> item) {
    _nameController.text = item['name'];
    _descriptionController.text = item['description'];
    _stockController.text = item['stock'].toString();
    _unitController.text = item['unit'];
    _reorderLevelController.text = item['reorderLevel'].toString();
    _unitCostController.text = item['unitCost'].toString();
    _leadTimeController.text = item['leadTime'].toString();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit ${item['name']}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Item Name'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 2,
              ),
              TextField(
                controller: _stockController,
                decoration: const InputDecoration(labelText: 'Current Stock'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _unitController,
                decoration: const InputDecoration(labelText: 'Unit'),
              ),
              TextField(
                controller: _reorderLevelController,
                decoration: const InputDecoration(labelText: 'Reorder Level'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _unitCostController,
                decoration: const InputDecoration(labelText: 'Unit Cost (₱)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _leadTimeController,
                decoration: const InputDecoration(labelText: 'Lead Time (days)'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_nameController.text.isNotEmpty) {
                final index = _allInventory.indexWhere((i) => i['id'] == item['id']);
                if (index != -1) {
                  setState(() {
                    _allInventory[index] = {
                      ...item,
                      'name': _nameController.text,
                      'description': _descriptionController.text,
                      'stock': double.tryParse(_stockController.text) ?? item['stock'],
                      'unit': _unitController.text,
                      'reorderLevel': double.tryParse(_reorderLevelController.text) ?? item['reorderLevel'],
                      'unitCost': double.tryParse(_unitCostController.text) ?? item['unitCost'],
                      'leadTime': int.tryParse(_leadTimeController.text) ?? item['leadTime'],
                    };
                    _filterInventory();
                  });
                  Navigator.pop(context);
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${_nameController.text} updated successfully!')),
                  );
                }
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showStockAdjustmentDialog(Map<String, dynamic> item) {
    _stockAdjustmentController.clear();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Adjust Stock for ${item['name']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Current Stock: ${item['stock']} ${item['unit']}'),
            const SizedBox(height: 16),
            TextField(
              controller: _stockAdjustmentController,
              decoration: const InputDecoration(
                labelText: 'Adjustment (+/-)',
                hintText: 'e.g., +10 or -5',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final adjustment = double.tryParse(_stockAdjustmentController.text);
              if (adjustment != null) {
                final newStock = item['stock'] + adjustment;
                if (newStock >= 0) {
                  final index = _allInventory.indexWhere((i) => i['id'] == item['id']);
                  if (index != -1) {
                    setState(() {
                      _allInventory[index]['stock'] = newStock;
                      _allInventory[index]['status'] = newStock <= _allInventory[index]['reorderLevel'] 
                          ? 'Low Stock' 
                          : 'Adequate';
                      _filterInventory();
                    });
                    Navigator.pop(context);
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Stock updated to ${newStock.toStringAsFixed(1)} ${item['unit']}')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Stock cannot be negative!')),
                  );
                }
              }
            },
            child: const Text('Update Stock'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: Text('Are you sure you want to delete "${item['name']}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _allInventory.removeWhere((i) => i['id'] == item['id']);
                _filterInventory();
              });
              Navigator.pop(context);
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${item['name']} deleted successfully!')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        leading: isMobile
            ? Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              )
            : null,
        title: const Text('Inventory'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: ProfileMenu(),
          ),
        ],
        iconTheme: Theme.of(context).appBarTheme.iconTheme,
        titleTextStyle: Theme.of(context).appBarTheme.titleTextStyle,
      ),
      drawer: isMobile ? const Drawer(child: Sidebar()) : null,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMobile) const Sidebar(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 32, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  if (isMobile) ...[
                    // Mobile Layout
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Inventory Management',
                          style: TextStyle(
                            fontWeight: FontWeight.bold, 
                            fontSize: 24,
                            color: Theme.of(context).textTheme.titleLarge?.color ?? (isDark ? Colors.white : Colors.black87),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Track and manage your printing materials, supplies, and equipment inventory',
                          style: TextStyle(
                            color: isDark ? Colors.grey[400] : Colors.grey, 
                            fontSize: 14
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _showAddItemDialog,
                            icon: const Icon(Icons.add),
                            label: const Text('Add Item'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2563EB),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    // Desktop Layout
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Inventory Management',
                          style: TextStyle(
                            fontWeight: FontWeight.bold, 
                            fontSize: 28,
                            color: Theme.of(context).textTheme.titleLarge?.color ?? (isDark ? Colors.white : Colors.black87),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Track and manage your printing materials, supplies, and equipment inventory',
                          style: TextStyle(
                            color: isDark ? Colors.grey[400] : Colors.grey, 
                            fontSize: 16
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton.icon(
                              onPressed: _showAddItemDialog,
                              icon: const Icon(Icons.add),
                              label: const Text('Add Item'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2563EB),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 24),
                  
                  // Search Section
                  if (isMobile) ...[
                    // Mobile Layout
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Search Inventory', 
                          style: TextStyle(
                            fontSize: 16, 
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).textTheme.titleMedium?.color ?? (isDark ? Colors.white : Colors.black87),
                          )
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _searchController,
                          onChanged: (value) => _filterInventory(),
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge?.color ?? (isDark ? Colors.white : Colors.black87),
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search by item name or description...',
                            hintStyle: TextStyle(
                              color: isDark ? Colors.grey[400] : Colors.grey[600],
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: isDark ? Colors.grey[400] : Colors.grey[600],
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: isDark ? Colors.blue[400]! : Colors.blue[600]!,
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: isDark ? Colors.grey[800] : Colors.grey[50],
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    // Desktop Layout
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Search: ', 
                          style: TextStyle(
                            fontSize: 14, 
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).textTheme.titleMedium?.color ?? (isDark ? Colors.white : Colors.black87),
                          )
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 300,
                          child: TextField(
                            controller: _searchController,
                            onChanged: (value) => _filterInventory(),
                            style: TextStyle(
                              color: Theme.of(context).textTheme.bodyLarge?.color ?? (isDark ? Colors.white : Colors.black87),
                            ),
                            decoration: InputDecoration(
                              hintText: 'Search by item name or description...',
                              hintStyle: TextStyle(
                                color: isDark ? Colors.grey[400] : Colors.grey[600],
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                color: isDark ? Colors.grey[400] : Colors.grey[600],
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: isDark ? Colors.blue[400]! : Colors.blue[600]!,
                                  width: 2,
                                ),
                              ),
                              filled: true,
                              fillColor: isDark ? Colors.grey[800] : Colors.grey[50],
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 16),
                  
                  // Inventory Table - Updated for full width
                  Card(
                    elevation: 0,
                    color: Theme.of(context).cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: isDark ? Colors.grey[800]! : const Color(0xFFE5E7EB), 
                        width: 1
                      ),
                    ),
                    child: Container(
                      width: double.infinity, // Force the container to take full width
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          dataTableTheme: DataTableThemeData(
                            columnSpacing: isMobile ? 8 : 24, // Increased column spacing for desktop
                            dataRowMinHeight: isMobile ? 60 : 52,
                            dataRowMaxHeight: isMobile ? 80 : 72,
                            headingRowHeight: isMobile ? 48 : 56,
                            horizontalMargin: 16,
                          ),
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: MediaQuery.of(context).size.width - (isMobile ? 32 : 320), // Adjust based on sidebar width
                            ),
                            child: DataTable(
                              columns: [
                                DataColumn(
                                  label: SizedBox(
                                    width: 40,
                                    child: Text('ID', style: TextStyle(fontSize: isMobile ? 12 : 14, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                DataColumn(
                                  label: SizedBox(
                                    width: isMobile ? 120 : 200, // Increased width for Item Name
                                    child: Text('Item Name', style: TextStyle(fontSize: isMobile ? 12 : 14, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                DataColumn(
                                  label: SizedBox(
                                    width: 80,
                                    child: Text('Stock', style: TextStyle(fontSize: isMobile ? 12 : 14, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                DataColumn(
                                  label: SizedBox(
                                    width: 80,
                                    child: Text('Unit', style: TextStyle(fontSize: isMobile ? 12 : 14, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                if (!isMobile) ...[
                                  DataColumn(
                                    label: SizedBox(
                                      width: 100,
                                      child: Text('Reorder Level', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                  DataColumn(
                                    label: SizedBox(
                                      width: 100,
                                      child: Text('Unit Cost', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                  DataColumn(
                                    label: SizedBox(
                                      width: 100,
                                      child: Text('Lead Time', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                ],
                                DataColumn(
                                  label: SizedBox(
                                    width: 100,
                                    child: Text('Status', style: TextStyle(fontSize: isMobile ? 12 : 14, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                DataColumn(
                                  label: SizedBox(
                                    width: isMobile ? 120 : 140, // Increased width for Actions
                                    child: Text('Actions', style: TextStyle(fontSize: isMobile ? 12 : 14, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ],
                              rows: _filteredInventory.map((item) {
                                final isLowStock = item['status'] == 'Low Stock';
                                final stockColor = isLowStock ? Colors.red : Colors.black87;
                                
                                return DataRow(cells: [
                                  DataCell(
                                    SizedBox(
                                      width: 40,
                                      child: Text(
                                        item['id'].toString(),
                                        style: TextStyle(fontSize: isMobile ? 12 : 14),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    SizedBox(
                                      width: isMobile ? 120 : 200,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            item['name'],
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: isMobile ? 12 : 14,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          if (!isMobile) Text(
                                            item['description'],
                                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    SizedBox(
                                      width: 80,
                                      child: Row(
                                        children: [
                                          if (isLowStock) ...[
                                            const Icon(Icons.warning, color: Colors.orange, size: 16),
                                            const SizedBox(width: 4),
                                          ],
                                          Flexible(
                                            child: Text(
                                              item['stock'].toString(),
                                              style: TextStyle(
                                                color: isLowStock 
                                                    ? Colors.red 
                                                    : (Theme.of(context).textTheme.bodyLarge?.color ?? (isDark ? Colors.white : Colors.black87)),
                                                fontWeight: isLowStock ? FontWeight.bold : FontWeight.normal,
                                                fontSize: isMobile ? 12 : 14,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    SizedBox(
                                      width: 80,
                                      child: Text(
                                        item['unit'],
                                        style: TextStyle(fontSize: isMobile ? 12 : 14),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  if (!isMobile) ...[
                                    DataCell(
                                      SizedBox(
                                        width: 100,
                                        child: Text(
                                          item['reorderLevel'].toString(),
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      SizedBox(
                                        width: 100,
                                        child: Text(
                                          '₱${item['unitCost'].toStringAsFixed(2)}',
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      SizedBox(
                                        width: 100,
                                        child: Text(
                                          '${item['leadTime']} days',
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ),
                                    ),
                                  ],
                                  DataCell(
                                    SizedBox(
                                      width: 100,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: isLowStock ? Colors.red.withOpacity(0.1) : Colors.green.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          item['status'],
                                          style: TextStyle(
                                            color: isLowStock ? Colors.red : Colors.green,
                                            fontWeight: FontWeight.w500,
                                            fontSize: isMobile ? 10 : 12,
                                          ),
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    SizedBox(
                                      width: isMobile ? 120 : 140,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (isMobile) ...[
                                            PopupMenuButton<String>(
                                              onSelected: (value) {
                                                switch (value) {
                                                  case 'edit':
                                                    _showEditItemDialog(item);
                                                    break;
                                                  case 'adjust':
                                                    _showStockAdjustmentDialog(item);
                                                    break;
                                                  case 'delete':
                                                    _showDeleteConfirmation(item);
                                                    break;
                                                }
                                              },
                                              itemBuilder: (context) => [
                                                const PopupMenuItem(
                                                  value: 'edit',
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.edit, size: 16),
                                                      SizedBox(width: 8),
                                                      Text('Edit'),
                                                    ],
                                                  ),
                                                ),
                                                const PopupMenuItem(
                                                  value: 'adjust',
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.inventory, size: 16),
                                                      SizedBox(width: 8),
                                                      Text('Adjust Stock'),
                                                    ],
                                                  ),
                                                ),
                                                const PopupMenuItem(
                                                  value: 'delete',
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.delete, size: 16, color: Colors.red),
                                                      SizedBox(width: 8),
                                                      Text('Delete', style: TextStyle(color: Colors.red)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                              child: const Icon(Icons.more_vert, size: 18),
                                            ),
                                          ] else ...[
                                            IconButton(
                                              onPressed: () => _showEditItemDialog(item),
                                              icon: const Icon(Icons.edit, size: 18),
                                              padding: const EdgeInsets.all(4),
                                              constraints: const BoxConstraints(),
                                              tooltip: 'Edit Item',
                                            ),
                                            IconButton(
                                              onPressed: () => _showStockAdjustmentDialog(item),
                                              icon: const Icon(Icons.inventory, size: 18),
                                              padding: const EdgeInsets.all(4),
                                              constraints: const BoxConstraints(),
                                              tooltip: 'Adjust Stock',
                                            ),
                                            IconButton(
                                              onPressed: () => _showDeleteConfirmation(item),
                                              icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                                              padding: const EdgeInsets.all(4),
                                              constraints: const BoxConstraints(),
                                              tooltip: 'Delete Item',
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ),
                                ]);
                              }).toList(),
                            ),
                          ),
                        ),
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
}