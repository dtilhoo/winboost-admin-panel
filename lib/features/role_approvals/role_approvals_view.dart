import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/role_approvals_cubit.dart';
import '../../injection/injection.dart';
import '../../core/widgets/data_table_card.dart';
import '../../core/widgets/status_chip.dart';
import '../../core/widgets/drawer_shell.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/topbar_search.dart';
import '../../core/widgets/drawer_details.dart';
import '../../data/models/admin_models.dart';
import '../../core/utils/toast_service.dart';
import '../../core/theme/app_colors.dart';

class RoleApprovalsView extends StatelessWidget {
  const RoleApprovalsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          RoleApprovalsCubit(approvalsUseCase: getIt())..load(),
      child: const _RoleApprovalsContent(),
    );
  }
}

class _RoleApprovalsContent extends StatefulWidget {
  const _RoleApprovalsContent();

  @override
  State<_RoleApprovalsContent> createState() => _RoleApprovalsContentState();
}

class _RoleApprovalsContentState extends State<_RoleApprovalsContent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isDrawerOpen = false;
  dynamic _selectedItem;
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _openDrawer(dynamic item) {
    setState(() {
      _selectedItem = item;
      _notesController.clear();
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
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const TopBarSearch(
                title: 'Role Approvals',
                subtitle: 'Review merchant KYC & influencer applications',
              ),
              TabBar(
                controller: _tabController,
                indicatorColor: AppColors.brand,
                labelColor: AppColors.brand,
                unselectedLabelColor: AppColors.muted,
                tabs: const [
                  Tab(text: 'Merchant Applications'),
                  Tab(text: 'Influencer Applications'),
                ],
              ),
              Expanded(
                child: BlocBuilder<RoleApprovalsCubit, RoleApprovalsState>(
                  builder: (context, state) {
                    if (state is RoleApprovalsLoading ||
                        state is RoleApprovalsInitial) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is RoleApprovalsError) {
                      return Center(child: Text('Error: ${state.message}'));
                    }
                    if (state is RoleApprovalsLoaded) {
                      return TabBarView(
                        controller: _tabController,
                        children: [
                          _buildMerchantAppsTable(context, state.merchantApps),
                          _buildCreatorAppsTable(context, state.creatorApps),
                        ],
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
            title: _selectedItem is MerchantApp
                ? 'Merchant application'
                : 'Influencer application',
            subtitle: _selectedItem != null
                ? '${_selectedItem.id} • ${_selectedItem is MerchantApp ? _selectedItem.merchant : _selectedItem.creator}'
                : '—',
            onClose: _closeDrawer,
            body: _buildDrawerBody(),
            actions: _buildDrawerActions(context),
          ),
        ],
      ),
    );
  }

  Widget _buildMerchantAppsTable(BuildContext context, List<MerchantApp> apps) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: DataTableCard(
        title: 'Merchant applications',
        subtitle: 'Pending → Approved / Rejected',
        columns: const [
          'App ID',
          'Merchant',
          'Email',
          'Submitted',
          'Status',
          'Docs',
          'Actions',
        ],
        rows: apps.map((app) {
          return DataRow(
            cells: [
              DataCell(Text(app.id)),
              DataCell(Text(app.merchant)),
              DataCell(Text(app.email)),
              DataCell(Text(app.submitted)),
              DataCell(
                StatusChip(
                  text: app.status.toUpperCase(),
                  kind: inferStatusKind(app.status),
                ),
              ),
              DataCell(
                StatusChip(
                  text: app.docs,
                  kind: app.docs == 'OK' ? StatusKind.ok : StatusKind.warn,
                ),
              ),
              DataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_red_eye_outlined, size: 18),
                      onPressed: () => _openDrawer(app),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.check_circle_outline,
                        size: 18,
                        color: AppColors.ok,
                      ),
                      onPressed: () {
                        context.read<RoleApprovalsCubit>().approveMerchant(
                          app.id,
                        );
                        ToastService.show('Approved');
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.cancel_outlined,
                        size: 18,
                        color: AppColors.danger,
                      ),
                      onPressed: () {
                        context.read<RoleApprovalsCubit>().rejectMerchant(
                          app.id,
                          '',
                        );
                        ToastService.show('Rejected');
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCreatorAppsTable(BuildContext context, List<CreatorApp> apps) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: DataTableCard(
        title: 'Influencer applications',
        subtitle: 'Pending → Approved / Rejected',
        columns: const [
          'App ID',
          'Creator',
          'Submitted',
          'Social',
          'Status',
          'Actions',
        ],
        rows: apps.map((app) {
          return DataRow(
            cells: [
              DataCell(Text(app.id)),
              DataCell(Text(app.creator)),
              DataCell(Text(app.submitted)),
              DataCell(Text(app.social)),
              DataCell(
                StatusChip(
                  text: app.status.toUpperCase(),
                  kind: inferStatusKind(app.status),
                ),
              ),
              DataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_red_eye_outlined, size: 18),
                      onPressed: () => _openDrawer(app),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.check_circle_outline,
                        size: 18,
                        color: AppColors.ok,
                      ),
                      onPressed: () {
                        context.read<RoleApprovalsCubit>().approveCreator(
                          app.id,
                        );
                        ToastService.show('Approved');
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.cancel_outlined,
                        size: 18,
                        color: AppColors.danger,
                      ),
                      onPressed: () {
                        context.read<RoleApprovalsCubit>().rejectCreator(
                          app.id,
                          '',
                        );
                        ToastService.show('Rejected');
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDrawerBody() {
    if (_selectedItem == null) return const SizedBox.shrink();

    Map<String, dynamic> items = {};
    if (_selectedItem is MerchantApp) {
      final app = _selectedItem as MerchantApp;
      items = {
        'App ID': app.id,
        'Merchant': app.merchant,
        'Email': app.email,
        'Submitted': app.submitted,
        'Docs': app.docs,
        'Status': StatusChip(
          text: app.status.toUpperCase(),
          kind: inferStatusKind(app.status),
        ),
      };
    } else if (_selectedItem is CreatorApp) {
      final app = _selectedItem as CreatorApp;
      items = {
        'App ID': app.id,
        'Creator': app.creator,
        'Submitted': app.submitted,
        'Social': app.social,
        'Status': StatusChip(
          text: app.status.toUpperCase(),
          kind: inferStatusKind(app.status),
        ),
      };
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DrawerKeyValueGrid(items: items),
        const DrawerSeparator(),
        const Text(
          'Reviewer notes',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        DrawerNotesInput(
          controller: _notesController,
          hintText: 'Add review notes...',
        ),
      ],
    );
  }

  Widget _buildDrawerActions(BuildContext context) {
    if (_selectedItem == null) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Buttons.secondary(label: 'Close', onPressed: _closeDrawer),
        const SizedBox(width: 8),
        Buttons.danger(
          label: 'Reject',
          onPressed: () {
            if (_selectedItem is MerchantApp) {
              context.read<RoleApprovalsCubit>().rejectMerchant(
                (_selectedItem as MerchantApp).id,
                _notesController.text,
              );
            } else {
              context.read<RoleApprovalsCubit>().rejectCreator(
                (_selectedItem as CreatorApp).id,
                _notesController.text,
              );
            }
            ToastService.show('Rejected');
            _closeDrawer();
          },
        ),
        const SizedBox(width: 8),
        Buttons.primary(
          label: 'Approve',
          onPressed: () {
            if (_selectedItem is MerchantApp) {
              context.read<RoleApprovalsCubit>().approveMerchant(
                (_selectedItem as MerchantApp).id,
              );
            } else {
              context.read<RoleApprovalsCubit>().approveCreator(
                (_selectedItem as CreatorApp).id,
              );
            }
            ToastService.show('Approved');
            _closeDrawer();
          },
        ),
      ],
    );
  }
}
