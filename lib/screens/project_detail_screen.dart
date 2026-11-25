import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/project.dart';

class ProjectDetailScreen extends StatelessWidget {
  const ProjectDetailScreen({required this.project, super.key});

  final Project project;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(project.title),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              project.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'Description',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(project.description),
            const SizedBox(height: 12),
            const Text(
              'Tech Stack',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(project.techStack),
            const SizedBox(height: 12),
            const Text(
              'Project URL',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(project.projectUrl.isEmpty ? '-' : project.projectUrl),
            // Only show the image part when the project has a thumbnail.
            if (project.thumbnail.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text(
                'Thumbnail',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Image.network(
                project.thumbnail,
                errorBuilder: (context, error, stackTrace) =>
                    Text(project.thumbnail),
              ),
            ],
          ],
        ),
      ),
    );
  }
}