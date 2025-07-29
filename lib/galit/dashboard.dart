import 'package:flutter/material.dart';
import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'sidebar.dart';

// App Data Classes
class Order {
  final String id;
  final String customer;
  final String service;
  final DateTime date;
  final String status;
  final double price;
  final int createdBy;

  Order({
    required this.id,
    required this.customer,
    required this.service,
    required this.date,
    required this.status,
    required this.price,
    required this.createdBy,
  });
}

class Payment {
  final String id;
  final String orderId;
  final DateTime date;
  final double amount;
  final String method;
  final String status;
  final int receivedBy;

  Payment({
    required this.id,
    required this.orderId,
    required this.date,
    required this.amount,
    required this.method,
    required this.status,
    required this.receivedBy,
  });
}

class InventoryItem {
  final String name;
  double stock;
  final double minStock;

  InventoryItem({required this.name, required this.stock, required this.minStock});
}

class Staff {
  final int id;
  final String name;
  final String role;

  Staff({required this.id, required this.name, required this.role});
}

class AppData {
  static List<Order> orders = [
    Order(id: 'JO-2044401', customer: 'Maria Santos', service: 'banner_printing', date: DateTime(2025, 7, 17, 8, 15), status: 'Completed', price: 8500, createdBy: 1),
    Order(id: 'JO-701050', customer: 'Juan Dela Cruz', service: 'tarpaulin_printing', date: DateTime(2025, 7, 17, 10, 30), status: 'Completed', price: 1200, createdBy: 1),
    Order(id: 'JO-799910', customer: 'Ana Reyes', service: 'photo_printing', date: DateTime(2025, 7, 16, 13, 45), status: 'In Progress', price: 750, createdBy: 2),
    Order(id: 'JO-199382', customer: 'Pedro Martinez', service: 'banner_printing', date: DateTime(2025, 7, 16, 15, 20), status: 'In Progress', price: 2800, createdBy: 1),
    Order(id: 'JO-298527', customer: 'Luz Garcia', service: 'business_cards', date: DateTime(2025, 7, 15, 9, 30), status: 'Pending', price: 1500, createdBy: 2),
    Order(id: 'JO-461239', customer: 'Roberto Lopez', service: 'sticker_printing', date: DateTime(2025, 7, 15, 12, 15), status: 'Pending', price: 6000, createdBy: 2),
    Order(id: 'JO-519447', customer: 'Carmen Rodriguez', service: 'large_format_printing', date: DateTime(2025, 7, 14, 7, 45), status: 'Delayed', price: 3600, createdBy: 1),
    Order(id: 'JO-552838', customer: 'Antonio Flores', service: 'flyer_printing', date: DateTime(2025, 7, 14, 14, 30), status: 'Cancelled', price: 2500, createdBy: 1),
  ];

  static List<Payment> payments = [
    Payment(id: 'REC-000001', orderId: 'JO-2044401', date: DateTime(2025, 7, 17, 9, 30), amount: 8500, method: 'Cash', status: 'Completed', receivedBy: 2),
    Payment(id: 'REC-000002', orderId: 'JO-701050', date: DateTime(2025, 7, 17, 11, 15), amount: 1200, method: 'GCash', status: 'Completed', receivedBy: 1),
    Payment(id: 'REC-000003', orderId: 'JO-799910', date: DateTime(2025, 7, 16, 14, 45), amount: 750, method: 'Cash', status: 'Partial', receivedBy: 2),
    Payment(id: 'REC-000004', orderId: 'JO-199382', date: DateTime(2025, 7, 16, 16, 20), amount: 2800, method: 'Cash', status: 'Partial', receivedBy: 1),
    Payment(id: 'REC-000005', orderId: 'JO-298527', date: DateTime(2025, 7, 15, 10, 30), amount: 1500, method: 'GCash', status: 'Partial', receivedBy: 2),
    Payment(id: 'REC-000006', orderId: 'JO-461239', date: DateTime(2025, 7, 15, 13, 15), amount: 6000, method: 'Cash', status: 'Partial', receivedBy: 2),
    Payment(id: 'REC-000007', orderId: 'JO-519447', date: DateTime(2025, 7, 14, 8, 45), amount: 3600, method: 'Cash', status: 'Refunded', receivedBy: 1),
    Payment(id: 'REC-000008', orderId: 'JO-552838', date: DateTime(2025, 7, 14, 15, 30), amount: 2500, method: 'Cash', status: 'Refunded', receivedBy: 1),
  ];

