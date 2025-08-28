import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF1976D2),
        unselectedItemColor: Colors.grey[600],
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 12,
        ),
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: _NavIcon(
              icon: '🌍',
              isSelected: false,
            ),
            activeIcon: _NavIcon(
              icon: '🌍',
              isSelected: true,
            ),
            label: 'Discover',
          ),
          BottomNavigationBarItem(
            icon: _NavIcon(
              icon: '📋',
              isSelected: false,
            ),
            activeIcon: _NavIcon(
              icon: '📋',
              isSelected: true,
            ),
            label: 'Planner',
          ),
          BottomNavigationBarItem(
            icon: _NavIcon(
              icon: '✈️',
              isSelected: false,
            ),
            activeIcon: _NavIcon(
              icon: '✈️',
              isSelected: true,
            ),
            label: 'Trips',
          ),
          BottomNavigationBarItem(
            icon: _NavIcon(
              icon: '👤',
              isSelected: false,
            ),
            activeIcon: _NavIcon(
              icon: '👤',
              isSelected: true,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final String icon;
  final bool isSelected;

  const _NavIcon({
    required this.icon,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF1976D2).withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        icon,
        style: TextStyle(
          fontSize: 24,
          color: isSelected ? const Color(0xFF1976D2) : Colors.grey[600],
        ),
      ),
    );
  }
}

// Navigation helper class
class NavigationHelper {
  static const int discoverIndex = 0;
  static const int plannerIndex = 1;
  static const int tripsIndex = 2;
  static const int profileIndex = 3;

  static String getTabName(int index) {
    switch (index) {
      case discoverIndex:
        return 'Discover';
      case plannerIndex:
        return 'Planner';
      case tripsIndex:
        return 'Trips';
      case profileIndex:
        return 'Profile';
      default:
        return 'Unknown';
    }
  }

  static bool isValidIndex(int index) {
    return index >= 0 && index <= 3;
  }
}
