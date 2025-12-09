import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc_state.dart';
import '../widgets/dashboard_bottom_nav.dart';
import '../widgets/dashboard_header.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../home/presentation/bloc/home_bloc.dart';
import '../../../home/presentation/bloc/home_event.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../../../profile/presentation/bloc/profile_event.dart';
import '../../../notification/presentation/pages/notification_page.dart';
import '../../../notification/presentation/bloc/notification_bloc.dart';
import '../../../notification/presentation/bloc/notification_event.dart';

/// Dashboard Page
/// Main container with bottom navigation bar
/// Shows different pages based on selected tab
/// Displays user name and email from storage using DashboardBloc
/// Tab index is managed by DashboardBloc (not local state)
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    // Load data when dashboard opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardBloc>().add(const DashboardDataRequested());
      context.read<HomeBloc>().add(const HomeItemsRequested());
      context.read<ProfileBloc>().add(const ProfileRequested());
      context.read<NotificationBloc>().add(const NotificationsRequested());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthBlocState>(
      builder: (context, authState) {
        if (authState is AuthAuthenticated) {
          return BlocBuilder<DashboardBloc, DashboardState>(
            builder: (context, dashboardState) {
              // Get current tab index from BLoC state
              final currentTabIndex = _getCurrentTabIndex(dashboardState);

              return Scaffold(
                body: Column(
                  children: [
                    // Dashboard Header with User Name and Email
                    const DashboardHeader(),
                    // Page Content
                    Expanded(
                      child: IndexedStack(
                        index: currentTabIndex,
                        children: const [
                          HomePage(),
                          NotificationPage(),
                          ProfilePage(),
                        ],
                      ),
                    ),
                  ],
                ),
                bottomNavigationBar: DashboardBottomNav(
                  currentIndex: currentTabIndex,
                  onTap: (index) {
                    // Dispatch event to BLoC to change tab
                    context.read<DashboardBloc>().add(DashboardTabChanged(index));
                  },
                ),
              );
            },
          );
        }
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  /// Helper method to extract current tab index from any dashboard state
  int _getCurrentTabIndex(DashboardState state) {
    if (state is DashboardLoaded) {
      return state.currentTabIndex;
    } else if (state is DashboardLoading) {
      return state.currentTabIndex;
    } else if (state is DashboardError) {
      return state.currentTabIndex;
    } else if (state is DashboardInitial) {
      return state.currentTabIndex;
    }
    return 0;
  }
}
