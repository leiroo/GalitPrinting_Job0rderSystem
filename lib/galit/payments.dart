import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'sidebar.dart';

class PaymentsPage extends StatefulWidget {
  const PaymentsPage({super.key});

  @override
  State<PaymentsPage> createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedStatus = 'All Statuses';
  String _selectedTime = 'All Time';
  List<Map<String, String>> _filteredPayments = [];

  List<Map<String, String>> get _allPayments {
    return AppData.payments.map((payment) {
      // Find the corresponding order to get customer name
      final order = AppData.orders.firstWhere(
        (order) => order.id == payment.orderId,
        orElse: () => Order(id: '', customer: 'Unknown', service: '', date: DateTime.now(), status: '', price: 0, createdBy: 0),
      );
      
      return {
        'receipt': payment.id,
        'order': payment.orderId,
        'customer': order.customer,
        'date': '${payment.date.month.toString().padLeft(2, '0')}/${payment.date.day.toString().padLeft(2, '0')}/${payment.date.year}',
        'time': '${payment.date.hour.toString().padLeft(2, '0')}:${payment.date.minute.toString().padLeft(2, '0')}',
        'amount': '₱${payment.amount.toStringAsFixed(0)}',
        'method': payment.method,
        'status': payment.status,
      };
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _filteredPayments = List.from(_allPayments);
    _searchController.addListener(_filterPayments);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterPayments() {
    setState(() {
      _filteredPayments = _allPayments.where((payment) {
        // Search filter
        final searchQuery = _searchController.text.toLowerCase();
        final matchesSearch = searchQuery.isEmpty ||
            payment['receipt']!.toLowerCase().contains(searchQuery) ||
            payment['order']!.toLowerCase().contains(searchQuery);

        // Status filter
        final matchesStatus = _selectedStatus == 'All Statuses' ||
            payment['status'] == _selectedStatus;

        // Time filter based on actual dates
        bool matchesTime = true;
        if (_selectedTime != 'All Time') {
          try {
            final paymentDate = DateTime.parse('2025-07-${payment['date']!.split(' ')[1].split(',')[0]}');
            final now = DateTime.now();
            final today = DateTime(now.year, now.month, now.day);
            final startOfWeek = today.subtract(Duration(days: today.weekday - 1));
            final endOfWeek = startOfWeek.add(const Duration(days: 6));
            final startOfMonth = DateTime(now.year, now.month, 1);
            final endOfMonth = DateTime(now.year, now.month + 1, 0);

            switch (_selectedTime) {
              case 'Today':
                matchesTime = paymentDate.isAtSameMomentAs(today);
                break;
              case 'This Week':
                matchesTime = paymentDate.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
                    paymentDate.isBefore(endOfWeek.add(const Duration(days: 1)));
                break;
              case 'This Month':
                matchesTime = paymentDate.isAfter(startOfMonth.subtract(const Duration(days: 1))) &&
                    paymentDate.isBefore(endOfMonth.add(const Duration(days: 1)));
                break;
            }
          } catch (e) {
            // If date parsing fails, show all
            matchesTime = true;
          }
        }

        return matchesSearch && matchesStatus && matchesTime;
      }).toList();
    });
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
        title: const Text('Payments'),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Payment Management', 
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      fontSize: 28,
                      color: Theme.of(context).textTheme.titleLarge?.color ?? (isDark ? Colors.white : Colors.black87),
                    )
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Track and manage all payment transactions, receipts, and financial records',
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey, 
                      fontSize: 16
                    ),
                  ),
                  const SizedBox(height: 24),
                  Card(
                    color: Theme.of(context).cardColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: isMobile
                          ? Column(
                              children: [
                                // Search bar - full width
                                TextField(
                                  controller: _searchController,
                                  style: TextStyle(
                                    color: Theme.of(context).textTheme.bodyLarge?.color ?? (isDark ? Colors.white : Colors.black87),
                                  ),
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                                    ),
                                    hintText: 'Search by receipt ID or order ID',
                                    hintStyle: TextStyle(
                                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                                    ),
                                    filled: true,
                                    fillColor: isDark ? Colors.grey[800] : Colors.white,
                                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
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
                                const SizedBox(height: 16),
                                // Filter dropdowns - side by side
                                Row(
                                  children: [
                                    Expanded(
                                      child: DropdownButtonFormField<String>(
                                        value: _selectedStatus,
                                        items: const [
                                          DropdownMenuItem(value: 'All Statuses', child: Text('All Statuses')),
                                          DropdownMenuItem(value: 'Received', child: Text('Received')),
                                          DropdownMenuItem(value: 'Completed', child: Text('Completed')),
                                          DropdownMenuItem(value: 'Partial', child: Text('Partial')),
                                          DropdownMenuItem(value: 'Refunded', child: Text('Refunded')),
                                        ],
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedStatus = value!;
                                            _filterPayments();
                                          });
                                        },
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: isDark ? Colors.grey[800] : Colors.white,
                                          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
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
                                    Expanded(
                                      child: DropdownButtonFormField<String>(
                                        value: _selectedTime,
                                        items: const [
                                          DropdownMenuItem(value: 'All Time', child: Text('All Time')),
                                          DropdownMenuItem(value: 'Today', child: Text('Today')),
                                          DropdownMenuItem(value: 'This Week', child: Text('This Week')),
                                          DropdownMenuItem(value: 'This Month', child: Text('This Month')),
                                        ],
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedTime = value!;
                                            _filterPayments();
                                          });
                                        },
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: isDark ? Colors.grey[800] : Colors.white,
                                          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
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
                            )
                          : Row(
                              children: [
                                // Search bar - takes more space
                                Expanded(
                                  flex: 2,
                                  child: TextField(
                                    controller: _searchController,
                                    style: TextStyle(
                                      color: Theme.of(context).textTheme.bodyLarge?.color ?? (isDark ? Colors.white : Colors.black87),
                                    ),
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.search,
                                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                                      ),
                                      hintText: 'Search by receipt ID or order ID',
                                      hintStyle: TextStyle(
                                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                                      ),
                                      filled: true,
                                      fillColor: isDark ? Colors.grey[800] : Colors.white,
                                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
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
                                // Status dropdown
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    value: _selectedStatus,
                                    items: const [
                                      DropdownMenuItem(value: 'All Statuses', child: Text('All Statuses')),
                                      DropdownMenuItem(value: 'Received', child: Text('Received')),
                                      DropdownMenuItem(value: 'Completed', child: Text('Completed')),
                                      DropdownMenuItem(value: 'Partial', child: Text('Partial')),
                                      DropdownMenuItem(value: 'Refunded', child: Text('Refunded')),
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedStatus = value!;
                                        _filterPayments();
                                      });
                                    },
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: isDark ? Colors.grey[800] : Colors.white,
                                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
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
                                // Time dropdown
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    value: _selectedTime,
                                    items: const [
                                      DropdownMenuItem(value: 'All Time', child: Text('All Time')),
                                      DropdownMenuItem(value: 'Today', child: Text('Today')),
                                      DropdownMenuItem(value: 'This Week', child: Text('This Week')),
                                      DropdownMenuItem(value: 'This Month', child: Text('This Month')),
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedTime = value!;
                                        _filterPayments();
                                      });
                                    },
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: isDark ? Colors.grey[800] : Colors.white,
                                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
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
                    ),
                  ),
                  const SizedBox(height: 24),
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
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Payment Transactions', 
                            style: TextStyle(
                              fontWeight: FontWeight.bold, 
                              fontSize: 22,
                              color: Theme.of(context).textTheme.titleLarge?.color ?? (isDark ? Colors.white : Colors.black87),
                            )
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'View and manage all payment records', 
                            style: TextStyle(
                              color: isDark ? Colors.grey[400] : Colors.grey,
                            )
                          ),
                          const SizedBox(height: 16),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columns: const [
                                DataColumn(label: Text('Receipt #')),
                                DataColumn(label: Text('Order ID')),
                                DataColumn(label: Text('Customer Name')),
                                DataColumn(label: Text('Date & Time')),
                                DataColumn(label: Text('Amount')),
                                DataColumn(label: Text('Method')),
                                DataColumn(label: Text('Status')),
                                DataColumn(label: Text('Actions')),
                              ],
                              rows: _filteredPayments.map((p) {
                                Color statusColor;
                                String status = p['status']!;
                                switch (status) {
                                  case 'Received':
                                    statusColor = const Color(0xFF3B82F6); // blue
                                    break;
                                  case 'Completed':
                                    statusColor = const Color(0xFF4ADE80); // green
                                    break;
                                  case 'Partial':
                                    statusColor = const Color(0xFFFACC15); // yellow
                                    break;
                                  case 'Refunded':
                                    statusColor = const Color(0xFFF87171); // red
                                    break;
                                  default:
                                    statusColor = Colors.grey;
                                }
                                return DataRow(cells: [
                                  DataCell(Text(p['receipt']!)),
                                  DataCell(Text(p['order']!)),
                                  DataCell(Text(p['customer']!)),
                                  DataCell(Text('${p['date']!} ${p['time']!}')),
                                  DataCell(Text(p['amount']!, style: const TextStyle(fontWeight: FontWeight.bold))),
                                  DataCell(Text(p['method']!)),
                                  DataCell(Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: statusColor.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.w500)),
                                  )),
                                  DataCell(Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.receipt_long, color: Color(0xFF2563EB)),
                                        tooltip: 'View Receipt',
                                        onPressed: () {},
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.link, color: Colors.black54),
                                        tooltip: 'Copy Link',
                                        onPressed: () {},
                                      ),
                                    ],
                                  )),
                                ]);
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  isMobile
                      ? Column(
                          children: [
                            // Payment Summary first, then Payment Methods
                            _paymentSummaryCard(),
                            const SizedBox(height: 24),
                            _paymentMethodsCard(),
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Payment Summary left, Payment Methods right
                            Expanded(flex: 1, child: _paymentSummaryCard()),
                            const SizedBox(width: 24),
                            Expanded(flex: 1, child: _paymentMethodsCard()),
                          ],
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

Widget _summaryRow(String label, String value, {Color? color, bool bold = false}) {
  return Builder(
    builder: (context) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      final defaultColor = isDark ? Colors.white : Colors.black;
      
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: color ?? defaultColor)),
          Text(value, style: TextStyle(
            color: color ?? defaultColor,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            fontSize: bold ? 18 : 16,
          )),
        ],
      );
    }
  );
}

