import 'package:flutter/material.dart';
import 'package:study_flutter_firebase/pages/input_collection.dart';
import 'package:study_flutter_firebase/pages/explain.dart';
import 'package:study_flutter_firebase/pages/privacypolicy.dart';
import 'dart:html' as html;

class IntroductionPage extends StatelessWidget {
  const IntroductionPage({super.key});

  void _navigateToCollectionInput(BuildContext context) async {
    String deviceId = await getDeviceUUID();
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CollectionInputPage(
                deviceId: deviceId,
              )),
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

  String getDeviceUUID() {
    final storage = html.window.localStorage;
    String? uuid = storage['deviceUUID'];
    if (uuid == null) {
      uuid = DateTime.now().millisecondsSinceEpoch.toString();
      storage['deviceUUID'] = uuid; // 保存
    }
    return uuid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "みんなで割り勘",
          style: TextStyle(fontFamily: "Roboto"),
        ),
        backgroundColor: const Color(0xFF75A9D6), // Appbarの色
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        // ここでスクロールを可能にする
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                Center(
                  child: Icon(
                    Icons.group,
                    size: 80,
                    color: Colors.blue.shade300,
                  ),
                ),
                const SizedBox(height: 40),
                const Center(
                  child: Text(
                    'お金のやり取りをシンプルに',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    'このアプリで、支払い管理がもっと簡単に！\nお金のことは忘れて旅行や飲み会を楽しみましょう！',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Roboto',
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center, // テキストの中央揃え
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () => _navigateToCollectionInput(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF75A9D6),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 24),
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
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('使い方'),
                ),
                const SizedBox(height: 40),
                // Row for Image and Text
                Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.center, // これで縦方向の中央揃えが可能
                  children: [
                    Container(
                      width: 175,
                      height: 175,
                      child: const Image(
                        image: AssetImage('images/グループ説明.png'), // 表示したい画像
                      ),
                    ),
                    const SizedBox(width: 30), // 画像とテキストの間の余白
                    const Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft, // 左揃えにする
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "固定メンバーで一括管理！ ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold, // 太文字にする
                                      fontSize: 13,
                                      fontFamily: 'Montserrat',
                                      color: Colors.black87,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        "\n過去の飲み会や旅行を確認することが出来るため、「あのときいくらはらったっけ？」と悩むことはありません。",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: 'Roboto',
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center, // テキストを中央揃えにする
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 27,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center, // 縦方向の中央揃え
                  children: [
                    const Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft, // テキスト部分は左揃え
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "リンク共有で誰でも入力！",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold, // 太文字にする
                                      fontSize: 13,
                                      fontFamily: 'Montserrat',
                                      color: Colors.black87,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "\n支払入力画面の共有リンクを使えば、誰でも支払入力できます。",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: 'Roboto',
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center, // テキストを中央揃えにする
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 30), // 画像とテキストの間の余白
                    Container(
                      width: 175,
                      height: 175,
                      child: const Image(
                        image: AssetImage('images/支払説明.png'), // 表示したい画像
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 27,
                ),
                Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.center, // これで縦方向の中央揃えが可能
                  children: [
                    Container(
                      width: 175,
                      height: 175,
                      child: const Image(
                        image: AssetImage('images/支払提案説明.png'), // 表示したい画像
                      ),
                    ),
                    const SizedBox(width: 30), // 画像とテキストの間の余白
                    const Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft, // 左揃えにする
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "効率の良い割り勘を！！",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold, // 太文字にする
                                      fontSize: 13,
                                      fontFamily: 'Montserrat',
                                      color: Colors.black87,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        "\n過去の支払情報から次のお会計の分配を行うことにより、個人の支払いのばらつきを小さくすることができます",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: 'Roboto',
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center, // テキストを中央揃えにする
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
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
                TextButton(
                  onPressed: _launchContactForm,
                  child: const Text(
                    '利用規約',
                    style: TextStyle(fontSize: 16, color: Colors.blueGrey),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: const Color(0xFFE0ECF8),
    );
  }
}
