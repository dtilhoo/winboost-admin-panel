import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/settings_cubit.dart';
import '../../core/widgets/data_table_card.dart';
import '../../core/widgets/topbar_search.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/toast_service.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsCubit(),
      child: const _SettingsContent(),
    );
  }
}

class _SettingsContent extends StatelessWidget {
  const _SettingsContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const TopBarSearch(
            title: 'Settings',
            subtitle: 'Global configuration',
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: BlocBuilder<SettingsCubit, SettingsState>(
                builder: (context, state) {
                  if (state is SettingsLoaded) {
                    return DataTableCard(
                      title: 'System Toggles',
                      subtitle: 'Environment and features',
                      columns: const ['Setting', 'Description', 'Status'],
                      rows: [
                        DataRow(
                          cells: [
                            const DataCell(
                              Text(
                                'Environment',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            const DataCell(
                              Text('Toggle between DEV and PROD API endpoints'),
                            ),
                            DataCell(
                              Switch(
                                value: state.isDevEnv,
                                activeThumbColor: AppColors.brand,
                                onChanged: (val) {
                                  context.read<SettingsCubit>().toggleEnv(val);
                                  ToastService.show(
                                    val
                                        ? 'Switched to DEV env'
                                        : 'Switched to PROD env',
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        DataRow(
                          cells: [
                            const DataCell(
                              Text(
                                'Rounding Rules',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            const DataCell(
                              Text(
                                'Round all calculations to 2 decimals globally',
                              ),
                            ),
                            DataCell(
                              Switch(
                                value: state.enableRounding,
                                activeThumbColor: AppColors.brand,
                                onChanged: (val) {
                                  context.read<SettingsCubit>().toggleRounding(
                                    val,
                                  );
                                  ToastService.show('Rounding rules updated');
                                },
                              ),
                            ),
                          ],
                        ),
                        DataRow(
                          cells: [
                            const DataCell(
                              Text(
                                'Sentry Tracing',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            const DataCell(
                              Text('Enable performance tracing to Sentry'),
                            ),
                            DataCell(
                              Switch(
                                value: state.enableSentry,
                                activeThumbColor: AppColors.brand,
                                onChanged: (val) {
                                  context.read<SettingsCubit>().toggleSentry(
                                    val,
                                  );
                                  ToastService.show(
                                    'Sentry configuration updated',
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
