import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:study_flutter_firebase/pages/add_memo_page.dart';
import 'package:study_flutter_firebase/pages/top_page.dart';
import 'package:study_flutter_firebase/pages/privacypolicy.dart';
import 'package:study_flutter_firebase/pages/servicerule.dart';
import 'package:study_flutter_firebase/pages/our_information.dart';
import 'dart:html' as html;

class CollectionInputPage extends StatefulWidget {
  final String deviceId;

  // コンストラクタで deviceId を受け取るように修正
  const CollectionInputPage({super.key, required this.deviceId});

  @override
  _CollectionInputPageState createState() => _CollectionInputPageState();
}

class _CollectionInputPageState extends State<CollectionInputPage> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _newGroupController = TextEditingController();

  // Firestoreに新しいグループがすでに存在するかを確認する非同期関数
  Future<bool> _checkIfGroupExists(String groupName) async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection(groupName).get();
      return snapshot.docs.isNotEmpty; // ドキュメントがあれば、グループ名は既に存在
    } catch (e) {
      print("Error checking group: $e");
      return false;
    }
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

  // 既存グループに移動
  void _navigateToNextPage(String collectionName) async {
    if (collectionName.isNotEmpty) {
      // グループが存在するか確認
      bool groupExists = await _checkIfGroupExists(collectionName);

      if (groupExists) {
        saveGroup(widget.deviceId, collectionName);
        // グループが存在すればページ遷移
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyHomePage(collectionName: collectionName),
          ),
        );
      } else {
        // グループが存在しない場合、エラーメッセージを表示
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('指定されたグループは存在しません')),
        );
      }
    } else {
      // グループ名が空の場合、エラーメッセージを表示
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('グループ名を入力してください')),
      );
    }
  }

  // 新しいグループを作成
  void _createNewGroupAndNavigate(String groupName) async {
    if (groupName.isNotEmpty) {
      bool groupExists = await _checkIfGroupExists(groupName);

      if (!groupExists) {
        saveGroup(widget.deviceId, groupName);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddMemoPage(collectionName: groupName),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('新しいグループが作成されました')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('このグループ名はすでに使われています')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('新しいグループ名を入力してください')),
      );
    }
  }

  Future<void> saveGroup(String deviceId, String groupName) async {
    final deviceRef =
        FirebaseFirestore.instance.collection('devices').doc(deviceId);

    final doc = await deviceRef.get();

    if (doc.exists) {
      // 既存のグループリストに追加
      final groups = List<String>.from(doc['groups'] ?? []);
      if (!groups.contains(groupName)) {
        groups.add(groupName);
        await deviceRef.update({'groups': groups});
      }
    } else {
      // 新規デバイスの場合
      await deviceRef.set({
        'groups': [groupName]
      });
    }
  }

  Future<List<String>> getGroups(String deviceId) async {
    final doc = await FirebaseFirestore.instance
        .collection('devices')
        .doc(deviceId)
        .get();
    if (doc.exists) {
      return List<String>.from(doc['groups'] ?? []);
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "グループ名入力",
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 22,
          ),
        ),
        backgroundColor: const Color(0xFF75A9D6), // AppBarの色
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        // スクロール可能にする
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'グループを作ってみんなと記録を共有しましょう!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                    color: Colors.blueGrey,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // 既存グループの検索フィールド
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'グループ名',
                  labelStyle: TextStyle(color: Colors.blueGrey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue.shade400),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _navigateToNextPage(_controller.text),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF75A9D6),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  '既存グループに移動',
                  style: TextStyle(fontFamily: "Roboto", fontSize: 16),
                ),
              ),
              const Divider(
                height: 40,
                color: Colors.blueGrey,
                thickness: 1.0,
              ),
              // 新しいグループ名の入力フィールド
              TextField(
                controller: _newGroupController,
                decoration: InputDecoration(
                  labelText: '新しいグループ名',
                  labelStyle: TextStyle(color: Colors.blueGrey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue.shade400),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () =>
                    _createNewGroupAndNavigate(_newGroupController.text),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF75A9D6),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  '新しいグループを作成',
                  style: TextStyle(fontFamily: "Roboto", fontSize: 16),
                ),
              ),
              const Divider(
                height: 40,
                color: Colors.blueGrey,
                thickness: 1.0,
              ),
              // グループリストを表示するFutureBuilder
              FutureBuilder<List<String>>(
                future: getGroups(widget.deviceId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('エラーが発生しました: ${snapshot.error}');
                  }
                  final groups = snapshot.data ?? [];
                  return ListView.builder(
                    physics:
                        const NeverScrollableScrollPhysics(), // 親スクロールと競合しないようにする
                    shrinkWrap: true, // サイズを調整
                    itemCount: groups.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          // タップされた時に画面遷移を行う
                          _navigateToNextPage(groups[index]);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFF75A9D6),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ListTile(
                            title: Text(
                              groups[index],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 24),
                            leading: const Icon(
                              Icons.group,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center, // 水平方向の中央揃え
                  children: [
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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => servicerule(),
                          ),
                        );
                      },
                      child: const Text(
                        '利用規約',
                        style: TextStyle(fontSize: 16, color: Colors.blueGrey),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AboutUsPage(),
                          ),
                        );
                      },
                      child: const Text(
                        '運営元情報',
                        style: TextStyle(fontSize: 16, color: Colors.blueGrey),
                      ),
                    ),
                    const SizedBox(height: 200),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      backgroundColor: const Color(0xFFE0ECF8),
    );
  }
}
