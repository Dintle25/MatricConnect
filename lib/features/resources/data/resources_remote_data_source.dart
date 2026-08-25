import 'dart:math';
import 'package:dio/dio.dart';
import '../domain/resource_page.dart';
import '../domain/study_resource.dart';

/// The contract any data source has to follow. Swapping the mock
/// one below for a real API later is just changing which class gets
/// created in resources_provider.dart — nothing else has to change.
abstract class ResourcesRemoteDataSource {
  Future<ResourcePage> fetchResources({required int page, String? subjectFilter});
}

/// Talks to a real backend through the shared Dio client — headers
/// and retry-on-flaky-connection already apply automatically because
/// this Dio instance came from DioClient with its interceptors attached.
/// Point [Dio.options.baseUrl] at your real API and this just works.
class DioResourcesRemoteDataSource implements ResourcesRemoteDataSource {
  final Dio dio;

  DioResourcesRemoteDataSource(this.dio);

  @override
  Future<ResourcePage> fetchResources({required int page, String? subjectFilter}) async {
    final response = await dio.get('/resources', queryParameters: {
      'page': page,
      if (subjectFilter != null) 'subject': subjectFilter,
    });
    final data = response.data as Map<String, dynamic>;
    return ResourcePage(
      items: (data['items'] as List).map((e) => StudyResource.fromJson(e as Map<String, dynamic>)).toList(),
      page: page,
      hasMore: data['hasMore'] as bool? ?? false,
    );
  }
}

/// There's no live backend for this demo, so this class stands in
/// for one. It returns real, varied fake data with real network
/// delay, and every so often throws a genuine DioException with a
/// realistic status code — so the retry interceptor and the friendly
/// error snackbars both have something real to react to, not a
/// hand-waved "pretend this failed" comment.
class MockResourcesRemoteDataSource implements ResourcesRemoteDataSource {
  final Random _random = Random();
  static const int _pageSize = 8;

  static final List<_MockSeed> _seeds = [
    _MockSeed('Mathematics', ResourceType.pastPaper, 2.4),
    _MockSeed('Mathematics', ResourceType.memo, 0.9),
    _MockSeed('Physical Sciences', ResourceType.pastPaper, 3.1),
    _MockSeed('Physical Sciences', ResourceType.studyGuide, 5.7),
    _MockSeed('Life Sciences', ResourceType.studyGuide, 4.3),
    _MockSeed('Life Sciences', ResourceType.video, 42.0),
    _MockSeed('English HL', ResourceType.pastPaper, 1.8),
    _MockSeed('English HL', ResourceType.studyGuide, 2.9),
    _MockSeed('Accounting', ResourceType.pastPaper, 2.2),
    _MockSeed('Accounting', ResourceType.memo, 1.1),
    _MockSeed('Geography', ResourceType.studyGuide, 6.4),
    _MockSeed('History', ResourceType.pastPaper, 2.0),
    _MockSeed('Business Studies', ResourceType.video, 28.0),
    _MockSeed('IT / CAT', ResourceType.studyGuide, 3.6),
  ];

  @override
  Future<ResourcePage> fetchResources({required int page, String? subjectFilter}) async {
    // Simulate real network latency so the loading skeletons on
    // screen actually get seen during a demo, not skipped instantly.
    await Future<void>.delayed(Duration(milliseconds: 500 + _random.nextInt(600)));

    _maybeThrowFlakyError();

    final filtered = subjectFilter == null
        ? _seeds
        : _seeds.where((s) => s.subject == subjectFilter).toList();

    final start = page * _pageSize;
    if (start >= filtered.length * 3) {
      return ResourcePage(items: const [], page: page, hasMore: false);
    }

    final items = List.generate(_pageSize, (i) {
      final seed = filtered[(start + i) % filtered.length];
      final index = start + i;
      return StudyResource(
        id: 'res-$index',
        title: _titleFor(seed, index),
        subject: seed.subject,
        grade: 'Grade 12',
        type: seed.type,
        fileSizeMb: (seed.baseSizeMb + _random.nextDouble()).toStringAsFixed(1).let(double.parse),
        pages: seed.type == ResourceType.video ? null : 4 + _random.nextInt(20),
        durationMinutes: seed.type == ResourceType.video ? 8 + _random.nextInt(30) : null,
        uploadedAt: DateTime.now().subtract(Duration(days: _random.nextInt(60))),
        downloadCount: _random.nextInt(400),
      );
    });

    return ResourcePage(items: items, page: page, hasMore: start + _pageSize < filtered.length * 3);
  }

  String _titleFor(_MockSeed seed, int index) {
    final year = 2021 + (index % 4);
    return switch (seed.type) {
      ResourceType.pastPaper => '${seed.subject} Paper ${1 + (index % 2)} — $year',
      ResourceType.memo => '${seed.subject} Memo — $year',
      ResourceType.studyGuide => '${seed.subject} Complete Study Guide',
      ResourceType.video => '${seed.subject} Exam Tips & Tricks',
    };
  }

  /// About 1 in 6 requests fails with a realistic status code. This
  /// is what lets you actually demo the retry logic and the friendly
  /// error messages live, instead of just describing them.
  void _maybeThrowFlakyError() {
    final roll = _random.nextInt(24);
    if (roll != 0) return;

    final statusOptions = [500, 503, 429, 404];
    final status = statusOptions[_random.nextInt(statusOptions.length)];

    throw DioException(
      requestOptions: RequestOptions(path: '/resources'),
      response: Response(
        requestOptions: RequestOptions(path: '/resources'),
        statusCode: status,
      ),
      type: DioExceptionType.badResponse,
    );
  }
}

class _MockSeed {
  final String subject;
  final ResourceType type;
  final double baseSizeMb;
  const _MockSeed(this.subject, this.type, this.baseSizeMb);
}

extension _Let<T> on T {
  R let<R>(R Function(T) block) => block(this);
}
