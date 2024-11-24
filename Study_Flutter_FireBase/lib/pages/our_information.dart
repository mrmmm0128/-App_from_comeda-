import 'package:flutter/material.dart';
import 'package:study_flutter_firebase/model/cliper.dart';
import 'dart:html' as html;

class AboutUsPage extends StatelessWidget {
  // URLをブラウザで開くための関数
  void _launchURL(url) {
    html.window.open(url, '_blank');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('運営元について'),
        backgroundColor: const Color(0xFF75A9D6), // Appbarの色
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // タイトル
            Text(
              '運営メンバー',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            // メンバーの写真
            Center(
              child: ClipPath(
                clipper: RoundedCornersClipper(),
                child: Image.asset(
                  'images/team_photo.jpg', // 画像のパス
                  width: 200,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
            ), // 二人の写真を一枚にまとめた画像のパス
            SizedBox(height: 16),
            // 運営メンバー情報
            MemberInfo(
              name1: '大学生S',
              description1:
                  '大学四年生です。理系です。来年からは大学院生としてマッチング理論の研究をします。アプリ開発は初心者ですが、書籍や友人を頼りに現在勉強に励んでいます。サッカー部だったので週末はサッカーをしてます！',
              name2: '大学生M',
              description2:
                  '大学四年生です。Flutterでwebアプリ作ったり、kaggleでデータ分析したりしてます、大学では植物の中の流体について研究していて、来年の4月からはエンジニアとして働きます。',
            ),
            SizedBox(height: 16),
            // 制作理由とリンク
            Text(
              '制作の理由をこちらで書いていますので是非',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            // リンク1
            GestureDetector(
              onTap: () {
                _launchURL(
                    'https://qiita.com/mrmmm0128/items/53901627029af0395e15');
              },
              child: Text(
                'Mが執筆',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                  fontSize: 14,
                ),
              ),
            ),
            SizedBox(height: 8),
            // リンク2
            GestureDetector(
              onTap: () {
                _launchURL(
                    'https://qiita.com/ssgaolai/items/bf2b91d1e2f3f015efba');
              },
              child: Text(
                'Sが執筆',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFE0ECF8),
    );
  }
}

// 運営メンバーの情報を表示するウィジェット
class MemberInfo extends StatelessWidget {
  final String name1;
  final String description1;
  final String name2;
  final String description2;

  MemberInfo({
    required this.name1,
    required this.description1,
    required this.name2,
    required this.description2,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // メンバー1の情報
        Text(
          name1,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          description1,
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 16),
        // メンバー2の情報
        Text(
          name2,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          description2,
          style: TextStyle(fontSize: 14),
        ),
        const Spacer(),
        const SizedBox(height: 70),
      ],
    );
  }
}
