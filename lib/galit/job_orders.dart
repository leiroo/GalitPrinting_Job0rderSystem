import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'sidebar.dart';

class JobOrdersPage extends StatelessWidget {
  const JobOrdersPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final orders = AppData.orders.map((o) => {
      'id': o.id,
      'customer': o.customer,
      'service': o.service,
      'date': o.date.toLocal().toString().split(' ')[0],
      'status': o.status,
      'price': '₱${o.price.toStringAsFixed(0)}',
      'createdBy': o.createdBy,
    }).toList();
    
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
        title: const Text('Job Orders'),
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
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 6 : 32, vertical: 32),
              child: JobOrdersTable(orders: orders),
            ),
          ),
        ],
      ),
    );
  }
}

class JobOrdersTable extends StatefulWidget {
  final List<Map<String, dynamic>> orders;
  final void Function(String orderId)? onViewDetails;
  final void Function(String orderId)? onAccept;
  final void Function(String orderId)? onReject;
  
  const JobOrdersTable({
    super.key,
    required this.orders,
    this.onViewDetails,
    this.onAccept,
    this.onReject,
  });

  @override
  State<JobOrdersTable> createState() => _JobOrdersTableState();
}

class _JobOrdersTableState extends State<JobOrdersTable> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedStatus = 'All Orders';
  List<Map<String, dynamic>> _filteredOrders = [];

  @override
  void initState() {
    super.initState();
    _filteredOrders = List.from(widget.orders);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterOrders() {
    setState(() {
      _filteredOrders = widget.orders.where((order) {
        final searchTerm = _searchController.text.toLowerCase();
        final statusFilter = _selectedStatus == 'All Orders' || order['status'] == _selectedStatus;
        final searchFilter = searchTerm.isEmpty || 
                           order['id'].toLowerCase().contains(searchTerm) ||
                           order['service'].toLowerCase().contains(searchTerm);
        return statusFilter && searchFilter;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1200;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Calculate consistent margins for both cards
    final cardMargin = EdgeInsets.only(bottom: 24, left: isMobile ? 8 : 16, right: isMobile ? 8 : 16);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Page Title - removed extra padding
        Padding(
          padding: EdgeInsets.only(left: isMobile ? 8 : 16, bottom: 8),
          child: Text(
            'Job Orders',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: isMobile ? 24 : 32,
              color: Theme.of(context).textTheme.titleLarge?.color ?? (isDark ? Colors.white : Colors.black87),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: isMobile ? 8 : 16, bottom: 24),
          child: Text(
            'Manage and track all printing job orders with real-time status updates',
            style: TextStyle(
              color: isDark ? Colors.grey[400] : Colors.grey,
              fontSize: isMobile ? 14 : 16,
            ),
          ),
        ),
        
        // Order Management Header Card
        Card(
          color: Theme.of(context).cardColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isDark ? Colors.grey[800]! : const Color(0xFFE5E7EB), 
              width: 1
            ),
          ),
          margin: cardMargin,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 16.0 : 32.0, 
              vertical: isMobile ? 20.0 : 32.0
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order Management', 
                  style: TextStyle(
                    fontWeight: FontWeight.bold, 
                    fontSize: isMobile ? 18 : 24, 
                    color: Theme.of(context).textTheme.titleLarge?.color ?? (isDark ? Colors.white : Colors.black87),
                  )
                ),
                const SizedBox(height: 16),
                
                // Search and Filter Section
                if (isMobile) ...[
                  // Mobile Layout
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Search field
                      TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          _filterOrders();
                        },
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color ?? (isDark ? Colors.white : Colors.black87),
                        ),
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.search,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                          hintText: 'Search by order ID or service type',
                          hintStyle: TextStyle(
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                          filled: true,
                          fillColor: isDark ? Colors.grey[800] : const Color(0xFFF8FAFC),
                          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
                              color: isDark ? Colors.blue[400]! : const Color(0xFF2563EB),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Status filter dropdown
                      DropdownButtonFormField<String>(
                        value: _selectedStatus,
                        items: const [
                          DropdownMenuItem(value: 'All Orders', child: Text('All Orders')),
                          DropdownMenuItem(value: 'Completed', child: Text('Completed')),
                          DropdownMenuItem(value: 'In Progress', child: Text('In Progress')),
                          DropdownMenuItem(value: 'Pending', child: Text('Pending')),
                          DropdownMenuItem(value: 'Delayed', child: Text('Delayed')),
                          DropdownMenuItem(value: 'Cancelled', child: Text('Cancelled')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedStatus = value!;
                            _filterOrders();
                          });
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: isDark ? Colors.grey[800] : const Color(0xFFF8FAFC),
                          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
                              color: isDark ? Colors.blue[400]! : const Color(0xFF2563EB),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  // Desktop/Tablet Layout
                  Row(
                    children: [
                      // Search field
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: _searchController,
                          onChanged: (value) {
                            _filterOrders();
                          },
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge?.color ?? (isDark ? Colors.white : Colors.black87),
                          ),
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.search,
                              color: isDark ? Colors.grey[400] : Colors.grey[600],
                            ),
                            hintText: 'Search by order ID or service type',
                            hintStyle: TextStyle(
                              color: isDark ? Colors.grey[400] : Colors.grey[600],
                            ),
                            filled: true,
                            fillColor: isDark ? Colors.grey[800] : const Color(0xFFF8FAFC),
                            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
                                color: isDark ? Colors.blue[400]! : const Color(0xFF2563EB),
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Status filter dropdown
                      SizedBox(
                        width: isTablet ? 160 : 180,
                        child: DropdownButtonFormField<String>(
                          value: _selectedStatus,
                          items: const [
                            DropdownMenuItem(value: 'All Orders', child: Text('All Orders')),
                            DropdownMenuItem(value: 'Completed', child: Text('Completed')),
                            DropdownMenuItem(value: 'In Progress', child: Text('In Progress')),
                            DropdownMenuItem(value: 'Pending', child: Text('Pending')),
                            DropdownMenuItem(value: 'Delayed', child: Text('Delayed')),
                            DropdownMenuItem(value: 'Cancelled', child: Text('Cancelled')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedStatus = value!;
                              _filterOrders();
                            });
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: isDark ? Colors.grey[800] : const Color(0xFFF8FAFC),
                            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
                                color: isDark ? Colors.blue[400]! : const Color(0xFF2563EB),
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
        
        // Job Orders Table Card
        Card(
          color: Theme.of(context).cardColor,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isDark ? Colors.grey[800]! : const Color(0xFFE5E7EB), 
              width: 1
            ),
          ),
          margin: cardMargin,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 16.0 : 32.0, 
              vertical: isMobile ? 20.0 : 32.0
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order List', 
                  style: TextStyle(
                    fontWeight: FontWeight.bold, 
                    fontSize: isMobile ? 18 : 20, 
                    color: Theme.of(context).textTheme.titleLarge?.color ?? (isDark ? Colors.white : Colors.black87),
                  )
                ),
                const SizedBox(height: 16),
                
                // Responsive Table Container
                isMobile 
                  ? SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: _buildDataTable(context, isMobile, isDark),
                    )
                  : _buildResponsiveTable(context, isDark),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDataTable(BuildContext context, bool isMobile, bool isDark) {
    return DataTable(
      headingRowColor: WidgetStateProperty.resolveWith<Color?>(
        (states) => Theme.of(context).cardColor
      ),
      headingTextStyle: TextStyle(
        fontWeight: FontWeight.bold, 
        color: Theme.of(context).textTheme.titleMedium?.color ?? (isDark ? Colors.white : Colors.black87), 
        fontSize: isMobile ? 11 : 14
      ),
      dataRowColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.hovered)) {
          return isDark ? Colors.grey[700] : const Color(0xFFF1F5F9);
        }
        return Theme.of(context).cardColor;
      }),
      columnSpacing: isMobile ? 16 : 24,
      horizontalMargin: 0,
      dataRowMinHeight: isMobile ? 40 : 48,
      dataRowMaxHeight: isMobile ? 48 : 56,
      columns: [
        DataColumn(
          label: Text(
            'Order ID',
            style: TextStyle(
              fontSize: isMobile ? 10 : 12,
              color: Theme.of(context).textTheme.bodyMedium?.color ?? (isDark ? Colors.white : Colors.black87)
            ),
          )
        ),
        DataColumn(
          label: Text(
            'Customer',
            style: TextStyle(
              fontSize: isMobile ? 10 : 12,
              color: Theme.of(context).textTheme.bodyMedium?.color ?? (isDark ? Colors.white : Colors.black87)
            ),
          )
        ),
        DataColumn(
          label: Text(
            'Service',
            style: TextStyle(
              fontSize: isMobile ? 10 : 12,
              color: Theme.of(context).textTheme.bodyMedium?.color ?? (isDark ? Colors.white : Colors.black87)
            ),
          )
        ),
        DataColumn(
          label: Text(
            'Date',
            style: TextStyle(
              fontSize: isMobile ? 10 : 12,
              color: Theme.of(context).textTheme.bodyMedium?.color ?? (isDark ? Colors.white : Colors.black87)
            ),
          )
        ),
        DataColumn(
          label: Text(
            'Status',
            style: TextStyle(
              fontSize: isMobile ? 10 : 12,
              color: Theme.of(context).textTheme.bodyMedium?.color ?? (isDark ? Colors.white : Colors.black87)
            ),
          )
        ),
        DataColumn(
          label: Text(
            'Price',
            style: TextStyle(
              fontSize: isMobile ? 10 : 12,
              color: Theme.of(context).textTheme.bodyMedium?.color ?? (isDark ? Colors.white : Colors.black87)
            ),
          )
        ),
      ],
      rows: _filteredOrders.map((order) {
        Color statusColor = _getStatusColor(order['status']);
        
        return DataRow(cells: [
          DataCell(
            Text(
              order['id'], 
              style: TextStyle(
                fontSize: isMobile ? 9 : 11,
                color: Theme.of(context).textTheme.bodyMedium?.color ?? (isDark ? Colors.white : Colors.black87),
              ),
            )
          ),
          DataCell(
            Text(
              order['customer'], 
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: isMobile ? 9 : 11,
                color: Theme.of(context).textTheme.bodyMedium?.color ?? (isDark ? Colors.white : Colors.black87),
              ),
            )
          ),
          DataCell(
            Text(
              order['service'], 
              style: TextStyle(
                fontSize: isMobile ? 9 : 11,
                color: Theme.of(context).textTheme.bodyMedium?.color ?? (isDark ? Colors.white : Colors.black87),
              ),
            )
          ),
          DataCell(
            Text(
              order['date'], 
              style: TextStyle(
                fontSize: isMobile ? 9 : 11,
                color: Theme.of(context).textTheme.bodyMedium?.color ?? (isDark ? Colors.white : Colors.black87),
              ),
            )
          ),
          DataCell(
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 6 : 8, 
                vertical: isMobile ? 3 : 4
              ),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                order['status'], 
                style: TextStyle(
                  color: statusColor,
                  fontSize: isMobile ? 8 : 10,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            )
          ),
          DataCell(
            Text(
              order['price'], 
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: isMobile ? 9 : 11,
                color: Theme.of(context).textTheme.bodyMedium?.color ?? (isDark ? Colors.white : Colors.black87),
              ),
            )
          ),
        ]);
      }).toList(),
    );
  }

  Widget _buildResponsiveTable(BuildContext context, bool isDark) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate available width for table content
        final availableWidth = constraints.maxWidth;
        
        // Define column flex ratios based on content importance
        const columnFlexRatios = {
          'id': 1.5,
          'customer': 2.0,
          'service': 2.0,
          'date': 1.5,
          'status': 1.5,
          'price': 1.0,
        };
        
        final totalFlex = columnFlexRatios.values.reduce((a, b) => a + b);
        
        return Table(
          columnWidths: {
            0: FlexColumnWidth(columnFlexRatios['id']! / totalFlex),
            1: FlexColumnWidth(columnFlexRatios['customer']! / totalFlex),
            2: FlexColumnWidth(columnFlexRatios['service']! / totalFlex),
            3: FlexColumnWidth(columnFlexRatios['date']! / totalFlex),
            4: FlexColumnWidth(columnFlexRatios['status']! / totalFlex),
            5: FlexColumnWidth(columnFlexRatios['price']! / totalFlex),
          },
          children: [
            // Header Row
            TableRow(
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[800]?.withOpacity(0.3) : Colors.grey[50],
                borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
              ),
              children: [
                _buildTableHeaderCell('Order ID', isDark),
                _buildTableHeaderCell('Customer', isDark),
                _buildTableHeaderCell('Service', isDark),
                _buildTableHeaderCell('Date', isDark),
                _buildTableHeaderCell('Status', isDark),
                _buildTableHeaderCell('Price', isDark),
              ],
            ),
            // Data Rows
            ..._filteredOrders.asMap().entries.map((entry) {
              final index = entry.key;
              final order = entry.value;
              final isEven = index % 2 == 0;
              final statusColor = _getStatusColor(order['status']);
              
              return TableRow(
                decoration: BoxDecoration(
                  color: isEven 
                    ? (isDark ? Colors.transparent : Colors.grey[25]) 
                    : (isDark ? Colors.grey[900]?.withOpacity(0.2) : Colors.white),
                ),
                children: [
                  _buildTableCell(order['id'], isDark),
                  _buildTableCell(order['customer'], isDark, bold: true),
                  _buildTableCell(order['service'], isDark),
                  _buildTableCell(order['date'], isDark),
                  _buildStatusCell(order['status'], statusColor),
                  _buildTableCell(order['price'], isDark, bold: true),
                ],
              );
            }).toList(),
          ],
        );
      },
    );
  }

  Widget _buildTableHeaderCell(String text, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
          color: Theme.of(context).textTheme.titleMedium?.color ?? (isDark ? Colors.white : Colors.black87),
        ),
      ),
    );
  }

  Widget _buildTableCell(String text, bool isDark, {bool bold = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          color: Theme.of(context).textTheme.bodyMedium?.color ?? (isDark ? Colors.white : Colors.black87),
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }

  Widget _buildStatusCell(String status, Color statusColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: statusColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          status,
          style: TextStyle(
            color: statusColor,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Completed':
        return Colors.green;
      case 'In Progress':
        return Colors.orange;
      case 'Pending':
        return Colors.blue;
      case 'Delayed':
        return Colors.red;
      case 'Cancelled':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color iconColor) {
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        
        return Card(
          elevation: 0,
          color: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(
              color: isDark ? Colors.grey[800]! : const Color(0xFFE5E7EB), 
              width: 1
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Text(
                          value,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.titleLarge?.color ?? (isDark ? Colors.white : Colors.black),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: Icon(icon, color: iconColor, size: 28),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}