import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/post.dart';
import '../models/auth_token.dart';

import './firebase_service.dart';

class PostsService extends FirebaseService {
  PostsService([AuthToken? authToken]) : super(authToken);

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

      // Loop through all posts
      for (final postId in postsMap.keys) {
        final post = postsMap[postId];
        posts.add(Post.fromJson({
          'id': postId,
          ...post,
        }));
      }

      return posts;
    } catch (error) {
      print(error);
      return posts;
    }
  }
}
