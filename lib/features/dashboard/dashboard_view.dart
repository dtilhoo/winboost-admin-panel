import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/dashboard_cubit.dart';
import '../../injection/injection.dart';
import '../../core/widgets/kpi_card.dart';
import '../../core/widgets/data_table_card.dart';
import '../../core/widgets/status_chip.dart';
import '../../core/widgets/drawer_shell.dart';
import '../../core/widgets/buttons.dart';
import '../../data/models/admin_models.dart';
import '../../core/widgets/topbar_search.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          DashboardCubit(metricsUseCase: getIt())..loadDashboard(),
      child: const _DashboardContent(),
    );
  }
}

class _DashboardContent extends StatefulWidget {
  const _DashboardContent();

  @override
  State<_DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<_DashboardContent> {
  bool _isDrawerOpen = false;
  dynamic _selectedItem;

  void _openDrawer(dynamic item) {
    setState(() {
      _selectedItem = item;
      _isDrawerOpen = true;
    });
  }

  void _closeDrawer() {
    setState(() {
      _isDrawerOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.transparent, // Background handled by AppTheme or parent
      body: Stack(
        children: [
          Column(
            children: [
              const TopBarSearch(
                title: 'Dashboard',
                subtitle: 'High-level operational KPIs',
              ),
              Expanded(
                child: BlocBuilder<DashboardCubit, DashboardState>(
                  builder: (context, state) {
                    if (state is DashboardLoading ||
                        state is DashboardInitial) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is DashboardError) {
                      return Center(child: Text('Error: ${state.message}'));
                    }
                    if (state is DashboardLoaded) {
                      return SingleChildScrollView(
                        padding: const EdgeInsets.only(
                          left: 18,
                          right: 18,
                          bottom: 60,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // KPI Grid
                            GridView.count(
                              crossAxisCount: 4,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisSpacing: 14,
                              mainAxisSpacing: 14,
                              childAspectRatio: 1.8,
                              children: [
                                KpiCard(
                                  label: 'Pending Merchant Apps',
                                  value: state.metrics['pendingMerchantApps']
                                      .toString(),
                                  hint: 'KYC queue',
                                ),
                                KpiCard(
                                  label: 'Pending Creator Apps',
                                  value: state.metrics['pendingCreatorApps']
                                      .toString(),
                                  hint: 'Approval queue',
                                ),
                                KpiCard(
                                  label: 'Pending Top-Ups',
                                  value: state.metrics['pendingTopups']
                                      .toString(),
                                  hint: 'Proof validation',
                                ),
                                KpiCard(
                                  label: 'Pending Withdrawals',
                                  value: state.metrics['pendingWithdrawals']
                                      .toString(),
                                  hint: 'Manual payouts',
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            // Recent Activity Table
                            DataTableCard(
                              title: 'Today activity',
                              subtitle: 'Items requiring attention',
                              columns: const [
                                'Event',
                                'Ref',
                                'Amount/Name',
                                'Status',
                                'Actions',
                              ],
                              rows: state.recentActivity.map((item) {
                                String event = '';
                                String ref = '';
                                String amount = '';
                                String status = '';

                                if (item is Topup) {
                                  event = 'Top-up pending';
                                  ref = item.id;
                                  amount = 'Rs ${item.amount}';
                                  status = item.status;
                                } else if (item is Withdrawal) {
                                  event = 'Withdrawal';
                                  ref = item.id;
                                  amount = 'Rs ${item.amount}';
                                  status = item.status;
                                } else if (item is MerchantApp) {
                                  event = 'Merchant application';
                                  ref = item.id;
                                  amount = item.merchant;
                                  status = item.status;
                                }

                                return DataRow(
                                  cells: [
                                    DataCell(Text(event)),
                                    DataCell(Text(ref)),
                                    DataCell(Text(amount)),
                                    DataCell(
                                      StatusChip(
                                        text: status.toUpperCase(),
                                        kind: inferStatusKind(status),
                                      ),
                                    ),
                                    DataCell(
                                      IconButton(
                                        icon: const Icon(
                                          Icons.remove_red_eye_outlined,
                                          size: 18,
                                        ),
                                        onPressed: () => _openDrawer(item),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
          DrawerShell(
            isOpen: _isDrawerOpen,
            title: 'Detail',
            subtitle: _selectedItem is Topup
                ? '${(_selectedItem as Topup).id} • ${(_selectedItem as Topup).merchant}'
                : '—',
            onClose: _closeDrawer,
            body: const Text('Detail body placeholder for MVP.'),
            actions: Buttons.secondary(label: 'Close', onPressed: _closeDrawer),
          ),
        ],
      ),
    );
  }
}
