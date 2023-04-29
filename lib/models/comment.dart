class Comment {
  final String id;
  final String content;
  final DateTime dateTime;

  Comment({
    required this.id,
    required this.content,
    required this.dateTime,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] ?? '',
      content: json['content'] ?? '',
      dateTime: DateTime.parse(json['dateTime']),
    );
  }

  Comment copyWith({
    String? id,
    String? content,
    DateTime? dateTime,
  }) {
    return Comment(
      id: id ?? this.id,
      content: content ?? this.content,
      dateTime: dateTime ?? this.dateTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'dateTime': dateTime.toIso8601String(),
    };
  }
}
