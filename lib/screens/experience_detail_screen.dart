import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/experience.dart';

class ExperienceDetailScreen extends StatelessWidget {
  const ExperienceDetailScreen({required this.experience, super.key});

  final Experience experience;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(experience.title),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              experience.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'Description',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(experience.description),
            const SizedBox(height: 12),
            const Text(
              'Category',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(experience.categoryDisplay),
            const SizedBox(height: 12),
            const Text(
              'Start Date',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(formatDate(experience.startedAt)),
            const SizedBox(height: 12),
            const Text(
              'End Date',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              experience.endedAt == null
                  ? 'Ongoing'
                  : formatDate(experience.endedAt!),
            ),
            const SizedBox(height: 12),
            const Text('Stars', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('${experience.starCount}'),
            // Only show the image part when there is a thumbnail.
            if (experience.thumbnail.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text(
                'Thumbnail',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Image.network(
                experience.thumbnail,
                errorBuilder: (context, error, stackTrace) =>
                    Text(experience.thumbnail),
              ),
            ],
          ],
        ),
      ),
    );
  }
}