  static List<InventoryItem> inventory = [
    InventoryItem(name: 'Tarpaulin Material', stock: 50, minStock: 10),
    InventoryItem(name: 'Ink - Magenta', stock: 20, minStock: 5),
    InventoryItem(name: 'Glossy Photo Paper', stock: 100, minStock: 20),
    InventoryItem(name: 'A4 Bond Paper', stock: 200, minStock: 50),
    InventoryItem(name: 'Sticker Paper', stock: 80, minStock: 15),
  ];

  static List<Staff> staff = [
    Staff(id: 1, name: 'Juan Dela Cruz', role: 'Admin'),
    Staff(id: 2, name: 'Maria Santos', role: 'Clerk'),
  ];
}

// Dashboard Overview Component
class DashboardOverview extends StatelessWidget {
  const DashboardOverview({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    
    // Calculate real data from AppData.orders
    final pendingOrders = AppData.orders.where((order) => order.status == 'Pending').length;
    final completedOrders = AppData.orders.where((order) => order.status == 'Completed').length;
    final todayRevenue = AppData.orders
        .where((order) => order.status == 'Completed')
        .fold(0.0, (sum, order) => sum + order.price);
    final lowStockItems = AppData.inventory.where((item) => item.stock <= item.minStock).length;
    
    final cards = [
      _buildCard(
        context,
        title: 'Pending Orders',
        value: pendingOrders.toString(),
        icon: Icons.access_time_outlined,
        statusIcon: Icons.arrow_upward,
        statusColor: Colors.green,
        subtitle: '${pendingOrders > 0 ? 'Active' : 'No'} pending orders',
        semanticLabel: 'Pending Orders',
        isMobile: isMobile,
      ),
      _buildCard(
        context,
        title: 'Completed Orders',
        value: completedOrders.toString(),
        icon: Icons.check_circle_outline,
        statusIcon: Icons.arrow_upward,
        statusColor: Colors.green,
        subtitle: '${completedOrders > 0 ? 'Successfully' : 'No'} completed',
        semanticLabel: 'Completed Orders',
        isMobile: isMobile,
      ),
      _buildCard(
        context,
        title: "Today's Revenue",
        value: '₱${todayRevenue.toStringAsFixed(0)}',
        icon: Icons.receipt_long,
        statusIcon: Icons.arrow_upward,
        statusColor: Colors.green,
        subtitle: 'From completed orders',
        semanticLabel: "Today's Revenue",
        isMobile: isMobile,
      ),
      _buildCard(
        context,
        title: 'Low Stock Items',
        value: lowStockItems.toString(),
        icon: Icons.inventory_2_outlined,
        statusIcon: lowStockItems > 0 ? Icons.error_outline : Icons.check_circle_outline,
        statusColor: lowStockItems > 0 ? Colors.red : Colors.green,
        subtitle: lowStockItems > 0 ? 'Restock needed' : 'All items in stock',
        semanticLabel: 'Low Stock Items',
        isMobile: isMobile,
      ),
    ];
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 6 : 16, vertical: isMobile ? 8 : 16),
        child: isMobile
            ? Wrap(
                spacing: 8,
                runSpacing: 8,
                children: cards.map((c) => SizedBox(
                  width: (MediaQuery.of(context).size.width / 2) - 16,
                  child: c,
                )).toList(),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: cards
                    .map((c) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: c)))
                    .toList(),
              ),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required IconData statusIcon,
    required Color statusColor,
    required String subtitle,
    required String semanticLabel,
    required bool isMobile,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        margin: EdgeInsets.symmetric(vertical: isMobile ? 6 : 12, horizontal: isMobile ? 2 : 8),
        child: Card(
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
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                    fontSize: isMobile ? 12 : 15,
                    letterSpacing: 0.1,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(
                        value,
                        style: TextStyle(
                          fontSize: isMobile ? 20 : 32,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).textTheme.titleLarge?.color ?? (isDark ? Colors.white : Colors.black),
                          height: 1.1,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: Icon(
                        icon, 
                        color: Theme.of(context).iconTheme.color ?? (isDark ? Colors.white : Colors.black87), 
                        size: isMobile ? 20 : 28, 
                        semanticLabel: semanticLabel
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(statusIcon, color: statusColor, size: isMobile ? 12 : 16, semanticLabel: subtitle),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          subtitle,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: isMobile ? 10 : 13,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.visible,
                          maxLines: 2,
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
    );
  }
}

// AI Insights Component
class AIInsights extends StatefulWidget {
  const AIInsights({super.key});

  @override
  State<AIInsights> createState() => _AIInsightsState();
}

