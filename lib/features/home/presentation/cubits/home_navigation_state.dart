import 'package:equatable/equatable.dart';

class HomeNavigationState extends Equatable {
  const HomeNavigationState({
    required this.currentIndex,
    required this.isVisible,
  });

  const HomeNavigationState.initial({this.currentIndex = 0}) : isVisible = true;

  final int currentIndex;
  final bool isVisible;

  HomeNavigationState copyWith({int? currentIndex, bool? isVisible}) {
    return HomeNavigationState(
      currentIndex: currentIndex ?? this.currentIndex,
      isVisible: isVisible ?? this.isVisible,
    );
  }

  @override
  List<Object> get props => [currentIndex, isVisible];
}
