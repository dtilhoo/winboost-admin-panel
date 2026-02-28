import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/partnerships_cubit.dart';
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

class PartnershipsView extends StatelessWidget {
  const PartnershipsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PartnershipsCubit(partnershipsUseCase: getIt())..load(),
      child: const _PartnershipsContent(),
    );
  }
}

class _PartnershipsContent extends StatefulWidget {
  const _PartnershipsContent();

  @override
  State<_PartnershipsContent> createState() => _PartnershipsContentState();
}

class _PartnershipsContentState extends State<_PartnershipsContent> {
  bool _isDrawerOpen = false;
  Partnership? _selectedItem;

  void _openDrawer(Partnership item) {
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
                title: 'Partnerships',
                subtitle: 'Manage merchant-influencer handshakes',
              ),
              Expanded(
                child: BlocBuilder<PartnershipsCubit, PartnershipsState>(
                  builder: (context, state) {
                    if (state is PartnershipsLoading ||
                        state is PartnershipsInitial) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is PartnershipsError) {
                      return Center(child: Text('Error: ${state.message}'));
                    }
                    if (state is PartnershipsLoaded) {
                      return _buildTable(context, state.partnerships);
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
          DrawerShell(
            isOpen: _isDrawerOpen,
            title: 'Partnership Detail',
            subtitle: _selectedItem != null ? '${_selectedItem!.id}' : '—',
            onClose: _closeDrawer,
            body: _buildDrawerBody(),
            actions: _buildDrawerActions(context),
          ),
        ],
      ),
    );
  }

  Widget _buildTable(BuildContext context, List<Partnership> partnerships) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: DataTableCard(
        title: 'Active & Pending Partnerships',
        subtitle: 'Handshakes',
        columns: const [
          'ID',
          'Merchant',
          'Influencer',
          'Date',
          'Status',
          'Actions',
        ],
        rows: partnerships.map((p) {
          return DataRow(
            cells: [
              DataCell(Text(p.id)),
              DataCell(Text(p.merchant)),
              DataCell(Text(p.creator)),
              DataCell(Text(p.date)),
              DataCell(
                StatusChip(
                  text: p.status.toUpperCase(),
                  kind: inferStatusKind(p.status),
                ),
              ),
              DataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_red_eye_outlined, size: 18),
                      onPressed: () => _openDrawer(p),
                    ),
                    if (p.status != 'Cancelled')
                      IconButton(
                        icon: const Icon(
                          Icons.cancel_outlined,
                          size: 18,
                          color: AppColors.danger,
                        ),
                        onPressed: () {
                          context.read<PartnershipsCubit>().cancelPartnership(
                            p.id,
                          );
                          ToastService.show('Partnership cancelled');
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

    final p = _selectedItem!;
    Map<String, dynamic> items = {
      'Partnership ID': p.id,
      'Merchant': p.merchant,
      'Influencer': p.creator,
      'Date': p.date,
      'Status': StatusChip(
        text: p.status.toUpperCase(),
        kind: inferStatusKind(p.status),
      ),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [DrawerKeyValueGrid(items: items)],
    );
  }

  Widget _buildDrawerActions(BuildContext context) {
    if (_selectedItem == null) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Buttons.secondary(label: 'Close', onPressed: _closeDrawer),
        if (_selectedItem!.status != 'Cancelled') ...[
          const SizedBox(width: 8),
          Buttons.danger(
            label: 'Force Cancel',
            onPressed: () {
              context.read<PartnershipsCubit>().cancelPartnership(
                _selectedItem!.id,
              );
              ToastService.show('Partnership cancelled');
              _closeDrawer();
            },
          ),
        ],
      ],
    );
  }
}