class _AIInsightsState extends State<AIInsights> {
  late final PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) return;
      setState(() {
        _currentPage = (_currentPage + 1) % 3;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final insights = [
      _buildInsight(
        Icons.trending_up,
        'Peak Hour Prediction',
        "Today's peak business hours are predicted between 2:00 PM - 5:00 PM. Consider allocating 2 additional staff members.",
        isDark ? Colors.blue[900]! : Colors.blue[50]!,
      ),
      _buildInsight(
        Icons.lightbulb,
        'Resource Optimization',
        'Tarpaulin printer #2 has 30% higher efficiency than #1. Prioritize high-volume orders on printer #2.',
        isDark ? Colors.yellow[900]! : Colors.yellow[50]!,
      ),
      _buildInsight(
        Icons.warning,
        'Inventory Alert',
        'Cyan ink will reach critical levels in 4 days based on current usage patterns. Order soon to avoid delays.',
        isDark ? Colors.green[900]! : Colors.green[50]!,
      ),
    ];
    return Card(
      margin: EdgeInsets.symmetric(vertical: 16, horizontal: MediaQuery.of(context).size.width < 600 ? 6 : 0),
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
        child: isMobile
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 170,
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      children: insights,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(insights.length, (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == index ? 16 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index 
                            ? (isDark ? Colors.blue[400] : Colors.indigo) 
                            : (isDark ? Colors.grey[600] : Colors.grey[300]),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    )),
                  ),
                ],
              )
            : Row(
                children: [
                  insights[0],
                  const SizedBox(width: 16),
                  insights[1],
                  const SizedBox(width: 16),
                  insights[2],
                ],
              ),
      ),
    );
  }

  Widget _buildInsight(IconData icon, String title, String desc, Color bg) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: isDark ? Colors.blue[300] : Colors.blue[600],
                  size: 24,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Theme.of(context).textTheme.titleLarge?.color ?? (isDark ? Colors.white : Colors.black87),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              desc,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.grey[300] : Colors.grey[700],
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Recent Orders Component
class RecentOrders extends StatelessWidget {
  const RecentOrders({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Card(
      margin: EdgeInsets.symmetric(vertical: 16, horizontal: isMobile ? 6 : 0),
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
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 24.0),
                  child: Text(
                    'Recent Orders', 
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      fontSize: 20, 
                      color: Theme.of(context).textTheme.titleLarge?.color ?? (isDark ? Colors.white : Colors.black87)
                    )
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 24.0),
                  child: TextButton(
                    onPressed: () {}, 
                    child: Text(
                      'View All', 
                      style: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.black54
                      )
                    )
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: WidgetStateProperty.resolveWith<Color?>((states) => Theme.of(context).cardColor),
                headingTextStyle: TextStyle(
                  fontWeight: FontWeight.bold, 
                  color: Theme.of(context).textTheme.titleLarge?.color ?? (isDark ? Colors.white : Colors.black87), 
                  fontSize: 15
                ),
                dataRowColor: WidgetStateProperty.resolveWith<Color?>((states) {
                  if (states.contains(WidgetState.hovered)) {
                    return isDark ? Colors.grey[800]! : const Color(0xFFF1F5F9);
                  }
                  return Theme.of(context).cardColor;
                }),
                columnSpacing: isMobile ? 32 : 100,
                horizontalMargin: isMobile ? 6 : 50,
                dataRowMinHeight: 56,
                dataRowMaxHeight: 64,
                columns: [
                  DataColumn(label: Text(
                    'Order ID',
                    style: TextStyle(color: Theme.of(context).textTheme.titleLarge?.color ?? (isDark ? Colors.white : Colors.black87))
                  )),
                  DataColumn(label: Text(
                    'Customer Name',
                    style: TextStyle(color: Theme.of(context).textTheme.titleLarge?.color ?? (isDark ? Colors.white : Colors.black87))
                  )),
                  DataColumn(label: Text(
                    'Service Type',
                    style: TextStyle(color: Theme.of(context).textTheme.titleLarge?.color ?? (isDark ? Colors.white : Colors.black87))
                  )),
                  DataColumn(label: Text(
                    'Date',
                    style: TextStyle(color: Theme.of(context).textTheme.titleLarge?.color ?? (isDark ? Colors.white : Colors.black87))
                  )),
                  DataColumn(label: Text(
                    'Status',
                    style: TextStyle(color: Theme.of(context).textTheme.titleLarge?.color ?? (isDark ? Colors.white : Colors.black87))
                  )),
                  DataColumn(label: Text(
                    'Price',
                    style: TextStyle(color: Theme.of(context).textTheme.titleLarge?.color ?? (isDark ? Colors.white : Colors.black87))
                  )),
                ],
                rows: [
                  _orderRow(context, 'JO-2044401', 'Juan Dela Cruz', 'banner_printing', 'Jul 17, 2025', 'Completed', '₱8,500', '1'),
                  _orderRow(context, 'JO-701050', 'Maria Santos', 'tarpaulin_printing', 'Jul 17, 2025', 'Completed', '₱1,200', '1'),
                  _orderRow(context, 'JO-799910', 'Pedro Reyes', 'photo_printing', 'Jul 17, 2025', 'In Progress', '₱750', '2'),
                  _orderRow(context, 'JO-199382', 'Ana Lim', 'banner_printing', 'Jul 17, 2025', 'In Progress', '₱2,800', '1'),
                  _orderRow(context, 'JO-298527', 'Liza Cruz', 'business_cards', 'Jul 17, 2025', 'Pending', '₱1,500', '2'),
                  _orderRow(context, 'JO-461239', 'Stacy Cruz', 'sticker_printing', 'Jul 17, 2025', 'Pending', '₱6,000', '2'),
                  _orderRow(context, 'JO-519447', 'Juan Dela Cruz', 'large_format_printing', 'Jul 17, 2025', 'Delayed', '₱3,600', '1'),
                  _orderRow(context, 'JO-552838', 'Maria Santos', 'flyer_printing', 'Jul 17, 2025', 'Cancelled', '₱2,500', '1'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  DataRow _orderRow(BuildContext context, String id, String customer, String service, String date, String status, String price, String createdBy) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Color statusColor;
    switch (status) {
      case 'Completed':
        statusColor = Colors.green;
        break;
      case 'In Progress':
        statusColor = Colors.orange;
        break;
      case 'Pending':
        statusColor = Colors.blue;
        break;
      case 'Delayed':
        statusColor = Colors.red;
        break;
      case 'Cancelled':
        statusColor = Colors.grey;
        break;
      default:
        statusColor = Colors.grey;
    }
    return DataRow(cells: [
      DataCell(Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          child: Text(
            id, 
            maxLines: 1, 
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color ?? (isDark ? Colors.white : Colors.black87)),
          ),
        ),
      )),
      DataCell(Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              customer, 
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge?.color ?? (isDark ? Colors.white : Colors.black87)
              ), 
              maxLines: 1, 
              overflow: TextOverflow.ellipsis
            ),
          ],
        ),
      )),
      DataCell(Text(
        service, 
        maxLines: 1, 
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color ?? (isDark ? Colors.white : Colors.black87)),
      )),
      DataCell(Text(
        date, 
        maxLines: 1, 
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color ?? (isDark ? Colors.white : Colors.black87)),
      )),
      DataCell(Align(
        alignment: Alignment.centerRight,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(isDark ? 0.2 : 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            status, 
            style: TextStyle(color: statusColor), 
            maxLines: 1, 
            overflow: TextOverflow.ellipsis
          ),
        ),
      )),
      DataCell(Align(
        alignment: Alignment.centerRight,
        child: Text(
          price, 
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyLarge?.color ?? (isDark ? Colors.white : Colors.black87)
          ), 
          maxLines: 1, 
          overflow: TextOverflow.ellipsis
        ),
      )),
    ]);
  }
}

