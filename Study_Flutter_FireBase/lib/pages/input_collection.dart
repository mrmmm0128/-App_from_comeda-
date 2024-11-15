import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:study_flutter_firebase/pages/add_memo_page.dart';
import 'package:study_flutter_firebase/pages/top_page.dart';

class CollectionInputPage extends StatefulWidget {
  const CollectionInputPage({super.key});

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

  // 既存グループに移動
  void _navigateToNextPage(String collectionName) async {
    if (collectionName.isNotEmpty) {
      // グループが存在するか確認
      bool groupExists = await _checkIfGroupExists(collectionName);

      if (groupExists) {
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
        backgroundColor: const Color(0xFF75A9D6), //Appbarの色,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'グループを作って仲間との支払記録を共有しましょう!',
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
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'グループ名',
                labelStyle: TextStyle(color: Colors.blue.shade400),
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
                backgroundColor: Colors.blue.shade400,
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
            TextField(
              controller: _newGroupController,
              decoration: InputDecoration(
                labelText: '新しいグループ名',
                labelStyle: TextStyle(color: Colors.blue.shade400),
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
                backgroundColor: Colors.blue.shade400,
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
          ],
        ),
      ),
      backgroundColor: const Color(0xFFE0ECF8), // 背景色,
    );
  }
}
