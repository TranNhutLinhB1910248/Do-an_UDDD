import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/comment.dart';
import '../models/post.dart';
import '../models/auth_token.dart';

import './firebase_service.dart';

class PostsService extends FirebaseService {
  PostsService([AuthToken? authToken]) : super(authToken);

  // Doc du lieu tu Firebase
  Future<List<Post>> fetchPosts([bool filterByUser = false]) async {
    final List<Post> posts = [];

    try {
      final filters =
          filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
      final postsUrl =
          Uri.parse('$databaseUrl/posts.json?auth=$token&$filters');
      final response = await http.get(postsUrl);
      final postsMap = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200) {
        print(postsMap['error']);
        return posts;
      }

      final userFavoritesUrl =
          Uri.parse('$databaseUrl/userFavorites/$userId.json?auth=$token');
      final userFavoritesResponse = await http.get(userFavoritesUrl);
      final userFavoritesMap = json.decode(userFavoritesResponse.body);

      final countFavoritesUrl =
          Uri.parse('$databaseUrl/countFavorites.json?auth=$token');
      final countFavoritesResponse = await http.get(countFavoritesUrl);
      final countFavoritesMap = json.decode(countFavoritesResponse.body);
      // Loop through all posts
      for (final postId in postsMap.keys) {
        final post = postsMap[postId];

        final isFavorite = userFavoritesMap?[postId] ?? false;
        final favoriteCount = countFavoritesMap?[postId] ?? 0;

        final commentsUrl =
            Uri.parse('$databaseUrl/postComments/$postId.json?auth=$token');
        final commentsResponse = await http.get(commentsUrl);
        final commentsMap =
            json.decode(commentsResponse.body) as Map<String, dynamic>?;

        if (commentsMap != null) {
          // Kiểm tra giá trị của 'commentsMap'
          final List<Comment> comments = [];

          // Loop through all comments and add to list
          for (final commentId in commentsMap.keys) {
            final comment = commentsMap[commentId];
            comments.add(Comment.fromJson({
              'id': commentId,
              'content': comment['content'] ?? '',
              'dateTime': comment['dateTime'],
            }));
          }

          // Add comments to post
          posts.add(Post.fromJson({
            'id': postId,
            ...post,
          }).copyWith(
            isFavorite: isFavorite,
            favoriteCount: favoriteCount,
            comments: comments,
          ));
        } else {
          // Handle null case here
          posts.add(Post.fromJson({
            'id': postId,
            ...post,
          }).copyWith(
            isFavorite: isFavorite,
            favoriteCount: favoriteCount,
          ));
        }
      }

      return posts;
    } catch (error) {
      print(error);
      return posts;
    }
  }

  // Luu trang thai yeu thich bai post
  Future<bool> saveFavoriteStatus(Post post) async {
    try {
      final url = Uri.parse(
          '$databaseUrl/userFavorites/$userId/${post.id}.json?auth=$token');
      final response = await http.put(
        url,
        body: json.encode(
          post.isFavorite,
        ),
      );

      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)['error']);
      }
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  // Dem so luot like cua bai post
  Future<bool> updateFavortiePost(Post post) async {
    try {
      final url =
          Uri.parse('$databaseUrl/countFavorites/${post.id}.json?auth=$token');
      final response = await http.put(
        url,
        body: json.encode(
          post.favoriteCount,
        ),
      );

      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)['error']);
      }

      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }
//them comment
  Future<Post?> addComment(Post post, Comment comment) async {
    try {
      final url =
          Uri.parse('$databaseUrl/postComments/${post.id}.json?auth=$token');
      final response = await http.post(
        url,
        body: json.encode(comment.toJson()),
      );
      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)['error']);
      }
      return post.copyWith(
        id: json.decode(response.body)['name'],
      );
    } catch (error) {
      print(error);
      return null;
    }
  }

  // Them bai post
  Future<Post?> addPost(Post post) async {
    try {
      final url = Uri.parse('$databaseUrl/posts.json?auth=$token');
      final response = await http.post(
        url,
        body: json.encode(
          post.toJson()
            ..addAll({
              'creatorId': userId,
            }),
        ),
      );

      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)['error']);
      }

      return post.copyWith(
        id: json.decode(response.body)['name'],
      );
    } catch (error) {
      print(error);
      return null;
    }
  }

  // Hieu chinh bai post
  Future<bool> updatePost(Post post) async {
    try {
      final url = Uri.parse('$databaseUrl/posts/${post.id}.json?auth=$token');
      final response = await http.patch(
        url,
        body: json.encode(post.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)['error']);
      }

      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  // Xoa bai post
  Future<bool> deletePost(String id) async {
    try {
      final url = Uri.parse('$databaseUrl/posts/$id.json?auth=$token');
      final response = await http.delete(url);

      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)['error']);
      }

      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }
}
