import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/merchant_review_cubit.dart';
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

class MerchantReviewView extends StatelessWidget {
  const MerchantReviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MerchantReviewCubit(profileUseCase: getIt())..load(),
      child: const _MerchantReviewContent(),
    );
  }
}

class _MerchantReviewContent extends StatefulWidget {
  const _MerchantReviewContent();

  @override
  State<_MerchantReviewContent> createState() => _MerchantReviewContentState();
}

class _MerchantReviewContentState extends State<_MerchantReviewContent> {
  bool _isDrawerOpen = false;
  Merchant? _selectedItem;

  void _openDrawer(Merchant item) {
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
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const TopBarSearch(
                title: 'Merchant Profile Review',
                subtitle: 'Review logos and public profiles',
              ),
              Expanded(
                child: BlocBuilder<MerchantReviewCubit, MerchantReviewState>(
                  builder: (context, state) {
                    if (state is MerchantReviewLoading ||
                        state is MerchantReviewInitial) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is MerchantReviewError) {
                      return Center(child: Text('Error: ${state.message}'));
                    }
                    if (state is MerchantReviewLoaded) {
                      return _buildTable(context, state.merchants);
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
          DrawerShell(
            isOpen: _isDrawerOpen,
            title: 'Merchant profile',
            subtitle: _selectedItem != null
                ? '${_selectedItem!.id} • ${_selectedItem!.name}'
                : '—',
            onClose: _closeDrawer,
            body: _buildDrawerBody(),
            actions: _buildDrawerActions(context),
          ),
        ],
      ),
    );
  }

  Widget _buildTable(BuildContext context, List<Merchant> merchants) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: DataTableCard(
        title: 'Profiles to review',
        subtitle: 'Logo / Cover changes',
        columns: const [
          'Merchant ID',
          'Name',
          'Owner',
          'Created',
          'Profile',
          'Status',
          'Actions',
        ],
        rows: merchants.map((m) {
          return DataRow(
            cells: [
              DataCell(Text(m.id)),
              DataCell(Text(m.name)),
              DataCell(Text(m.owner)),
              DataCell(Text(m.created)),
              DataCell(StatusChip(text: 'UPDATED', kind: StatusKind.info)),
              DataCell(
                StatusChip(
                  text: m.status.toUpperCase(),
                  kind: inferStatusKind(m.status),
                ),
              ),
              DataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_red_eye_outlined, size: 18),
                      onPressed: () => _openDrawer(m),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.check_circle_outline,
                        size: 18,
                        color: AppColors.ok,
                      ),
                      onPressed: () {
                        ToastService.show('Profile approved');
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.cancel_outlined,
                        size: 18,
                        color: AppColors.danger,
                      ),
                      onPressed: () {
                        ToastService.show('Profile rejected');
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

    final m = _selectedItem!;
    Map<String, dynamic> items = {
      'Merchant ID': m.id,
      'Name': m.name,
      'Owner': m.owner,
      'Created': m.created,
      'Status': StatusChip(
        text: m.status.toUpperCase(),
        kind: inferStatusKind(m.status),
      ),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DrawerKeyValueGrid(items: items),
        const DrawerSeparator(),
        const Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              '[Logo Placeholder]',
              style: TextStyle(color: AppColors.muted),
            ),
          ),
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
          label: 'Reject Logo',
          onPressed: () {
            ToastService.show('Logo rejected');
            _closeDrawer();
          },
        ),
        const SizedBox(width: 8),
        Buttons.primary(
          label: 'Approve Profile',
          onPressed: () {
            ToastService.show('Profile approved');
            _closeDrawer();
          },
        ),
      ],
    );
  }
}
