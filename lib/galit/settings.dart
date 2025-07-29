import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'dashboard.dart';
import 'sidebar.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _emailNotifications = true;
  bool _smsNotifications = false;
  bool _orderUpdates = true;
  bool _paymentReminders = true;
  String _language = 'English';
  String _timezone = 'Asia/Manila';

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final themeProvider = Provider.of<ThemeProvider>(context);
    
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
        title: const Text('Settings'),
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
                  Text(
                    'Settings', 
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      fontSize: 28,
                      color: Theme.of(context).textTheme.titleLarge?.color,
                    )
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Customize your account preferences, notification settings, and system configuration',
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[400] : Colors.grey, 
                      fontSize: 16
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Profile Settings
                  _buildSectionCard(
                    'Profile Settings',
                    Icons.person,
                    [
                      _buildProfileInfo(),
                      const SizedBox(height: 24),
                      _buildProfileActions(),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Notification Settings
                  _buildSectionCard(
                    'Notification Preferences',
                    Icons.notifications,
                    [
                      _buildNotificationSettings(),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // System Preferences
                  _buildSectionCard(
                    'System Preferences',
                    Icons.settings,
                    [
                      _buildSystemSettings(themeProvider),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Security Settings
                  _buildSectionCard(
                    'Security & Privacy',
                    Icons.security,
                    [
                      _buildSecuritySettings(),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Data Management
                  _buildSectionCard(
                    'Data Management',
                    Icons.storage,
                    [
                      _buildDataManagement(),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveSettings,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Save Changes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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

  Widget _buildSectionCard(String title, IconData icon, List<Widget> children) {
    return Card(
      elevation: 0,
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).brightness == Brightness.dark 
              ? Colors.grey[800]! 
              : const Color(0xFFE5E7EB), 
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
                Icon(icon, color: const Color(0xFF2563EB), size: 24),
                const SizedBox(width: 12),
                Text(
                  title, 
                  style: TextStyle(
                    fontWeight: FontWeight.bold, 
                    fontSize: 20,
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  )
                ),
              ],
            ),
            const SizedBox(height: 24),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Column(
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: const Color(0xFF2563EB),
              backgroundImage: const AssetImage('assets/logo.jpg'),
              child: null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'System Administrator', 
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      fontSize: 18,
                      color: Theme.of(context).textTheme.titleLarge?.color,
                    )
                  ),
                  Text(
                    'Administrator', 
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[400] : Colors.grey
                    )
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.email, 
                        size: 16, 
                        color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[400] : Colors.grey
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'admin@galitprinting.com', 
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[400] : Colors.grey
                        )
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProfileActions() {
    return Column(
      children: [
        _buildActionTile(
          'Edit Profile',
          'Update your personal information',
          Icons.edit,
          () => _showEditProfileDialog(),
        ),
        _buildActionTile(
          'Change Password',
          'Update your account password',
          Icons.lock,
          () => _showChangePasswordDialog(),
        ),
        _buildActionTile(
          'Profile Picture',
          'Upload or change your profile photo',
          Icons.camera_alt,
          () => _showProfilePictureDialog(),
        ),
      ],
    );
  }

  Widget _buildNotificationSettings() {
    return Column(
      children: [
        _buildSwitchTile(
          'Email Notifications',
          'Receive notifications via email',
          _emailNotifications,
          (value) => setState(() => _emailNotifications = value),
        ),
        _buildSwitchTile(
          'SMS Notifications',
          'Receive notifications via SMS',
          _smsNotifications,
          (value) => setState(() => _smsNotifications = value),
        ),
        _buildSwitchTile(
          'Order Updates',
          'Get notified about order status changes',
          _orderUpdates,
          (value) => setState(() => _orderUpdates = value),
        ),
        _buildSwitchTile(
          'Payment Reminders',
          'Receive payment due reminders',
          _paymentReminders,
          (value) => setState(() => _paymentReminders = value),
        ),
      ],
    );
  }

  Widget _buildSystemSettings(ThemeProvider themeProvider) {
    return Column(
      children: [
        _buildDropdownTile(
          'Language',
          'Select your preferred language',
          Icons.language,
          _language,
          ['English', 'Filipino', 'Spanish'],
          (value) => setState(() => _language = value!),
        ),
        _buildDropdownTile(
          'Timezone',
          'Set your local timezone',
          Icons.access_time,
          _timezone,
          ['Asia/Manila', 'UTC', 'America/New_York'],
          (value) => setState(() => _timezone = value!),
        ),

        _buildSwitchTile(
          'Dark Mode',
          'Use dark theme for the application',
          themeProvider.isDarkMode,
          (value) => themeProvider.toggleTheme(),
        ),

      ],
    );
  }

  Widget _buildSecuritySettings() {
    return Column(
      children: [
        _buildActionTile(
          'Two-Factor Authentication',
          'Add an extra layer of security',
          Icons.verified_user,
          () => _showTwoFactorDialog(),
        ),
        _buildActionTile(
          'Login History',
          'View your recent login activity',
          Icons.history,
          () => _showLoginHistoryDialog(),
        ),
        _buildActionTile(
          'Active Sessions',
          'Manage your active sessions',
          Icons.devices,
          () => _showActiveSessionsDialog(),
        ),
        _buildActionTile(
          'Privacy Settings',
          'Control your privacy preferences',
          Icons.privacy_tip,
          () => _showPrivacyDialog(),
        ),
      ],
    );
  }

  Widget _buildDataManagement() {
    return Column(
      children: [

        _buildActionTile(
          'Backup Settings',
          'Create a backup of your settings',
          Icons.backup,
          () => _showBackupDialog(),
        ),
        _buildActionTile(
          'Clear Cache',
          'Clear application cache and temporary files',
          Icons.clear_all,
          () => _showClearCacheDialog(),
        ),
        _buildActionTile(
          'Delete Account',
          'Permanently delete your account',
          Icons.delete_forever,
          () => _showDeleteAccountDialog(),
          isDestructive: true,
        ),
      ],
    );
  }

  Widget _buildActionTile(String title, String subtitle, IconData icon, VoidCallback onTap, {bool isDestructive = false}) {
    return ListTile(
      leading: Icon(icon, color: isDestructive ? Colors.red : const Color(0xFF2563EB)),
      title: Text(
        title, 
        style: TextStyle(
          color: isDestructive ? Colors.red : Theme.of(context).textTheme.titleMedium?.color,
        )
      ),
      subtitle: Text(
        subtitle, 
        style: TextStyle(
          color: isDestructive ? Colors.red.withOpacity(0.7) : 
                 (Theme.of(context).brightness == Brightness.dark ? Colors.grey[400] : Colors.grey),
        )
      ),
      trailing: Icon(
        Icons.arrow_forward_ios, 
        size: 16,
        color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[400] : Colors.grey,
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return ListTile(
      title: Text(
        title, 
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: Theme.of(context).textTheme.titleMedium?.color,
        )
      ),
      subtitle: Text(
        subtitle, 
        style: TextStyle(
          color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[400] : Colors.grey
        )
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF2563EB),
      ),
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildDropdownTile(String title, String subtitle, IconData icon, String value, List<String> options, ValueChanged<String?> onChanged) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF2563EB)),
      title: Text(
        title, 
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: Theme.of(context).textTheme.titleMedium?.color,
        )
      ),
      subtitle: Text(
        subtitle, 
        style: TextStyle(
          color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[400] : Colors.grey
        )
      ),
      trailing: DropdownButton<String>(
        value: value,
        onChanged: onChanged,
        items: options.map((String option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(option),
          );
        }).toList(),
        underline: Container(),
      ),
      contentPadding: EdgeInsets.zero,
    );
  }

  void _saveSettings() {
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings saved successfully!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: const Text('Profile editing functionality will be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: const Text('Password change functionality will be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showProfilePictureDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Profile Picture'),
        content: const Text('Profile picture upload functionality will be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showTwoFactorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Two-Factor Authentication'),
        content: const Text('Two-factor authentication setup will be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showLoginHistoryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login History'),
        content: const Text('Login history will be displayed here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showActiveSessionsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Active Sessions'),
        content: const Text('Active sessions will be displayed here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Settings'),
        content: const Text('Privacy settings will be displayed here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Data'),
        content: const Text('Data export functionality will be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showBackupDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Backup Settings'),
        content: const Text('Backup functionality will be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text('Cache clearing functionality will be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text('This action cannot be undone. Are you sure you want to delete your account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle account deletion
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
} 