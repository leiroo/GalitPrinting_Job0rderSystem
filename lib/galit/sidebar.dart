import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';

// Notification Data Model
class NotificationItem {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final NotificationType type;
  final bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    this.isRead = false,
  });
}

enum NotificationType {
  order,
  payment,
  inventory,
  system,
}

// Profile Menu Component
class ProfileMenu extends StatelessWidget {
  const ProfileMenu({super.key});

  void _handleMenuSelection(BuildContext context, String value) {
    switch (value) {
      case 'profile':
      case 'settings':
        // Both profile and settings go to settings page
        Navigator.pushReplacementNamed(context, '/settings');
        break;
      case 'logout':
        // Show logout confirmation dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Logout'),
              content: const Text('Are you sure you want to logout?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                    Navigator.pushReplacementNamed(context, '/login'); // Go to login
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Logout'),
                ),
              ],
            );
          },
        );
        break;
    }
  }

  void _showNotificationsDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final deviceWidth = MediaQuery.of(context).size.width;
    final isMobile = deviceWidth < 600;
    
    // Sample notifications data - in real app, this would come from a database
    final notifications = [
      NotificationItem(
        id: '1',
        title: 'New Order Received',
        message: 'Order JO-2044401 from Maria Santos for banner printing (₱8,500)',
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
        type: NotificationType.order,
      ),
      NotificationItem(
        id: '2',
        title: 'Low Stock Alert',
        message: 'Vinyl Sticker Material is running low (8 meters remaining)',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        type: NotificationType.inventory,
      ),
      NotificationItem(
        id: '3',
        title: 'Payment Completed',
        message: 'Payment received for Order JO-701050 (₱1,200) via GCash',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        type: NotificationType.payment,
      ),
      NotificationItem(
        id: '4',
        title: 'Order Status Update',
        message: 'Order JO-799910 (Photo Printing) is now In Progress',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        type: NotificationType.order,
      ),
      NotificationItem(
        id: '5',
        title: 'System Maintenance',
        message: 'Scheduled maintenance for printer #2 at 10:00 PM tonight',
        timestamp: DateTime.now().subtract(const Duration(hours: 8)),
        type: NotificationType.system,
      ),
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: isMobile ? deviceWidth * 0.95 : deviceWidth * 0.4,
            constraints: BoxConstraints(
              maxWidth: 500,
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[800] : Colors.grey[50],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.notifications,
                        color: isDark ? Colors.blue[300] : Colors.blue[600],
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Notifications',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.titleLarge?.color,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${notifications.length}',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
                // Notifications List
                Expanded(
                  child: ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notification = notifications[index];
                      return _buildNotificationTile(context, notification, isDark);
                    },
                  ),
                ),
                // Footer
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[800] : Colors.grey[50],
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          // TODO: Mark all as read
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('All notifications marked as read')),
                          );
                        },
                        icon: const Icon(Icons.done_all),
                        label: const Text('Mark all as read'),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          // TODO: Navigate to notifications page
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Notifications page coming soon!')),
                          );
                        },
                        icon: const Icon(Icons.list),
                        label: const Text('View all'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNotificationTile(BuildContext context, NotificationItem notification, bool isDark) {
    IconData iconData;
    Color iconColor;
    
    switch (notification.type) {
      case NotificationType.order:
        iconData = Icons.shopping_cart;
        iconColor = Colors.blue;
        break;
      case NotificationType.payment:
        iconData = Icons.payment;
        iconColor = Colors.green;
        break;
      case NotificationType.inventory:
        iconData = Icons.inventory;
        iconColor = Colors.orange;
        break;
      case NotificationType.system:
        iconData = Icons.settings;
        iconColor = Colors.purple;
        break;
    }

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
            width: 1,
          ),
        ),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            iconData,
            color: iconColor,
            size: 20,
          ),
        ),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.titleMedium?.color,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              notification.message,
              style: TextStyle(
                color: isDark ? Colors.grey[300] : Colors.grey[600],
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _getTimeAgo(notification.timestamp),
              style: TextStyle(
                color: isDark ? Colors.grey[500] : Colors.grey[400],
                fontSize: 11,
              ),
            ),
          ],
        ),
        trailing: !notification.isRead
            ? Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              )
            : null,
        onTap: () {
          // TODO: Mark as read and handle notification action
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Handling notification: ${notification.title}'),
              duration: const Duration(seconds: 2),
            ),
          );
        },
      ),
    );
  }

  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    if (isMobile) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Notification Bell with Badge - UPDATED with improved styling
          Stack(
            children: [
              IconButton(
                icon: Icon(
                  Icons.notifications_outlined,
                  color: Colors.white, // FIXED: Always white in top bar context
                  size: 28,
                ),
                onPressed: () => _showNotificationsDialog(context),
              ),
              // SMALLER red notification badge
              Positioned(
                right: 8,  // Better positioning
                top: 8,    // Better positioning
                child: Container(
                  padding: const EdgeInsets.all(2), // Smaller padding
                  decoration: BoxDecoration(
                    color: const Color(0xFFDC2626), // Consistent red color
                    borderRadius: BorderRadius.circular(8), // Smaller radius
                    border: Border.all(
                      color: Colors.white,
                      width: 1,
                    ),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16, // Smaller
                    minHeight: 16, // Smaller
                  ),
                  child: const Text(
                    '5',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10, // Smaller font
                      fontWeight: FontWeight.w600,
                      height: 1.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          PopupMenuButton<String>(
            icon: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.deepPurple,
              backgroundImage: const AssetImage('assets/logo.jpg'),
              child: null,
            ),
            onSelected: (value) => _handleMenuSelection(context, value),
            itemBuilder: (context) => [
              PopupMenuItem(value: 'profile', child: ListTile(leading: const Icon(Icons.person), title: const Text('Your Profile'))),
              PopupMenuItem(value: 'settings', child: ListTile(leading: const Icon(Icons.settings), title: const Text('Settings'))),
              PopupMenuItem(value: 'logout', child: ListTile(leading: const Icon(Icons.logout), title: const Text('Logout'))),
            ],
          ),
        ],
      );
    }
    return Row(
      children: [
        // Notification Bell with Badge - UPDATED with improved styling
        Stack(
          children: [
            IconButton(
              icon: Icon(
                Icons.notifications_outlined,
                color: Colors.white, // FIXED: Always white in top bar context
                size: 28,
              ),
              onPressed: () => _showNotificationsDialog(context),
            ),
            // SMALLER red notification badge
            Positioned(
              right: 8,  // Better positioning
              top: 8,    // Better positioning
              child: Container(
                padding: const EdgeInsets.all(2), // Smaller padding
                decoration: BoxDecoration(
                  color: const Color(0xFFDC2626), // Consistent red color
                  borderRadius: BorderRadius.circular(8), // Smaller radius
                  border: Border.all(
                    color: Colors.white,
                    width: 1,
                  ),
                ),
                constraints: const BoxConstraints(
                  minWidth: 16, // Smaller
                  minHeight: 16, // Smaller
                ),
                child: const Text(
                  '5',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10, // Smaller font
                    fontWeight: FontWeight.w600,
                    height: 1.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 16),
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.deepPurple,
          backgroundImage: const AssetImage('assets/logo.jpg'),
          child: null,
        ),
        const SizedBox(width: 8),
        // Fixed text alignment to center vertically with avatar
        IntrinsicHeight(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'System Administrator', 
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.2,
                )
              ),
              SizedBox(height: 1), // Small gap between texts
              Text(
                'Administrator', 
                style: TextStyle(
                  fontSize: 12, 
                  color: Colors.white70,
                  height: 1.2,
                )
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        PopupMenuButton<String>(
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[400] : Colors.grey,
          ),
          onSelected: (value) => _handleMenuSelection(context, value),
          itemBuilder: (context) => [
            PopupMenuItem(value: 'profile', child: ListTile(leading: const Icon(Icons.person), title: const Text('Your Profile'))),
            PopupMenuItem(value: 'settings', child: ListTile(leading: const Icon(Icons.settings), title: const Text('Settings'))),
            PopupMenuItem(value: 'logout', child: ListTile(leading: const Icon(Icons.logout), title: const Text('Logout'))),
          ],
        ),
      ],
    );
  }
}

// Sidebar Component
class Sidebar extends StatelessWidget {
  final bool collapsed;
  final VoidCallback? onCollapse;
  const Sidebar({super.key, this.collapsed = false, this.onCollapse});

  @override
  Widget build(BuildContext context) {
    final String? currentRoute = ModalRoute.of(context)?.settings.name;
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Container(
      width: collapsed ? 72 : 260,
      color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1E293B) : Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            const SizedBox(height: 20),
            if (!collapsed)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Circular Logo Area
                    Center(
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF2563EB),
                          border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1E293B) : Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/logo.jpg',
                            width: 64,
                            height: 64,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'GALIT Digital Printing Services',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        color: Theme.of(context).textTheme.titleLarge?.color,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Job Order Management System',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[400] : Colors.grey,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            if (!collapsed) const SizedBox(height: 8),
            _SidebarItem(
              icon: Icons.grid_view,
              label: 'Dashboard',
              active: currentRoute == '/dashboard',
              collapsed: collapsed,
              onTap: () {
                if (currentRoute != '/dashboard') {
                  Navigator.pushReplacementNamed(context, '/dashboard');
                }
              },
            ),
            _SidebarItem(
              icon: Icons.assignment_outlined,
              label: 'Job Orders',
              active: currentRoute == '/job-orders',
              collapsed: collapsed,
              onTap: () {
                if (currentRoute != '/job-orders') {
                  Navigator.pushReplacementNamed(context, '/job-orders');
                }
              },
            ),
            _SidebarItem(
              icon: Icons.inventory_2_outlined,
              label: 'Inventory',
              active: currentRoute == '/inventory',
              collapsed: collapsed,
              onTap: () {
                if (currentRoute != '/inventory') {
                  Navigator.pushReplacementNamed(context, '/inventory');
                }
              },
            ),
            _SidebarItem(
              icon: Icons.receipt_long,
              label: 'Payments',
              active: currentRoute == '/payments',
              collapsed: collapsed,
              onTap: () {
                if (currentRoute != '/payments') {
                  Navigator.pushReplacementNamed(context, '/payments');
                }
              },
            ),
            _SidebarItem(
              icon: Icons.show_chart,
              label: 'Analytics',
              active: currentRoute == '/analytics',
              collapsed: collapsed,
              onTap: () {
                if (currentRoute != '/analytics') {
                  Navigator.pushReplacementNamed(context, '/analytics');
                }
              },
            ),
            _SidebarItem(
              icon: Icons.insert_chart_outlined,
              label: 'Reports',
              active: currentRoute == '/reports',
              collapsed: collapsed,
              onTap: () {
                if (currentRoute != '/reports') {
                  Navigator.pushReplacementNamed(context, '/reports');
                }
              },
            ),
              ],
            ),
          ),
          if (!collapsed)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  Divider(color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[700] : Colors.grey[300]),
                  const SizedBox(height: 8),
                  // Theme Toggle Button
                  _SidebarItem(
                    icon: themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                    label: themeProvider.isDarkMode ? 'Light Mode' : 'Dark Mode',
                    active: false,
                    collapsed: collapsed,
                    onTap: () {
                      themeProvider.toggleTheme();
                    },
                  ),
                  _SidebarItem(
                    icon: Icons.settings,
                    label: 'Settings',
                    active: currentRoute == '/settings',
                    collapsed: collapsed,
                    onTap: () {
                      if (currentRoute != '/settings') {
                        Navigator.pushReplacementNamed(context, '/settings');
                      }
                    },
                  ),
                  _SidebarItem(
                    icon: Icons.logout,
                    label: 'Logout',
                    active: false,
                    collapsed: collapsed,
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final bool collapsed;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.collapsed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: collapsed ? 16 : 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: active 
                  ? (Theme.of(context).brightness == Brightness.dark ? Colors.blue[900] : Colors.blue[50]) 
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: active 
                      ? const Color(0xFF2563EB) 
                      : (Theme.of(context).brightness == Brightness.dark ? Colors.grey[400] : Colors.grey[600]),
                  size: 20,
                ),
                if (!collapsed) ...[
                  const SizedBox(width: 12),
                  Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: active 
                          ? const Color(0xFF2563EB) 
                          : (Theme.of(context).brightness == Brightness.dark ? Colors.grey[400] : Colors.grey[600]),
                      fontSize: 15,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}