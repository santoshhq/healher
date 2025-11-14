// Improved Flutter bottom navigation and screens
// Single-file demo: Provider state, modern "React-like" UI, responsive, animated
// Paste this into a Dart file (e.g. lib/flutter_restyle_bottom_nav.dart)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

// ---------------------------
// Theme & Design Tokens
// ---------------------------
const Color kPrimary = Color(0xFFD81B60);
const Color kPrimaryLight = Color(0xFFFF66B2);
const Color kBg = Color(0xFFF8F6FB);
const double kRadius = 16.0;

final _cardShadow = [
  BoxShadow(
    color: Colors.black.withOpacity(0.06),
    blurRadius: 18,
    offset: Offset(0, 10),
  ),
];

// ---------------------------
// Navigation Model (Provider)
// ---------------------------
class NavigationModel extends ChangeNotifier {
  int _index = 2; // center home
  int get index => _index;
  setIndex(int i) {
    if (_index == i) return;
    _index = i;
    notifyListeners();
  }
}

// ---------------------------
// App Entry (for demo)
// ---------------------------
class RestyledApp extends StatelessWidget {
  const RestyledApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NavigationModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'HealHer — Modern UI',
        theme: ThemeData(
          scaffoldBackgroundColor: kBg,
          textTheme: GoogleFonts.poppinsTextTheme(),
          primaryColor: kPrimary,
          useMaterial3: true,
        ),
        home: const BottomNavigationShell(),
      ),
    );
  }
}

// ---------------------------
// Bottom Navigation Shell
// ---------------------------
class BottomNavigationShell extends StatelessWidget {
  const BottomNavigationShell({Key? key}) : super(key: key);

  final List<Widget> _pages = const [
    PeriodTrackerPage(),
    HealthPage(),
    HomePage(),
    BarcodeScannerPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final nav = context.watch<NavigationModel>();

    return Scaffold(
      extendBody: true,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        switchInCurve: Curves.easeOutCubic,
        child: _pages[nav.index],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => nav.setIndex(2),
        elevation: 6,
        backgroundColor: kPrimary,
        child: Icon(Icons.home, size: 28, color: Colors.white),
      ),
      bottomNavigationBar: _CustomBottomBar(
        currentIndex: nav.index,
        onTap: (i) => nav.setIndex(i),
      ),
    );
  }
}

