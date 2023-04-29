//cac bai post tren trang ca nhan
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/post.dart';
import 'edit_post_screen.dart';
import 'post_detail_screen.dart';
import 'posts_manager.dart';
import 'package:intl/intl.dart' as intl;

class AccountPostListTile extends StatelessWidget {
  final Post post;

  const AccountPostListTile(
    this.post, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildInforHeaderPost(context),
        buildImagePost(context),
        buildIconFavoritePost(context),
        buildCountFavoritePost(),
        buildContentPost(),
      ],
    );
  }

  Widget buildInforHeaderPost(BuildContext context) {
    final now = DateTime.now();
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

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16.0, 8.0, 16.0),
      child: Row(
        children: [
          CircleAvatar(
                radius: 20.0,
                backgroundColor: Color(0xff74EDED),
                backgroundImage: NetworkImage(
                    "https://tse1.mm.bing.net/th?id=OIP.v6XJwvqSeoFeVjLpMNe_7gHaEo&pid=Api&P=0"),
              ),
          // CircleAvatar(
          //   backgroundImage: NetworkImage(post.imageUrl),
          //   radius: 20.0,
          // ),
          const SizedBox(width: 16.0),
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
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          ),
          buildPostFilterMenu(context),
        ],
      ),
    );
  }

  Widget buildPostFilterMenu(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(
        Icons.more_vert,
      ),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: "edit",
          child: Row(
            children: const [
              SizedBox(width: 8),
              Text("Edit"),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: "delete",
          child: Row(
            children: const [
              SizedBox(width: 8),
              Text("Delete"),
            ],
          ),
        ),
      ],
      onSelected: (String value) {
        if (value == "edit") {
          Navigator.of(context).pushNamed(
            EditPostScreen.routeName,
            arguments: post.id,
          );
        } else if (value == "delete") {
          context.read<PostsManager>().deletePost(post.id!);
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text(
                  'Post deleted',
                  textAlign: TextAlign.center,
                ),
              ),
            );
        }
      },
    );
  }

  Widget buildImagePost(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          PostDetailScreen.routeName,
          arguments: post.id,
        );
      },
      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: Image.network(
          post.imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget buildCountFavoritePost() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ValueListenableBuilder<int>(
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
    );
  }
//ValueListenableBuilder lắng nghe sự thay đổi giá trị của biến:
  Widget buildIconFavoritePost(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Row(
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
          const SizedBox(width: 8.0),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.mode_comment_outlined),
          ),
        ],
      ),
    );
  }

  Widget buildContentPost() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
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
        ],
      ),
    );
  }
}
