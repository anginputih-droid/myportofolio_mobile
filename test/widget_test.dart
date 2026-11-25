import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

void main() {
  test('Project reads snake_case JSON and leaves id out of toJson', () {
    final project = Project.fromJson({
      'id': 'abc',
      'title': 'Weather App',
      'description': 'Shows the weather',
      'tech_stack': 'Flutter',
      'project_url': 'https://example.com',
      'thumbnail': null,
    });

    expect(project.techStack, 'Flutter');
    expect(project.thumbnail, '');
    expect(project.toJson().containsKey('id'), isFalse);
    expect(project.toJson()['tech_stack'], 'Flutter');
  });

  test(
    'ApiClient.getProjects turns the JSON list into Project objects',
    () async {
      final client = MockClient((request) async {
        return http.Response(
          jsonEncode([
            {
              'id': '1',
              'title': 'Weather App',
              'description': 'd',
              'tech_stack': 'Flutter',
              'project_url': 'https://example.com',
              'thumbnail': '',
            },
          ]),
          200,
        );
      });

      final projects = await ApiClient(client: client).getProjects();
      expect(projects.single.title, 'Weather App');
    },
  );

  testWidgets('Home page shows the menu buttons', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(apiClient: ApiClient()));
    expect(find.text('View Projects'), findsOneWidget);
    expect(find.text('Add Project'), findsOneWidget);
  });
}
