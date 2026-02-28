import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'buttons.dart';
import '../utils/toast_service.dart';

class TopBarSearch extends StatelessWidget {
  final String title;
  final String subtitle;
  final Function()? onHelpTap;
  final List<Widget>? actions;

  const TopBarSearch({
    super.key,
    required this.title,
    required this.subtitle,
    this.onHelpTap,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 18, top: 18, bottom: 14),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 13, color: AppColors.muted),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0x0AFFFFFF),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0x1EFFFFFF)),
              ),
              child: Row(
                children: [
                  const Text('🔎', style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      style: const TextStyle(
                        color: AppColors.text,
                        fontSize: 13,
                      ),
                      decoration: const InputDecoration(
                        hintText:
                            'Search by merchant, creator, reference, transaction id…',
                        hintStyle: TextStyle(color: AppColors.muted),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (actions != null) ...actions!,
              if (actions != null) const SizedBox(width: 10),
              Buttons.secondary(label: '📘 SOP', onPressed: onHelpTap ?? () {}),
              const SizedBox(width: 10),
              Buttons.primary(
                label: '⬇️ Export',
                onPressed: () => ToastService.show('Export queued (prototype)'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
