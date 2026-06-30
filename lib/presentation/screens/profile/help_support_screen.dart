import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';

@RoutePage()
class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  // ── Contact details ─────────────────────────────────────────────────────────
  static const String _phone = '+263770000000';
  static const String _whatsapp = '+263770000000';
  static const String _email = 'support@farchis.com';
  static const String _termsUrl = 'https://farchis.com/terms';
  static const String _privacyUrl = 'https://farchis.com/privacy';

  // ── FAQ data ─────────────────────────────────────────────────────────────────
  static const List<_FaqItem> _faqs = [
    _FaqItem(
      question: 'How do I book a service?',
      answer:
          'Tap "Book a Service" from the Home screen, choose your service type, select an available time slot, and confirm your booking. You\'ll receive a notification once it\'s confirmed.',
    ),
    _FaqItem(
      question: 'Can I cancel or reschedule a booking?',
      answer:
          'Yes — open the booking from the Bookings tab and tap "Cancel". Rescheduling is available up to 2 hours before the scheduled time. Contact us via WhatsApp for urgent changes.',
    ),
    _FaqItem(
      question: 'How does the loyalty programme work?',
      answer:
          'You earn points on every completed booking. Points accumulate toward tier upgrades (Bronze → Silver → Gold → Platinum) and can be redeemed for discounts on future services.',
    ),
    _FaqItem(
      question: 'How do I track my vehicle during a service?',
      answer:
          'Once your booking is active, you\'ll see a live-tracking option in the Bookings tab that shows the technician\'s progress in real time.',
    ),
    _FaqItem(
      question: 'What payment methods are accepted?',
      answer:
          'We currently accept cash on delivery, EcoCash, and major credit/debit cards. Online payment integration is coming soon.',
    ),
    _FaqItem(
      question: 'How do I update my vehicle details?',
      answer:
          'Go to Account → My Vehicles to add, edit, or remove saved vehicles. Your saved vehicle details will pre-fill automatically when you book a service.',
    ),
    _FaqItem(
      question: 'I\'m having trouble signing in — what should I do?',
      answer:
          'Try resetting your password using the "Forgot Password" link on the login screen. If the problem persists, contact our support team via WhatsApp or email.',
    ),
  ];

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.navyDark : AppColors.navyPrimary,
        foregroundColor: AppColors.white,
        title: const Text('Help & Support'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.lg),
        children: [
          // ── FAQ Section ──────────────────────────────────────────────────
          _sectionLabel(context, 'FREQUENTLY ASKED QUESTIONS'),
          const SizedBox(height: AppDimensions.md),
          _buildFaqAccordion(context, theme, isDark),

          const SizedBox(height: AppDimensions.xxxl),

          // ── Contact Section ──────────────────────────────────────────────
          _sectionLabel(context, 'CONTACT US'),
          const SizedBox(height: AppDimensions.md),
          _buildContactCard(context, theme, isDark),

          const SizedBox(height: AppDimensions.xxxl),

          // ── Legal links ──────────────────────────────────────────────────
          _sectionLabel(context, 'LEGAL'),
          const SizedBox(height: AppDimensions.md),
          _buildLegalCard(context, theme, isDark),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _sectionLabel(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(left: AppDimensions.xs),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.5),
              letterSpacing: 1.2,
            ),
      ),
    );
  }

  // ── FAQ Accordion ──────────────────────────────────────────────────────────

  Widget _buildFaqAccordion(
      BuildContext context, ThemeData theme, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? AppColors.black : AppColors.navyDarkest)
                .withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        child: Column(
          children: _faqs.map((faq) {
            final isLast = faq == _faqs.last;
            return Column(
              children: [
                Theme(
                  data: theme.copyWith(
                    dividerColor: Colors.transparent,
                  ),
                  child: ExpansionTile(
                    title: Text(
                      faq.question,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    iconColor: isDark ? AppColors.navyLight : AppColors.navyPrimary,
                    collapsedIconColor:
                        theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    childrenPadding: const EdgeInsets.only(
                      left: AppDimensions.lg,
                      right: AppDimensions.lg,
                      bottom: AppDimensions.md,
                    ),
                    children: [
                      Text(
                        faq.answer,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isLast)
                  Padding(
                    padding: const EdgeInsets.only(left: AppDimensions.lg),
                    child: Divider(
                      height: 1,
                      thickness: 1,
                      color: theme.colorScheme.outline.withValues(alpha: 0.15),
                    ),
                  ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  // ── Contact Card ───────────────────────────────────────────────────────────

  Widget _buildContactCard(
      BuildContext context, ThemeData theme, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? AppColors.black : AppColors.navyDarkest)
                .withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _ContactTile(
            icon: Icons.call_rounded,
            label: 'Call Us',
            subtitle: _phone,
            isDark: isDark,
            onTap: () => _launch('tel:$_phone'),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 56),
            child: Divider(
              height: 1,
              thickness: 1,
              color: theme.colorScheme.outline.withValues(alpha: 0.15),
            ),
          ),
          _ContactTile(
            icon: Icons.chat_rounded,
            label: 'WhatsApp',
            subtitle: _whatsapp,
            isDark: isDark,
            onTap: () => _launch(
                'https://wa.me/${_whatsapp.replaceAll(RegExp(r'[^\d]'), '')}'),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 56),
            child: Divider(
              height: 1,
              thickness: 1,
              color: theme.colorScheme.outline.withValues(alpha: 0.15),
            ),
          ),
          _ContactTile(
            icon: Icons.email_outlined,
            label: 'Email',
            subtitle: _email,
            isDark: isDark,
            isLast: true,
            onTap: () => _launch('mailto:$_email?subject=Support%20Request'),
          ),
        ],
      ),
    );
  }

  // ── Legal Card ─────────────────────────────────────────────────────────────

  Widget _buildLegalCard(BuildContext context, ThemeData theme, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? AppColors.black : AppColors.navyDarkest)
                .withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _ContactTile(
            icon: Icons.description_outlined,
            label: 'Terms of Service',
            isDark: isDark,
            onTap: () => _launch(_termsUrl),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 56),
            child: Divider(
              height: 1,
              thickness: 1,
              color: theme.colorScheme.outline.withValues(alpha: 0.15),
            ),
          ),
          _ContactTile(
            icon: Icons.shield_outlined,
            label: 'Privacy Policy',
            isDark: isDark,
            isLast: true,
            onTap: () => _launch(_privacyUrl),
          ),
        ],
      ),
    );
  }
}

// ─── Reusable tile ─────────────────────────────────────────────────────────────

class _ContactTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final bool isDark;
  final bool isLast;
  final VoidCallback onTap;

  const _ContactTile({
    required this.icon,
    required this.label,
    required this.isDark,
    required this.onTap,
    this.subtitle,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.lg,
            vertical: AppDimensions.md + 2,
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: (isDark ? AppColors.navyLight : AppColors.navyPrimary)
                      .withValues(alpha: isDark ? 0.15 : 0.08),
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusSm),
                ),
                child: Icon(
                  icon,
                  size: AppDimensions.iconSm,
                  color: (isDark ? AppColors.navyLight : AppColors.navyPrimary)
                      .withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(width: AppDimensions.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.55),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: AppDimensions.iconMd,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── FAQ data class ────────────────────────────────────────────────────────────

class _FaqItem {
  final String question;
  final String answer;

  const _FaqItem({required this.question, required this.answer});
}
