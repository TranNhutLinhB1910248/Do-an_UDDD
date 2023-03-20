import 'package:flutter/material.dart';

class Post {
  final String? id;
  final String content;
  final String imageUrl;
  final DateTime dateTime;
  final ValueNotifier<bool> _isFavorite;
  final ValueNotifier<int> _favoriteCount;

  Post({
    this.id,
    required this.content,
    required this.imageUrl,
    DateTime? dateTime,
    isFavorite = false,
    favoriteCount = 0,
  })  : _isFavorite = ValueNotifier(isFavorite),
        _favoriteCount = ValueNotifier(favoriteCount),
        dateTime = dateTime ?? DateTime.now();

  set isFavorite(bool newValue) {
    _isFavorite.value = newValue;
  }

  bool get isFavorite {
    return _isFavorite.value;
  }

  ValueNotifier<bool> get isFavoriteListenable {
    return _isFavorite;
  }

  set favoriteCount(int newValue) {
    _favoriteCount.value = newValue;
  }

  int get favoriteCount {
    return _favoriteCount.value;
  }

  ValueNotifier<int> get favoriteCountListenable {
    return _favoriteCount;
  }

  void updateFavoriteCount() {
    if (_isFavorite.value) {
      _favoriteCount.value += 1;
    } else {
      _favoriteCount.value -= 1;
    }
  }

  Post copyWith({
    String? id,
    String? content,
    String? imageUrl,
    DateTime? dateTime,
    bool? isFavorite,
    int? favoriteCount,
  }) {
    return Post(
      id: id ?? this.id,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      dateTime: dateTime ?? this.dateTime,
      isFavorite: isFavorite ?? this.isFavorite,
      favoriteCount: favoriteCount ?? this.favoriteCount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'imageUrl': imageUrl,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  static Post fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      content: json['content'],
      imageUrl: json['imageUrl'],
      dateTime: DateTime.parse(json['dateTime']),
    );
  }
}
