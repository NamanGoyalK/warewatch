import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warewatch/features/home/presentation/cubits/home_navigation_state.dart';

class HomeNavigationCubit extends Cubit<HomeNavigationState> {
  HomeNavigationCubit({int initialIndex = 0})
    : super(HomeNavigationState.initial(currentIndex: initialIndex));

  void selectTab(int index) {
    emit(state.copyWith(currentIndex: index));
  }
}
