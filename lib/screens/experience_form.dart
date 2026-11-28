import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/experience.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

class ExperienceFormPage extends StatefulWidget {
  const ExperienceFormPage({super.key});

  @override
  State<ExperienceFormPage> createState() => _ExperienceFormPageState();
}

class _ExperienceFormPageState extends State<ExperienceFormPage> {
  final _formKey = GlobalKey<FormState>();

  String _experienceTitle = "";
  String _description = "";
  String _category = "full-time"; // same default as the Django model
  String _thumbnail = "";
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isSubmitting = false;

  // Same choices as EXPERIENCE_CHOICES in the Django Experience model.
  final Map<String, String> _categories = {
    'internship': 'Internship',
    'research': 'Research',
    'volunteer': 'Volunteer',
    'part-time': 'Part-Time',
    'full-time': 'Full-Time',
    'freelance': 'Freelance',
  };

  // Shows the picked dates inside the date fields.
  final _startController = TextEditingController();
  final _endController = TextEditingController();

  // Empties every field and puts the form back to how it started.
  void _clearForm() {
    _formKey.currentState!.reset();
    _startController.clear();
    _endController.clear();
    setState(() {
      _experienceTitle = "";
      _description = "";
      _category = "full-time";
      _thumbnail = "";
      _startDate = null;
      _endDate = null;
    });
  }

  @override
  void dispose() {
    _startController.dispose();
    _endController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isStart}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: (isStart ? _startDate : _endDate) ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    setState(() {
      if (isStart) {
        _startDate = picked;
        _startController.text = formatDate(picked);
      } else {
        _endDate = picked;
        _endController.text = formatDate(picked);
      }
    });
  }

  // A picked date has no time zone, so save it as midnight UTC on that day.
  DateTime _toUtc(DateTime date) =>
      DateTime.utc(date.year, date.month, date.day);

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // Make sure we have a token before sending the POST request.
    final loggedIn = await ensureLoggedIn(context);
    if (!loggedIn || !mounted) return;

    final auth = context.read<AuthState>();
    final apiClient = context.read<ApiClient>();
    final newExperience = Experience(
      title: _experienceTitle.trim(),
      description: _description.trim(),
      category: _category,
      thumbnail: _thumbnail.trim(),
      startedAt: _toUtc(_startDate!),
      endedAt: _endDate == null ? null : _toUtc(_endDate!),
    );

    setState(() {
      _isSubmitting = true;
    });

    try {
      final saved = await apiClient.createExperience(
        newExperience,
        token: auth.token!,
      );
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('Experience added successfully!'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Title: ${saved.title}'),
                  Text('Description: ${saved.description}'),
                  Text('Category: ${saved.categoryDisplay}'),
                  Text(
                    'Thumbnail: ${saved.thumbnail.isEmpty ? "-" : saved.thumbnail}',
                  ),
                  Text('Period: ${saved.period}'),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: const Text('Add another'),
                onPressed: () {
                  Navigator.pop(dialogContext);
                  _clearForm();
                },
              ),
              TextButton(
                child: const Text('See list'),
                onPressed: () {
                  Navigator.pop(dialogContext);
                  // true tells the screen before this one that we saved something.
                  Navigator.pop(context, true);
                },
              ),
            ],
          );
        },
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      if (e.statusCode == 401) {
        // The token is no longer valid: log out and ask to log in again.
        await auth.logout();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Your session ended. Please log in again.'),
          ),
        );
        await ensureLoggedIn(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not save the experience (${e.statusCode}).'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Experience Form',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // === Experience Name ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLength: 255,
                  decoration: InputDecoration(
                    hintText: "Example: Backend Intern at Company X",
                    labelText: "Title",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _experienceTitle = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Enter a title.";
                    }
                    if (value.trim().length > 255) {
                      return "Title can't be longer than 255 characters.";
                    }
                    return null;
                  },
                ),
              ),

              // === Description ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: "What did you do there?",
                    labelText: "Description",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _description = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Enter a description.";
                    }
                    return null;
                  },
                ),
              ),

              // === Category ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: "Category",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  initialValue: _category,
                  items: _categories.entries
                      .map(
                        (category) => DropdownMenuItem(
                          value: category.key,
                          child: Text(category.value),
                        ),
                      )
                      .toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _category = newValue!;
                    });
                  },
                ),
              ),

              // === Thumbnail URL (optional) ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    hintText: "https://...",
                    labelText: "Thumbnail URL (optional)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _thumbnail = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return null; // optional, like blank=True in Django
                    }
                    final uri = Uri.tryParse(value.trim());
                    final isValid =
                        uri != null &&
                        (uri.scheme == 'http' || uri.scheme == 'https') &&
                        uri.host.isNotEmpty;
                    if (!isValid) {
                      return "Enter a valid URL that starts with http:// or https://.";
                    }
                    return null;
                  },
                ),
              ),

              // === Start Date ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _startController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Start Date",
                    suffixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onTap: () => _pickDate(isStart: true),
                  validator: (String? value) {
                    if (_startDate == null) {
                      return "Pick a start date.";
                    }
                    return null;
                  },
                ),
              ),

              // === End Date (optional) ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _endController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "End Date (leave empty if ongoing)",
                    suffixIcon: _endDate == null
                        ? const Icon(Icons.calendar_today)
                        : IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _endDate = null;
                                _endController.clear();
                              });
                            },
                          ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onTap: () => _pickDate(isStart: false),
                  validator: (String? value) {
                    if (_endDate != null &&
                        _startDate != null &&
                        _endDate!.isBefore(_startDate!)) {
                      return "End date can't be before the start date.";
                    }
                    return null;
                  },
                ),
              ),

              // === Save Button ===
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.indigo),
                    ),
                    onPressed: _isSubmitting ? null : _submit,
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text(
                            "Save",
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),
              ),

              // === Clear Button ===
              Align(
                alignment: Alignment.bottomCenter,
                child: TextButton(
                  onPressed: _clearForm,
                  child: const Text("Clear form"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