// Revenue Trend Component
class RevenueTrend extends StatefulWidget {
  const RevenueTrend({super.key});

  @override
  State<RevenueTrend> createState() => _RevenueTrendState();
}

class _RevenueTrendState extends State<RevenueTrend> {
  int? selectedIndex;
  int _currentPage = 0;
  final PageController _pageController = PageController();
  String _selectedPeriod = 'Monthly';

  // Data up to July 2025 (current year)
  final months = const [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul'
  ];
  final values = const [
    32000, 25000, 30000, 40000, 37000, 34000, 42000
  ];

  @override
  Widget build(BuildContext context) {
    int pageCount = (months.length / 4).ceil();
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Card(
      margin: EdgeInsets.symmetric(vertical: 16, horizontal: MediaQuery.of(context).size.width < 600 ? 6 : 0),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Revenue Trend', 
                  style: TextStyle(
                    fontWeight: FontWeight.bold, 
                    fontSize: 18, 
                    color: Theme.of(context).textTheme.titleLarge?.color ?? (isDark ? Colors.white : Colors.black87)
                  )
                ),
                DropdownButton<String>(
                  value: _selectedPeriod,
                  items: [
                    DropdownMenuItem(value: 'Monthly', child: Text('Monthly')),
                    DropdownMenuItem(value: 'Weekly', child: Text('Weekly')),
                    DropdownMenuItem(value: 'Yearly', child: Text('Yearly')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedPeriod = value!;
                    });
                  },
                  dropdownColor: Theme.of(context).cardColor,
                  style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color ?? (isDark ? Colors.white : Colors.black87)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            isMobile
                ? Column(
                    children: [
                      SizedBox(
                        height: 180,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: pageCount,
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                            });
                          },
                          itemBuilder: (context, pageIndex) {
                            int start = pageIndex * 4;
                            int end = (start + 4).clamp(0, months.length);
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: List.generate(end - start, (i) {
                                int idx = start + i;
                                return Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedIndex = idx;
                                      });
                                    },
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        AnimatedContainer(
                                          duration: const Duration(milliseconds: 200),
                                          height: values[idx] / 700,
                                          width: 36,
                                          color: selectedIndex == idx 
                                              ? (isDark ? Colors.orange[400] : Colors.orange) 
                                              : (isDark ? Colors.blue[400] : Colors.blue),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          months[idx],
                                          style: TextStyle(
                                            color: Theme.of(context).textTheme.bodyMedium?.color ?? (isDark ? Colors.grey[300] : Colors.grey[600]),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(pageCount, (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentPage == index ? 16 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index 
                                ? (isDark ? Colors.blue[400] : Colors.indigo) 
                                : (isDark ? Colors.grey[600] : Colors.grey[300]),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        )),
                      ),
                    ],
                  )
                : SizedBox(
                    height: 180,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(months.length, (i) {
                        return Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndex = i;
                              });
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  height: values[i] / 700,
                                  width: 36,
                                  color: selectedIndex == i ? Colors.orange : Colors.blue,
                                ),
                                const SizedBox(height: 8),
                                Text(months[i]),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
            if (selectedIndex != null) ...[
              const SizedBox(height: 16),
              Text(
                '${months[selectedIndex!]}: ₱${values[selectedIndex!].toString().replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (m) => "${m[1]},")}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.indigo),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Popular Services Component
class PopularServices extends StatefulWidget {
  const PopularServices({super.key});

  @override
  State<PopularServices> createState() => _PopularServicesState();
}

class _PopularServicesState extends State<PopularServices> {
  String _selectedPeriod = 'This Month';

    List<Map<String, dynamic>> get services {
    if (_selectedPeriod == 'This Month') {
      return [
        {'name': 'Tarpaulin Printing', 'icon': Icons.print, 'percent': 35, 'color': Colors.blue},
        {'name': 'Business Cards', 'icon': Icons.credit_card, 'percent': 28, 'color': Colors.indigo},
        {'name': 'Sticker Printing', 'icon': Icons.sticky_note_2, 'percent': 20, 'color': Colors.green},
        {'name': 'ID Cards', 'icon': Icons.badge, 'percent': 12, 'color': Colors.orange},
        {'name': 'Booklet Printing', 'icon': Icons.menu_book, 'percent': 5, 'color': Colors.purple},
      ];
    } else if (_selectedPeriod == 'Last Month') {
      return [
        {'name': 'Tarpaulin Printing', 'icon': Icons.print, 'percent': 30, 'color': Colors.blue},
        {'name': 'Business Cards', 'icon': Icons.credit_card, 'percent': 25, 'color': Colors.indigo},
        {'name': 'Sticker Printing', 'icon': Icons.sticky_note_2, 'percent': 22, 'color': Colors.green},
        {'name': 'ID Cards', 'icon': Icons.badge, 'percent': 15, 'color': Colors.orange},
        {'name': 'Booklet Printing', 'icon': Icons.menu_book, 'percent': 8, 'color': Colors.purple},
      ];
    } else {
      return [
        {'name': 'Tarpaulin Printing', 'icon': Icons.print, 'percent': 32, 'color': Colors.blue},
        {'name': 'Business Cards', 'icon': Icons.credit_card, 'percent': 24, 'color': Colors.indigo},
        {'name': 'Sticker Printing', 'icon': Icons.sticky_note_2, 'percent': 18, 'color': Colors.green},
        {'name': 'ID Cards', 'icon': Icons.badge, 'percent': 14, 'color': Colors.orange},
        {'name': 'Booklet Printing', 'icon': Icons.menu_book, 'percent': 12, 'color': Colors.purple},
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 16),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Popular Services', 
                  style: TextStyle(
                    fontWeight: FontWeight.bold, 
                    fontSize: 18, 
                    color: Theme.of(context).textTheme.titleLarge?.color ?? (isDark ? Colors.white : Colors.black87)
                  )
                ),
                DropdownButton<String>(
                  value: _selectedPeriod,
                  items: [
                    DropdownMenuItem(value: 'This Month', child: Text('This Month')),
                    DropdownMenuItem(value: 'Last Month', child: Text('Last Month')),
                    DropdownMenuItem(value: 'This Year', child: Text('This Year')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedPeriod = value!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...services.map((service) => _buildService(service)),
          ],
        ),
      ),
    );
  }

  Widget _buildService(Map service) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(service['icon'], color: service['color']),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              service['name'],
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color ?? (isDark ? Colors.white : Colors.black87),
              ),
            )
          ),
          SizedBox(
            width: 120,
            child: LinearProgressIndicator(
              value: (service['percent'] as int) / 100,
              backgroundColor: isDark ? Colors.grey[700] : Colors.grey[200],
              color: service['color'],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${service['percent']}%', 
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyLarge?.color ?? (isDark ? Colors.white : Colors.black87),
            )
          ),
        ],
      ),
    );
  }
}

