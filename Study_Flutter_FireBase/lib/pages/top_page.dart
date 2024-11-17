import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:study_flutter_firebase/model/memo.dart';
import 'package:study_flutter_firebase/pages/add_memo_page.dart';
import 'package:study_flutter_firebase/pages/memo_detail_page.dart';
import 'package:study_flutter_firebase/pages/input_collection.dart';
import 'dart:html' as html;
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:study_flutter_firebase/pages/explain.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.collectionName});

  final String collectionName;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late CollectionReference memoCollection;

  @override
  void initState() {
    super.initState();
    memoCollection =
        FirebaseFirestore.instance.collection(widget.collectionName);
  }

  void _navigateToExplain(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Explain()),
    );
  }

  void _deleteMemo(String id) async {
    await memoCollection.doc(id).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('メモを削除しました')),
    );
  }

  void _getLink(String memoId, String collectionName) async {
    // メモIDをURLエンコードしてリンクを生成
    String link = "https://groupwarikan.com/travel/$collectionName/$memoId";

    // クリップボードにリンクをコピー
    Clipboard.setData(ClipboardData(text: link)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("リンクがクリップボードにコピーされました")),
      );
    });
  }

  void _navigateToCollectionInput(BuildContext context) async {
    String deviceId = await getDeviceInfo();
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CollectionInputPage(
                deviceId: deviceId,
              )),
    );
  }

  String getDeviceInfo() {
    // ブラウザのユーザーエージェントを取得
    String userAgent = html.window.navigator.userAgent;
    final bytes = utf8.encode(userAgent);
    final hash = sha256.convert(bytes); // SHA256でハッシュ化
    return hash.toString(); // 安全なドキュメントID

    // 必要に応じて、ユーザーエージェントからデバイスやブラウザ情報を抽出
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "みんなで割り勘",
          style: TextStyle(
            fontFamily: 'Roboto',
          ),
        ),
        backgroundColor: const Color(0xFF75A9D6), //Appbarの色
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline), // ボタンのアイコン
            onPressed: () => _navigateToExplain(context), // ページ遷移
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: memoCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return const Center(child: Text("データがありません"));
          }
          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> data =
                  docs[index].data() as Map<String, dynamic>;
              DateTime date = (data["date"] as Timestamp).toDate();

              final Memo fetchMemo = Memo(
                id: docs[index].id,
                title: data["title"],
                date: date,
                participants: List<String>.from(data["participants"]),
              );

              String formattedDate =
                  DateFormat('yyyy年MM月dd日').format(fetchMemo.date);

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(
                      fetchMemo.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "日付: $formattedDate",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        Text(
                          "参加者: ${fetchMemo.participants.length}人",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    leading: const Icon(
                      Icons.receipt_long,
                      color: Colors.blueAccent,
                      size: 40,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.link),
                          color: Colors.blueAccent,
                          onPressed: () {
                            _getLink(fetchMemo.id, widget.collectionName);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          color: Colors.redAccent,
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("確認"),
                                  content: const Text("このメモを削除しますか？"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("キャンセル"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        _deleteMemo(fetchMemo.id);
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("削除"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey[400],
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MemoDetailPage(
                            collectionName: widget.collectionName,
                            memoId: docs[index].id,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton.extended(
              onPressed: () => _navigateToCollectionInput(context),
              backgroundColor: const Color(0xFF75A9D6),
              foregroundColor: Colors.white,
              label: const Text("グループ選択"),
              icon: const Icon(Icons.folder_open),
            ),
            FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddMemoPage(
                      collectionName: widget.collectionName,
                    ),
                  ),
                );
              },
              backgroundColor: const Color(0xFF75A9D6),
              foregroundColor: Colors.white,
              label: const Text("メモ追加"),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFE0ECF8), // 背景色,
    );
  }
}
