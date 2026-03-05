import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/treasury_cubit.dart';
import '../../core/widgets/data_table_card.dart';
import '../../core/widgets/drawer_shell.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/topbar_search.dart';
import '../../core/widgets/drawer_details.dart';
import '../../core/widgets/status_chip.dart';
import '../../core/utils/toast_service.dart';

class TreasuryView extends StatelessWidget {
  const TreasuryView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TreasuryCubit()..load(),
      child: const _TreasuryContent(),
    );
  }
}

class _TreasuryContent extends StatefulWidget {
  const _TreasuryContent();

  @override
  State<_TreasuryContent> createState() => _TreasuryContentState();
}

class _TreasuryContentState extends State<_TreasuryContent> {
  bool _isDrawerOpen = false;
  Map<String, dynamic>? _selectedItem;
  final TextEditingController _rateController = TextEditingController();

  void _openDrawer(Map<String, dynamic> item) {
    setState(() {
      _selectedItem = item;
      _rateController.text = item['rate'].toString();
      _isDrawerOpen = true;
    });
  }

  void _closeDrawer() {
    setState(() {
      _isDrawerOpen = false;
    });
  }

  @override
  void dispose() {
    _rateController.dispose();
    super.dispose();
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
                title: 'Treasury & Exchange',
                subtitle: 'Manage cross-border Wins conversion rates',
              ),
              Expanded(
                child: BlocBuilder<TreasuryCubit, TreasuryState>(
                  builder: (context, state) {
                    if (state is TreasuryLoading || state is TreasuryInitial) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is TreasuryError) {
                      return Center(child: Text('Error: ${state.message}'));
                    }
                    if (state is TreasuryLoaded) {
                      return _buildTable(context, state.rates);
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
          DrawerShell(
            isOpen: _isDrawerOpen,
            title: 'Conversion Rate Detail',
            subtitle: _selectedItem != null ? _selectedItem!['id'] : '—',
            onClose: _closeDrawer,
            body: _buildDrawerBody(),
            actions: _buildDrawerActions(context),
          ),
        ],
      ),
    );
  }

  Widget _buildTable(BuildContext context, List<dynamic> rates) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: DataTableCard(
        title: 'Country Ledger Conversions',
        subtitle: 'Internal tables managed by Treasury',
        columns: const [
          'ID',
          'Source Ledger',
          'Target Ledger',
          'Current Rate',
          'Status',
          'Actions',
        ],
        rows: rates.map((r) {
          StatusKind kind = StatusKind.info;
          if (r['status'] == 'Active') kind = StatusKind.ok;

          return DataRow(
            cells: [
              DataCell(Text(r['id'])),
              DataCell(Text(r['source'])),
              DataCell(Text(r['target'])),
              DataCell(Text(r['rate'].toString())),
              DataCell(StatusChip(text: r['status'].toUpperCase(), kind: kind)),
              DataCell(
                IconButton(
                  icon: const Icon(Icons.remove_red_eye_outlined, size: 18),
                  onPressed: () => _openDrawer(r),
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
    StatusKind kind = StatusKind.info;
    if (r['status'] == 'Active') kind = StatusKind.ok;

    Map<String, dynamic> items = {
      'Source': r['source'],
      'Target': r['target'],
      'Status': StatusChip(text: r['status'].toUpperCase(), kind: kind),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DrawerKeyValueGrid(items: items),
        const SizedBox(height: 24),
        const Text(
          'Modify Conversion Rate',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        const Text(
          'Rates are reviewed periodically by the Treasury and do not follow live FX fluctuations.',
          style: TextStyle(fontSize: 13, color: Colors.grey),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _rateController,
          decoration: const InputDecoration(
            labelText: 'New Conversion Rate',
            border: OutlineInputBorder(),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
        Buttons.primary(
          label: 'Save Rate',
          onPressed: () {
            final rate = double.tryParse(_rateController.text);
            if (rate != null) {
              context.read<TreasuryCubit>().updateRate(
                _selectedItem!['id'],
                rate,
              );
              ToastService.show('Conversion rate updated');
              _closeDrawer();
            } else {
              ToastService.show('Invalid rate value');
            }
          },
        ),
      ],
    );
  }
}