// AI Insights & Predictions Component
class AIInsightsPredictions extends StatelessWidget {
  const AIInsightsPredictions({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
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
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AI Insights & Predictions', 
              style: TextStyle(
                fontWeight: FontWeight.bold, 
                fontSize: 18,
                color: Theme.of(context).textTheme.titleLarge?.color ?? (isDark ? Colors.white : Colors.black87),
              )
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _insightCard(
                    icon: Icons.trending_up,
                    title: 'Sales Forecast',
                    desc: 'Based on current trends, expect a 15% increase in tarpaulin printing orders next month. Consider increasing inventory levels.',
                    color: isDark ? Colors.blue[900]! : Colors.blue[50]!,
                    iconColor: Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _insightCard(
                    icon: Icons.lightbulb_outline,
                    title: 'Efficiency Opportunity',
                    desc: 'Bundling business cards with flyers could increase average order value by 22%. Consider creating a promotional package.',
                    color: isDark ? Colors.yellow[900]! : Colors.yellow[50]!,
                    iconColor: Colors.amber,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _insightCard(
                    icon: Icons.error_outline,
                    title: 'Potential Risk',
                    desc: 'Sticker production efficiency has dropped 8% in the last 2 weeks. Consider maintenance for the cutting machine.',
                    color: isDark ? Colors.red[900]! : Colors.red[50]!,
                    iconColor: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget _insightCard({required IconData icon, required String title, required String desc, required Color color, required Color iconColor}) {
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: iconColor),
                  const SizedBox(width: 8),
                  Text(
                    title, 
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.titleMedium?.color ?? (isDark ? Colors.white : Colors.black87),
                    )
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                desc, 
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).textTheme.bodyMedium?.color ?? (isDark ? Colors.grey[300] : Colors.grey[700]),
                )
              ),
            ],
          ),
        );
      }
    );
  }
}

