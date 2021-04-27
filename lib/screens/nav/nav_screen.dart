import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_bloc/enums/enums.dart';
import 'package:instagram_bloc/repositories/auth/auth_repository.dart';
import 'package:instagram_bloc/screens/nav/cubit/bottom_nav_bar_cubit.dart';

import 'widgets/widgets.dart';

class NavScreen extends StatelessWidget {
  static const String routeName = '/nav';
  static Route route() {
    return PageRouteBuilder(
      settings: const RouteSettings(name: routeName),
      transitionDuration: const Duration(seconds: 0),
      pageBuilder: (_, __, ___) => BlocProvider(
        create: (_) => BottomNavBarCubit(),
        child: NavScreen(),
      ),
    );
  }

  final Map<BottomNavItem, IconData> items = const {
    BottomNavItem.feed: Icons.home,
    BottomNavItem.search: Icons.search,
    BottomNavItem.create: Icons.add,
    BottomNavItem.notifications: Icons.favorite_border,
    BottomNavItem.profile: Icons.account_circle,
  };

  final Map<BottomNavItem, GlobalKey<NavigatorState>> navigatorKeys = {
    BottomNavItem.feed: GlobalKey<NavigatorState>(),
    BottomNavItem.search: GlobalKey<NavigatorState>(),
    BottomNavItem.create: GlobalKey<NavigatorState>(),
    BottomNavItem.notifications: GlobalKey<NavigatorState>(),
    BottomNavItem.profile: GlobalKey<NavigatorState>(),
  };

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          // SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
          false,
      child: BlocBuilder<BottomNavBarCubit, BottomNavBarState>(
        builder: (context, state) {
          return Scaffold(
            body: Stack(
              children: items
                  .map((item, _) => MapEntry(
                      item,
                      _buildOffstageNavigator(
                        item,
                        item == state.selectedItem,
                      )))
                  .values
                  .toList(),
            ),
            bottomNavigationBar: BottomNavBar(
              onTap: (index) {
                BottomNavItem selectedItem = BottomNavItem.values[index];
                _selectBottomNavItem(
                    context, selectedItem, selectedItem == state.selectedItem);
              },
              items: items,
              selectedItem: state.selectedItem,
            ),
          );
        },
      ),
    );
  }

  void _selectBottomNavItem(
    BuildContext context,
    BottomNavItem selectedItem,
    bool isSameItem,
  ) {
    if (isSameItem) {
      navigatorKeys[selectedItem]
          .currentState
          .popUntil((route) => route.isFirst);
    }
    context.read<BottomNavBarCubit>().updateSelectedItem(selectedItem);
  }

  Widget _buildOffstageNavigator(BottomNavItem currentItem, bool isSelected) {
    return Offstage(
      // remember that offstage hides its child when its true, thats why we used !isSelected
      offstage: !isSelected,
      child: TabNavigator(
          navigatorKey: navigatorKeys[currentItem], item: currentItem),
    );
  }
}
