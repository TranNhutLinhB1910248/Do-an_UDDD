import 'package:flutter/material.dart';

import 'comment.dart';

class Post {
  final String? id;
  final String content;
  final String imageUrl;
  final DateTime dateTime;
  final ValueNotifier<bool> _isFavorite;
  final ValueNotifier<int> _favoriteCount;
  final ValueNotifier<List<Comment>> _comments;

  // int get commentCount {
  //   return comments.length;
  // }

  Post({
    this.id,
    required this.content,
    required this.imageUrl,
    DateTime? dateTime,
    isFavorite = false,
    favoriteCount = 0,
    List<Comment>? comments,
  })  : _isFavorite = ValueNotifier(isFavorite),
        _favoriteCount = ValueNotifier(favoriteCount),
        _comments = ValueNotifier(comments ?? []),
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

  set comments(List<Comment> newValue) {
    _comments.value = newValue;
  }

  List<Comment> get comments {
    return _comments.value;
  }

  ValueNotifier<List<Comment>> get commentCountListenable {
    return _comments;
  }

  void updateComments(Comment newComment) {
    _comments.value = [...comments, newComment];
  }

  Post copyWith({
    String? id,
    String? content,
    String? imageUrl,
    DateTime? dateTime,
    bool? isFavorite,
    int? favoriteCount,
    List<Comment>? comments,
  }) {
    return Post(
      id: id ?? this.id,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      dateTime: dateTime ?? this.dateTime,
      isFavorite: isFavorite ?? this.isFavorite,
      favoriteCount: favoriteCount ?? this.favoriteCount,
      comments: comments ?? this.comments,
    );
  }
// phương thức toJson() và fromJson() giúp chuyển
// đổi qua lại giữa một đối tượng Post và chuỗi JSON.
  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'imageUrl': imageUrl,
      'dateTime': dateTime.toIso8601String(),
      'comments':
          List<dynamic>.from(comments.map((comment) => comment.toJson())),
    };
  }

  static Post fromJson(Map<String, dynamic> json) {
    final comments = json['comments'] as List<dynamic>?;

    final commentList =
        comments?.map((comment) => Comment.fromJson(comment)).toList() ?? [];

    return Post(
      id: json['id'],
      content: json['content'],
      imageUrl: json['imageUrl'],
      dateTime: DateTime.parse(json['dateTime']),
      comments: commentList,
    );
  }
}
