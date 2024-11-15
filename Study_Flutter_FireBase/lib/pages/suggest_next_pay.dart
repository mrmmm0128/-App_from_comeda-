import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentSuggestionPage extends StatefulWidget {
  final String memoId;
  final String collectionName;

  PaymentSuggestionPage({required this.memoId, required this.collectionName});

  @override
  _PaymentSuggestionPageState createState() => _PaymentSuggestionPageState();
}

class _PaymentSuggestionPageState extends State<PaymentSuggestionPage> {
  Map<String, List<Map<String, dynamic>>> amounts = {}; // 支払履歴データ
  List<String> suggestionResults = []; // 支払提案結果リスト
  final TextEditingController _amountController =
      TextEditingController(); // 次の会計金額入力用コントローラ

  @override
  void initState() {
    super.initState();
    _fetchMemoData(); // Firestoreから支払データを取得
  }

  // Firestoreから支払履歴データを取得
  Future<void> _fetchMemoData() async {
    try {
      DocumentSnapshot memoDoc = await FirebaseFirestore.instance
          .collection(widget.collectionName)
          .doc(widget.memoId)
          .get();

      if (memoDoc.exists) {
        setState(() {
          amounts = Map<String, List<Map<String, dynamic>>>.from(
            memoDoc['amounts'].map(
                  (key, value) => MapEntry(
                    key,
                    List<Map<String, dynamic>>.from(
                        value.map((entry) => Map<String, dynamic>.from(entry))),
                  ),
                ) ??
                {},
          );
        });
        _generatePaymentSuggestion(); // 取得後に支払提案を生成
      } else {
        setState(() {
          suggestionResults = ["データが見つかりません"];
        });
      }
    } catch (e) {
      print("Error fetching memo data: $e");
      setState(() {
        suggestionResults = ["データ取得エラー"];
      });
    }
  }

  // 支払提案ロジック
  void _generatePaymentSuggestion() {
    // 各参加者の支払合計を計算
    Map<String, double> payMap = {
      for (var entry in amounts.entries)
        entry.key: entry.value
            .fold(0.0, (sum, payment) => sum + (payment['amount'] as double))
    };

    // 未払いの金額（次の会計）を取得
    final double amountToPay = double.tryParse(_amountController.text) ?? 0.0;

    // 未払い金額がある場合に支払提案を生成
    if (amountToPay > 0) {
      // 現在の支払合計
      double totalPaidSoFar =
          payMap.values.fold(0.0, (sum, paid) => sum + paid);

      // 全体の支払総額と平均支払額を計算
      double totalAmount = totalPaidSoFar + amountToPay;
      double averagePayment = totalAmount / payMap.length;

      // 支払額が少ない人から順に並べる
      List<String> sortedParticipants = payMap.keys.toList();
      sortedParticipants.sort((a, b) => payMap[a]!.compareTo(payMap[b]!));

      // 残りの会計金額を均等になるように配分
      double remainingAmount = amountToPay;
      List<String> suggestions = [];

      for (var participant in sortedParticipants) {
        double personPaid = payMap[participant]!;
        double differenceToAverage = averagePayment - personPaid;

        // 各人が平均に近づけるための支払額を計算
        double amountToContribute = differenceToAverage;

        // 残り金額を超えないよう調整
        if (amountToContribute > remainingAmount) {
          amountToContribute = remainingAmount;
        }

        if (amountToContribute > 0) {
          suggestions.add('$participant は ¥${amountToContribute.round()} 支払う');
          remainingAmount -= amountToContribute;
          payMap[participant] = personPaid + amountToContribute; // 支払額を更新
        }

        // 残り金額がなくなれば終了
        if (remainingAmount <= 0) break;
      }

      // 提案結果を更新
      setState(() {
        suggestionResults = suggestions;
      });
    } else {
      setState(() {
        suggestionResults = ["未払い金額を入力してください"];
      });
    }
  }

  // 金額を追加して支払提案を更新
  void _addAmount() {
    final double? amount = double.tryParse(_amountController.text);
    if (amount != null && amount > 0) {
      setState(() {
        _generatePaymentSuggestion(); // 支払提案を更新
      });
      _amountController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
          "有効な金額を入力してください",
          style: TextStyle(fontFamily: "Roboto"),
        )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "支払提案",
          style: TextStyle(
            fontFamily: 'Roboto',
          ),
        ),
        backgroundColor: const Color(0xFF75A9D6), //Appbarの色
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: '次の会計金額'),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: _addAmount,
              child: Text('金額を追加', style: TextStyle(fontFamily: "Roboto")),
            ),
            Expanded(
              child: suggestionResults.isEmpty
                  ? Center(child: CircularProgressIndicator()) // データ取得中
                  : ListView.builder(
                      itemCount: suggestionResults.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(suggestionResults[index]),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFE0ECF8), // 背景色
    );
  }
}
