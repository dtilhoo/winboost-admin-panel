import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/merchant_counters_cubit.dart';
import '../../injection/injection.dart';
import '../../core/widgets/data_table_card.dart';
import '../../core/widgets/drawer_shell.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/topbar_search.dart';
import '../../core/widgets/drawer_details.dart';
import '../../data/models/admin_models.dart';
import '../../core/utils/toast_service.dart';

class MerchantCountersView extends StatelessWidget {
  const MerchantCountersView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          MerchantCountersCubit(countersUseCase: getIt())..load(),
      child: const _MerchantCountersContent(),
    );
  }
}

class _MerchantCountersContent extends StatefulWidget {
  const _MerchantCountersContent();

  @override
  State<_MerchantCountersContent> createState() =>
      _MerchantCountersContentState();
}

class _MerchantCountersContentState extends State<_MerchantCountersContent> {
  bool _isDrawerOpen = false;
  MerchantCounter? _selectedItem;

  void _openDrawer(MerchantCounter item) {
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
                title: 'Merchant Counters',
                subtitle: 'Manage cashier/salesperson access',
              ),
              Expanded(
                child:
                    BlocBuilder<MerchantCountersCubit, MerchantCountersState>(
                      builder: (context, state) {
                        if (state is MerchantCountersLoading ||
                            state is MerchantCountersInitial) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (state is MerchantCountersError) {
                          return Center(child: Text('Error: ${state.message}'));
                        }
                        if (state is MerchantCountersLoaded) {
                          return _buildTable(context, state.counters);
                        }
                        return const SizedBox.shrink();
                      },
                    ),
              ),
            ],
          ),
          DrawerShell(
            isOpen: _isDrawerOpen,
            title: 'Counter Detail',
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

  Widget _buildTable(BuildContext context, List<MerchantCounter> counters) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: DataTableCard(
        title: 'Counters',
        subtitle: 'Cashier accounts linked to merchants',
        columns: const [
          'Counter ID',
          'Merchant',
          'Active Offers',
          'Total Scans',
          'Actions',
        ],
        rows: counters.map((c) {
          return DataRow(
            cells: [
              DataCell(Text(c.id)),
              DataCell(Text(c.merchant)),
              DataCell(Text(c.activeOffers.toString())),
              DataCell(Text(c.totalScans.toString())),
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
    Map<String, dynamic> items = {
      'Counter ID': c.id,
      'Merchant': c.merchant,
      'Active Offers': c.activeOffers.toString(),
      'Total Scans': c.totalScans.toString(),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [DrawerKeyValueGrid(items: items)],
    );
  }

  Widget _buildDrawerActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Buttons.secondary(label: 'Close', onPressed: _closeDrawer),
        const SizedBox(width: 8),
        Buttons.danger(
          label: 'Revoke Access',
          onPressed: () {
            ToastService.show('Counter access revoked');
            _closeDrawer();
          },
        ),
      ],
    );
  }
}
