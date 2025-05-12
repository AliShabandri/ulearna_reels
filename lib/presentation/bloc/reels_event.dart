part of 'reels_bloc.dart';

sealed class ReelsEvent extends Equatable {
  const ReelsEvent();

  @override
  List<Object> get props => [];
}

class FetchReels extends ReelsEvent {
  final int limit;
  final String country;

  const FetchReels({this.limit = 10, this.country = 'United+States'});

  @override
  List<Object> get props => [limit, country];
}

class FetchMoreReels extends ReelsEvent {}

class RefreshReels extends ReelsEvent {
  final int limit;
  final String country;

  const RefreshReels({this.limit = 10, this.country = 'United+States'});

  @override
  List<Object> get props => [limit, country];
}
