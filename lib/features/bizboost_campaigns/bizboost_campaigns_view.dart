import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/bizboost_campaigns_cubit.dart';
import '../../core/widgets/data_table_card.dart';
import '../../core/widgets/drawer_shell.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/topbar_search.dart';
import '../../core/widgets/drawer_details.dart';
import '../../core/widgets/status_chip.dart';
import '../../core/utils/toast_service.dart';

class BizboostCampaignsView extends StatelessWidget {
  const BizboostCampaignsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BizboostCampaignsCubit()..load(),
      child: const _CampaignsContent(),
    );
  }
}

class _CampaignsContent extends StatefulWidget {
  const _CampaignsContent();

  @override
  State<_CampaignsContent> createState() => _CampaignsContentState();
}

class _CampaignsContentState extends State<_CampaignsContent> {
  bool _isDrawerOpen = false;
  Map<String, dynamic>? _selectedItem;

  void _openDrawer(Map<String, dynamic> item) {
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
                title: 'BizBoost Campaigns',
                subtitle: 'Monitor and moderate active promotional campaigns',
              ),
              Expanded(
                child:
                    BlocBuilder<BizboostCampaignsCubit, BizboostCampaignsState>(
                      builder: (context, state) {
                        if (state is BizboostCampaignsLoading ||
                            state is BizboostCampaignsInitial) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (state is BizboostCampaignsError) {
                          return Center(child: Text('Error: ${state.message}'));
                        }
                        if (state is BizboostCampaignsLoaded) {
                          return _buildTable(context, state.campaigns);
                        }
                        return const SizedBox.shrink();
                      },
                    ),
              ),
            ],
          ),
          DrawerShell(
            isOpen: _isDrawerOpen,
            title: 'Campaign Detail',
            subtitle: _selectedItem != null
                ? '${_selectedItem!['id']} • ${_selectedItem!['merchant']}'
                : '—',
            onClose: _closeDrawer,
            body: _buildDrawerBody(),
            actions: _buildDrawerActions(context),
          ),
        ],
      ),
    );
  }

  Widget _buildTable(BuildContext context, List<dynamic> campaigns) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: DataTableCard(
        title: 'Active Campaigns',
        subtitle: 'Promotional rules funded by merchants',
        columns: const [
          'ID',
          'Merchant',
          'Rule',
          'Budget',
          'Status',
          'Actions',
        ],
        rows: campaigns.map((c) {
          StatusKind kind = StatusKind.info;
          if (c['status'] == 'Active') kind = StatusKind.ok;
          if (c['status'] == 'Force Cancelled') kind = StatusKind.bad;

          return DataRow(
            cells: [
              DataCell(Text(c['id'])),
              DataCell(Text(c['merchant'])),
              DataCell(Text(c['rule'])),
              DataCell(Text(c['budget'])),
              DataCell(StatusChip(text: c['status'].toUpperCase(), kind: kind)),
              DataCell(
                IconButton(
                  icon: const Icon(Icons.remove_red_eye_outlined, size: 18),
                  onPressed: () => _openDrawer(c),
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

    final c = _selectedItem!;
    StatusKind kind = StatusKind.info;
    if (c['status'] == 'Active') kind = StatusKind.ok;
    if (c['status'] == 'Force Cancelled') kind = StatusKind.bad;

    Map<String, dynamic> items = {
      'Campaign ID': c['id'],
      'Merchant': c['merchant'],
      'Rule': c['rule'],
      'Budget': c['budget'],
      'Status': StatusChip(text: c['status'].toUpperCase(), kind: kind),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DrawerKeyValueGrid(items: items),
        const SizedBox(height: 20),
        const Text(
          'Anti-Abuse Oversight',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        const Text(
          'Use "Force Cancel" to immediately halt campaigns suspected of abuse or fraud. This protects the ecosystem.',
          style: TextStyle(fontSize: 13, color: Colors.grey),
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
        if (_selectedItem!['status'] == 'Active') ...[
          const SizedBox(width: 8),
          Buttons.danger(
            label: 'Force Cancel',
            onPressed: () {
              context.read<BizboostCampaignsCubit>().cancelCampaign(
                _selectedItem!['id'],
              );
              ToastService.show('Campaign halted immediately');
              _closeDrawer();
            },
          ),
        ],
      ],
    );
  }
}