// ---------------------------
// Custom Bottom Bar — Modern, subtle
// ---------------------------
class _CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _CustomBottomBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final items = <Map<String, dynamic>>[
      {'icon': Icons.calendar_today, 'label': 'Cycle'},
      {'icon': Icons.favorite, 'label': 'Health'},
      {'icon': Icons.home, 'label': 'Home'},
      {'icon': Icons.qr_code_scanner, 'label': 'Scan'},
      {'icon': Icons.person, 'label': 'Profile'},
    ];

    return SafeArea(
      minimum: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: _cardShadow,
        ),
        child: Row(
          children: List.generate(items.length, (i) {
            // Leave center slot for FAB
            if (i == 2) {
              return Expanded(child: SizedBox());
            }
            final displayIndex = i < 2 ? i : i; // mapping preserved

            return Expanded(
              child: _NavButton(
                icon: items[i]['icon'],
                label: items[i]['label'],
                selected: currentIndex == i,
                onTap: () => onTap(i),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        decoration: BoxDecoration(
          color: selected ? kPrimary.withOpacity(0.08) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22, color: selected ? kPrimary : Colors.grey[600]),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 280),
              style: TextStyle(
                fontSize: selected ? 12 : 11,
                color: selected ? kPrimary : Colors.grey[600],
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------
// Reusable App Scaffold
// ---------------------------
class AppSectionScaffold extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final Widget child;

  const AppSectionScaffold({
    Key? key,
    required this.title,
    required this.child,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: _cardShadow,
                  ),
                  child: Icon(
                    Icons.local_fire_department,
                    color: kPrimaryLight,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Make small daily improvements',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------
// Page Implementations (clean, modular)
// ---------------------------

class PeriodTrackerPage extends StatelessWidget {
  const PeriodTrackerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppSectionScaffold(
      title: 'Period Tracker',
      child: SingleChildScrollView(
        child: Column(
          children: [
            _primaryCard(
              child: Column(
                children: [
                  _bigCircle(icon: Icons.calendar_month, color: kPrimaryLight),
                  const SizedBox(height: 18),
                  Text(
                    'Predict your cycle',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Accurate cycle & period predictions',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            _featureGrid(context, [
              {
                'icon': Icons.insights,
                'title': 'Insights',
                'desc': 'Patterns & analytics',
              },
              {
                'icon': Icons.notifications,
                'title': 'Reminders',
                'desc': 'Never miss a pill',
              },
              {
                'icon': Icons.analytics,
                'title': 'Trends',
                'desc': 'Health correlations',
              },
            ]),
            const SizedBox(height: 18),
            _compactCard(
              title: 'Update cycle data',
              subtitle: 'Tap to add a new cycle entry',
              actionLabel: 'Add',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _primaryCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kRadius),
        boxShadow: _cardShadow,
      ),
      child: child,
    );
  }

  Widget _bigCircle({required IconData icon, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color.withOpacity(0.95), kPrimary]),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: kPrimary.withOpacity(0.18),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Icon(icon, size: 48, color: Colors.white),
    );
  }

  Widget _featureGrid(BuildContext context, List<Map<String, dynamic>> items) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: items.map((it) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: _cardShadow,
            ),
            child: Column(
              children: [
                Icon(it['icon'] as IconData, size: 24, color: kPrimary),
                const SizedBox(height: 6),
                Text(
                  it['title']!,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  it['desc']!,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _compactCard({
    required String title,
    required String subtitle,
    required String actionLabel,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: _cardShadow,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(actionLabel),
          ),
        ],
      ),
    );
  }
}

class HealthPage extends StatelessWidget {
  const HealthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppSectionScaffold(
      title: 'Health & Workouts',
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _statCard('Steps', '1,234', Icons.directions_walk),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _statCard(
                    'Calories',
                    '245',
                    Icons.local_fire_department,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [kPrimaryLight, kPrimary]),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: kPrimary.withOpacity(0.16),
                    blurRadius: 16,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Today's Goal",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: 0.65,
                    minHeight: 8,
                    backgroundColor: Colors.white24,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '6,500 / 10,000 steps',
                    style: GoogleFonts.poppins(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Column(
              children: [
                _actionTile(
                  'Yoga & Meditation',
                  '20 min',
                  Icons.self_improvement,
                ),
                const SizedBox(height: 12),
                _actionTile('Cardio Training', '30 min', Icons.fitness_center),
                const SizedBox(height: 12),
                _actionTile(
                  'Strength Training',
                  '45 min',
                  Icons.sports_gymnastics,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: _cardShadow,
      ),
      child: Column(
        children: [
          Icon(icon, color: kPrimary, size: 28),
          const SizedBox(height: 8),
          Text(value, style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(
            label,
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _actionTile(String title, String subtitle, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: _cardShadow,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: kPrimary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: kPrimary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () {},
            child: Icon(Icons.play_arrow, color: kPrimary),
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppSectionScaffold(
      title: 'Welcome Back! 👋',
      trailing: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: _cardShadow,
        ),
        child: Icon(Icons.notifications_active, color: kPrimary),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [kPrimaryLight, kPrimary]),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: kPrimary.withOpacity(0.14),
                    blurRadius: 12,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Health Dashboard',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Overview of your vitals',
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _tinyStat('Sleep', '8h 20m'),
                      const SizedBox(width: 12),
                      _tinyStat('Water', '2.1L'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Quick Actions',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _quickAction('upload Reports', Icons.upload_file),
                _quickAction('Gynologist', Icons.local_hospital),
                _quickAction('Talk with Ai', Icons.smart_toy),
                _quickAction('Community', Icons.lightbulb),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _tinyStat(String label, String value) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        value,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        label,
        style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12),
      ),
    ],
  );

  Widget _quickAction(String title, IconData icon) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: _cardShadow,
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 28, color: kPrimary),
        const SizedBox(height: 8),
        Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ],
    ),
  );
}

class BarcodeScannerPage extends StatelessWidget {
  const BarcodeScannerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppSectionScaffold(
      title: 'Food Scanner',
      child: Column(
        children: [
          Container(
            height: 300,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: _cardShadow,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [kPrimaryLight, kPrimary],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: kPrimary.withOpacity(0.16),
                          blurRadius: 12,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.qr_code_scanner,
                      size: 70,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Scan product barcodes for nutrition',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Start Scanning',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Recent Scans',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 12),
          _recentItem('Apple', '52 cal'),
          const SizedBox(height: 8),
          _recentItem('Yogurt', '150 cal'),
        ],
      ),
    );
  }

  Widget _recentItem(String name, String cal) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: _cardShadow,
    ),
    child: Row(
      children: [
        CircleAvatar(
          backgroundColor: kPrimary.withOpacity(0.08),
          child: Icon(Icons.food_bank, color: kPrimary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            name,
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
        ),
        Text(cal, style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
      ],
    ),
  );
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppSectionScaffold(
      title: 'Profile',
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [kPrimaryLight, kPrimary]),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: kPrimary.withOpacity(0.14),
                    blurRadius: 12,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 36, color: kPrimary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Jane Doe',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'janedoe@healher.com',
                          style: GoogleFonts.poppins(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: kPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('Edit'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _menuTile(Icons.person_outline, 'Personal Information'),
            const SizedBox(height: 8),
            _menuTile(Icons.medical_information, 'Health Records'),
            const SizedBox(height: 8),
            _menuTile(Icons.notifications_outlined, 'Notifications'),
            const SizedBox(height: 8),
            _menuTile(Icons.lock_outline, 'Privacy & Security'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      title: Text(
                        'Logout',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      content: Text(
                        'Are you sure you want to logout?',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.poppins(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/',
                              (route) => false,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Logout',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('Logout', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuTile(IconData icon, String title) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: _cardShadow,
    ),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: kPrimary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: kPrimary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
        ),
        Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black54),
      ],
    ),
  );
}

// ---------------------------
// End of file
// ---------------------------
