import 'package:movies/features/main_layout/home_tab/data/models/movie_model.dart';

class MovieDetailsResponse {
  String? status;
  String? statusMessage;
  MovieDetailsData? data;

  MovieDetailsResponse.fromJson(dynamic json) {
    status = json['status'];
    statusMessage = json['status_message'];
    data = json['data'] != null ? MovieDetailsData.fromJson(json['data']) : null;
  }
}

class MovieDetailsData {
  Movies? movie;

  MovieDetailsData.fromJson(dynamic json) {
    movie = json['movie'] != null ? Movies.fromJson(json['movie']) : null;
  }
}

