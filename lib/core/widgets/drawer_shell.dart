import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class DrawerShell extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget body;
  final Widget actions;
  final VoidCallback onClose;
  final bool isOpen;

  const DrawerShell({
    super.key,
    required this.title,
    required this.subtitle,
    required this.body,
    required this.actions,
    required this.onClose,
    this.isOpen = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!isOpen) return const SizedBox.shrink();

    return Material(
      color: Colors.black54,
      child: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: onClose,
              child: Container(color: Colors.transparent),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            width: 520, // Mobile: 100% (will handle later in responsive layer)
            child: Container(
              decoration: const BoxDecoration(
                border: Border(left: BorderSide(color: AppColors.line)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFA101D3A), // rgba(16,29,58,.98)
                    Color(0xFA0F1A33), // rgba(15,26,51,.98)
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x59000000), // rgba(0,0,0,.35)
                    blurRadius: 50,
                    offset: Offset(-20, 0),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(14),
                      child: body,
                    ),
                  ),
                  _buildActions(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.line)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: AppColors.muted),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: onClose,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0x1EFFFFFF)),
                color: const Color(0x0AFFFFFF),
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.close, size: 18, color: AppColors.text),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      child: actions, // Expecting a Wrap or Row with buttons
    );
  }
}
