// //them /sua bai post
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/post.dart';
import '../shared/dialog_utils.dart';

import 'posts_manager.dart';

class EditPostScreen extends StatefulWidget {
  static const routeName = '/edit-post';

  EditPostScreen(
    Post? post, {
    super.key,
    // required this.arguments,
  }) {
    if (post == null) {
      this.post = Post(id: null, content: '', imageUrl: '', comments: []);
    } else {
      this.post = post;
    }
  }
  late final Post post;

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _editForm = GlobalKey<FormState>();
  late Post _editedPost;
  var _isLoading = false;
// Phương thức init(), dispose() lần lượt khởi tạo và hủy/giải phóng các biến. Biến
// _imageUrlFocusNode dùng để lúc nghe trạng thái focus của trường nhập liệu cho ảnh. Nếu dữ
// liệu nhập liệu là một URL ảnh hợp lệ thì yêu cầu vẽ lại màn hình để hiện ảnh xem trước.
  bool _isValidImageUrl(String value) {
    return (value.startsWith('http') || value.startsWith('https')) &&
        (value.endsWith('.png') ||
            value.endsWith('.jpg') ||
            value.endsWith('.jpeg'));
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(() {
      if (!_imageUrlFocusNode.hasFocus) {
        if (!_isValidImageUrl(_imageUrlController.text)) {
          return;
        }
        // Ảnh hợp lệ
        setState(() {});
      }
    });
    _editedPost = widget.post;
    _imageUrlController.text = _editedPost.imageUrl;
    super.initState();
  }

  @override
  void dispose() {
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }
// Phương thức _saveForm thực hiện thêm post vào danh sách post quản lý bởi PostsManager:
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
      if (_editedPost.id != null) {
        await postsManager.updatePost(_editedPost);
      } else {
        print(_editedPost);
        await postsManager.addPost(_editedPost);
      }
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
        title: const Text('Post'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveForm,
          ),
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
                    buildContentField(),
                    buildImageURLField(),
                    buildPostPreview(),
                  ],
                ),
              ),
            ),
    );
  }

  TextFormField buildContentField() {
    return TextFormField(
      initialValue: _editedPost.content,
      decoration: const InputDecoration(labelText: 'Content'),
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

  Widget buildPostPreview() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Container(
          width: 360,
          height: 200,
          margin: const EdgeInsets.only(
            top: 15,
            // right: 10,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: _imageUrlController.text.isEmpty
              ? const Text('Ảnh hiển thị')
              : FittedBox(
                  child: Image.network(
                    _imageUrlController.text,
                    fit: BoxFit.cover,
                  ),
                ),
        ),
      ],
    );
  }

  TextFormField buildImageURLField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Image URL'),
      keyboardType: TextInputType.url,
      textInputAction: TextInputAction.done,
      controller: _imageUrlController,
      focusNode: _imageUrlFocusNode,
      onFieldSubmitted: (value) => _saveForm(),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter an image URL.';
        }
        if (!_isValidImageUrl(value)) {
          return 'Please enter a valid image URL.';
        }
        return null;
      },
      onSaved: (value) {
        _editedPost = _editedPost.copyWith(imageUrl: value);
      },
    );
  }
}
