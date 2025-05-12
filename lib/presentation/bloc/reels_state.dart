part of 'reels_bloc.dart';

sealed class ReelsState extends Equatable {
  const ReelsState();
  
  @override
  List<Object> get props => [];
}

class ReelsInitial extends ReelsState {}

class ReelsLoading extends ReelsState {}

class ReelsLoaded extends ReelsState {
  final List<Reel> reels;
  final bool hasReachedMax;
  final int currentPage;
  final int limit;
  final String country;
  final bool isLoadingMore;
  final bool isRefreshing;

  const ReelsLoaded({
    required this.reels,
    required this.hasReachedMax,
    required this.currentPage,
    required this.limit,
    required this.country,
    this.isLoadingMore = false,
    this.isRefreshing = false,
  });

  @override
  List<Object> get props => [
    reels,
    hasReachedMax,
    currentPage,
    limit,
    country,
    isLoadingMore,
    isRefreshing,
  ];
}

class ReelsError extends ReelsState {
  final String message;

  const ReelsError({required this.message});

  @override
  List<Object> get props => [message];
}