Widget _methodRow(IconData icon, String label, String amount, String percent, Color color, double progress) {
  return Builder(
    builder: (context) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                label, 
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).textTheme.bodyLarge?.color ?? (isDark ? Colors.white : Colors.black87),
                )
              ),
              const Spacer(),
              Text(
                amount, 
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge?.color ?? (isDark ? Colors.white : Colors.black87),
                )
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: color.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
          const SizedBox(height: 2),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              percent, 
              style: TextStyle(
                color: isDark ? Colors.grey[400] : Colors.grey[600], 
                fontSize: 12
              )
            ),
          ),
        ],
      );
    }
  );
}

Widget _paymentSummaryCard() {
  return Builder(
    builder: (context) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      
      // Calculate totals from AppData
      final totalAmount = AppData.payments.fold<double>(0, (sum, payment) => sum + payment.amount);
      final completedPayments = AppData.payments.where((p) => p.status == 'Completed').fold<double>(0, (sum, payment) => sum + payment.amount);
      final partialPayments = AppData.payments.where((p) => p.status == 'Partial').fold<double>(0, (sum, payment) => sum + payment.amount);
      
      return Card(
        color: Theme.of(context).cardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isDark ? Colors.grey[800]! : const Color(0xFFE5E7EB), 
            width: 1
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined, 
                    size: 24,
                    color: Theme.of(context).iconTheme.color ?? (isDark ? Colors.white : Colors.black87),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Payment Summary', 
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      fontSize: 20,
                      color: Theme.of(context).textTheme.titleLarge?.color ?? (isDark ? Colors.white : Colors.black87),
                    )
                  ),
                ],
              ),
          const SizedBox(height: 24),
          _summaryRow('Total Revenue', '₱${totalAmount.toStringAsFixed(0)}', bold: true),
          const SizedBox(height: 8),
          _summaryRow('Completed Payments', '₱${completedPayments.toStringAsFixed(0)}', color: const Color(0xFF22C55E)),
          const SizedBox(height: 8),
          _summaryRow('Partial Payments', '₱${partialPayments.toStringAsFixed(0)}', color: const Color(0xFFF59E42)),
          const Divider(height: 32),
          _summaryRow('Total Orders', '${AppData.orders.length}', color: Colors.blue),
          const SizedBox(height: 8),
          _summaryRow('Total Payments', '${AppData.payments.length}', color: Colors.purple),
            ],
          ),
        ),
      );
    }
  );
}

