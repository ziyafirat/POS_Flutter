import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/language_controller.dart';
import '../controllers/app_controller.dart';

class AlmayaHeader extends StatelessWidget {
  final String? pageTitle;
  final List<Widget>? actions;
  final double height;

  const AlmayaHeader({
    super.key,
    this.pageTitle,
    this.actions,
    this.height = 60,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFFE31E24), Color(0xFFC41E3A)], // Almaya red colors
        ),
      ),
      child: Row(
        children: [
          // Almaya Logo (Left side)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Center(
                    child: Text(
                      'A',
                      style: TextStyle(
                        color: Color(0xFFE31E24),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'almaya',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4),
                const Text(
                  'supermarket',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),

          // Spacer to push content to right
          const Spacer(),

          // Page title (if provided)
          if (pageTitle != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                pageTitle!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          // Custom actions (if provided)
          if (actions != null) ...actions!,

          // Default language and help buttons (if no custom actions)
          if (actions == null) _buildDefaultActions(),

          const SizedBox(width: 16),
        ],
      ),
    );
  }

  Widget _buildDefaultActions() {
    final langController = Get.find<LanguageController>();

    return Row(
      children: [
        // Language Button (compact)
        SizedBox(
          width: 80,
          height: 40,
          child: ElevatedButton.icon(
            onPressed: () {
              langController.toggleLanguage();
            },
            icon: const Icon(Icons.language, size: 16),
            label: Obx(
              () => Text(
                langController.languageButtonText,
                style: const TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Call for Help Button (compact)
        SizedBox(
          width: 80,
          height: 40,
          child: ElevatedButton.icon(
            onPressed: () {
              // Call for assistance - navigate to error page and stay there
              final appController = Get.find<AppController>();
              appController.callForAssistance();
            },
            icon: const Icon(Icons.help, size: 16),
            label: Obx(
              () => Text(
                langController.callHelp,
                style: const TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange.withValues(alpha: 0.9),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            ),
          ),
        ),
      ],
    );
  }
}
