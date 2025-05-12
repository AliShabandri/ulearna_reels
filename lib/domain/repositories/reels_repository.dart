import 'package:equatable/equatable.dart';
import 'package:ulearna_reels/core/utils/typedefs.dart';
import 'package:ulearna_reels/domain/entities/reel.dart';
abstract class ReelsRepository {
  /// Fetches reels from the remote data source
  ///
  /// Returns a [List<Reel>] if successful
  /// Returns a [Failure] if unsuccessful
  ///
  /// Parameters:
  /// - [page]: Current page number for pagination
  /// - [limit]: Number of reels to fetch per page
  /// - [country]: Country filter for reels
  ResultFuture<List<Reel>> getReels({
    required int page,
    required int limit,
    required String country,
  });
}

class GetReels {
  final ReelsRepository repository;

  GetReels({required this.repository});

  ResultFuture<List<Reel>> call(GetReelsParams params) {
    return repository.getReels(
      page: params.page,
      limit: params.limit,
      country: params.country,
    );
  }
}

class GetReelsParams extends Equatable {
  final int page;
  final int limit;
  final String country;

  const GetReelsParams({
    required this.page,
    required this.limit,
    required this.country,
  });

  @override
  List<Object> get props => [page, limit, country];
}
