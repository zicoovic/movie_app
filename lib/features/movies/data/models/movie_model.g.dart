// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MovieModelAdapter extends TypeAdapter<MovieModel> {
  @override
  final int typeId = 0;

  @override
  MovieModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MovieModel(
      movieId: fields[0] as int,
      movieTitle: fields[1] as String,
      movieOverview: fields[2] as String,
      moviePosterPath: fields[3] as String?,
      movieBackdropPath: fields[4] as String?,
      movieVoteAverage: fields[5] as double,
      movieReleaseDate: fields[6] as String,
      movieGenreIds: (fields[7] as List).cast<int>(),
      cachedAt: fields[8] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, MovieModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.movieId)
      ..writeByte(1)
      ..write(obj.movieTitle)
      ..writeByte(2)
      ..write(obj.movieOverview)
      ..writeByte(3)
      ..write(obj.moviePosterPath)
      ..writeByte(4)
      ..write(obj.movieBackdropPath)
      ..writeByte(5)
      ..write(obj.movieVoteAverage)
      ..writeByte(6)
      ..write(obj.movieReleaseDate)
      ..writeByte(7)
      ..write(obj.movieGenreIds)
      ..writeByte(8)
      ..write(obj.cachedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieModel _$MovieModelFromJson(Map<String, dynamic> json) => MovieModel(
      movieId: (json['movieId'] as num).toInt(),
      movieTitle: json['movieTitle'] as String,
      movieOverview: json['movieOverview'] as String,
      moviePosterPath: json['moviePosterPath'] as String?,
      movieBackdropPath: json['movieBackdropPath'] as String?,
      movieVoteAverage: (json['movieVoteAverage'] as num).toDouble(),
      movieReleaseDate: json['movieReleaseDate'] as String,
      movieGenreIds: (json['movieGenreIds'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      cachedAt: DateTime.parse(json['cachedAt'] as String),
    );

Map<String, dynamic> _$MovieModelToJson(MovieModel instance) =>
    <String, dynamic>{
      'movieId': instance.movieId,
      'movieTitle': instance.movieTitle,
      'movieOverview': instance.movieOverview,
      'moviePosterPath': instance.moviePosterPath,
      'movieBackdropPath': instance.movieBackdropPath,
      'movieVoteAverage': instance.movieVoteAverage,
      'movieReleaseDate': instance.movieReleaseDate,
      'movieGenreIds': instance.movieGenreIds,
      'cachedAt': instance.cachedAt.toIso8601String(),
    };
