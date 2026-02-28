import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class FiltersRow extends StatelessWidget {
  final List<String> dropdownOptions;
  final String selectedDropdown;
  final Function(String?) onDropdownChanged;
  final String searchHint;
  final Function(String) onSearchChanged;

  const FiltersRow({
    super.key,
    required this.dropdownOptions,
    required this.selectedDropdown,
    required this.onDropdownChanged,
    required this.searchHint,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: const Color(0x0AFFFFFF), // rgba(255,255,255,.04)
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0x1EFFFFFF),
            ), // rgba(255,255,255,.12)
          ),
          height: 36,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedDropdown,
              dropdownColor: AppColors.panel,
              style: const TextStyle(
                color: AppColors.text,
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
              icon: const Icon(
                Icons.arrow_drop_down,
                color: AppColors.muted,
                size: 20,
              ),
              onChanged: onDropdownChanged,
              items: dropdownOptions.map((e) {
                return DropdownMenuItem(value: e, child: Text(e));
              }).toList(),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: const Color(0x0AFFFFFF), // rgba(255,255,255,.04)
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0x1EFFFFFF),
            ), // rgba(255,255,255,.12)
          ),
          width: 150,
          height: 36,
          alignment: Alignment.center,
          child: TextField(
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              hintText: searchHint,
              hintStyle: const TextStyle(color: AppColors.muted),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
      ],
    );
  }
}
