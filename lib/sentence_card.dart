
import 'package:flutter/material.dart';
import 'package:jp_transliterate/jp_transliterate.dart';

import 'sentence.dart';

class SentenceCard extends StatefulWidget {
  final Sentence sentence;

  const SentenceCard({
    super.key,
    required this.sentence,
  });

  @override
  State<SentenceCard> createState() => _SentenceCardState();
}

class _SentenceCardState extends State<SentenceCard> {
  bool showFurigana = true;

  late Future<List<TransliterationData>> transliterationFuture;

  @override
  void initState() {
    super.initState();
    transliterationFuture = JpTransliterate.transliterateWords(
      kanji: widget.sentence.japanese,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Visible ON/OFF toggle
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Show Furigana',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(showFurigana ? 'ON' : 'OFF'),
              value: showFurigana,
              onChanged: (value) {
                setState(() {
                  showFurigana = value;
                });
              },
            ),

            const Divider(),

            // Japanese sentence
            FutureBuilder<List<TransliterationData>>(
              future: transliterationFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (snapshot.hasError ||
                    !snapshot.hasData ||
                    snapshot.data!.isEmpty) {
                  return Text(
                    widget.sentence.japanese,
                    style: const TextStyle(fontSize: 28),
                  );
                }

                if (showFurigana) {
                  return FuriganaText(
                    transliterations: snapshot.data!,
                    style: const TextStyle(
                      fontSize: 28,
                      color: Colors.black,
                    ),
                    rubyStyle: const TextStyle(
                      fontSize: 12,
                      color: Colors.blue,
                    ),
                  );
                }

                return Text(
                  widget.sentence.japanese,
                  style: const TextStyle(
                    fontSize: 28,
                    color: Colors.black,
                  ),
                );
              },
            ),

            const SizedBox(height: 12),

            Text(
              widget.sentence.meaning,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
