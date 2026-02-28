import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/withdrawals_cubit.dart';
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

class WithdrawalsView extends StatelessWidget {
  const WithdrawalsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WithdrawalsCubit(walletUseCase: getIt())..load(),
      child: const _WithdrawalsContent(),
    );
  }
}

class _WithdrawalsContent extends StatefulWidget {
  const _WithdrawalsContent();

  @override
  State<_WithdrawalsContent> createState() => _WithdrawalsContentState();
}

class _WithdrawalsContentState extends State<_WithdrawalsContent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isDrawerOpen = false;
  Withdrawal? _selectedItem;
  bool _isMerchant = true; // Track if the drawer is for a merchant withdrawal
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

  void _openDrawer(Withdrawal item, bool isMerchant) {
    setState(() {
      _selectedItem = item;
      _isMerchant = isMerchant;
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
                title: 'Withdrawals',
                subtitle:
                    'Manual approvals & payouts for unused bounds or earnings',
              ),
              TabBar(
                controller: _tabController,
                indicatorColor: AppColors.brand,
                labelColor: AppColors.brand,
                unselectedLabelColor: AppColors.muted,
                tabs: const [
                  Tab(text: 'Merchant Withdrawals'),
                  Tab(text: 'Influencer Withdrawals'),
                ],
              ),
              Expanded(
                child: BlocBuilder<WithdrawalsCubit, WithdrawalsState>(
                  builder: (context, state) {
                    if (state is WithdrawalsLoading ||
                        state is WithdrawalsInitial) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is WithdrawalsError) {
                      return Center(child: Text('Error: ${state.message}'));
                    }
                    if (state is WithdrawalsLoaded) {
                      return TabBarView(
                        controller: _tabController,
                        children: [
                          _buildTable(context, state.merchantWithdrawals, true),
                          _buildTable(context, state.creatorWithdrawals, false),
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
            title: _isMerchant
                ? 'Merchant withdrawal'
                : 'Influencer withdrawal',
            subtitle: _selectedItem != null
                ? '${_selectedItem!.id} • ${_selectedItem!.ownerName}'
                : '—',
            onClose: _closeDrawer,
            body: _buildDrawerBody(),
            actions: _buildDrawerActions(context),
          ),
        ],
      ),
    );
  }

  Widget _buildTable(
    BuildContext context,
    List<Withdrawal> withdrawals,
    bool isMerchant,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: DataTableCard(
        title: isMerchant ? 'Merchant withdrawals' : 'Influencer withdrawals',
        subtitle: 'Pending → Approved → Paid / Rejected',
        columns: [
          'Request ID',
          isMerchant ? 'Merchant' : 'Influencer',
          'Amount',
          'Submitted',
          'Status',
          'Actions',
        ],
        rows: withdrawals.map((w) {
          return DataRow(
            cells: [
              DataCell(Text(w.id)),
              DataCell(Text(w.ownerName)),
              DataCell(Text('Rs ${w.amount}')),
              DataCell(Text(w.submitted)),
              DataCell(
                StatusChip(
                  text: w.status.toUpperCase(),
                  kind: inferStatusKind(w.status),
                ),
              ),
              DataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_red_eye_outlined, size: 18),
                      onPressed: () => _openDrawer(w, isMerchant),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.check_circle_outline,
                        size: 18,
                        color: AppColors.ok,
                      ),
                      onPressed: () {
                        if (isMerchant) {
                          context
                              .read<WithdrawalsCubit>()
                              .updateMerchantWithdrawal(w.id, 'Approved');
                        } else {
                          context
                              .read<WithdrawalsCubit>()
                              .updateCreatorWithdrawal(w.id, 'Approved');
                        }
                        ToastService.show('Approved');
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.payments_outlined,
                        size: 18,
                        color: AppColors.info,
                      ),
                      onPressed: () {
                        if (isMerchant) {
                          context
                              .read<WithdrawalsCubit>()
                              .updateMerchantWithdrawal(w.id, 'Paid');
                        } else {
                          context
                              .read<WithdrawalsCubit>()
                              .updateCreatorWithdrawal(w.id, 'Paid');
                        }
                        ToastService.show('Paid');
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.cancel_outlined,
                        size: 18,
                        color: AppColors.danger,
                      ),
                      onPressed: () {
                        if (isMerchant) {
                          context
                              .read<WithdrawalsCubit>()
                              .updateMerchantWithdrawal(w.id, 'Rejected');
                        } else {
                          context
                              .read<WithdrawalsCubit>()
                              .updateCreatorWithdrawal(w.id, 'Rejected');
                        }
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

    final w = _selectedItem!;
    Map<String, dynamic> items = {
      'Request ID': w.id,
      _isMerchant ? 'Merchant' : 'Influencer': w.ownerName,
      'Amount': 'Rs ${w.amount}',
      'Submitted': w.submitted,
      'Status': StatusChip(
        text: w.status.toUpperCase(),
        kind: inferStatusKind(w.status),
      ),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DrawerKeyValueGrid(items: items),
        const DrawerSeparator(),
        const Text(
          'Payout reference',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        DrawerNotesInput(
          controller: _notesController,
          hintText: 'Enter bank transfer id...',
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
            if (_isMerchant) {
              context.read<WithdrawalsCubit>().updateMerchantWithdrawal(
                _selectedItem!.id,
                'Rejected',
                ref: _notesController.text,
              );
            } else {
              context.read<WithdrawalsCubit>().updateCreatorWithdrawal(
                _selectedItem!.id,
                'Rejected',
                ref: _notesController.text,
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
            if (_isMerchant) {
              context.read<WithdrawalsCubit>().updateMerchantWithdrawal(
                _selectedItem!.id,
                'Approved',
                ref: _notesController.text,
              );
            } else {
              context.read<WithdrawalsCubit>().updateCreatorWithdrawal(
                _selectedItem!.id,
                'Approved',
                ref: _notesController.text,
              );
            }
            ToastService.show('Approved');
            _closeDrawer();
          },
        ),
        const SizedBox(width: 8),
        Buttons.primary(
          label: 'Mark Paid',
          onPressed: () {
            if (_isMerchant) {
              context.read<WithdrawalsCubit>().updateMerchantWithdrawal(
                _selectedItem!.id,
                'Paid',
                ref: _notesController.text,
              );
            } else {
              context.read<WithdrawalsCubit>().updateCreatorWithdrawal(
                _selectedItem!.id,
                'Paid',
                ref: _notesController.text,
              );
            }
            ToastService.show('Paid');
            _closeDrawer();
          },
        ),
      ],
    );
  }
}
