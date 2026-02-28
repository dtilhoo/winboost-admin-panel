import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/dashboard/dashboard_view.dart';
import '../features/role_approvals/role_approvals_view.dart';
import '../features/withdrawals/withdrawals_view.dart';
import '../features/refunds/refunds_view.dart';
import '../features/wallet_funding/wallet_funding_view.dart';
import '../features/merchant_category/merchant_category_view.dart';
import '../features/merchant_review/merchant_review_view.dart';
import '../features/partnerships/partnerships_view.dart';
import '../features/messaging_moderation/messaging_moderation_view.dart';
import '../features/merchant_counters/merchant_counters_view.dart';
import '../features/in_app_notifications/in_app_notifications_view.dart';
import '../features/audit_logs/audit_logs_view.dart';
import '../features/settings/settings_view.dart';
import '../core/widgets/sidebar.dart';

// Create a GlobalKey for the root Navigator
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);
final GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'shell',
);

CustomTransitionPage buildPageWithDefaultTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 200),
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(opacity: animation, child: child),
  );
}

final goRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  routes: [
    ShellRoute(
      navigatorKey: shellNavigatorKey,
      builder: (context, state, child) {
        return Scaffold(
          body: Row(
            children: [
              const Sidebar(),
              Expanded(
                child: Column(children: [Expanded(child: child)]),
              ),
            ],
          ),
        );
      },
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const DashboardView(),
          ),
        ),
        GoRoute(
          path: '/approvals',
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const RoleApprovalsView(),
          ),
        ),
        GoRoute(
          path: '/merchant-review',
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const MerchantReviewView(),
          ),
        ),
        GoRoute(
          path: '/categories',
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const MerchantCategoryView(),
          ),
        ),
        GoRoute(
          path: '/funding',
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const WalletFundingView(),
          ),
        ),
        GoRoute(
          path: '/withdrawals',
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const WithdrawalsView(),
          ),
        ),
        GoRoute(
          path: '/refunds',
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const RefundsView(),
          ),
        ),
        GoRoute(
          path: '/partnerships',
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const PartnershipsView(),
          ),
        ),
        GoRoute(
          path: '/messages',
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const MessagingModerationView(),
          ),
        ),
        GoRoute(
          path: '/counters',
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const MerchantCountersView(),
          ),
        ),
        GoRoute(
          path: '/notifications',
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const InAppNotificationsView(),
          ),
        ),
        GoRoute(
          path: '/logs',
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const AuditLogsView(),
          ),
        ),
        GoRoute(
          path: '/settings',
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const SettingsView(),
          ),
        ),
      ],
    ),
  ],
);
