//trang ca nhan
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/data.dart';
import '../shared/app_drawer.dart';

import 'images_grid.dart';
import 'edit_post_screen.dart';
import 'posts_manager.dart';

import 'account_post_list_tile.dart';

class AccountPostsScreen extends StatelessWidget {
  static const routeName = '/account';
  const AccountPostsScreen({super.key});

  Future<void> _refreshPosts(BuildContext context) async {
    await context.read<PostsManager>().fetchPosts(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your post'),
      ),
      endDrawer: const AppDrawer(),
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, bool innerBoxIsScrolled) => [
            buildHeaderAccount(context),
          ],
          body: buildContentAccount(context),
        ),
      ),
    );
  }
// thực hiện tải danh mục post khi khởi tạo. Trong
// quá trình tải dữ liệu thì hiển thị thanh tiến trình chờ
  Widget buildContentAccount(BuildContext context) {
    return Column(
      children: <Widget>[
        Material(
          color: Colors.white,
          child: TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey[400],
            indicatorWeight: 1,
            indicatorColor: Colors.black,
            tabs: const [
              Tab(
                icon: Icon(
                  Icons.grid_on_sharp,
                  color: Colors.black,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.person_pin_rounded,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            children: [
              FutureBuilder(
                future: _refreshPosts(context),
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () => _refreshPosts(context),
                    child: const ImagesGrid(),
                  );
                },
              ),
              FutureBuilder(
                future: _refreshPosts(context),
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () => _refreshPosts(context),
                    child: buildAccountPostListView(),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildHeaderAccount(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(color: Colors.white),
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildHeaderAccountInforAuthor(),
                  const SizedBox(
                    height: 20,
                  ),
                  buildHeaderAccountAddPost(context),
                  const SizedBox(
                    height: 20,
                  ),
                  buildAccountHeaderHighligh(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHeaderAccountInforAuthor() {
    return Column(children: [
      SizedBox(
        height: 10,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: const [
              CircleAvatar(
                radius: 40,
                backgroundColor: Color(0xff74EDED),
                backgroundImage: NetworkImage(
                    "https://tse1.mm.bing.net/th?id=OIP.v6XJwvqSeoFeVjLpMNe_7gHaEo&pid=Api&P=0"),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                "Author",
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  letterSpacing: 0.4,
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                "Chào buổi sáng",
                style: TextStyle(
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Column(
                children: const [
                  Text(
                    "05",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    "Posts",
                    style: TextStyle(
                      fontSize: 15,
                      letterSpacing: 0.4,
                    ),
                  )
                ],
              ),
              SizedBox(
                width: 30,
              ),
              Column(
                children: const [
                  Text(
                    "2.0K",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    "Followers",
                    style: TextStyle(
                      letterSpacing: 0.4,
                      fontSize: 15,
                    ),
                  )
                ],
              ),
              SizedBox(
                width: 30,
              ),
              Column(
                children: const[
                  Text(
                    "105",
                    style: TextStyle(
                      letterSpacing: 0.4,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    "Following",
                    style: TextStyle(
                      letterSpacing: 0.4,
                      fontSize: 15,
                    ),
                  )
                ],
              ),
              SizedBox(
                width: 15,
              ),
            ],
          )
        ],
      ),
    ]);
  }

  Widget buildHeaderAccountAddPost(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                EditPostScreen.routeName,
              );
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: Text("+ Add Post", style: TextStyle(color: Colors.black)),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildAccountHeaderHighligh() {
    return SizedBox(
      height: 85,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: highlightItems.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: CircleAvatar(
                        backgroundImage:
                            AssetImage(highlightItems[index].thumbnail),
                        radius: 28,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      highlightItems[index].title,
                      style: const TextStyle(fontSize: 13),
                    ),
                  )
                ],
              ),
              const SizedBox(
                width: 10,
              )
            ],
          );
        },
      ),
    );
  }

  Widget buildAccountPostListView() {
    return Consumer<PostsManager>(
      builder: (ctx, postsManager, child) {
        final count = postsManager.itemCount;
        if (count != 0) {
          return ListView.builder(
            itemCount: postsManager.itemCount,
            itemBuilder: (ctx, i) => Column(
              children: [
                AccountPostListTile(
                  postsManager.items[i],
                ),
                const Divider(),
              ],
            ),
          );
        } else {
          return const Center(
            child: Text(
              'No post.',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          );
        }
      },
    );
  }
}
