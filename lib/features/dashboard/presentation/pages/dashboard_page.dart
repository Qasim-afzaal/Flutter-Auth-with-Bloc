import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc_state.dart';
import '../widgets/dashboard_bottom_nav.dart';
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
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Load data when dashboard opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeBloc>().add(const HomeItemsRequested());
      context.read<ProfileBloc>().add(const ProfileRequested());
      context.read<NotificationBloc>().add(const NotificationsRequested());
    });
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthBlocState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return Scaffold(
            body: IndexedStack(
              index: _currentIndex,
              children: const [
                HomePage(),
                NotificationPage(),
                ProfilePage(),
              ],
            ),
            bottomNavigationBar: DashboardBottomNav(
              currentIndex: _currentIndex,
              onTap: _onTabTapped,
            ),
          );
        }
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
