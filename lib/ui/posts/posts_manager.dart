//cac phuong thuc
import 'package:flutter/foundation.dart';

import '../../models/auth_token.dart';
import '../../models/comment.dart';
import '../../models/post.dart';
import '../../services/posts_service.dart';

class PostsManager with ChangeNotifier {
  List<Post> _items = [];

  final PostsService _postsService;

  PostsManager([AuthToken? authToken])
      : _postsService = PostsService(authToken);

  set authToken(AuthToken? authToken) {
    _postsService.authToken = authToken;
  }

  Future<void> fetchPosts([bool filterByUser = false]) async {
    _items = await _postsService.fetchPosts(filterByUser);
    notifyListeners();
  }

  int get itemCount {
    return _items.length;
  }

  List<Post> get items {
    return [..._items];
  }

  List<Post> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Post findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> toggleFavoriteStatus(Post post) async {
    final savedStatus = post.isFavorite;
    post.isFavorite = !savedStatus;

    if (!await _postsService.saveFavoriteStatus(post)) {
      post.isFavorite = savedStatus;
    }
  }

  Future<void> updateFavortiePost(Post post) async {
    final savedStatus = post.favoriteCount;
    post.updateFavoriteCount();
    if (!await _postsService.updateFavortiePost(post)) {
      post.favoriteCount = savedStatus;
    }
  }

  Future<void> addComment(String postId, Comment comment) async {
    final postIndex = _items.indexWhere((post) => post.id == postId);
    if (postIndex >= 0) {
      final updatedPost =
          await _postsService.addComment(_items[postIndex], comment);
      final post = _items[postIndex];
      post.updateComments(comment);
      if (updatedPost != null) {
        _items[postIndex] = updatedPost;
        notifyListeners();
      }
    }
  }

  Future<void> addPost(Post post) async {
    final newPost = await _postsService.addPost(post);
    if (newPost != null) {
      _items.add(newPost);
      notifyListeners();
    }
  }

  Future<void> updatePost(Post post) async {
    final index = _items.indexWhere((item) => item.id == post.id);
    if (index >= 0) {
      if (await _postsService.updatePost(post)) {
        _items[index] = post;
        notifyListeners();
      }
    }
  }

  Future<void> deletePost(String id) async {
    final index = _items.indexWhere((item) => item.id == id);
    Post? existingPost = _items[index];
    _items.removeAt(index);
    notifyListeners();

    if (!await _postsService.deletePost(id)) {
      _items.insert(index, existingPost);
      notifyListeners();
    }
  }
}
