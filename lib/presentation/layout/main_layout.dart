import 'package:bm_binus/core/constants.dart/custom_colors.dart';
import 'package:bm_binus/presentation/bloc/sidebar_bloc.dart';
import 'package:bm_binus/presentation/layout/sidebar_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SidebarBloc(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 800;
          final sidebar = SidebarMenu(isCollapsed: isMobile);
          return Scaffold(
            appBar: isMobile
                ? buildAppBarMobile(context)
                : buildAppBarDesktop(context),
            drawer: isMobile ? Drawer(child: sidebar) : null,
            body: Row(
              children: [
                if (!isMobile) SizedBox(width: 240, child: sidebar),
                Expanded(child: child),
              ],
            ),
          );
        },
      ),
    );
  }
}

PreferredSizeWidget buildAppBarDesktop(BuildContext context) {
  return AppBar(
    title: Row(
      spacing: 10,
      children: [
        Image.asset('assets/images/logo.png', height: 40),
        const Text(
          'Building Management',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ],
    ),
    backgroundColor: CustomColors.primary,
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 15),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.sunny, color: Colors.white),
              onPressed: () {},
            ),
          ],
        ),
      ),
    ],
  );
}

PreferredSizeWidget buildAppBarMobile(BuildContext context) {
  return AppBar(
    backgroundColor: CustomColors.primary,
    title: Row(
      spacing: 10,
      children: [
        Image.asset('assets/images/logo.png', height: 40),
        const Text(
          'Building Management',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ],
    ),
    actions: [
      IconButton(
        icon: const Icon(Icons.notifications, color: Colors.white),
        onPressed: () {},
      ),
      IconButton(
        icon: const Icon(Icons.sunny, color: Colors.white),
        onPressed: () {},
      ),
    ],
    leading: Builder(
      builder: (context) => IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
    ),
  );
}
