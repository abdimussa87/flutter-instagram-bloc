import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram_bloc/enums/bottom_nav_item.dart';
import 'package:meta/meta.dart';

part 'bottom_nav_bar_state.dart';

class BottomNavBarCubit extends Cubit<BottomNavBarState> {
  BottomNavBarCubit()
      : super(BottomNavBarState(selectedItem: BottomNavItem.feed));

  void updateSelectedItem(BottomNavItem selectedItem) {
    if (selectedItem != state.selectedItem) {
      emit(BottomNavBarState(selectedItem: selectedItem));
    }
  }
}
