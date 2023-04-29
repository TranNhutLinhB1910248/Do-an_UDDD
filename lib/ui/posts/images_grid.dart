//tao anh dang luoi tren trang ca nhan
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'account_post_image_grid_tile.dart';
import 'posts_manager.dart';

import '../../models/post.dart';

class ImagesGrid extends StatelessWidget {
  const ImagesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final posts = context
        .select<PostsManager, List<Post>>((postsManager) => postsManager.items);
    return posts.isNotEmpty
        ? GridView.builder(
            padding: const EdgeInsets.all(10.0),
            itemCount: posts.length,
            itemBuilder: (ctx, i) => AccountPostImageGridTile(posts[i]),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
          )
        : const Center(
            child: Text(
              'No image.',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          );
  }
}
