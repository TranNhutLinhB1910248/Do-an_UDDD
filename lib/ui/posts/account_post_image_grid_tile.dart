//lay hinh anh tao khung qua trang ca nhan
import 'package:flutter/material.dart';

import '../../models/post.dart';
import 'post_detail_screen.dart';

class  AccountPostImageGridTile extends StatelessWidget {
  final Post post;

  const  AccountPostImageGridTile(
    this.post, {
    super.key,
  });


  @override
  Widget build(BuildContext context){
    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: GridTile(
        child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(
                  PostDetailScreen.routeName,
                  arguments: post.id,
                );
              },

          child: Image.network(
            post.imageUrl,
            fit:BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
