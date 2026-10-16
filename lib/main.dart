
import 'package:flutter/material.dart';
import 'package:jp_transliterate/jp_transliterate.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Furigana Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const FuriganaPage(),
    );
  }
}

class FuriganaPage extends StatefulWidget {
  const FuriganaPage({super.key});

  @override
  State<FuriganaPage> createState() => _FuriganaPageState();
}

class _FuriganaPageState extends State<FuriganaPage> {
  final String japanese = '私は学校へ行きます。';

  List<TransliterationData> transliterationWords = [];

  bool loading = true;
  bool showFurigana = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    generateFurigana();
  }

  Future<void> generateFurigana() async {
    try {
      final words = await JpTransliterate.transliterateWords(
        kanji: japanese,
      );

      if (!mounted) return;

      setState(() {
        transliterationWords = words;
        loading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        errorMessage = error.toString();
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Furigana Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Visible Furigana ON/OFF switch
            Card(
              child: SwitchListTile(
                title: const Text(
                  'Show Furigana',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                subtitle: Text(
                  showFurigana ? 'ON' : 'OFF',
                ),
                secondary: Icon(
                  showFurigana
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: Colors.grey,
                ),
                value: showFurigana,
                onChanged: (value) {
                  setState(() {
                    showFurigana = value;
                  });
                },
              ),
            ),

            const SizedBox(height: 30),

            // Japanese sentence
            Expanded(
              child: Center(
                child: loading
                    ? const CircularProgressIndicator()
                    : errorMessage != null
                        ? Text(
                            'Error: $errorMessage',
                            style: const TextStyle(
                              color: Colors.red,
                            ),
                          )
                        : showFurigana
                            ? FuriganaText(
                                transliterations:
                                    transliterationWords,
                                style: const TextStyle(
                                  fontSize: 28,
                                  color: Colors.black,
                                ),
                                rubyStyle: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              )
                            : Text(
                                japanese,
                                style: const TextStyle(
                                  fontSize: 28,
                                  color: Colors.black,
                                ),
                              ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
