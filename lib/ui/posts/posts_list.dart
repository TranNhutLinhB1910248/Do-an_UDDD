//tao danh sach cac bai post tren trang chu
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'post_list_tile.dart';
import 'posts_manager.dart';
import '../../models/post.dart';

class PostsList extends StatelessWidget {
  final bool showFavorites;

  const PostsList(this.showFavorites, {super.key});

  @override
  Widget build(BuildContext context) {
    final posts = context.select<PostsManager, List<Post>>(
      (postsManager) => showFavorites
      ? postsManager.favoriteItems
      : postsManager.items);

    return ListView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: posts.length,
      itemBuilder: (ctx, i) => PostListTile(posts[i]),
    );
  }
}
