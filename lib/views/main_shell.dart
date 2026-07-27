import 'package:flutter/material.dart';
import 'package:planit/core/theme/app_colors.dart';
import 'package:planit/views/home_page.dart';
import 'package:planit/views/pomodoro_page.dart';
import 'package:planit/views/profile_page.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  static const _pages = [HomePage(), PomodoroPage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: _NeoNavBar(
        index: _index,
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}

class _NeoNavBar extends StatelessWidget {
  final int index;
  final ValueChanged<int> onTap;

  const _NeoNavBar({required this.index, required this.onTap});

  static const _items = [
    (icon: Icons.check_box_rounded, label: "Todos"),
    (icon: Icons.timer_rounded, label: "Pomodoro"),
    (icon: Icons.person_rounded, label: "Profile"),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceLight,
        border: Border(
          top: BorderSide(color: AppColors.ink, width: AppStyles.borderWidth),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: List.generate(_items.length, (i) {
              final item = _items[i];
              return Expanded(
                child: _NavItem(
                  icon: item.icon,
                  label: item.label,
                  selected: i == index,
                  onTap: () => onTap(i),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: selected ? AppStyles.border() : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.ink, size: 24),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: selected ? FontWeight.w900 : FontWeight.w600,
                color: AppColors.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
