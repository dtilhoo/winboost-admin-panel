import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class StatusChip extends StatelessWidget {
  final String text;
  final StatusKind kind;

  const StatusChip({
    super.key,
    required this.text,
    this.kind = StatusKind.info,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color border;
    Color textColor;

    switch (kind) {
      case StatusKind.ok:
        bg = AppColors.okBg;
        border = AppColors.okBorder;
        textColor = AppColors.okText;
        break;
      case StatusKind.warn:
        bg = AppColors.warnBg;
        border = AppColors.warnBorder;
        textColor = AppColors.warnText;
        break;
      case StatusKind.bad:
        bg = AppColors.badBg;
        border = AppColors.badBorder;
        textColor = AppColors.badText;
        break;
      case StatusKind.info:
        bg = AppColors.infoBg;
        border = AppColors.infoBorder;
        textColor = AppColors.infoText;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w900,
          height: 1, // To avoid extra vertical space
        ),
      ),
    );
  }
}

enum StatusKind { ok, warn, bad, info }

StatusKind inferStatusKind(String status) {
  final s = status.toLowerCase();
  if (['approved', 'confirmed', 'paid', 'active', 'ok', 'sent'].contains(s)) {
    return StatusKind.ok;
  }
  if (['pending'].contains(s)) return StatusKind.warn;
  if (['rejected', 'failed', 'suspended', 'missing'].contains(s)) {
    return StatusKind.bad;
  }
  return StatusKind.info;
}
