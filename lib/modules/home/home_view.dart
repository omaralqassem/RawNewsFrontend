import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawnes/core/constants/app_colors.dart';
import 'package:rawnes/core/utils/widgets.dart';

import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;

    final List<Widget> pages = [
      const _PlaceholderPage(title: "FEED"),
      const _PlaceholderPage(title: "SEARCH"),
      const _PlaceholderPage(title: "BOOKMARKS"),
      const _PlaceholderPage(title: "PREFERENCES"),
    ];

    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(Icons.menu_rounded, color: textPrimary, size: 22),
          onPressed: () => scaffoldKey.currentState?.openDrawer(),
        ),
        title: RichText(
          text: TextSpan(
            text: "RAW",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              letterSpacing: -1.0,
              color: textPrimary,
            ),
            children: const [
              TextSpan(
                text: ".",
                style: TextStyle(color: AppColors.actionBlue),
              ),
              TextSpan(
                text: "NEWS",
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: borderColor, height: 1.0),
        ),
      ),

      drawer: const HomeDrawer(),

      body: Obx(() => pages[controller.currentIndex.value]),

      bottomNavigationBar: Obx(
        () => Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: borderColor, width: 1.0)),
          ),
          child: BottomNavigationBar(
            currentIndex: controller.currentIndex.value,
            onTap: controller.changeTabIndex,
            type: BottomNavigationBarType.fixed,
            backgroundColor: theme.scaffoldBackgroundColor,
            selectedItemColor: AppColors.actionBlue,
            unselectedItemColor: textSecondary.withOpacity(0.6),
            selectedFontSize: 10,
            unselectedFontSize: 10,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
            ),
            elevation: 0,
            items: [
              BottomNavigationBarItem(
                icon: const Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.newspaper_rounded, size: 20),
                ),
                label: "FEED",
              ),
              BottomNavigationBarItem(
                icon: const Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.search_rounded, size: 20),
                ),
                label: "SEARCH",
              ),
              BottomNavigationBarItem(
                icon: const Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.bookmarks_outlined, size: 20),
                ),
                label: "SAVED",
              ),
              BottomNavigationBarItem(
                icon: const Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.tune_rounded, size: 20),
                ),
                label: "PREFS",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlaceholderPage extends StatelessWidget {
  final String title;

  const _PlaceholderPage({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              letterSpacing: 4.0,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Container(width: 40, height: 2, color: AppColors.actionBlue),
        ],
      ),
    );
  }
}

class HomeDrawer extends GetView<HomeController> {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return Drawer(
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Obx(() {
              if (controller.isProfileLoading.value) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 32.0,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: borderColor, width: 1.0),
                    ),
                  ),
                  child: const Center(
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5,
                        color: AppColors.actionBlue,
                      ),
                    ),
                  ),
                );
              }

              final user = controller.rxUser.value;

              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 20.0,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: borderColor, width: 1.0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: AppColors.actionBlue.withOpacity(
                            0.1,
                          ),
                          backgroundImage: user?.avatarUrl != null
                              ? NetworkImage(user!.avatarUrl!)
                              : null,
                          child: user?.avatarUrl == null
                              ? const Icon(
                                  Icons.person_outline_rounded,
                                  color: AppColors.actionBlue,
                                  size: 36,
                                )
                              : null,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user?.name ?? "Guest User",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: textPrimary,
                      ),
                    ),
                    Text(
                      user?.email ?? "no-email@rawnews.com",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
              );
            }),

            Expanded(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          DrawerListTile(
                            icon: Icons.person_outline_rounded,
                            title: "Profile",
                            onTap: () => Get.toNamed('/profile'),
                          ),

                          Obx(
                            () => DrawerListTile(
                              icon: Icons.dark_mode_outlined,
                              title: "Dark mode",
                              trailing: Switch(
                                value: controller.isDarkMode.value,
                                onChanged: (_) => controller.toggleTheme(),
                              ),
                            ),
                          ),

                          const Spacer(),

                          SectionHeader(title: "About us"),
                          DrawerListTile(
                            icon: Icons.info_outline,
                            title: "About us",
                            onTap: () => Get.toNamed('/about'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: borderColor, width: 1.0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  OutlinedButton.icon(
                    onPressed: controller.logout,
                    icon: const Icon(Icons.logout_rounded, size: 16),
                    label: Text(
                      "logout".toUpperCase(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.errorRed,
                      side: const BorderSide(
                        color: AppColors.errorRed,
                        width: 1.0,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      "RAW.NEWS v1.0.0",
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                        color: textSecondary.withOpacity(0.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
