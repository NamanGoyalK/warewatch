import 'package:equatable/equatable.dart';

class HomeNavigationState extends Equatable {
  const HomeNavigationState({required this.currentIndex});

  const HomeNavigationState.initial({this.currentIndex = 0});

  final int currentIndex;

  HomeNavigationState copyWith({int? currentIndex}) {
    return HomeNavigationState(currentIndex: currentIndex ?? this.currentIndex);
  }

  @override
  List<Object> get props => [currentIndex];
}
