import 'package:flutter/material.dart';
import 'package:study_flutter_firebase/pages/input_collection.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:html' as html;

class IntroductionPage extends StatelessWidget {
  const IntroductionPage({super.key});

  void _navigateToCollectionInput(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CollectionInputPage()),
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
        title: const Text(
          "みんなで割り勘",
          style: TextStyle(fontFamily: "Roboto", fontSize: 22),
        ),
        backgroundColor: const Color(0xFF75A9D6), //Appbarの色
        foregroundColor: Colors.white,
        elevation: 4,
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
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                  color: Colors.blueGrey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'グループを作って仲間との支払記録を共有しましょう！',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blueGrey,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () => _navigateToCollectionInput(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade400,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                icon: const Icon(Icons.arrow_forward),
                label: const Text('始める'),
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 20),
              // アプリの説明を追加
              const Text(
                '① 仲間とグループを作って旅行や行事を管理しましょう！\n'
                '② 行事ごとに支払を記録しましょう！\n'
                '③ 支払提案機能を用いて次の支払の分配をお願いしましょう！\n'
                '④ 清算ボタンを押して、支払が少なかった人は多く支払った人にお金を渡しましょう！',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 30),
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('プライバシーポリシーはまだ実装されていません')),
                  );
                },
                child: const Text(
                  'プライバシーポリシー',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blueGrey,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              TextButton(
                onPressed: _launchContactForm,
                child: const Text(
                  'お問い合わせ',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blueGrey,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: const Color(0xFFE0ECF8), // 背景色
    );
  }
}
