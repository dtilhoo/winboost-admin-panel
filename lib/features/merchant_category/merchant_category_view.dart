import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/merchant_category_cubit.dart';
import '../../injection/injection.dart';
import '../../core/widgets/data_table_card.dart';
import '../../core/widgets/status_chip.dart';
import '../../core/widgets/topbar_search.dart';
import '../../data/models/admin_models.dart';
import '../../core/utils/toast_service.dart';
import '../../core/theme/app_colors.dart';

class MerchantCategoryView extends StatelessWidget {
  const MerchantCategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          MerchantCategoryCubit(categoryUseCase: getIt())..load(),
      child: const _MerchantCategoryContent(),
    );
  }
}

class _MerchantCategoryContent extends StatelessWidget {
  const _MerchantCategoryContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const TopBarSearch(
            title: 'Merchant Categories Option',
            subtitle: 'Manage categories and commission bounds',
          ),
          Expanded(
            child: BlocBuilder<MerchantCategoryCubit, MerchantCategoryState>(
              builder: (context, state) {
                if (state is MerchantCategoryLoading ||
                    state is MerchantCategoryInitial) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is MerchantCategoryError) {
                  return Center(child: Text('Error: ${state.message}'));
                }
                if (state is MerchantCategoryLoaded) {
                  return _buildTable(context, state.categories);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTable(BuildContext context, List<Category> categories) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: DataTableCard(
        title: 'Categories',
        subtitle: 'Add new category, min/max commission (%)',
        columns: const [
          'Category ID',
          'Name',
          'Min Comm.',
          'Max Comm.',
          'Status',
          'Actions',
        ],
        rows: categories.map((c) {
          return DataRow(
            cells: [
              DataCell(Text(c.id)),
              DataCell(Text(c.name)),
              DataCell(Text('${c.minCommission}%')),
              DataCell(Text('${c.maxCommission}%')),
              DataCell(
                StatusChip(
                  text: c.status.toUpperCase(),
                  kind: inferStatusKind(c.status),
                ),
              ),
              DataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (c.status == 'Suspended')
                      IconButton(
                        icon: const Icon(
                          Icons.check_circle_outline,
                          size: 18,
                          color: AppColors.ok,
                        ),
                        onPressed: () {
                          context
                              .read<MerchantCategoryCubit>()
                              .activateCategory(c.id);
                          ToastService.show('${c.name} category activated');
                        },
                      ),
                    if (c.status == 'Active')
                      IconButton(
                        icon: const Icon(
                          Icons.cancel_outlined,
                          size: 18,
                          color: AppColors.danger,
                        ),
                        onPressed: () {
                          context.read<MerchantCategoryCubit>().suspendCategory(
                            c.id,
                          );
                          ToastService.show('${c.name} category suspended');
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
}
