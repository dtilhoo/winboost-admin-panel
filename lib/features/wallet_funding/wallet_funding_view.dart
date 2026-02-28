import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/wallet_funding_cubit.dart';
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

class WalletFundingView extends StatelessWidget {
  const WalletFundingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WalletFundingCubit(walletUseCase: getIt())..load(),
      child: const _WalletFundingContent(),
    );
  }
}

class _WalletFundingContent extends StatefulWidget {
  const _WalletFundingContent();

  @override
  State<_WalletFundingContent> createState() => _WalletFundingContentState();
}

class _WalletFundingContentState extends State<_WalletFundingContent> {
  bool _isDrawerOpen = false;
  Topup? _selectedItem;
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _openDrawer(Topup item) {
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
                title: 'Wallet Top-Ups',
                subtitle: 'Manual proof validation & crediting',
              ),
              Expanded(
                child: BlocBuilder<WalletFundingCubit, WalletFundingState>(
                  builder: (context, state) {
                    if (state is WalletFundingLoading ||
                        state is WalletFundingInitial) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is WalletFundingError) {
                      return Center(child: Text('Error: ${state.message}'));
                    }
                    if (state is WalletFundingLoaded) {
                      return _buildTable(context, state.topups);
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
          DrawerShell(
            isOpen: _isDrawerOpen,
            title: 'Top-up request',
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

  Widget _buildTable(BuildContext context, List<Topup> topups) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: DataTableCard(
        title: 'Top-up requests',
        subtitle: 'Pending → Confirmed / Rejected',
        columns: const [
          'Top-up ID',
          'Merchant',
          'Amount',
          'Reference',
          'Submitted',
          'Status',
          'Proof',
          'Actions',
        ],
        rows: topups.map((t) {
          return DataRow(
            cells: [
              DataCell(Text(t.id)),
              DataCell(Text(t.merchant)),
              DataCell(Text('Rs ${t.amount}')),
              DataCell(Text(t.ref)),
              DataCell(Text(t.submitted)),
              DataCell(
                StatusChip(
                  text: t.status.toUpperCase(),
                  kind: inferStatusKind(t.status),
                ),
              ),
              DataCell(
                StatusChip(
                  text: t.proof ? 'PROOF' : 'MISSING',
                  kind: t.proof ? StatusKind.info : StatusKind.bad,
                ),
              ),
              DataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_red_eye_outlined, size: 18),
                      onPressed: () => _openDrawer(t),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.check_circle_outline,
                        size: 18,
                        color: AppColors.ok,
                      ),
                      onPressed: () {
                        context.read<WalletFundingCubit>().confirmTopup(t.id);
                        ToastService.show('Top-up confirmed');
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.cancel_outlined,
                        size: 18,
                        color: AppColors.danger,
                      ),
                      onPressed: () {
                        context.read<WalletFundingCubit>().rejectTopup(
                          t.id,
                          '',
                        );
                        ToastService.show('Top-up rejected');
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

    final t = _selectedItem!;
    Map<String, dynamic> items = {
      'Top-up ID': t.id,
      'Merchant': t.merchant,
      'Amount': 'Rs ${t.amount}',
      'Reference': t.ref,
      'Submitted': t.submitted,
      'Proof': StatusChip(
        text: t.proof ? 'UPLOADED' : 'MISSING',
        kind: t.proof ? StatusKind.info : StatusKind.bad,
      ),
      'Status': StatusChip(
        text: t.status.toUpperCase(),
        kind: inferStatusKind(t.status),
      ),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DrawerKeyValueGrid(items: items),
        const DrawerSeparator(),
        const Text('Notes', style: TextStyle(fontWeight: FontWeight.w900)),
        const SizedBox(height: 8),
        DrawerNotesInput(
          controller: _notesController,
          hintText: 'Mismatch reasons, bank ref, etc...',
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
            context.read<WalletFundingCubit>().rejectTopup(
              _selectedItem!.id,
              _notesController.text,
            );
            ToastService.show('Top-up rejected');
            _closeDrawer();
          },
        ),
        const SizedBox(width: 8),
        Buttons.primary(
          label: 'Confirm',
          onPressed: () {
            context.read<WalletFundingCubit>().confirmTopup(_selectedItem!.id);
            ToastService.show('Top-up confirmed');
            _closeDrawer();
          },
        ),
      ],
    );
  }
}
