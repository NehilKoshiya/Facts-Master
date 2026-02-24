import 'dart:developer';
import 'package:daily_facts/core/constants/app_colors.dart';
import 'package:daily_facts/generated/assets.dart';
import 'package:daily_facts/module/home/views/explore_topics_screen.dart';
import 'package:daily_facts/module/home/views/home_view.dart';
import 'package:daily_facts/module/setting/views/like_screen.dart';
import 'package:daily_facts/module/setting/views/settings_view.dart';
import 'package:daily_facts/widgets/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final PersistentTabController _controller;
  final PageController _pageController = PageController();
  bool _hideNavBar = false;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);

    _controller.addListener(() {
      setState(() {});
    });
    // Detect Scroll Direction
    _pageController.addListener(() {
      if (!_pageController.hasClients) return;

      final direction = _pageController.position.userScrollDirection;

      if (direction == ScrollDirection.reverse && !_hideNavBar) {
        log("Hiding Nav Bar");
        setState(() => _hideNavBar = true);
      } else if (direction == ScrollDirection.forward && _hideNavBar) {
        log("Showing Nav Bar");
        setState(() => _hideNavBar = false);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      controller: _controller,
      hideNavigationBar: _hideNavBar,
      avoidBottomPadding: false,
      margin: EdgeInsets.zero,
      tabs: [
        PersistentTabConfig(
          screen: FactsReelsScreen(scrollController: _pageController),

          item: ItemConfig(
            icon: CustomSvgImage(
              image: Assets.imagesHome,
              imageHeight: 20,
              imageWidth: 20,
              imageColor: _controller.index == 0
                  ? Colors.pinkAccent
                  : Colors.white,
            ),
            title: "Home",

            activeForegroundColor: Colors.pinkAccent,
            inactiveForegroundColor: Colors.grey,
          ),
        ),
        PersistentTabConfig(
          screen: ExploreTopicsScreen(),
          item: ItemConfig(
            icon: CustomSvgImage(
              image: Assets.imagesCategory,
              imageHeight: 20,
              imageWidth: 20,
              imageColor: _controller.index == 1
                  ? const Color(0xFF41b37e)
                  : Colors.white,
            ),
            title: "Category",
            activeForegroundColor: Color(0xFF41b37e),
            inactiveForegroundColor: Colors.grey,
          ),
        ),
        PersistentTabConfig(
          screen: LikedMessagesView(),
          item: ItemConfig(
            icon: CustomSvgImage(
              image: Assets.imagesSaved,
              imageHeight: 20,
              imageWidth: 20,
              imageColor: _controller.index == 2
                  ? const Color(0xFFf3594e)
                  : Colors.white,
            ),
            title: "Saved",
            activeForegroundColor: const Color(0xFFf3594e),
            inactiveForegroundColor: Colors.grey,
          ),
        ),
        PersistentTabConfig(
          screen: SettingsView(),
          item: ItemConfig(
            icon: CustomSvgImage(
              image: Assets.imagesSetting,
              imageHeight: 20,
              imageWidth: 20,
              imageColor: _controller.index == 3
                  ? const Color(0xFF6756d0)
                  : Colors.white,
            ),
            title: "Setting",
            activeForegroundColor: const Color(0xFF6756d0),
            inactiveForegroundColor: Colors.grey,
          ),
        ),
      ],
      navBarBuilder: (navBarConfig) => Padding(
        padding: const EdgeInsets.all(20),

        child: Style2BottomNavBar(
          navBarConfig: navBarConfig,

          itemAnimationProperties: ItemAnimation(
            duration: Durations.extralong2,
          ),

          itemPadding: EdgeInsets.all(10),
          navBarDecoration: NavBarDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Color(0xFF0D001C),
          ),
        ),
      ),
    );
  }
}
