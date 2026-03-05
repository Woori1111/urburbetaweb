import 'package:supabase_flutter/supabase_flutter.dart';

import '../hall_of_fame/hall_of_fame_repository.dart';

/// 반성문 행
class ReflectionItem {
  ReflectionItem({
    required this.id,
    required this.hallOfFameId,
    required this.content,
    required this.createdAt,
    this.releaseVoteCount = 0,
  });

  factory ReflectionItem.fromJson(Map<String, dynamic> json) {
    return ReflectionItem(
      id: json['id'] as String,
      hallOfFameId: json['hall_of_fame_id'] as String? ?? '',
      content: json['content'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at'] as String? ?? DateTime.now().toIso8601String()),
      releaseVoteCount: (json['release_vote_count'] as int?) ?? 0,
    );
  }

  final String id;
  final String hallOfFameId;
  final String content;
  final DateTime createdAt;
  final int releaseVoteCount;

  static const int releaseThreshold = 5;

  bool get isReleased => releaseVoteCount >= releaseThreshold;
}

/// 반성문 Supabase 연동. 테이블 reflections. 석방 5회 시 명예의 전당 정지 해제.
class ReflectionRepository {
  ReflectionRepository({
    SupabaseClient? client,
    HallOfFameRepository? hallOfFameRepository,
  })  : _client = client ?? Supabase.instance.client,
        _hallOfFame = hallOfFameRepository ?? HallOfFameRepository();

  final SupabaseClient _client;
  final HallOfFameRepository _hallOfFame;

  static const String _table = 'reflections';

  Stream<List<ReflectionItem>> watchReflections() {
    return _client
        .from(_table)
        .stream(primaryKey: ['id'])
        .map((list) {
          final items = list.map((e) => ReflectionItem.fromJson(e)).toList();
          items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return items;
        });
  }

  Future<void> addReflection({
    required String hallOfFameId,
    required String content,
  }) async {
    await _client.from(_table).insert({
      'hall_of_fame_id': hallOfFameId,
      'content': content.trim(),
      'release_vote_count': 0,
    });
  }

  Future<void> incrementReleaseVote(String reflectionId) async {
    final res = await _client.from(_table).select('release_vote_count, hall_of_fame_id').eq('id', reflectionId).single();
    final count = (res['release_vote_count'] as int?) ?? 0;
    final hallOfFameId = res['hall_of_fame_id'] as String? ?? '';
    await _client.from(_table).update({'release_vote_count': count + 1}).eq('id', reflectionId);
    if (count + 1 >= ReflectionItem.releaseThreshold && hallOfFameId.isNotEmpty) {
      await _hallOfFame.release(hallOfFameId);
    }
  }
}
