import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

/// 명예의 전당 행
class HallOfFameItem {
  HallOfFameItem({
    required this.id,
    required this.imageUrl,
    required this.createdAt,
    this.likeCount = 0,
    this.dislikeCount = 0,
    this.releasedAt,
  });

  factory HallOfFameItem.fromJson(Map<String, dynamic> json) {
    return HallOfFameItem(
      id: json['id'] as String,
      imageUrl: json['image_url'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at'] as String? ?? DateTime.now().toIso8601String()),
      likeCount: (json['like_count'] as int?) ?? 0,
      dislikeCount: (json['dislike_count'] as int?) ?? 0,
      releasedAt: json['released_at'] != null
          ? DateTime.parse(json['released_at'] as String)
          : null,
    );
  }

  final String id;
  final String imageUrl;
  final DateTime createdAt;
  final int likeCount;
  final int dislikeCount;
  final DateTime? releasedAt;

  bool get isSuspended => dislikeCount >= 5 && releasedAt == null;
}

/// 명예의 전당 Supabase 연동. 테이블 hall_of_fame, 스토리지 버킷 hall_of_fame 사용.
class HallOfFameRepository {
  HallOfFameRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  static const String _table = 'hall_of_fame';
  static const String _bucket = 'hall_of_fame';

  Stream<List<HallOfFameItem>> watchPhotos() {
    return _client
        .from(_table)
        .stream(primaryKey: ['id'])
        .map((list) {
          final items = list.map((e) => HallOfFameItem.fromJson(e)).toList();
          items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return items;
        });
  }

  Future<void> addPhoto({
    required String fileName,
    required List<int> bytes,
  }) async {
    final path = '${DateTime.now().millisecondsSinceEpoch}_$fileName';
    final data = bytes is Uint8List ? bytes : Uint8List.fromList(bytes);
    await _client.storage.from(_bucket).uploadBinary(
          path,
          data,
          fileOptions: const FileOptions(contentType: 'image/jpeg'),
        );
    final imageUrl = _client.storage.from(_bucket).getPublicUrl(path);
    await _client.from(_table).insert({
      'image_url': imageUrl,
      'like_count': 0,
      'dislike_count': 0,
    });
  }

  Future<void> incrementLike(String id) async {
    final res = await _client.from(_table).select('like_count').eq('id', id).single();
    final count = (res['like_count'] as int?) ?? 0;
    await _client.from(_table).update({'like_count': count + 1}).eq('id', id);
  }

  Future<void> incrementDislike(String id) async {
    final res = await _client.from(_table).select('dislike_count').eq('id', id).single();
    final count = (res['dislike_count'] as int?) ?? 0;
    await _client.from(_table).update({'dislike_count': count + 1}).eq('id', id);
  }

  Future<void> release(String id) async {
    await _client.from(_table).update({'released_at': DateTime.now().toIso8601String()}).eq('id', id);
  }

  Future<void> deletePhoto(String id) async {
    await _client.from(_table).delete().eq('id', id);
  }
}
