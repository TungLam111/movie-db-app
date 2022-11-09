import 'package:dio/dio.dart';
import 'package:mock_bloc_stream/auth/data/models/request/req_delete_session.dart';
import 'package:mock_bloc_stream/auth/data/models/request/req_login.dart';
import 'package:mock_bloc_stream/auth/data/models/request/req_token.dart';
import 'package:mock_bloc_stream/auth/data/models/request_token_response.dart';
import 'package:mock_bloc_stream/auth/data/models/session_response.dart';
import 'package:mock_bloc_stream/auth/data/models/session_with_login.dart';
import 'package:mock_bloc_stream/movie/data/models/media_movie_image_model.dart';
import 'package:mock_bloc_stream/movie/data/models/movie_detail_response.dart';
import 'package:mock_bloc_stream/movie/data/models/movie_response.dart';
import 'package:mock_bloc_stream/tv/data/models/media_tv_image_model.dart';
import 'package:mock_bloc_stream/tv/data/models/tv_detail_response.dart';
import 'package:mock_bloc_stream/tv/data/models/tv_response.dart';
import 'package:mock_bloc_stream/tv/data/models/tv_season_episode_response.dart';
import 'package:mock_bloc_stream/utils/urls.dart';
import 'package:retrofit/retrofit.dart';

part 'api_service.g.dart';

@RestApi()
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @GET('/tv/on_the_air')
  Future<TvResponse> getOnTheAirTvs({
    @Query('api_key') String apiKey = Urls.apiKey,
    @Query('language') String language = 'en-US',
    @Query('page') int page = 1,
  });

  @GET('/tv/popular')
  Future<TvResponse> getPopularTvs({
    @Query('api_key') String apiKey = Urls.apiKey,
    @Query('language') String language = 'en-US',
    @Query('page') int page = 1,
  });

  @GET('/tv/top_rated')
  Future<TvResponse> getTopRatedTvs({
    @Query('api_key') String apiKey = Urls.apiKey,
    @Query('language') String language = 'en-US',
    @Query('page') int page = 1,
  });

  @GET('/tv/{id}')
  Future<TvDetailResponse> getTvDetail({
    @Path() required int id,
    @Query('api_key') String apiKey = Urls.apiKey,
  });

  @GET('/tv/{id}/season/{seasonNumber}')
  Future<TvSeasonEpisodeResponse> getTvSeasonEpisodes({
    @Path() required int id,
    @Path() required int seasonNumber,
    @Query('api_key') String apiKey = Urls.apiKey,
  });

  @GET('/tv/{id}/recommendations')
  Future<TvResponse> getTvRecommendations({
    @Path() required int id,
    @Query('api_key') String apiKey = Urls.apiKey,
  });

  @GET('/search/tv')
  Future<TvResponse> searchTvs({
    @Query('query') required String query,
    @Query('api_key') String apiKey = Urls.apiKey,
  });

  @GET('/tv/{id}/images?language=en-US&include_image_language=en,null')
  Future<MediaTvImageModel> getTvImages({
    @Path() required int id,
    @Query('api_key') String apiKey = Urls.apiKey,
  });

  @GET('/movie/now_playing')
  Future<MovieResponse> getNowPlayingMovies({
    @Query('api_key') String apiKey = Urls.apiKey,
  });

  @GET('/movie/popular')
  Future<MovieResponse> getPopularMovies({
    @Query('api_key') String apiKey = Urls.apiKey,
  });

  @GET('/movie/top_rated')
  Future<MovieResponse> getTopRatedMovies({
    @Query('api_key') String apiKey = Urls.apiKey,
  });

  @GET('/movie/{id}')
  Future<MovieDetailResponse> getMovieDetail({
    @Path() required int id,
    @Query('api_key') String apiKey = Urls.apiKey,
  });

  @GET('/movie/{id}/recommendations')
  Future<MovieResponse> getMovieRecommendations({
    @Path() required int id,
    @Query('api_key') String apiKey = Urls.apiKey,
  });

  @GET('/search/movie')
  Future<MovieResponse> searchMovies({
    @Query('query') required String query,
    @Query('api_key') String apiKey = Urls.apiKey,
  });

  @GET('/movie/{id}/images')
  Future<MediaMovieImageModel> getMovieImages({
    @Path() required int id,
    @Query('api_key') String apiKey = Urls.apiKey,
  });

  @GET('/authentication/token/new')
  Future<RequestTokenResponse> createRequestToken({
    @Query('api_key') String apiKey = Urls.apiKey,
  });

  @POST('/authentication/session/new')
  Future<SessionResponse> createSession({
    @Query('api_key') String apiKey = Urls.apiKey,
    @Body() required ReqToken requestToken,
  });

  @POST('/authentication/token/validate_with_login')
  Future<SessionWithLoginResponse> createSessionWithLogin({
    @Query('api_key') String apiKey = Urls.apiKey,
    @Body() required ReqLogin requestLogin,
  });

  @DELETE('/authentication/session')
  Future<dynamic> deleteSession({
    @Query('api_key') String apiKey = Urls.apiKey,
    @Body() required ReqDeleteSession requestDelete,
  });
}
