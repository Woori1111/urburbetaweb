/// Supabase 프로젝트 URL / anon key는 Supabase 대시보드에서 복사해 넣으세요.
const String supabaseUrl = 'YOUR_SUPABASE_URL';
const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';

/// 필요한 Supabase 설정:
/// 1. Auth: Providers에서 카카오(Kakao) 활성화 후 카카오 개발자 콘솔에서 REST API 키 등록
/// 2. Table Editor - SQL로 테이블 생성:
///    - hall_of_fame: id (uuid, default gen_random_uuid()), image_url (text), created_at (timestamptz, default now()), like_count (int4, default 0), dislike_count (int4, default 0), released_at (timestamptz nullable)
///    - community_posts: id (uuid), content (text), created_at (timestamptz, default now()), author_id (text nullable)
///    - reflections: id (uuid), hall_of_fame_id (uuid), content (text), created_at (timestamptz, default now()), release_vote_count (int4, default 0)
/// 3. Storage: 버킷 hall_of_fame 생성 (public)
