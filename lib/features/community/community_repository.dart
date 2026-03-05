import 'package:supabase_flutter/supabase_flutter.dart';

/// 커뮤니티 게시글 (익명, 삭제용 author_id)
class CommunityPost {
  CommunityPost({
    required this.id,
    required this.content,
    required this.createdAt,
    this.authorId,
  });

  factory CommunityPost.fromJson(Map<String, dynamic> json) {
    return CommunityPost(
      id: json['id'] as String,
      content: json['content'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at'] as String? ?? DateTime.now().toIso8601String()),
      authorId: json['author_id'] as String?,
    );
  }

  final String id;
  final String content;
  final DateTime createdAt;
  final String? authorId;

  bool isMine(String? myAuthorId) =>
      myAuthorId != null && myAuthorId.isNotEmpty && authorId == myAuthorId;
}

/// 커뮤니티 Supabase 연동. 테이블 community_posts.
class CommunityRepository {
  CommunityRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  static const String _table = 'community_posts';

  Stream<List<CommunityPost>> watchPosts() {
    return _client
        .from(_table)
        .stream(primaryKey: ['id'])
        .map((list) {
          final items = list.map((e) => CommunityPost.fromJson(e)).toList();
          items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return items;
        });
  }

  Future<void> addPost(String content, String authorId) async {
    await _client.from(_table).insert({
      'content': content.trim(),
      'author_id': authorId,
    });
  }

  Future<void> deletePost(String id) async {
    await _client.from(_table).delete().eq('id', id);
  }
}
