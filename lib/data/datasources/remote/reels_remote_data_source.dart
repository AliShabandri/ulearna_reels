import 'dart:convert';
import 'package:ulearna_reels/core/constants/api_constants.dart';
import 'package:ulearna_reels/core/errors/exceptions.dart';
import 'package:ulearna_reels/data/models/reel_model.dart';
import 'package:http/http.dart' as http;

abstract class ReelsRemoteDataSource {
  /// Calls the API endpoint to get reels
  ///
  /// Throws a [ServerException] for all error codes
  Future<List<ReelModel>> getReels({
    required int page,
    required int limit,
    required String country,
  });
}

class ReelsRemoteDataSourceImpl implements ReelsRemoteDataSource {
  final http.Client client;

  ReelsRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ReelModel>> getReels({
    required int page,
    required int limit,
    required String country,
  }) async {
    try {
      final url = ApiConstants.getReelsUrl(
        page: page,
        limit: limit,
        country: country,
      );

      final response = await client.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        final reelsResponse = ReelsResponse.fromJson(responseBody);
          return reelsResponse.data;
      } else {
        throw ServerException(
          message: 'Failed to fetch reels',
          statusCode: response.statusCode,
        );
      }
    } on http.ClientException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(message: e.toString());
    }
  }
}
