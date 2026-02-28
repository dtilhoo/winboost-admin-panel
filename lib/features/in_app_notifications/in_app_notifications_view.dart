import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/in_app_notifications_cubit.dart';
import '../../injection/injection.dart';
import '../../core/widgets/data_table_card.dart';
import '../../core/widgets/status_chip.dart';
import '../../core/widgets/drawer_shell.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/topbar_search.dart';
import '../../core/widgets/drawer_details.dart';
import '../../data/models/admin_models.dart';
import '../../core/utils/toast_service.dart';

class InAppNotificationsView extends StatelessWidget {
  const InAppNotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          InAppNotificationsCubit(notificationsUseCase: getIt())..load(),
      child: const _InAppNotificationsContent(),
    );
  }
}

class _InAppNotificationsContent extends StatefulWidget {
  const _InAppNotificationsContent();

  @override
  State<_InAppNotificationsContent> createState() =>
      _InAppNotificationsContentState();
}

class _InAppNotificationsContentState
    extends State<_InAppNotificationsContent> {
  bool _isDrawerOpen = false;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  String _channel = 'In-app + Push';
  String _audience = 'All Merchants';

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _openComposer() {
    setState(() {
      _titleController.clear();
      _contentController.clear();
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
              TopBarSearch(
                title: 'In-App Notifications',
                subtitle: 'Push messages to users',
                actions: [
                  Buttons.primary(
                    label: 'Compose',
                    onPressed: _openComposer,
                    icon: Icons.add,
                  ),
                ],
              ),
              Expanded(
                child:
                    BlocBuilder<
                      InAppNotificationsCubit,
                      InAppNotificationsState
                    >(
                      builder: (context, state) {
                        if (state is InAppNotificationsLoading ||
                            state is InAppNotificationsInitial) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (state is InAppNotificationsError) {
                          return Center(child: Text('Error: ${state.message}'));
                        }
                        if (state is InAppNotificationsLoaded) {
                          return _buildTable(context, state.notifications);
                        }
                        return const SizedBox.shrink();
                      },
                    ),
              ),
            ],
          ),
          DrawerShell(
            isOpen: _isDrawerOpen,
            title: 'Compose Message',
            subtitle: 'Broadcast to segments',
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
    List<NotificationModel> notifications,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: DataTableCard(
        title: 'Recent Broadcasts',
        subtitle: 'History of sent notifications',
        columns: const [
          'ID',
          'Title',
          'Channel',
          'Audience',
          'Created',
          'Status',
        ],
        rows: notifications.map((n) {
          return DataRow(
            cells: [
              DataCell(Text(n.id)),
              DataCell(Text(n.title)),
              DataCell(Text(n.channel)),
              DataCell(Text(n.audience)),
              DataCell(Text(n.created)),
              DataCell(
                StatusChip(text: n.status.toUpperCase(), kind: StatusKind.ok),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDrawerBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Target Audience',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        DropdownButton<String>(
          value: _audience,
          isExpanded: true,
          items: [
            'All Merchants',
            'All Influencers',
            'All Customers',
          ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (val) {
            if (val != null) setState(() => _audience = val);
          },
        ),
        const SizedBox(height: 16),
        const Text('Channel', style: TextStyle(fontWeight: FontWeight.w900)),
        DropdownButton<String>(
          value: _channel,
          isExpanded: true,
          items: [
            'In-app only',
            'Push only',
            'In-app + Push',
          ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (val) {
            if (val != null) setState(() => _channel = val);
          },
        ),
        const SizedBox(height: 16),
        const Text(
          'Message Title',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        DrawerNotesInput(
          controller: _titleController,
          hintText: 'Enter title...',
        ),
        const SizedBox(height: 16),
        const Text(
          'Message Body',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        DrawerNotesInput(
          controller: _contentController,
          hintText: 'Enter message content...',
        ),
      ],
    );
  }

  Widget _buildDrawerActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Buttons.secondary(label: 'Cancel', onPressed: _closeDrawer),
        const SizedBox(width: 8),
        Buttons.primary(
          label: 'Send Broadcast',
          onPressed: () {
            if (_titleController.text.isEmpty) {
              ToastService.show('Please enter a title');
              return;
            }
            context.read<InAppNotificationsCubit>().sendNotification(
              _titleController.text,
              _channel,
              _audience,
              _contentController.text,
            );
            ToastService.show('Broadcast sent');
            _closeDrawer();
          },
        ),
      ],
    );
  }
}
