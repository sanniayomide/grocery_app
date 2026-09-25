import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/theme.dart';
import '../../core/widgets/app_icon.dart';
import '../catalog/data/product_repository.dart';
import '../catalog/domain/models/product.dart';
import '../catalog/presentation/screens/product_detail_screen.dart';
import '../cart/presentation/providers/cart_providers.dart';
import '../cart/presentation/screens/cart_screen.dart';
import '../home/home_screen.dart';
import '../orders/orders_screen.dart';
import '../wallet/wallet_screen.dart';

class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    // Seed demo products after the widget has been initialized.
    Future.microtask(() async {
      try {
        await ref.read(productRepositoryProvider).seedDemoProductsIfEmpty();
      } catch (error) {
        debugPrint('Error seeding demo products: $error');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartNotifierProvider);

    final screens = [
      HomeScreen(
        onOpenCart: () => _goToTab(1),
        onOpenProduct: (product) => _openProduct(context, product),
      ),
      const CartScreen(),
      const OrdersScreen(),
      const WalletScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: _ShellBottomNav(
        currentIndex: _currentIndex,
        cartCount: cartState.totalItems,
        onTap: _goToTab,
      ),
    );
  }

  void _goToTab(int index) {
    if (index < 0 || index > 3) return;

    if (_currentIndex == index) return;

    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> _openProduct(
    BuildContext context,
    Product product,
  ) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ProductDetailScreen(
          product: product,
        ),
      ),
    );
  }
}

class _ShellBottomNav extends StatelessWidget {
  const _ShellBottomNav({
    required this.currentIndex,
    required this.cartCount,
    required this.onTap,
  });

  final int currentIndex;
  final int cartCount;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(
            color: AppColors.border,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spaceLg,
            vertical: AppDimensions.spaceSm,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: AppIconType.search,
                label: 'Home',
                isActive: currentIndex == 0,
                onTap: () => onTap(0),
              ),
              _NavItem(
                icon: AppIconType.cart,
                label: 'Cart',
                isActive: currentIndex == 1,
                badgeCount: cartCount,
                onTap: () => onTap(1),
              ),
              _NavItem(
                icon: AppIconType.orders,
                label: 'Orders',
                isActive: currentIndex == 2,
                onTap: () => onTap(2),
              ),
              _NavItem(
                icon: AppIconType.wallet,
                label: 'Wallet',
                isActive: currentIndex == 3,
                onTap: () => onTap(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
    this.badgeCount = 0,
  });

  final AppIconType icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final int badgeCount;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spaceSm,
          vertical: AppDimensions.spaceXs,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                AppIcon(
                  icon,
                  isActive: isActive,
                  size: AppDimensions.iconMd,
                ),
                if (badgeCount > 0)
                  Positioned(
                    top: -8,
                    right: -10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 2,
                      ),
                      decoration: const BoxDecoration(
                        gradient: AppGradients.accent,
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            AppDimensions.radiusPill,
                          ),
                        ),
                      ),
                      child: Text(
                        badgeCount > 99 ? '99+' : '$badgeCount',
                        style: AppTypography.badge.copyWith(
                          color: AppColors.textOnPrimary,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(
              height: AppDimensions.spaceXs,
            ),
            Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: isActive ? AppColors.primaryDark : AppColors.textMuted,
                fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
