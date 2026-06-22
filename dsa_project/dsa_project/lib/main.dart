import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const DsaProjectApp());
}

class DsaProjectApp extends StatelessWidget {
  const DsaProjectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DSA URL Shortener',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const UrlShortenerScreen(),
    );
  }
}

class UrlShortenerScreen extends StatefulWidget {
  const UrlShortenerScreen({super.key});

  @override
  State<UrlShortenerScreen> createState() => _UrlShortenerScreenState();
}

class _UrlShortenerScreenState extends State<UrlShortenerScreen> {
  final TextEditingController _urlController = TextEditingController();
  
  // DSA Requirement: Hash Map Database emulation for O(1) lookups
  final Map<String, String> _shortToLongTable = {};
  final Map<String, String> _longToShortTable = {};
  
  final String _baseChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
  String _generatedShortUrl = "";
  String _redirectResult = "";

  // DATA STRUCTURE ALGORITHM: Custom Hashing with Collision Handling
  String _generateShortCode(String longUrl) {
    // Check if URL already exists to avoid redundant computation
    if (_longToShortTable.containsKey(longUrl)) {
      return _longToShortTable[longUrl]!;
    }

    int codeLength = 6;
    Random random = Random();
    String code = "";

    // Loop handles collision resolution (Linear Probing variant via salt re-generation)
    while (true) {
      code = "";
      for (int i = 0; i < codeLength; i++) {
        code += _baseChars[random.nextInt(_baseChars.length)];
      }
      
      // Collision Check: If code is unique, break loop. Else, re-hash.
      if (!_shortToLongTable.containsKey(code)) {
        break;
      }
    }

    // Store mappings in Hash tables for instant O(1) performance
    _shortToLongTable[code] = longUrl;
    _longToShortTable[longUrl] = code;
    return code;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DSA Project: Bitly-Lite Service'), backgroundColor: Colors.teal),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Theme B1: URL Shortener & Collision Handling', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'Enter Long URL',
                hintText: 'https://example.com/very-long-query-path',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50), backgroundColor: Colors.teal),
              onPressed: () {
                if (_urlController.text.isNotEmpty) {
                  setState(() {
                    String code = _generateShortCode(_urlController.text);
                    _generatedShortUrl = "short.ly/$code";
                    _redirectResult = "";
                  });
                }
              },
              child: const Text('Generate Short URL', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
            const SizedBox(height: 25),
            if (_generatedShortUrl.isNotEmpty) ...[
              Card(
                color: Colors.teal[50],
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text('Result: $_generatedShortUrl', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.teal)),
                      ),
                      IconButton(
                        icon: const Icon(Icons.bolt, color: Colors.amber),
                        tooltip: 'Simulate O(1) Redirect',
                        onPressed: () {
                          // Simulate immediate retrieval via Hash Map pointer lookup
                          String code = _generatedShortUrl.split('/').last;
                          setState(() {
                            _redirectResult = _shortToLongTable[code] ?? "Not Found";
                          });
                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 20),
            if (_redirectResult.isNotEmpty) ...[
              const Text('O(1) Hash Redirect Destination:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(_redirectResult, style: const TextStyle(fontSize: 14, color: Colors.blueGrey, fontStyle: FontStyle.italic)),
            ]
          ],
        ),
      ),
    );
  }
}