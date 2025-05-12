import 'dart:convert';

import 'package:ulearna_reels/core/errors/exceptions.dart';
import 'package:ulearna_reels/data/models/reel_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ReelsLocalDataSource {
  /// Gets the cached reels from SharedPreferences
  ///
  /// Throws [CacheException] if no cached data is present
  Future<ReelModel> getCachedReels({
    required int page,
    required int limit,
    required String country,
  });

  /// Caches the reels in SharedPreferences
  Future<void> cacheReels({
    required List<ReelModel> reels,
    required int page,
    required int limit,
    required String country,
  });
}

const CACHED_REELS_KEY = 'CACHED_REELS';

class ReelsLocalDataSourceImpl implements ReelsLocalDataSource {
  final SharedPreferences sharedPreferences;

  ReelsLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<ReelModel> getCachedReels({
    required int page,
    required int limit,
    required String country,
  }) async {
    // Create a unique key for this combination of parameters
    final cacheKey = '${CACHED_REELS_KEY}_${country}_${page}_${limit}';

    final jsonString = sharedPreferences.getString(cacheKey);
    if (jsonString != null) {
      try {
        final decodedJson = json.decode(jsonString);
        return decodedJson.map((item) => ReelModel.fromJson(item));
      } catch (e) {
        throw CacheException(message: 'Failed to decode cached reels');
      }
    } else {
      throw CacheException(message: 'No cached reels found');
    }
  }

  @override
  Future<void> cacheReels({
    required List<ReelModel> reels,
    required int page,
    required int limit,
    required String country,
  }) async {
    // Create a unique key for this combination of parameters
    final cacheKey = '${CACHED_REELS_KEY}_${country}_${page}_${limit}';

    try {
      final List<Map<String, dynamic>> jsonList =
          reels.map((reel) => reel.toJson()).toList();
      await sharedPreferences.setString(cacheKey, json.encode(jsonList));
    } catch (e) {
      throw CacheException(message: 'Failed to cache reels');
    }
  }
}
