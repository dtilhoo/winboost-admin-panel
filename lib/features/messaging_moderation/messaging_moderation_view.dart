import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/messaging_moderation_cubit.dart';
import '../../injection/injection.dart';
import '../../core/widgets/data_table_card.dart';
import '../../core/widgets/drawer_shell.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/topbar_search.dart';
import '../../core/widgets/drawer_details.dart';
import '../../data/models/admin_models.dart';
import '../../core/theme/app_colors.dart';

class MessagingModerationView extends StatelessWidget {
  const MessagingModerationView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          MessagingModerationCubit(messagesUseCase: getIt())..load(),
      child: const _MessagingModerationContent(),
    );
  }
}

class _MessagingModerationContent extends StatefulWidget {
  const _MessagingModerationContent();

  @override
  State<_MessagingModerationContent> createState() =>
      _MessagingModerationContentState();
}

class _MessagingModerationContentState
    extends State<_MessagingModerationContent> {
  bool _isDrawerOpen = false;
  MessageThread? _selectedItem;

  void _openDrawer(MessageThread item) {
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
                title: 'Messaging Moderation',
                subtitle: 'Monitor P2P communication and disputes',
              ),
              Expanded(
                child:
                    BlocBuilder<
                      MessagingModerationCubit,
                      MessagingModerationState
                    >(
                      builder: (context, state) {
                        if (state is MessagingModerationLoading ||
                            state is MessagingModerationInitial) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (state is MessagingModerationError) {
                          return Center(child: Text('Error: ${state.message}'));
                        }
                        if (state is MessagingModerationLoaded) {
                          return _buildTable(context, state.threads);
                        }
                        return const SizedBox.shrink();
                      },
                    ),
              ),
            ],
          ),
          DrawerShell(
            isOpen: _isDrawerOpen,
            title: 'Read-only Thread Viewer',
            subtitle: _selectedItem != null
                ? '${_selectedItem!.id} • ${_selectedItem!.participants}'
                : '—',
            onClose: _closeDrawer,
            body: _buildDrawerBody(),
            actions: _buildDrawerActions(context),
          ),
        ],
      ),
    );
  }

  Widget _buildTable(BuildContext context, List<MessageThread> threads) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: DataTableCard(
        title: 'Active Threads',
        subtitle: 'Flagged or high-volume chats',
        columns: const [
          'Thread ID',
          'Partnership ID',
          'Participants',
          'Total Msgs',
          'Last Msg At',
          'Actions',
        ],
        rows: threads.map((t) {
          return DataRow(
            cells: [
              DataCell(Text(t.id)),
              DataCell(Text(t.partnershipId)),
              DataCell(Text(t.participants)),
              DataCell(Text(t.messageCount.toString())),
              DataCell(Text(t.lastMessage)),
              DataCell(
                IconButton(
                  icon: const Icon(Icons.remove_red_eye_outlined, size: 18),
                  onPressed: () => _openDrawer(t),
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
      'Thread ID': t.id,
      'Partnership ID': t.partnershipId,
      'Participants': t.participants,
      'Total Messages': t.messageCount.toString(),
      'Last Message': t.lastMessage,
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
              '[Dummy Chat History List Placeholder]',
              style: TextStyle(color: AppColors.muted),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDrawerActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [Buttons.secondary(label: 'Close', onPressed: _closeDrawer)],
    );
  }
}
