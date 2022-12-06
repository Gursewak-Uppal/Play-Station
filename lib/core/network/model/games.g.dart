// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'games.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Games _$GamesFromJson(Map<String, dynamic> json) => Games(
      json['id'] as int?,
      json['name'] as String?,
      json['background_image'] as String?,
      json['metacritic'] as int?,
      (json['parent_platforms'] as List<dynamic>?)
          ?.map((e) => ParentPlatform.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['released'] as String?,
      (json['genres'] as List<dynamic>?)
          ?.map((e) => Genres.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['short_screenshots'] as List<dynamic>?)
          ?.map((e) => ShortScreenShots.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['ratings'] as List<dynamic>?)
          ?.map((e) => Ratings.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['ratings_count'] as int?,
      json['description'] as String?,
      json['description_raw'] as String?,
    );

Map<String, dynamic> _$GamesToJson(Games instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'background_image': instance.backgroundImage,
      'metacritic': instance.metacritic,
      'released': instance.released,
      'parent_platforms': instance.parentPlatform,
      'genres': instance.genres,
      'short_screenshots': instance.shortScreenshots,
      'ratings': instance.ratings,
      'ratings_count': instance.ratingsCount,
      'description': instance.description,
      'description_raw': instance.descriptionRaw,
    };
