class Movie {
  int id;
  String originalName;
  String posterPath;
  String overview;

  Movie({
    this.id,
    this.originalName,
    this.posterPath,
    this.overview,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
        id: json['id'],
        originalName: json['original_name'],
        posterPath: json['poster_path'],
        overview: json['overview']);
  }

  static List<Movie> parseMovieList(map) {
    var list = map['results'] as List;
    return list.map((movie) => Movie.fromJson(movie)).toList();
  }
}
