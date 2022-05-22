class Comment {
  final int id;
  final String loginId;
  final String userNickname;
  final String body;
  bool deleted;
  final int parentId;
  List<dynamic> children;

  List<String>? userImageUrls;
  DateTime? createdAt;

  Comment({
    required this.id,
    required this.loginId,
    required this.userNickname,
    required this.body,
    required this.deleted,
    required this.parentId,
    required this.children,
    this.userImageUrls,
    this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
        id: json['id'],
        loginId: json['loginId'],
        userNickname: json['userNickname'],
        body: json['body'],
        deleted: json['deleted'],
        parentId: json['parentId'],
        children:
            json['children'].map((json) => Comment.fromJson(json)).toList(),
        userImageUrls: json['userImageUrls']?.toList(),
        // createdAt: DateTime.parse(json['createdAt']),
        createdAt: DateTime(2021, 05, 05));
  }
}
