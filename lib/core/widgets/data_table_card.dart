import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class DataTableCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? filtersRow;
  final List<String> columns;
  final List<DataRow> rows;

  const DataTableCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.filtersRow,
    required this.columns,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0x0DFFFFFF), // rgba(255,255,255,.05)
            Color(0x08FFFFFF), // rgba(255,255,255,.03)
          ],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x59000000), // rgba(0,0,0,.35)
            blurRadius: 40,
            offset: Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                if (filtersRow != null) filtersRow!,
              ],
            ),
          ),
          Container(height: 1, color: AppColors.line),
          if (rows.isEmpty)
            const Padding(
              padding: EdgeInsets.all(32),
              child: Center(
                child: Text(
                  'No data found.',
                  style: TextStyle(color: AppColors.muted),
                ),
              ),
            )
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: MaterialStateProperty.all(
                  const Color(0x08FFFFFF),
                ), // rgba(255,255,255,.03)
                dataRowMinHeight: 48,
                dataRowMaxHeight: double.infinity,
                headingTextStyle: const TextStyle(
                  fontSize: 11,
                  color: AppColors.muted,
                  letterSpacing: 0.8, // Approximation for .08em
                  fontWeight: FontWeight.w900,
                ),
                dataTextStyle: const TextStyle(
                  fontSize: 13,
                  color: AppColors.text,
                ),
                dividerThickness: 1,
                columns: columns
                    .map((e) => DataColumn(label: Text(e.toUpperCase())))
                    .toList(),
                rows: rows,
              ),
            ),
        ],
      ),
    );
  }
}
