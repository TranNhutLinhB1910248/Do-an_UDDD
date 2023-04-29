//trang them binh luan
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/comment.dart';
import '../../models/post.dart';
import '../shared/dialog_utils.dart';

import 'posts_manager.dart';

class AddCommentPostScreen extends StatefulWidget {
  static const routeName = '/add-comment';

  AddCommentPostScreen(
    Post? post, {
    super.key,
  }) {
    if (post == null) {
      this.post = Post(
          id: null,
          content: '',
          dateTime: DateTime.now(),
          imageUrl: '',
          comments: []);
    } else {
      this.post = post;
    }
  }

  late final Post post;

  @override
  State<AddCommentPostScreen> createState() => _AddCommentPostScreenState();
}

class _AddCommentPostScreenState extends State<AddCommentPostScreen> {
  final _editForm = GlobalKey<FormState>();
  late Post _editedPost;
  var _isLoading = false;

  @override
  void initState() {
    _editedPost = widget.post;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _editForm.currentState!.validate();
    if (!isValid) {
      return;
    }

    _editForm.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    try {
      final postsManager = context.read<PostsManager>();
      final newComment = Comment(
        content: _editedPost.content,
        dateTime: DateTime.now(),
        id: DateTime.now().toString(),
      );
      await postsManager.addComment(_editedPost.id!, newComment);

      // Cập nhật danh sách các comment hiển thị trên giao diện
      setState(() {
        _editedPost.comments.add(newComment);
      });
    } catch (error) {
      await showErrorDialog(context, 'Something went wrong.');
    }

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add comment'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _editForm,
                child: ListView(
                  children: <Widget>[
                    buildCommentField(),
                  ],
                ),
              ),
            ),
    );
  }

  TextFormField buildCommentField() {
    return TextFormField(
      initialValue: '',
      decoration: const InputDecoration(labelText: 'Comment'),
      textInputAction: TextInputAction.next,
      autofocus: true,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please provide a value.';
        }
        return null;
      },
      onSaved: (value) {
        _editedPost = _editedPost.copyWith(content: value);
      },
    );
  }
}
