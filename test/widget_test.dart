import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:campus_connect_flutter/main.dart';

class _TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return _MockHttpClient();
  }
}

class _MockHttpClient implements HttpClient {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  bool autoUncompress = true;

  @override
  Duration? connectionTimeout;

  @override
  Duration idleTimeout = const Duration(seconds: 15);

  @override
  int? maxConnectionsPerHost;

  @override
  String? userAgent;

  @override
  Future<HttpClientRequest> getUrl(Uri url) => openUrl('GET', url);

  @override
  Future<HttpClientRequest> postUrl(Uri url) => openUrl('POST', url);

  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) async {
    return _MockHttpClientRequest();
  }
}

class _MockHttpClientRequest implements HttpClientRequest {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  final HttpHeaders headers = _MockHttpHeaders();

  @override
  void add(List<int> data) {}

  @override
  void write(Object? obj) {}

  @override
  Future<void> flush() async {}

  @override
  Future<HttpClientResponse> close() async {
    return _MockHttpClientResponse();
  }
}

class _MockHttpHeaders implements HttpHeaders {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) {}

  @override
  void add(String name, Object value, {bool preserveHeaderCase = false}) {}
}

class _MockHttpClientResponse implements HttpClientResponse {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  int get statusCode => 200;

  @override
  int get contentLength => _transparentPixelPng.length;

  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;

  // 1x1 transparent PNG bytes
  static final List<int> _transparentPixelPng = base64Decode(
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII=',
  );

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return Stream<List<int>>.value(_transparentPixelPng).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}

void main() {
  setUpAll(() {
    HttpOverrides.global = _TestHttpOverrides();
  });

  tearDownAll(() {
    HttpOverrides.global = null;
  });

  testWidgets('Campus Build basic smoke and navigation test', (WidgetTester tester) async {
    // Build the CampusConnectApp
    await tester.pumpWidget(const CampusConnectApp());
    await tester.pumpAndSettle();

    // Verify app renders greeting and institutional identity
    expect(find.text('GL Bajaj Institute'), findsWidgets);
    expect(find.text('Hey, Aarav 👋'), findsOneWidget);
    expect(find.text('Your Campus Today'), findsOneWidget);

    // Verify bottom navigation items exist
    expect(find.text('Home'), findsWidgets);
    expect(find.text('Discover'), findsWidgets);
    expect(find.text('Create'), findsWidgets);
    expect(find.text('Play'), findsWidgets);
    expect(find.text('Profile'), findsWidgets);

    // Verify daily check-in button interaction
    final checkInButton = find.text('Check In (+50 XP)');
    if (checkInButton.evaluate().isNotEmpty) {
      await tester.tap(checkInButton);
      await tester.pumpAndSettle();
      expect(find.text('Checked-In ✓'), findsOneWidget);
    }

    // Navigate to Discover tab
    await tester.tap(find.text('Discover').first);
    await tester.pumpAndSettle();

    // Verify Discover vertical tabs
    expect(find.text('Study Buddies'), findsWidgets);
    expect(find.text('Marketplace'), findsWidgets);
    expect(find.text('Lost & Found'), findsWidgets);
    expect(find.text('Campus Q&A'), findsWidgets);

    // Navigate to Play tab
    await tester.tap(find.text('Play').first);
    await tester.pumpAndSettle();

    expect(find.text('Treasure Hunt'), findsWidgets);
    expect(find.text('Quiz Battles'), findsWidgets);
    expect(find.text('Leaderboard'), findsWidgets);

    // Navigate to Profile tab
    await tester.tap(find.text('Profile').first);
    await tester.pumpAndSettle();

    expect(find.text('Aarav Sharma'), findsOneWidget);
    expect(find.text('My Study Tasks'), findsOneWidget);
  });
}
