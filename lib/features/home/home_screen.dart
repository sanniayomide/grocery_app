import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/theme.dart';
import '../../core/widgets/primary_button.dart';
import '../auth/domain/models/app_user.dart';
import '../auth/domain/models/auth_state.dart';
import '../auth/presentation/providers/auth_providers.dart';
import '../catalog/data/product_repository.dart';
import '../catalog/domain/models/product.dart';
import '../catalog/presentation/providers/catalog_providers.dart';
import '../cart/presentation/providers/cart_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({
    super.key,
    required this.onOpenCart,
    required this.onOpenProduct,
  });

  final VoidCallback onOpenCart;
  final ValueChanged<Product> onOpenProduct;

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateNotifierProvider);
    final filteredProducts = ref.watch(filteredProductsProvider);
    final featuredProducts = ref.watch(featuredProductsProvider);
    final categories = ref.watch(categoriesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final searchQuery = ref.watch(productSearchQueryProvider);
    final cartState = ref.watch(cartNotifierProvider);
    final isSigningOut = authState.status == AuthStatus.loading;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primaryDark,
          onRefresh: () async {
            await ref.read(productRepositoryProvider).seedDemoProductsIfEmpty();
            ref.invalidate(allProductsProvider);
          },
          child: ListView(
            padding: const EdgeInsets.all(AppDimensions.spaceLg),
            children: [
              _buildHeader(
                context,
                user: authState.user,
                cartCount: cartState.totalItems,
              ),
              const SizedBox(height: AppDimensions.spaceXl),
              _SearchBar(
                initialValue: searchQuery,
                onCartTap: onOpenCart,
                onChanged: (value) {
                  ref.read(productSearchQueryProvider.notifier).state = value;
                },
              ),
              const SizedBox(height: AppDimensions.spaceXl),
              _SectionHeader(
                title: 'Shop by Category',
                trailing: '${categories.length - 1} groups',
              ),
              const SizedBox(height: AppDimensions.spaceMd),
              SizedBox(
                height: 112,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(width: AppDimensions.spaceMd),
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return _CategoryCard(
                      category: category,
                      isSelected: selectedCategory == category.id,
                      onTap: () {
                        ref.read(selectedCategoryProvider.notifier).state =
                            category.id;
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: AppDimensions.spaceXl),
              _PromoCard(
                onTap: () {
                  ref.read(selectedCategoryProvider.notifier).state =
                      CategoryId.fruits;
                },
              ),
              const SizedBox(height: AppDimensions.spaceXl),
              featuredProducts.when(
                data: (products) => _FeaturedSection(
                  products: products,
                  onOpenProduct: onOpenProduct,
                  onAddToCart: (product) {
                    ref.read(cartNotifierProvider.notifier).addProduct(product);
                    _showAddedSnackBar(context, product.name);
                  },
                ),
                loading: () => const _SectionLoader(title: 'Featured Picks'),
                error: (_, __) => const _SectionError(
                  title: 'Featured Picks',
                  message: 'Could not load featured products yet.',
                ),
              ),
              const SizedBox(height: AppDimensions.spaceXl),
              _SectionHeader(
                title: selectedCategory == CategoryId.all
                    ? 'All Products'
                    : '${_prettyCategory(selectedCategory)} Picks',
                trailing: filteredProducts.maybeWhen(
                  data: (products) => '${products.length} items',
                  orElse: () => '',
                ),
              ),
              const SizedBox(height: AppDimensions.spaceMd),
              filteredProducts.when(
                data: (products) {
                  if (products.isEmpty) {
                    return _EmptyProductsState(
                      onReset: () {
                        ref.read(selectedCategoryProvider.notifier).state =
                            CategoryId.all;
                        ref.read(productSearchQueryProvider.notifier).state = '';
                      },
                    );
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: products.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: AppDimensions.spaceMd,
                      crossAxisSpacing: AppDimensions.spaceMd,
                      childAspectRatio: 0.72,
                    ),
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return _ProductCard(
                        product: product,
                        onTap: () => onOpenProduct(product),
                        onAdd: () {
                          ref
                              .read(cartNotifierProvider.notifier)
                              .addProduct(product);
                          _showAddedSnackBar(context, product.name);
                        },
                      );
                    },
                  );
                },
                loading: () => const _SectionLoader(title: 'All Products'),
                error: (_, __) => _SectionError(
                  title: 'All Products',
                  message: 'Could not load products right now.',
                  actionLabel: 'Load demo data',
                  onAction: () async {
                    await ref
                        .read(productRepositoryProvider)
                        .seedDemoProductsIfEmpty();
                    ref.invalidate(allProductsProvider);
                  },
                ),
              ),
              const SizedBox(height: AppDimensions.spaceXl),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: isSigningOut
                      ? null
                      : () => ref
                          .read(authStateNotifierProvider.notifier)
                          .signOut(),
                  icon: isSigningOut
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.logout_outlined),
                  label: Text(
                    isSigningOut ? 'Signing out...' : 'Sign Out',
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.error,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.error.withValues(alpha: 0.2)),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusMd),
                    ),
                    minimumSize: const Size.fromHeight(52),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context, {
    required AppUser? user,
    required int cartCount,
  }) {
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            gradient: AppGradients.softWash,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
          child: Icon(
            Icons.person_outline,
            color: AppColors.primaryDark,
            size: AppDimensions.iconLg,
          ),
        ),
        const SizedBox(width: AppDimensions.spaceMd),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_getGreeting()}, ${user?.displayName ?? 'Shopper'}',
                style: AppTypography.h3,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppDimensions.spaceXs),
              Text(
                'Fresh groceries delivered fast to your doorstep.',
                style: AppTypography.bodySmall,
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: onOpenCart,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  border: Border.all(color: AppColors.border),
                ),
                child: Icon(
                  Icons.shopping_bag_outlined,
                  color: AppColors.primaryDark,
                  size: AppDimensions.iconMd,
                ),
              ),
              if (cartCount > 0)
                Positioned(
                  top: -4,
                  right: -4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 3,
                    ),
                    decoration: const BoxDecoration(
                      gradient: AppGradients.accent,
                      borderRadius: BorderRadius.all(
                        Radius.circular(AppDimensions.radiusPill),
                      ),
                    ),
                    child: Text(
                      cartCount > 99 ? '99+' : '$cartCount',
                      style: AppTypography.badge.copyWith(
                        color: AppColors.textOnPrimary,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  void _showAddedSnackBar(BuildContext context, String productName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$productName added to cart.'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.success,
      ),
    );
  }

  static String _prettyCategory(CategoryId category) {
    final label = category.name;
    return '${label[0].toUpperCase()}${label.substring(1)}';
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.initialValue,
    required this.onChanged,
    required this.onCartTap,
  });

  final String initialValue;
  final ValueChanged<String> onChanged;
  final VoidCallback onCartTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.surface,
        hintText: 'Search fresh produce, dairy, snacks...',
        hintStyle: AppTypography.bodyMedium,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: AppDimensions.spaceXs),
          child: IconButton(
            onPressed: onCartTap,
            icon: const Icon(Icons.shopping_cart_checkout_outlined),
            color: AppColors.primaryDark,
          ),
        ),
        suffixIconConstraints: const BoxConstraints(minWidth: 56),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          borderSide: const BorderSide(color: AppColors.primaryDark),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.trailing,
  });

  final String title;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(title, style: AppTypography.h2),
        ),
        if (trailing.isNotEmpty)
          Text(
            trailing,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textMuted,
            ),
          ),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  final ProductCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Color(category.bgColorHex);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 90,
        padding: const EdgeInsets.all(AppDimensions.spaceMd),
        decoration: BoxDecoration(
          gradient: isSelected ? AppGradients.primary : null,
          color: isSelected ? null : backgroundColor,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: isSelected ? null : Border.all(color: AppColors.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.textOnPrimary.withValues(alpha: 0.16)
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              ),
              child: Icon(
                IconData(
                  category.iconCodePoint,
                  fontFamily: 'MaterialIcons',
                ),
                color:
                    isSelected ? AppColors.textOnPrimary : AppColors.primaryDark,
                size: AppDimensions.iconMd,
              ),
            ),
            const SizedBox(height: AppDimensions.spaceSm),
            Text(
              category.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodyMedium.copyWith(
                color: isSelected
                    ? AppColors.textOnPrimary
                    : AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PromoCard extends StatelessWidget {
  const _PromoCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceLg),
      decoration: BoxDecoration(
        gradient: AppGradients.primary,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spaceSm,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.textOnPrimary.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusPill,
                    ),
                  ),
                  child: Text(
                    'WEEKEND DEAL',
                    style: AppTypography.badge.copyWith(
                      color: AppColors.textOnPrimary,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceMd),
                Text(
                  'Save on juicy fruits\nand pantry staples',
                  style: AppTypography.h2.copyWith(
                    color: AppColors.textOnPrimary,
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceMd),
                SizedBox(
                  width: 128,
                  child: PrimaryButton(
                    text: 'Explore',
                    onPressed: onTap,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 92,
            height: 92,
            decoration: BoxDecoration(
              color: AppColors.textOnPrimary.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            ),
            alignment: Alignment.center,
            child: const Text(
              '🧺',
              style: TextStyle(fontSize: 40),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturedSection extends StatelessWidget {
  const _FeaturedSection({
    required this.products,
    required this.onOpenProduct,
    required this.onAddToCart,
  });

  final List<Product> products;
  final ValueChanged<Product> onOpenProduct;
  final ValueChanged<Product> onAddToCart;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: 'Featured Picks',
          trailing: '${products.length} picks',
        ),
        const SizedBox(height: AppDimensions.spaceMd),
        SizedBox(
          height: 238,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            separatorBuilder: (_, __) =>
                const SizedBox(width: AppDimensions.spaceMd),
            itemBuilder: (context, index) {
              final product = products[index];
              return SizedBox(
                width: 178,
                child: _ProductCard(
                  product: product,
                  onTap: () => onOpenProduct(product),
                  onAdd: () => onAddToCart(product),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.product,
    required this.onTap,
    required this.onAdd,
  });

  final Product product;
  final VoidCallback onTap;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        child: Ink(
          padding: const EdgeInsets.all(AppDimensions.spaceMd),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 94,
                decoration: BoxDecoration(
                  color: AppColors.primaryTint,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                ),
                alignment: Alignment.center,
                child: Text(
                  product.emojiFallback,
                  style: const TextStyle(fontSize: 42),
                ),
              ),
              const SizedBox(height: AppDimensions.spaceSm),
              if (product.isOrganic)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spaceSm,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusPill,
                    ),
                  ),
                  child: Text(
                    'Organic',
                    style: AppTypography.badge.copyWith(
                      color: AppColors.success,
                    ),
                  ),
                ),
              if (product.isOrganic)
                const SizedBox(height: AppDimensions.spaceSm),
              Text(
                product.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.bodyLarge.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: AppDimensions.spaceXs),
              Text(
                product.unitLabel,
                style: AppTypography.bodySmall,
              ),
              const SizedBox(height: AppDimensions.spaceXs),
              Row(
                children: [
                  Icon(
                    Icons.star_rounded,
                    size: AppDimensions.iconSm,
                    color: AppColors.warning,
                  ),
                  const SizedBox(width: AppDimensions.spaceXs),
                  Text(
                    '${product.rating.toStringAsFixed(1)} (${product.ratingCount})',
                    style: AppTypography.bodySmall,
                  ),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (product.isOnSale)
                          Text(
                            '\$${product.originalPrice!.toStringAsFixed(2)}',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textMuted,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: AppTypography.price,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: onAdd,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        gradient: AppGradients.primary,
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusSm,
                        ),
                      ),
                      child: Icon(
                        Icons.add,
                        color: AppColors.textOnPrimary,
                        size: AppDimensions.iconMd,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionLoader extends StatelessWidget {
  const _SectionLoader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: title, trailing: ''),
        const SizedBox(height: AppDimensions.spaceLg),
        const Center(
          child: CircularProgressIndicator(),
        ),
      ],
    );
  }
}

class _SectionError extends StatelessWidget {
  const _SectionError({
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceLg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(title: title, trailing: ''),
          const SizedBox(height: AppDimensions.spaceSm),
          Text(message, style: AppTypography.bodyMedium),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: AppDimensions.spaceMd),
            SizedBox(
              width: 160,
              child: PrimaryButton(
                text: actionLabel!,
                onPressed: onAction,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _EmptyProductsState extends StatelessWidget {
  const _EmptyProductsState({required this.onReset});

  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceLg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Text(
            'No products match that search yet.',
            style: AppTypography.bodyLarge.copyWith(
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spaceSm),
          Text(
            'Try another keyword or switch back to all categories.',
            style: AppTypography.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spaceLg),
          SizedBox(
            width: 180,
            child: PrimaryButton(
              text: 'Reset Filters',
              onPressed: onReset,
            ),
          ),
        ],
      ),
    );
  }
}
