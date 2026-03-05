import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

/// 익명 작성자 식별용 ID (커뮤니티 본인 글 삭제 시에만 사용)
class AuthorIdService {
  static const String _key = 'community_author_id';

  static Future<String> getOrCreate() async {
    final prefs = await SharedPreferences.getInstance();
    var id = prefs.getString(_key);
    if (id == null || id.isEmpty) {
      id = _generateId();
      await prefs.setString(_key, id);
    }
    return id;
  }

  static String _generateId() {
    final r = Random();
    return '${DateTime.now().millisecondsSinceEpoch}_${r.nextInt(0x7FFFFFFF)}';
  }
}
