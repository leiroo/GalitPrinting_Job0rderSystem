import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'sidebar.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

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
        title: const Text('Analytics'),
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
                    'Analytics Dashboard', 
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      fontSize: 24,
                      color: Theme.of(context).textTheme.titleLarge?.color ?? (isDark ? Colors.white : Colors.black87),
                    )
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Comprehensive analytics and insights for your printing business performance',
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey, 
                      fontSize: 16
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Revenue Trends Section
                  Text(
                    'Revenue Trends',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      fontSize: 20, 
                      color: Theme.of(context).textTheme.titleLarge?.color ?? (isDark ? Colors.white : Colors.black87)
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Track your revenue performance over time with detailed monthly breakdowns',
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey, 
                      fontSize: 14
                    ),
                  ),
                  const SizedBox(height: 16),
                  const RevenueTrendsChart(),
                  const SizedBox(height: 32),
                  
                  // Service Breakdown Section
                  Text(
                    'Service Performance',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      fontSize: 20, 
                      color: Theme.of(context).textTheme.titleLarge?.color ?? (isDark ? Colors.white : Colors.black87)
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Analyze which services contribute most to your business revenue',
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey, 
                      fontSize: 14
                    ),
                  ),
                  const SizedBox(height: 16),
                  const ServiceBreakdownChart(),
                  const SizedBox(height: 32),
                  
                  // Monthly Sales Section
                  Text(
                    'Monthly Sales Comparison',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      fontSize: 20, 
                      color: Theme.of(context).textTheme.titleLarge?.color ?? (isDark ? Colors.white : Colors.black87)
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Compare current month sales with previous month across all services',
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey, 
                      fontSize: 14
                    ),
                  ),
                  const SizedBox(height: 16),
                  const MonthlySalesChart(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 