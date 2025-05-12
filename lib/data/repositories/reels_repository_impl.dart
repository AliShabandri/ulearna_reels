import 'package:dartz/dartz.dart';
import 'package:ulearna_reels/core/errors/exceptions.dart';
import 'package:ulearna_reels/core/errors/failures.dart';
import 'package:ulearna_reels/core/utils/typedefs.dart';
import 'package:ulearna_reels/data/datasources/local/reels_local_data_source.dart';
import 'package:ulearna_reels/data/datasources/remote/reels_remote_data_source.dart';
import 'package:ulearna_reels/domain/entities/reel.dart';
import 'package:ulearna_reels/domain/repositories/reels_repository.dart';

class ReelsRepositoryImpl implements ReelsRepository {
  final ReelsRemoteDataSource remoteDataSource;
  final ReelsLocalDataSource localDataSource;


  ReelsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  ResultFuture<List<Reel>> getReels({
    required int page,
    required int limit,
    required String country,
  }) async {
    // Check if device is online

      try {
        // Get reels from remote data source
        final remoteReels = await remoteDataSource.getReels(
          page: page,
          limit: limit,
          country: country,
        );

        // Cache the reels
        await localDataSource.cacheReels(
          reels: remoteReels,
          page: page,
          limit: limit,
          country: country,
        );

        return Right(remoteReels);
      } on ServerException catch (e) {
        return Left(
          ServerFailure(message: e.message, statusCode: e.statusCode),
        );
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
  }
}
