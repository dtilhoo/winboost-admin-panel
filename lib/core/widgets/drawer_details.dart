import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class DrawerKeyValueGrid extends StatelessWidget {
  final Map<String, dynamic> items;

  const DrawerKeyValueGrid({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: items.entries.map((e) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 140,
                child: Text(
                  e.key,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: e.value is Widget
                    ? Align(
                        alignment: Alignment.centerLeft,
                        child: e.value as Widget,
                      )
                    : Text(
                        e.value.toString(),
                        style: const TextStyle(
                          color: AppColors.text,
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class DrawerNotesInput extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;

  const DrawerNotesInput({
    super.key,
    this.controller,
    this.hintText = 'Add notes...',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 90),
      decoration: BoxDecoration(
        color: const Color(0x0AFFFFFF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x1EFFFFFF)),
      ),
      child: TextField(
        controller: controller,
        maxLines: null, // Makes it expand
        keyboardType: TextInputType.multiline,
        style: const TextStyle(
          color: AppColors.text,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: AppColors.muted),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(10),
        ),
      ),
    );
  }
}

class DrawerSeparator extends StatelessWidget {
  const DrawerSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(vertical: 14),
      color: AppColors.line,
    );
  }
}
