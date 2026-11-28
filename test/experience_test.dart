import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/models/experience.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

void main() {
  final sampleJson = {
    'id': 'abc',
    'title': 'PBP Teaching Assistant',
    'description': 'Helped students',
    'category': 'part-time',
    'category_display': 'Part-Time',
    'thumbnail': null,
    'started_at': '2025-08-01T00:00:00Z',
    'ended_at': null,
    'star_count': 2,
    'is_starred': false,
    'starred_by_names': 'a, b',
  };

  test('Experience reads snake_case JSON and only sends writable fields', () {
    final experience = Experience.fromJson(sampleJson);

    expect(experience.categoryDisplay, 'Part-Time');
    expect(experience.thumbnail, '');
    expect(experience.endedAt, isNull);
    expect(experience.starCount, 2);

    final json = experience.toJson();
    expect(json.containsKey('id'), isFalse);
    expect(json.containsKey('category_display'), isFalse);
    expect(json.containsKey('star_count'), isFalse);
    expect(json['started_at'], '2025-08-01T00:00:00.000Z');
  });

  test('createExperience sends the token and the JSON body', () async {
    late http.Request sent;
    final client = MockClient((request) async {
      sent = request;
      return http.Response(jsonEncode(sampleJson), 201);
    });

    final saved = await ApiClient(client: client).createExperience(
      Experience(
        title: 'PBP Teaching Assistant',
        description: 'Helped students',
        category: 'part-time',
        startedAt: DateTime.utc(2025, 8, 1),
      ),
      token: 'secret',
    );

    expect(sent.method, 'POST');
    expect(sent.url.path, '/api/v1/experience/');
    expect(sent.headers['Authorization'], 'Token secret');
    expect(jsonDecode(sent.body)['category'], 'part-time');
    expect(saved.id, 'abc');
  });

  test('getExperiences throws ApiException on a 401', () async {
    final client = MockClient((request) async => http.Response('{}', 401));

    expect(
      ApiClient(client: client).getExperiences(),
      throwsA(
        isA<ApiException>().having((e) => e.statusCode, 'statusCode', 401),
      ),
    );
  });
}