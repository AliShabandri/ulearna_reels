import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ulearna_reels/domain/entities/reel.dart';
import 'package:ulearna_reels/domain/repositories/reels_repository.dart';

part 'reels_event.dart';
part 'reels_state.dart';

class ReelsBloc extends Bloc<ReelsEvent, ReelsState> {
  final GetReels getReels;

  ReelsBloc({required this.getReels}) : super(ReelsInitial()) {
    on<FetchReels>(_onFetchReels);
    on<FetchMoreReels>(_onFetchMoreReels);
    on<RefreshReels>(_onRefreshReels);
  }

  Future<void> _onFetchReels(FetchReels event, Emitter<ReelsState> 
  emit) async {
    emit(ReelsLoading());

    final result = await getReels(
      GetReelsParams(page: 1, limit: event.limit, country: event.country),
    );

    result.fold(
      (failure) => emit(ReelsError(message: failure.message)),
      (reels) => emit(
        ReelsLoaded(
          reels: reels,
          hasReachedMax: reels.length < event.limit,
          currentPage: 1,
          limit: event.limit,
          country: event.country,
        ),
      ),
    );
  }

  Future<void> _onFetchMoreReels(
    FetchMoreReels event,
    Emitter<ReelsState> emit,
  ) async {
    if (state is ReelsLoaded) {
      final currentState = state as ReelsLoaded;

      // Return if we've already reached max
      if (currentState.hasReachedMax) return;

      emit(
        ReelsLoaded(
          reels: currentState.reels,
          hasReachedMax: currentState.hasReachedMax,
          currentPage: currentState.currentPage,
          limit: currentState.limit,
          country: currentState.country,
          isLoadingMore: true,
        ),
      );

      final nextPage = currentState.currentPage + 1;

      final result = await getReels(
        GetReelsParams(
          page: nextPage,
          limit: currentState.limit,
          country: currentState.country,
        ),
      );

      result.fold((failure) => emit(ReelsError(message: failure.message)), (
        newReels,
      ) {
        final hasReachedMax = newReels.length < currentState.limit;
        final allReels = List<Reel>.from(currentState.reels)..addAll(newReels);

        emit(
          ReelsLoaded(
            reels: allReels,
            hasReachedMax: hasReachedMax,
            currentPage: nextPage,
            limit: currentState.limit,
            country: currentState.country,
            isLoadingMore: false,
          ),
        );
      });
    }
  }

  Future<void> _onRefreshReels(
    RefreshReels event,
    Emitter<ReelsState> emit,
  ) async {
    if (state is ReelsLoaded) {
      final currentState = state as ReelsLoaded;

      emit(
        ReelsLoaded(
          reels: currentState.reels,
          hasReachedMax: currentState.hasReachedMax,
          currentPage: currentState.currentPage,
          limit: currentState.limit,
          country: currentState.country,
          isRefreshing: true,
        ),
      );

      final result = await getReels(
        GetReelsParams(
          page: 1,
          limit: currentState.limit,
          country: currentState.country,
        ),
      );

      result.fold(
        (failure) => emit(ReelsError(message: failure.message)),
        (reels) => emit(
          ReelsLoaded(
            reels: reels,
            hasReachedMax: reels.length < currentState.limit,
            currentPage: 1,
            limit: currentState.limit,
            country: currentState.country,
            isRefreshing: false,
          ),
        ),
      );
    } else {
      add(FetchReels(limit: event.limit, country: event.country));
    }
  }
}