// Monthly Sales Chart Component
class MonthlySalesChart extends StatefulWidget {
  const MonthlySalesChart({super.key});

  @override
  State<MonthlySalesChart> createState() => _MonthlySalesChartState();
}

class _MonthlySalesChartState extends State<MonthlySalesChart> {
  BarTouchResponse? _touchedBar;

  @override
  Widget build(BuildContext context) {
    final services = ['Tarpaulin', 'Business Cards', 'Stickers', 'Flyers', 'ID Cards'];
    final prevMonth = [35000.0, 30000.0, 17000.0, 12000.0, 15000.0];
    final currMonth = [42000.0, 43000.0, 20000.0, 15000.0, 17000.0];
    
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
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
            Text(
              'Monthly Sales by Service', 
              style: TextStyle(
                fontWeight: FontWeight.bold, 
                fontSize: 18, 
                color: Theme.of(context).textTheme.titleLarge?.color ?? (isDark ? Colors.white : Colors.black87)
              )
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width < 600 ? 1000 : 900,
                  child: BarChart(
                BarChartData(
                  barGroups: List.generate(services.length, (i) {
                    return BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: prevMonth[i], 
                          color: Colors.lightBlue, 
                          width: 16,
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: 60000,
                            color: Colors.grey.withOpacity(0.1),
                          ),
                        ),
                        BarChartRodData(
                          toY: currMonth[i], 
                          color: Colors.blue, 
                          width: 16,
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: 60000,
                            color: Colors.grey.withOpacity(0.1),
                          ),
                        ),
                      ],
                      barsSpace: 4,
                    );
                  }),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true, 
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${(value / 1000).toInt()}K',
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).textTheme.bodyMedium?.color ?? (isDark ? Colors.grey[300] : Colors.grey[600]),
                            ),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value >= 0 && value < services.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                services[value.toInt()],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).textTheme.bodyMedium?.color ?? (isDark ? Colors.grey[300] : Colors.grey[600]),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                        interval: 1,
                      ),
                    ),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(
                    show: true,
                    horizontalInterval: 10000,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: (isDark ? Colors.grey[600]! : Colors.grey).withOpacity(0.3),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  borderData: FlBorderData(show: true),
                  groupsSpace: 24,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colors.black87,
                      tooltipRoundedRadius: 8,
                      tooltipPadding: const EdgeInsets.all(8),
                      tooltipMargin: 8,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final service = services[group.x.toInt()];
                        final value = rod.toY;
                        final period = rodIndex == 0 ? 'Previous Month' : 'Current Month';
                        final color = rodIndex == 0 ? Colors.lightBlue : Colors.blue;
                        
                        return BarTooltipItem(
                          '$service\n$period: ₱${value.toStringAsFixed(0)}',
                          TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          children: [
                            TextSpan(
                              text: '\n${(value / 1000).toStringAsFixed(1)}K',
                              style: TextStyle(
                                color: color,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    touchCallback: (FlTouchEvent event, BarTouchResponse? response) {
                      setState(() {
                        _touchedBar = response;
                      });
                    },
                  ),
                  minY: 0,
                  maxY: 60000,
                ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: const [
                _Legend(color: Colors.lightBlue, label: 'Previous Month'),
                SizedBox(width: 16),
                _Legend(color: Colors.blue, label: 'Current Month'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;
  const _Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Row(
      children: [
        Container(width: 16, height: 8, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyMedium?.color ?? (isDark ? Colors.grey[300] : Colors.grey[600]),
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

// Revenue Trends Chart Component
class RevenueTrendsChart extends StatefulWidget {
  const RevenueTrendsChart({super.key});

  @override
  State<RevenueTrendsChart> createState() => _RevenueTrendsChartState();
}

class _RevenueTrendsChartState extends State<RevenueTrendsChart> {
  LineTouchResponse? _touchedSpot;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
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
            Text(
              'Revenue Trends', 
              style: TextStyle(
                fontWeight: FontWeight.bold, 
                fontSize: 18, 
                color: Theme.of(context).textTheme.titleLarge?.color ?? (isDark ? Colors.white : Colors.black87)
              )
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 220,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    horizontalInterval: 2000,
                    verticalInterval: 1,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: (isDark ? Colors.grey[600]! : Colors.grey).withOpacity(0.3),
                        strokeWidth: 1,
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: (isDark ? Colors.grey[600]! : Colors.grey).withOpacity(0.1),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true, 
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${(value / 1000).toInt()}K',
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).textTheme.bodyMedium?.color ?? (isDark ? Colors.grey[300] : Colors.grey[600]),
                            ),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
                          if (value >= 0 && value < months.length) {
                            return Text(
                              months[value.toInt()],
                              style: TextStyle(
                                color: Theme.of(context).textTheme.bodyMedium?.color ?? (isDark ? Colors.grey[300] : Colors.grey[600]),
                                fontSize: 12,
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                        interval: 1,
                      ),
                    ),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: true),
                  minX: 0,
                  maxX: 5,
                  minY: 0,
                  maxY: 10000,
                  lineTouchData: LineTouchData(
                    enabled: true,
                    touchTooltipData: LineTouchTooltipData(
                      tooltipBgColor: Colors.black87,
                      tooltipRoundedRadius: 8,
                      tooltipPadding: const EdgeInsets.all(8),
                      tooltipMargin: 8,
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((touchedSpot) {
                          const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
                          final month = months[touchedSpot.x.toInt()];
                          final revenue = touchedSpot.y;
                          
                          return LineTooltipItem(
                            '$month\n₱${revenue.toStringAsFixed(0)}',
                            TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            children: [
                              TextSpan(
                                text: '\n${(revenue / 1000).toStringAsFixed(1)}K',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          );
                        }).toList();
                      },
                    ),
                    touchCallback: (FlTouchEvent event, LineTouchResponse? response) {
                      setState(() {
                        _touchedSpot = response;
                      });
                    },
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 5000),
                        FlSpot(1, 7500),
                        FlSpot(2, 7000),
                        FlSpot(3, 9000),
                        FlSpot(4, 8000),
                        FlSpot(5, 10000),
                      ],
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      dotData: FlDotData(show: true),
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
}

// Service Breakdown Chart Component
class ServiceBreakdownChart extends StatefulWidget {
  const ServiceBreakdownChart({super.key});

  @override
  State<ServiceBreakdownChart> createState() => _ServiceBreakdownChartState();
}

class _ServiceBreakdownChartState extends State<ServiceBreakdownChart> {
  int? touchedIndex;
  PieTouchResponse? pieTouchResponse;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final data = [
      {'label': 'Tarpaulin', 'value': 35.0, 'color': Colors.blue, 'amount': '₱84,000'},
      {'label': 'Business Cards', 'value': 25.0, 'color': Colors.lightBlue, 'amount': '₱60,000'},
      {'label': 'Stickers', 'value': 20.0, 'color': Colors.amber, 'amount': '₱48,000'},
      {'label': 'Flyers', 'value': 15.0, 'color': Colors.pinkAccent, 'amount': '₱36,000'},
      {'label': 'Other', 'value': 5.0, 'color': Colors.green, 'amount': '₱12,000'},
    ];
    
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
            Text(
              'Service Breakdown', 
              style: TextStyle(
                fontWeight: FontWeight.bold, 
                fontSize: 18, 
                color: Theme.of(context).textTheme.titleLarge?.color ?? (isDark ? Colors.white : Colors.black87)
              )
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    enabled: true,
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (event.isInterestedForInteractions &&
                            pieTouchResponse != null &&
                            pieTouchResponse.touchedSection != null) {
                          touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                        } else {
                          touchedIndex = null;
                        }
                      });
                    },
                  ),
                  sections: data.asMap().entries.map((entry) {
                    final index = entry.key;
                    final d = entry.value;
                    final isTouched = index == touchedIndex;
                    
                    return PieChartSectionData(
                      color: d['color'] as Color,
                      value: d['value'] as double,
                      title: isTouched ? '${(d['value'] as double).toInt()}%' : '',
                      titleStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: const [Shadow(color: Colors.black, blurRadius: 2)],
                      ),
                      radius: isTouched ? 110 : 100,
                      titlePositionPercentageOffset: 0.5,
                    );
                  }).toList(),
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: data.asMap().entries.map((entry) {
                final index = entry.key;
                final d = entry.value;
                final isTouched = index == touchedIndex;
                
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isTouched ? (d['color'] as Color).withOpacity(0.1) : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: isTouched ? Border.all(color: d['color'] as Color, width: 1) : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 12, 
                        height: 12, 
                        decoration: BoxDecoration(
                          color: d['color'] as Color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${d['label']} ${(d['value'] as double?)?.toInt() ?? 0}%', 
                            style: TextStyle(
                              color: isDark ? Colors.grey[300] : Colors.grey[700],
                              fontSize: 14,
                              fontWeight: isTouched ? FontWeight.bold : FontWeight.normal,
                            )
                          ),
                          if (isTouched)
                            Text(
                              d['amount'] as String,
                              style: TextStyle(
                                color: d['color'] as Color,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            if (touchedIndex != null && touchedIndex! >= 0 && touchedIndex! < data.length) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (data[touchedIndex!]['color'] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: data[touchedIndex!]['color'] as Color,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: data[touchedIndex!]['color'] as Color,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${data[touchedIndex!]['label']} represents ${data[touchedIndex!]['value']}% of total revenue (${data[touchedIndex!]['amount']})',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium?.color ?? (isDark ? Colors.white : Colors.black87),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Main Dashboard Page
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
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
        title: const Text('Dashboard'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: ProfileMenu(),
          ),
        ],
        iconTheme: Theme.of(context).appBarTheme.iconTheme,
        titleTextStyle: Theme.of(context).appBarTheme.titleTextStyle,
      ),
      drawer: isMobile ? const Drawer(child: Sidebar()) : null,
      body: Column(
        children: [
          Divider(
            height: 1, 
            thickness: 1, 
            color: isDark ? Colors.grey[800]! : const Color(0xFFE5E7EB)
          ),
          Expanded(
            child: Row(
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
                          'Dashboard Overview', 
                          style: TextStyle(
                            fontWeight: FontWeight.bold, 
                            fontSize: 24,
                            color: Theme.of(context).textTheme.titleLarge?.color ?? (isDark ? Colors.white : Colors.black87),
                          )
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Real-time business metrics and insights to monitor your printing business performance',
                          style: TextStyle(
                            color: isDark ? Colors.grey[400] : Colors.grey, 
                            fontSize: 16
                          ),
                        ),
                        const SizedBox(height: 24),
                        const DashboardOverview(),
                        const SizedBox(height: 24),
                        const AIInsights(),
                        const SizedBox(height: 24),
                        const RecentOrders(),
                        const SizedBox(height: 24),
                        const RevenueTrend(),
                        const SizedBox(height: 24),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Expanded(
                              flex: 1,
                              child: PopularServices(),
                            ),
                          ],
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
    );
  }
} 