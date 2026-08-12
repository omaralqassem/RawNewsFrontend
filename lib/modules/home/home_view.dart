import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawnes/core/constants/app_colors.dart';
import 'package:rawnes/core/utils/widgets.dart';
import 'package:rawnes/modules/NewsFeed/news_feed_view.dart';
import 'package:rawnes/modules/Preferences/preferencesView.dart';
import 'package:rawnes/modules/bookmarks/bookmarks_view.dart';
import 'package:rawnes/modules/search/search_view.dart';

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
      const FeedView(),
      const SearchView(),
      const BookmarksView(),
      const PreferencesView(),
    ];

    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: theme.scaffoldBackgroundColor,

        appBar: AppBar(
          titleSpacing: 0,
          leading: IconButton(
            icon: Icon(Icons.menu_rounded, color: textPrimary, size: 24),
            onPressed: () => scaffoldKey.currentState?.openDrawer(),
          ),
          title: RichText(
            text: TextSpan(
              text: "RAW",
              style: TextStyle(
                fontSize: 22,
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
              selectedFontSize: 11,
              unselectedFontSize: 11,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w900),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w700,
              ),
              elevation: 0,
              items: const [
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.newspaper_rounded, size: 22),
                  ),
                  label: "الأخبار",
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.search_rounded, size: 22),
                  ),
                  label: "البحث",
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.bookmarks_outlined, size: 22),
                  ),
                  label: "المحفوظات",
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.tune_rounded, size: 22),
                  ),
                  label: "الإعدادات",
                ),
              ],
            ),
          ),
        ),
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
                          radius: 26,
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
                      user?.username ?? "مستخدم زائر",
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
                            title: "الملف الشخصي",
                            onTap: () => Get.toNamed('/profile'),
                          ),

                          Obx(
                            () => DrawerListTile(
                              icon: Icons.dark_mode_outlined,
                              title: "الوضع الداكن",
                              trailing: Switch(
                                value: controller.isDarkMode.value,
                                onChanged: (_) => controller.toggleTheme(),
                                activeColor: AppColors.actionBlue,
                              ),
                            ),
                          ),

                          const Spacer(),

                          const SectionHeader(title: "معلومات التطبيق"),
                          DrawerListTile(
                            icon: Icons.info_outline,
                            title: "عن التطبيق والمعلومات",
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
                    icon: const Icon(Icons.logout_rounded, size: 18),
                    label: const Text(
                      "تسجيل الخروج",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.errorRed,
                      side: const BorderSide(
                        color: AppColors.errorRed,
                        width: 1.0,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      "RAW.NEWS الإصدار 1.0.0",
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
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
