//chi tiet bai post
import 'package:flutter/material.dart';
import '../../models/comment.dart';
import 'add_comment_post_screen.dart';
import 'posts_manager.dart';
import 'package:provider/provider.dart';

import '../../models/post.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart' as intl;

class PostDetailScreen extends StatelessWidget {
  static const routeName = '/post-detail';

  final Post post;

  const PostDetailScreen(
    this.post, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    //chon thoi gian
    final difference = now.difference(post.dateTime);

    String timeAgo;
    if (difference.inDays > 7) {
      timeAgo = DateFormat('dd/MM/yyyy').format(post.dateTime);
    } else if (difference.inDays > 0) {
      timeAgo = '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      timeAgo = '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      timeAgo = '${difference.inMinutes} minutes ago';
    } else {
      timeAgo = 'just now';
    }
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(post.imageUrl),
              radius: 16.0,
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Author',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  Text(
                    timeAgo,
                    style: const TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              width: double.infinity,
              child: AspectRatio(
                aspectRatio: 3 / 4,
                child: Image.network(
                  post.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            buildFavoriteDetails(context),
            buildFavoritesAndCommentsCount(),
            const SizedBox(
              height: 10,
            ),
            buildContentDetails(),
            const SizedBox(
              height: 20,
            ),
            buildAddButton(context),
            buildCommentDetails(),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
//dong 1
  Widget buildFavoriteDetails(BuildContext context) {
    return Row(
      children: [
        GridTileBar(
          leading: ValueListenableBuilder<bool>(
            valueListenable: post.isFavoriteListenable,
            builder: (ctx, isFavorite, child) {
              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                ),
                color: Theme.of(context).colorScheme.secondary,
                onPressed: () {
                  ctx.read<PostsManager>().toggleFavoriteStatus(post);
                  ctx.read<PostsManager>().updateFavortiePost(post);
                },
              );
            },
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.mode_comment_outlined),
        ),
      ],
    );
  }
//dong 2
  Widget buildFavoritesAndCommentsCount() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ValueListenableBuilder<int>(
            valueListenable: post.favoriteCountListenable,
            builder: (ctx, favoriteCount, child) {
              return Text(
                '${intl.NumberFormat.decimalPattern().format(favoriteCount).split(',').join('.')} likes',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              );
            },
          ),
          const SizedBox(width: 10),
          ValueListenableBuilder<List<Comment>>(
            valueListenable: post.commentCountListenable,
            builder: (ctx, commentCount, child) {
              return post.comments.isEmpty
                  ? const Text(
                      'No comments.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    )
                  : Text(
                      '${post.comments.length} comments',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    );
            },
          ),
        ],
      ),
    );
  }
//dong 3
  Widget buildContentDetails() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      width: double.infinity,
      child: RichText(
        text: TextSpan(
          text: 'Author',
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          children: <TextSpan>[
            TextSpan(
              text: ' ${post.content}',
              style: const TextStyle(fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
//add comment
  Widget buildAddButton(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).pushNamed(
              AddCommentPostScreen.routeName,
              arguments: post.id,
            );
          },
        ),
        const Text(
          'Add Comment',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget buildCommentDetails() {
    return ValueListenableBuilder<List<Comment>>(
      valueListenable: post.commentCountListenable,
      builder: (ctx, commentCount, child) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: post.comments.length,
          itemBuilder: (context, index) {
            final comment = post.comments[index];
            final now = DateTime.now();
            final difference1 = now.difference(comment.dateTime);

            String timeAgo1;
            if (difference1.inDays > 0) {
              timeAgo1 = '${difference1.inDays}d';
            } else if (difference1.inHours > 0) {
              timeAgo1 = '${difference1.inHours}h';
            } else if (difference1.inMinutes > 0) {
              timeAgo1 = '${difference1.inMinutes}m';
            } else {
              timeAgo1 = 'just now';
            }
            return Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(post.imageUrl),
                        radius: 16.0,
                      ),
                      const SizedBox(width: 12.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'User',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            Text(
                              comment.content,
                              style: const TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                      padding: const EdgeInsets.only(left: 45.0),
                      child: Row(
                        children: [
                          const Text(
                            'Like  Reply  ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                            ),
                          ),
                          Text(
                            timeAgo1,
                          ),
                        ],
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
