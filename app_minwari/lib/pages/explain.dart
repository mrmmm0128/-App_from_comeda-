import 'package:flutter/material.dart';

class Explain extends StatelessWidget {
  const Explain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0ECF8), // 背景色
      appBar: AppBar(
        backgroundColor: const Color(0xFF75A9D6),
        title: const Text(
          '使い方',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(  // ここでスクロールを有効にする
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // 左寄せ
            children: [
              const SizedBox(height: 20),
              const Text(
                'みんなで割り勘の使い方',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'みんなで割り勘は旅行や遊び、飲み会等の場面で使える割り勘アプリです。',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              const Text(
                '1. グループ名を入力しよう',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'みんなで割り勘を利用するメンバーのグループ名を入力しましょう！\n',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Center(
                child: Image(// Imageウィジェット
                  image: AssetImage('images/explain1.jpg'), // 表示したい画像
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '2. メンバーを追加しよう',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'メンバーを登録しましょう！人数が多い場合は、「参加者を追加ボタン」から入力欄を増やせます。\nメンバーが入力できたら、「確定」ボタンで次に進みます。\n行き先などの情報をメモとして記入できます。',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Center(
                child: Image(// Imageウィジェット
                  image: AssetImage('images/explain2.jpg'), // 表示したい画像
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '3. リンクを共有しよう',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'グループ内に新しく画像のようなリストが作成されているはずです。この画面から、リンクをコピーしてメンバーに共有しましょう！共有することで誰でも書き込みができます',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Center(
                child: Image(// Imageウィジェット
                  image: AssetImage('images/explain3.jpg'), // 表示したい画像
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '4. 支払い情報を入力しよう',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                '''支払いが発生したら、誰がいくら払ったかを入力しましょう。複数の外貨にも対応しています！また、右のボタンからメモできます！なんて優秀なアプリ''',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Center(
                child: Image(// Imageウィジェット
                  image: AssetImage('images/explain4.jpg'), // 表示したい画像
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '5. 精算しよう',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                '''・入力したデータは「保存」ボタンで保存しましょう\n・「履歴」ボタンで過去の支払いを確認できます\n
・旅行や遊びの最後に「精算」することで、メンバー全員の支払額が同じになります！\n
・「支払提案」ボタンは次回の支払額を入力することで最後の精算を楽にすることができます！素敵な機能ですね\n
                ''',
                style: TextStyle(fontSize: 16),
              ),
              Center(
                child: Image(// Imageウィジェット
                  image: AssetImage('images/explain5.jpg'), // 表示したい画像
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'さあ、お金の不安をなくして友達、家族と楽しい時間を過ごそう！',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF75A9D6), // ボタンの背景色
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text(
                  '閉じる',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
