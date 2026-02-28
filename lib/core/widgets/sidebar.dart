import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/auth/cubit/auth_cubit.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      decoration: const BoxDecoration(
        color: AppColors.panel, // Fallback
        border: Border(right: BorderSide(color: AppColors.line)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0x0AFFFFFF), // rgba(255,255,255,.04)
            Color(0x05FFFFFF), // rgba(255,255,255,.02)
          ],
        ),
      ),
      child: Column(
        children: [
          _buildBrand(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              children: [
                _MenuItem(
                  title: 'Dashboard',
                  icon: Icons.dashboard_outlined,
                  route: '/',
                  isActive: GoRouterState.of(context).matchedLocation == '/',
                ),
                _MenuItem(
                  title: 'Role Approvals',
                  icon: Icons.verified_user_outlined,
                  route: '/approvals',
                  isActive: GoRouterState.of(
                    context,
                  ).matchedLocation.startsWith('/approval'),
                ),
                _MenuItem(
                  title: 'Merchant Profile Review',
                  icon: Icons.store_outlined,
                  route: '/merchant-review',
                  isActive: GoRouterState.of(
                    context,
                  ).matchedLocation.startsWith('/merchant-review'),
                ),
                _MenuItem(
                  title: 'Category & Commission',
                  icon: Icons.category_outlined,
                  route: '/categories',
                  isActive: GoRouterState.of(
                    context,
                  ).matchedLocation.startsWith('/categories'),
                ),
                _MenuItem(
                  title: 'Wallet Funding',
                  icon: Icons.account_balance_wallet_outlined,
                  route: '/funding',
                  isActive: GoRouterState.of(
                    context,
                  ).matchedLocation.startsWith('/funding'),
                ),
                _MenuItem(
                  title: 'Withdrawals',
                  icon: Icons.money_off_outlined,
                  route: '/withdrawals',
                  isActive: GoRouterState.of(
                    context,
                  ).matchedLocation.startsWith('/withdrawals'),
                ),
                _MenuItem(
                  title: 'Refunds',
                  icon: Icons.settings_backup_restore_outlined,
                  route: '/refunds',
                  isActive: GoRouterState.of(
                    context,
                  ).matchedLocation.startsWith('/refunds'),
                ),
                _MenuItem(
                  title: 'Partnerships',
                  icon: Icons.handshake_outlined,
                  route: '/partnerships',
                  isActive: GoRouterState.of(
                    context,
                  ).matchedLocation.startsWith('/partnerships'),
                ),
                _MenuItem(
                  title: 'Moderation',
                  icon: Icons.message_outlined,
                  route: '/messages',
                  isActive: GoRouterState.of(
                    context,
                  ).matchedLocation.startsWith('/messages'),
                ),
                _MenuItem(
                  title: 'Counters',
                  icon: Icons.calculate_outlined,
                  route: '/counters',
                  isActive: GoRouterState.of(
                    context,
                  ).matchedLocation.startsWith('/counters'),
                ),
                _MenuItem(
                  title: 'Notifications',
                  icon: Icons.notifications_outlined,
                  route: '/notifications',
                  isActive: GoRouterState.of(
                    context,
                  ).matchedLocation.startsWith('/notifications'),
                ),
                _MenuItem(
                  title: 'Audit Logs',
                  icon: Icons.list_alt_outlined,
                  route: '/logs',
                  isActive: GoRouterState.of(
                    context,
                  ).matchedLocation.startsWith('/logs'),
                ),
                _MenuItem(
                  title: 'Settings',
                  icon: Icons.settings_outlined,
                  route: '/settings',
                  isActive: GoRouterState.of(
                    context,
                  ).matchedLocation.startsWith('/settings'),
                ),
              ],
            ),
          ),
          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildBrand() {
    return Container(
      padding: const EdgeInsets.only(top: 16, bottom: 14, left: 14, right: 14),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.line)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0x5900C853), Color(0x2E18D36A)],
              ),
              border: Border.all(color: const Color(0x4000C853)),
            ),
            alignment: Alignment.center,
            child: const Text(
              'WB',
              style: TextStyle(
                color: AppColors.brand,
                fontWeight: FontWeight.w900,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'WinBoost Admin',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'MVP operations console',
                  style: TextStyle(fontSize: 12, color: AppColors.muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 12, bottom: 16, left: 14, right: 14),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _FooterPill(text: '🟢 DEV • INFO/ERROR logs'),
          const SizedBox(height: 10),
          _FooterPill(text: '🛡️ Manual payouts • No gateway'),
          const SizedBox(height: 16),
          InkWell(
            onTap: () {
              context.read<AuthCubit>().logout();
            },
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0x1EEF4444)),
                color: const Color(0x0AEF4444),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.logout, size: 16, color: AppColors.danger),
                  SizedBox(width: 8),
                  Text(
                    'Logout',
                    style: TextStyle(
                      color: AppColors.danger,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
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
}

class _MenuItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final String route;
  final bool isActive;

  const _MenuItem({
    required this.title,
    required this.icon,
    required this.route,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.go(route),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: isActive ? const Color(0x1F00C853) : Colors.transparent,
          border: isActive
              ? Border.all(color: const Color(0x2E00C853))
              : Border.all(color: Colors.transparent),
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: isActive
                    ? const Color(0x2E00C853)
                    : const Color(0x0CFFFFFF),
                border: Border.all(
                  color: isActive
                      ? const Color(0x3800C853)
                      : const Color(0x14FFFFFF),
                ),
              ),
              child: Icon(
                icon,
                size: 18,
                color: isActive ? AppColors.brand2 : AppColors.muted,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isActive ? AppColors.text : AppColors.muted,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FooterPill extends StatelessWidget {
  final String text;
  const _FooterPill({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0x1EFFFFFF)),
        color: const Color(0x0AFFFFFF),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.muted,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
