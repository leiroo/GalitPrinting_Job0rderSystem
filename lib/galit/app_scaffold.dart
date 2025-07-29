import 'package:flutter/material.dart';
import 'sidebar.dart';

/// -------------------------------------------------------------------------
///  Re‑usable app scaffold for every admin page
/// -------------------------------------------------------------------------
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 900;

    return Scaffold(
      drawer: isMobile ? const Drawer(child: Sidebar()) : null,
      body: Column(
        children: [
          _TopBar(title: title),   // unified top bar
          _buildTopBorder(context),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (!isMobile) const Sidebar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 6 : 32,
                      vertical: 32,
                    ),
                    child: child,
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

/* ───────────────────────────────────────────────────────────────────────── */
/*  Top‑bar widget                                                          */
/* ───────────────────────────────────────────────────────────────────────── */
// Replace the _TopBar class in your app_scaffold.dart file with this updated version

class _TopBar extends StatelessWidget {
  const _TopBar({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      color: const Color(0xFF2563EB),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Bell with badge - FIXED styling
          Stack(
            clipBehavior: Clip.none,
            children: [
              // Notification bell - FIXED icon color
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15), // Slightly more visible background
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.notifications_none_rounded,
                  color: Colors.white, // PURE WHITE - no opacity
                  size: 24,
                ),
              ),
              // Badge - SMALLER size
              Positioned(
                right: 4, // Better positioning
                top: 4,   // Better positioning  
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2), // Better padding
                  decoration: BoxDecoration(
                    color: const Color(0xFFDC2626), // Slightly darker red for better contrast
                    borderRadius: BorderRadius.circular(10), // More rounded
                    border: Border.all(
                      color: Colors.white,
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 18, // Smaller minimum width
                    minHeight: 18, // Smaller minimum height
                  ),
                  child: const Text(
                    '5',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11, // Slightly larger for readability
                      fontWeight: FontWeight.w600, // Less bold
                      height: 1.0, // Tighter line height
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 24),

          // Rest of your code remains the same...
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: ClipOval(
                  child: Image.asset('assets/logo.jpg', fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 14),

              // Centered text block
              IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'System Administrator',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Administrator',
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const Spacer(),

          // Dropdown arrow
          const Icon(Icons.keyboard_arrow_down_rounded,
              color: Colors.white, size: 32),
        ],
      ),
    );
  }
}

/* ───────────────────────────────────────────────────────────────────────── */
Widget _buildTopBorder(BuildContext context) => Divider(
      height: 1,
      thickness: 1,
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.grey[800]
          : const Color(0xFFE5E7EB),
    );