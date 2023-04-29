//trang chu
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'posts_manager.dart';
import 'posts_list.dart';

import '../shared/app_drawer.dart';
// thực hiện tải danh mục post khi khởi tạo.
// Trong quá trình tải dữ liệu thì hiển thị thanh tiến trình chờ
class PostsOverviewScreen extends StatefulWidget {
  const PostsOverviewScreen({super.key});

  @override
  State<PostsOverviewScreen> createState() => _PostsOverviewScreenState();
}

class _PostsOverviewScreenState extends State<PostsOverviewScreen> {
  final _showAllFavorites = ValueNotifier<bool>(false);
  late Future<void> _fetchPosts;

  @override
  void initState() {
    super.initState();
    _fetchPosts = context.read<PostsManager>().fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyApp'),
      ),
      endDrawer: const AppDrawer(),
      body: FutureBuilder(
        future: _fetchPosts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ValueListenableBuilder<bool>(
              valueListenable: _showAllFavorites,
              builder: (context, allFavorites, child) {
                return PostsList(allFavorites);
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
