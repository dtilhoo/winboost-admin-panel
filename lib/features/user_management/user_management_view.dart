import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/user_management_cubit.dart';
import '../../core/widgets/data_table_card.dart';
import '../../core/widgets/drawer_shell.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/topbar_search.dart';
import '../../core/widgets/drawer_details.dart';
import '../../core/widgets/status_chip.dart';
import '../../core/utils/toast_service.dart';

class UserManagementView extends StatelessWidget {
  const UserManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserManagementCubit()..load(),
      child: const _UserManagementContent(),
    );
  }
}

class _UserManagementContent extends StatefulWidget {
  const _UserManagementContent();

  @override
  State<_UserManagementContent> createState() => _UserManagementContentState();
}

class _UserManagementContentState extends State<_UserManagementContent> {
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
                title: 'User Management',
                subtitle: 'Manage user tiers, badges, and roles',
              ),
              Expanded(
                child: BlocBuilder<UserManagementCubit, UserManagementState>(
                  builder: (context, state) {
                    if (state is UserManagementLoading ||
                        state is UserManagementInitial) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is UserManagementError) {
                      return Center(child: Text('Error: ${state.message}'));
                    }
                    if (state is UserManagementLoaded) {
                      return _buildTable(context, state.users);
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
          DrawerShell(
            isOpen: _isDrawerOpen,
            title: 'User Detail',
            subtitle: _selectedItem != null
                ? '${_selectedItem!['id']} • ${_selectedItem!['name']}'
                : '—',
            onClose: _closeDrawer,
            body: _buildDrawerBody(),
            actions: _buildDrawerActions(context),
          ),
        ],
      ),
    );
  }

  Widget _buildTable(BuildContext context, List<dynamic> users) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: DataTableCard(
        title: 'Platform Users',
        subtitle: 'All User, Creator, and Merchant accounts',
        columns: const [
          'ID',
          'Name',
          'Role',
          'Tier/Badge',
          'Status',
          'Actions',
        ],
        rows: users.map((u) {
          return DataRow(
            cells: [
              DataCell(Text(u['id'])),
              DataCell(Text(u['name'])),
              DataCell(Text(u['role'])),
              DataCell(Text(u['tier'])),
              DataCell(
                StatusChip(
                  text: u['status'].toUpperCase(),
                  kind: StatusKind.ok,
                ),
              ),
              DataCell(
                IconButton(
                  icon: const Icon(Icons.remove_red_eye_outlined, size: 18),
                  onPressed: () => _openDrawer(u),
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

    final u = _selectedItem!;
    Map<String, dynamic> items = {
      'User ID': u['id'],
      'Name': u['name'],
      'Role': u['role'],
      'Tier/Badge': u['tier'],
      'Status': StatusChip(
        text: u['status'].toUpperCase(),
        kind: StatusKind.ok,
      ),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DrawerKeyValueGrid(items: items),
        const SizedBox(height: 24),
        const Text(
          'Manual Adjustments',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        const Text(
          'Use manual overrides for tiers and badges only in administrative review cases.',
          style: TextStyle(fontSize: 13, color: Colors.grey),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Override Tier/Badge',
            border: OutlineInputBorder(),
          ),
          initialValue: u['tier'],
          items: const [
            DropdownMenuItem(value: 'Standard', child: Text('Standard')),
            DropdownMenuItem(value: 'Silver', child: Text('Silver')),
            DropdownMenuItem(value: 'Gold', child: Text('Gold')),
            DropdownMenuItem(value: 'Starter', child: Text('Starter')),
            DropdownMenuItem(value: 'Booster', child: Text('Booster')),
            DropdownMenuItem(value: 'Influencer', child: Text('Influencer')),
            DropdownMenuItem(value: 'Level 1', child: Text('Level 1')),
            DropdownMenuItem(value: 'Level 2', child: Text('Level 2')),
          ],
          onChanged: (val) {
            if (val != null) {
              // In a real app we would show a save button, for MVP we directly override
              context.read<UserManagementCubit>().overrideTier(u['id'], val);
              setState(() {
                _selectedItem!['tier'] = val;
              });
            }
          },
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
          label: 'Save Changes',
          onPressed: () {
            ToastService.show('User configuration updated');
            _closeDrawer();
          },
        ),
      ],
    );
  }
}
