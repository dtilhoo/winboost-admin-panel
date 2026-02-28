import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/audit_logs_cubit.dart';
import '../../injection/injection.dart';
import '../../core/widgets/data_table_card.dart';
import '../../core/widgets/status_chip.dart';
import '../../core/widgets/topbar_search.dart';
import '../../data/models/admin_models.dart';

class AuditLogsView extends StatelessWidget {
  const AuditLogsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuditLogsCubit(logsUseCase: getIt())..load(),
      child: const _AuditLogsContent(),
    );
  }
}

class _AuditLogsContent extends StatelessWidget {
  const _AuditLogsContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const TopBarSearch(
            title: 'Audit Logs',
            subtitle: 'System events and error tracking',
          ),
          Expanded(
            child: BlocBuilder<AuditLogsCubit, AuditLogsState>(
              builder: (context, state) {
                if (state is AuditLogsLoading || state is AuditLogsInitial) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is AuditLogsError) {
                  return Center(child: Text('Error: ${state.message}'));
                }
                if (state is AuditLogsLoaded) {
                  return _buildTable(context, state.logs);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTable(BuildContext context, List<LogItem> logs) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: DataTableCard(
        title: 'System Logs',
        subtitle: 'Read-only events',
        columns: const ['Time', 'Level', 'Message'],
        rows: logs.map((l) {
          return DataRow(
            cells: [
              DataCell(Text(l.time)),
              DataCell(
                StatusChip(
                  text: l.level,
                  kind: l.level == 'ERROR' ? StatusKind.bad : StatusKind.info,
                ),
              ),
              DataCell(Text(l.message)),
            ],
          );
        }).toList(),
      ),
    );
  }
}
