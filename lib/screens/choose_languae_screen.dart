import 'package:flutter/material.dart';
import 'package:myprojectshop/theme/theme.dart';

// void main() {
//   runApp(const MaterialApp(
//     home: LanguageSelectionPage(),
//     debugShowCheckedModeBanner: false,
//   ));
// }

class LanguageSelectionPage extends StatefulWidget {
  const LanguageSelectionPage({Key? key}) : super(key: key);

  @override
  State<LanguageSelectionPage> createState() => _LanguageSelectionPageState();
}

class _LanguageSelectionPageState extends State<LanguageSelectionPage> {
  String? selectedLanguage = 'English';

  final List<Map<String, String>> languages = [
    {'title': 'English', 'subtitle': 'English'},
    {'title': 'Spanish', 'subtitle': 'Español'},
    {'title': 'French', 'subtitle': 'Français'},
    {'title': 'German', 'subtitle': 'Deutsch'},
    {'title': 'Italian', 'subtitle': 'Italiano'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.arrow_back),
              const SizedBox(height: 20),
              const Text(
                'Choose Language',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Select your preferred language',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.builder(
                  itemCount: languages.length,
                  itemBuilder: (context, index) {
                    final lang = languages[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: selectedLanguage == lang['title']
                                ? Colors.deepPurple
                                : Colors.grey.shade300,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: RadioListTile(
                          value: lang['title'],
                          groupValue: selectedLanguage,
                          onChanged: (value) {
                            setState(() {
                              selectedLanguage = value.toString();
                            });
                          },
                          title: Text(
                            lang['title']!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(lang['subtitle']!),
                          activeColor: Colors.deepPurple,
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // تابع التنقل أو التخزين حسب اختيار المستخدم
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
