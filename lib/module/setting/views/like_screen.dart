import 'package:daily_facts/core/constants/constants.dart';
import 'package:daily_facts/services/storage_service.dart';
import 'package:daily_facts/widgets/app_motion.dart';
import 'package:daily_facts/widgets/app_surfaces.dart';
import 'package:daily_facts/widgets/app_text.dart';
import 'package:daily_facts/widgets/custom_appbar.dart';
import 'package:daily_facts/widgets/fact_card.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../controllers/setting_controller.dart';

class LikedMessagesView extends StatefulWidget {
  const LikedMessagesView({super.key});

  @override
  State<LikedMessagesView> createState() => _LikedMessagesViewState();
}

class _LikedMessagesViewState extends State<LikedMessagesView> {
  final SettingController c = Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        c.loadStoredData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: customAppBar(
        title: 'Saved Facts',
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
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (c.likedMessages.isEmpty) {
          return const Center(child: AppText("No saved facts yet"));
        }

        return ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            const AppSectionHeader(
              title: 'Saved Facts',
              subtitle:
                  'Everything you bookmarked stays here for quick access.',
            ),
            const Gap(18),
            ...List.generate(c.likedMessages.length, (index) {
              final fact = c.likedMessages[index];
              final data = StorageService().read(Constants.likedMessages) ?? [];
              final isLiked = data.contains(fact);
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index == c.likedMessages.length - 1 ? 0 : 16,
                ),
                child: AppAnimatedEntrance(
                  delay: Duration(milliseconds: 55 * (index % 6)),
                  child: FactCard(
                    fact: fact,
                    compact: true,
                    isLiked: isLiked,
                    useAnimatedLike: false,
                    onCopy: () => Constants().copyMessage(fact),
                    onShare: () => Constants().shareOther(fact),
                    onWhatsApp: () => Constants().shareToWhatsApp(fact),
                    onLike: (liked) async {
                      Constants().toggleLike(fact);
                      c.loadStoredData();
                      return !liked;
                    },
                  ),
                ),
              );
            }),
          ],
        );
      }),
    );
  }
}
