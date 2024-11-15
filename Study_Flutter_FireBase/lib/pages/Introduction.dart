import 'package:flutter/material.dart';
import 'package:study_flutter_firebase/pages/input_collection.dart';
import 'package:study_flutter_firebase/pages/explain.dart';
import 'package:study_flutter_firebase/pages/privacypolicy.dart';
import 'dart:html' as html;

class IntroductionPage extends StatelessWidget {
  const IntroductionPage({super.key});

  void _navigateToCollectionInput(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CollectionInputPage()),
    );
  }

  void _navigateToExplain(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Explain()),
    );
  }

  void _navigateToPrivacyPolicy(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PrivacyPolicyPage()),
    );
  }

  // GoogleフォームのURLを開く関数
  void _launchContactForm() {
    html.window.open(
      'https://docs.google.com/forms/d/e/1FAIpQLSfHpmSHm5SBAARgemK39rfeWldmxmLPmfFU0BM1uuUXWYX3Hw/viewform?usp=sf_link',
      '_blank',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("みんなで割り勘", style: TextStyle(fontFamily: "Roboto")),
        backgroundColor: const Color(0xFF75A9D6), //Appbarの色
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.group,
                size: 80,
                color: Colors.blue.shade300,
              ),
              const SizedBox(height: 20),
              const Text(
                'みんなで割り勘へようこそ！',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '始めるボタンを押してグループ名入力ページに進んでください。',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Roboto',
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => _navigateToCollectionInput(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF75A9D6),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('始める'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _navigateToExplain(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF75A9D6),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('使い方'),
              ),
              const SizedBox(height: 40),
              const Divider(),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => _navigateToPrivacyPolicy(context),
                child: const Text(
                  'プライバシーポリシー',
                  style: TextStyle(fontSize: 16, color: Colors.blueGrey),
                ),
              ),
              TextButton(
                onPressed: _launchContactForm,
                child: const Text(
                  'お問い合わせ',
                  style: TextStyle(fontSize: 16, color: Colors.blueGrey),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: const Color(0xFFE0ECF8),
    );
  }
}
