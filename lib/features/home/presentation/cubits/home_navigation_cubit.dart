import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warewatch/features/home/presentation/cubits/home_navigation_state.dart';

class HomeNavigationCubit extends Cubit<HomeNavigationState> {
  HomeNavigationCubit({int initialIndex = 0})
    : super(HomeNavigationState.initial(currentIndex: initialIndex)) {
    _startHideTimer();
  }

  Timer? _hideTimer;

  void selectTab(int index) {
    emit(state.copyWith(currentIndex: index, isVisible: true));
    _startHideTimer();
  }

  void showDock() {
    emit(state.copyWith(isVisible: true));
    _startHideTimer();
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 5), () {
      if (!isClosed) {
        emit(state.copyWith(isVisible: false));
      }
    });
  }

  @override
  Future<void> close() {
    _hideTimer?.cancel();
    return super.close();
  }
}
