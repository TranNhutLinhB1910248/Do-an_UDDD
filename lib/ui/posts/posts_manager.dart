import 'package:flutter/foundation.dart';

import '../../models/auth_token.dart';
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
}
