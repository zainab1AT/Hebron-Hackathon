import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/home_shell.dart';
import 'screens/notifications_screen.dart';
import 'screens/onboarding/role_onboarding.dart';
import 'screens/settings/settings_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (_, __) => const HomeShell(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (_, __) => const RoleOnboarding(),
    ),
    GoRoute(
      path: '/notifications',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const NotificationsScreen(),
        transitionsBuilder: (_, animation, __, child) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          )),
          child: child,
        ),
      ),
    ),
    GoRoute(
      path: '/settings',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const SettingsScreen(),
        transitionsBuilder: (_, animation, __, child) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          )),
          child: child,
        ),
      ),
    ),
  ],
);
