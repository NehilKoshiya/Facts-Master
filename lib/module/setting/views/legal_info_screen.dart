import 'package:daily_facts/core/constants/app_colors.dart';
import 'package:daily_facts/widgets/app_motion.dart';
import 'package:daily_facts/widgets/app_surfaces.dart';
import 'package:daily_facts/widgets/app_text.dart';
import 'package:daily_facts/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class LegalInfoScreen extends StatelessWidget {
  const LegalInfoScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.heroTitle,
    required this.heroDescription,
    required this.sections,
    required this.icon,
    required this.accent,
  });

  final String title;
  final String subtitle;
  final String heroTitle;
  final String heroDescription;
  final List<LegalSectionData> sections;
  final IconData icon;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: customAppBar(
        title: title,
        context: context,
        toolbarHeight: 82,
        leadingWidth: 72,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
          child: AppPulseButton(
            onTap: Get.back,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.darkBorder),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ),
        titleWidget: _LegalTopBar(title: title, subtitle: subtitle),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          AppAnimatedEntrance(
            child: _LegalHero(
              icon: icon,
              accent: accent,
              title: heroTitle,
              description: heroDescription,
            ),
          ),
          const Gap(18),
          ...List.generate(sections.length, (index) {
            final section = sections[index];
            return Padding(
              padding: EdgeInsets.only(
                bottom: index == sections.length - 1 ? 0 : 14,
              ),
              child: AppAnimatedEntrance(
                delay: Duration(milliseconds: 60 * (index % 4)),
                child: _LegalSectionCard(
                  title: section.title,
                  points: section.points,
                  accent: accent,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class LegalSectionData {
  const LegalSectionData({required this.title, required this.points});

  final String title;
  final List<String> points;
}

class _LegalTopBar extends StatelessWidget {
  const _LegalTopBar({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppText(title, fontSize: 20, fontWeight: FontWeight.w900),
        AppText(subtitle, fontSize: 12, color: Theme.of(context).hintColor),
      ],
    );
  }
}

class _LegalHero extends StatelessWidget {
  const _LegalHero({
    required this.icon,
    required this.accent,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final Color accent;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accent.withValues(alpha: 0.22),
            const Color(0xFF152032),
            const Color(0xFF0D121D),
          ],
        ),
        borderRadius: BorderRadius.circular(34),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [accent, Colors.white.withValues(alpha: 0.34)],
                  ),
                ),
                child: Icon(icon, color: Colors.white, size: 22),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const AppText(
                  'In-App Details',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const Gap(14),
          AppText(title, fontSize: 22, fontWeight: FontWeight.w900),
          const Gap(8),
          AppText(
            description,
            fontSize: 13,
            color: Theme.of(context).hintColor,
          ),
        ],
      ),
    );
  }
}

class _LegalSectionCard extends StatelessWidget {
  const _LegalSectionCard({
    required this.title,
    required this.points,
    required this.accent,
  });

  final String title;
  final List<String> points;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return AppGlassCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(99),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [accent, accent.withValues(alpha: 0.28)],
                  ),
                ),
              ),
              const Gap(12),
              Expanded(
                child: AppText(
                  title,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const Gap(14),
          ...points.map(
            (point) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(top: 6),
                    decoration: BoxDecoration(
                      color: accent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const Gap(10),
                  Expanded(
                    child: AppText(
                      point,
                      fontSize: 13,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
