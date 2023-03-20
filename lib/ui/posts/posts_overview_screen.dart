import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'posts_manager.dart';
import 'posts_list.dart';

import '../shared/app_drawer.dart';

enum FilterOptions { favorites, all }

class PostsOverviewScreen extends StatefulWidget {
  const PostsOverviewScreen({super.key});

  @override
  State<PostsOverviewScreen> createState() => _PostsOverviewScreenState();
}

class _PostsOverviewScreenState extends State<PostsOverviewScreen> {
  final _showOnlyFavorites = ValueNotifier<bool>(false);
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
              valueListenable: _showOnlyFavorites,
              builder: (context, onlyFavorites, child) {
                return PostsList(onlyFavorites);
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