Widget _paymentMethodsCard() {
  return Builder(
    builder: (context) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      
      // Calculate payment method totals from AppData
      final cashPayments = AppData.payments.where((p) => p.method == 'Cash').fold<double>(0, (sum, payment) => sum + payment.amount);
      final gcashPayments = AppData.payments.where((p) => p.method == 'GCash').fold<double>(0, (sum, payment) => sum + payment.amount);
      final totalAmount = AppData.payments.fold<double>(0, (sum, payment) => sum + payment.amount);
      
      final cashPercentage = totalAmount > 0 ? cashPayments / totalAmount : 0.0;
      final gcashPercentage = totalAmount > 0 ? gcashPayments / totalAmount : 0.0;
      
      return Card(
        color: Theme.of(context).cardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isDark ? Colors.grey[800]! : const Color(0xFFE5E7EB), 
            width: 1
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.credit_card, 
                    size: 24, 
                    color: Theme.of(context).iconTheme.color ?? (isDark ? Colors.white : Colors.black87),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Payment Methods', 
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      fontSize: 20, 
                      color: Theme.of(context).textTheme.titleLarge?.color ?? (isDark ? Colors.white : Colors.black87),
                    )
                  ),
                ],
              ),
          const SizedBox(height: 24),
          _methodRow(Icons.attach_money, 'Cash', '₱${cashPayments.toStringAsFixed(0)}', '${(cashPercentage * 100).toStringAsFixed(0)}% of total', Colors.green, cashPercentage),
          const SizedBox(height: 16),
          _methodRow(Icons.account_balance_wallet, 'GCash', '₱${gcashPayments.toStringAsFixed(0)}', '${(gcashPercentage * 100).toStringAsFixed(0)}% of total', Colors.blue, gcashPercentage),
            ],
          ),
        ),
      );
    }
  );
} 