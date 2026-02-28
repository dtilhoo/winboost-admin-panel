import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/refunds_cubit.dart';
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

class RefundsView extends StatelessWidget {
  const RefundsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RefundsCubit(walletUseCase: getIt())..load(),
      child: const _RefundsContent(),
    );
  }
}

class _RefundsContent extends StatefulWidget {
  const _RefundsContent();

  @override
  State<_RefundsContent> createState() => _RefundsContentState();
}

class _RefundsContentState extends State<_RefundsContent> {
  bool _isDrawerOpen = false;
  Refund? _selectedItem;
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _openDrawer(Refund item) {
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
                title: 'Refund Requests',
                subtitle: 'Unused merchant balance refunds',
              ),
              Expanded(
                child: BlocBuilder<RefundsCubit, RefundsState>(
                  builder: (context, state) {
                    if (state is RefundsLoading || state is RefundsInitial) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is RefundsError) {
                      return Center(child: Text('Error: ${state.message}'));
                    }
                    if (state is RefundsLoaded) {
                      return _buildTable(context, state.refunds);
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
          DrawerShell(
            isOpen: _isDrawerOpen,
            title: 'Refund request',
            subtitle: _selectedItem != null
                ? '${_selectedItem!.id} • ${_selectedItem!.merchant}'
                : '—',
            onClose: _closeDrawer,
            body: _buildDrawerBody(),
            actions: _buildDrawerActions(context),
          ),
        ],
      ),
    );
  }

  Widget _buildTable(BuildContext context, List<Refund> refunds) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: DataTableCard(
        title: 'Refund requests',
        subtitle: 'Pending → Approved → Paid / Rejected',
        columns: const [
          'Refund ID',
          'Merchant',
          'Amount',
          'Reason',
          'Submitted',
          'Status',
          'Actions',
        ],
        rows: refunds.map((r) {
          return DataRow(
            cells: [
              DataCell(Text(r.id)),
              DataCell(Text(r.merchant)),
              DataCell(Text('Rs ${r.amount}')),
              DataCell(Text(r.reason)),
              DataCell(Text(r.submitted)),
              DataCell(
                StatusChip(
                  text: r.status.toUpperCase(),
                  kind: inferStatusKind(r.status),
                ),
              ),
              DataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_red_eye_outlined, size: 18),
                      onPressed: () => _openDrawer(r),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.check_circle_outline,
                        size: 18,
                        color: AppColors.ok,
                      ),
                      onPressed: () {
                        context.read<RefundsCubit>().updateRefund(
                          r.id,
                          'Approved',
                        );
                        ToastService.show('Refund approved');
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.payments_outlined,
                        size: 18,
                        color: AppColors.info,
                      ),
                      onPressed: () {
                        context.read<RefundsCubit>().updateRefund(r.id, 'Paid');
                        ToastService.show('Refund paid');
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.cancel_outlined,
                        size: 18,
                        color: AppColors.danger,
                      ),
                      onPressed: () {
                        context.read<RefundsCubit>().updateRefund(
                          r.id,
                          'Rejected',
                        );
                        ToastService.show('Refund rejected');
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

    final r = _selectedItem!;
    Map<String, dynamic> items = {
      'Refund ID': r.id,
      'Merchant': r.merchant,
      'Amount': 'Rs ${r.amount}',
      'Reason': r.reason,
      'Submitted': r.submitted,
      'Status': StatusChip(
        text: r.status.toUpperCase(),
        kind: inferStatusKind(r.status),
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
            context.read<RefundsCubit>().updateRefund(
              _selectedItem!.id,
              'Rejected',
              ref: _notesController.text,
            );
            ToastService.show('Refund rejected');
            _closeDrawer();
          },
        ),
        const SizedBox(width: 8),
        Buttons.primary(
          label: 'Approve',
          onPressed: () {
            context.read<RefundsCubit>().updateRefund(
              _selectedItem!.id,
              'Approved',
              ref: _notesController.text,
            );
            ToastService.show('Refund approved');
            _closeDrawer();
          },
        ),
        const SizedBox(width: 8),
        Buttons.primary(
          label: 'Mark Paid',
          onPressed: () {
            context.read<RefundsCubit>().updateRefund(
              _selectedItem!.id,
              'Paid',
              ref: _notesController.text,
            );
            ToastService.show('Refund paid');
            _closeDrawer();
          },
        ),
      ],
    );
  }
}
