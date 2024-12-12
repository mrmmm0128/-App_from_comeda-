import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';

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
  double? rate;
  List<String> currencies = [
    //
    'USD', 'AED', 'AFN', 'ALL', 'AMD', 'ANG', 'AOA', 'ARS', 'AUD', 'AWG', 'AZN',
    'BAM', 'BBD', 'BDT', 'BGN', 'BHD', 'BIF', 'BMD', 'BND', 'BOB', 'BRL', 'BSD',
    'BTN', 'BWP', 'BYN', 'BZD', 'CAD', 'CDF', 'CHF', 'CLP', 'CNY', 'COP', 'CRC',
    'CUP', 'CVE', 'CZK', 'DJF', 'DKK', 'DOP', 'DZD', 'EGP', 'ERN', 'ETB', 'EUR',
    'FJD', 'FKP', 'FOK', 'GBP', 'GEL', 'GGP', 'GHS', 'GIP', 'GMD', 'GNF', 'GTQ',
    'GYD', 'HKD', 'HNL', 'HRK', 'HTG', 'HUF', 'IDR', 'ILS', 'IMP', 'INR', 'IQD',
    'IRR', 'ISK', 'JEP', 'JMD', 'JOD', 'JPY', 'KES', 'KGS', 'KHR', 'KID', 'KMF',
    'KRW', 'KWD', 'KYD', 'KZT', 'LAK', 'LBP', 'LKR', 'LRD', 'LSL', 'LYD', 'MAD',
    'MDL', 'MGA', 'MKD', 'MMK', 'MNT', 'MOP', 'MRU', 'MUR', 'MVR', 'MWK', 'MXN',
    'MYR', 'MZN', 'NAD', 'NGN', 'NIO', 'NOK', 'NPR', 'NZD', 'OMR', 'PAB', 'PEN',
    'PGK', 'PHP', 'PKR', 'PLN', 'PYG', 'QAR', 'RON', 'RSD', 'RUB', 'RWF', 'SAR',
    'SBD', 'SCR', 'SDG', 'SEK', 'SGD', 'SHP', 'SLE', 'SLL', 'SOS', 'SRD', 'SSP',
    'STN', 'SYP', 'SZL', 'THB', 'TJS', 'TMT', 'TND', 'TOP', 'TRY', 'TTD', 'TVD',
    'TWD', 'TZS', 'UAH', 'UGX', 'UYU', 'UZS', 'VES', 'VND', 'VUV', 'WST', 'XAF',
    'XCD', 'XDR', 'XOF', 'XPF', 'YER', 'ZAR', 'ZMW', 'ZWL'
  ];
  String selectedCurrencies = "JPY";

  final TextEditingController _amountController =
      TextEditingController(); // 次の会計金額入力用コントローラ

  @override
  void initState() {
    super.initState();
    selectedCurrencies = "JPY";

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
        _generatePaymentSuggestion(
            selectedCurrencies, rate, "JPY"); // 取得後に支払提案を生成
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

  Future<Map<String, dynamic>> _convertToJPY(
      double amount, String? currency) async {
    if (currency == 'JPY') {
      return {'convertedAmount': amount, 'rate': 1.0};
    }

    final url =
        'https://v6.exchangerate-api.com/v6/645a1985815f1f802148fe2f/latest/$currency';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final rates = json.decode(response.body)['conversion_rates'];
      if (rates.containsKey('JPY')) {
        double rate = rates['JPY'];
        double convertedAmount = amount * rate;
        return {'convertedAmount': convertedAmount, 'rate': rate};
      }
    }
    throw Exception("通貨レートの取得に失敗しました");
  }

  // 支払提案ロジック
  void _generatePaymentSuggestion(currency, rate, selectedCurrency) {
    // 各参加者の支払合計を計算
    Map<String, double> payMap = {
      for (var entry in amounts.entries)
        entry.key: entry.value.fold(
            0.0,
            (sum, payment) =>
                sum + (payment['amount'] as num).toDouble()) // ここでキャスト
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
          remainingAmount -= amountToContribute;
          if (currency != "JPY") {
            amountToContribute = amountToContribute / rate;
          }
          suggestions.add(
              '$participant は $selectedCurrency を ${amountToContribute.round()} 支払う');
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
  // 金額を追加して支払提案を更新
  void _addAmount() async {
    double? amount = double.tryParse(_amountController.text);
    if (amount != null && amount > 0) {
      // 通貨を日本円に変換
      final result = await _convertToJPY(amount, selectedCurrencies);
      double convertedAmount = result["convertedAmount"];
      double rate = result["rate"];

      // 変換後の金額を設定し、支払提案を更新
      setState(() {
        _amountController.text =
            convertedAmount.toStringAsFixed(2); // 金額を日本円に変換して表示
        _generatePaymentSuggestion(
            selectedCurrencies, rate, selectedCurrencies); // 支払提案を更新
      });
      _amountController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "有効な金額を入力してください",
            style: TextStyle(fontFamily: "Roboto"),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Color _getColor(int index, int total) {
      // 色のリストを用意
      List<Color> colors = [
        Colors.blue,
        Colors.green,
        Colors.orange,
        Colors.red,
        Colors.purple,
        Colors.yellow,
        Colors.teal,
        Colors.pink,
        Colors.brown,
      ];

      // 人数に合わせて色を循環させる
      return colors[index % colors.length];
    }

    Map<String, double> payMap = {
      for (var entry in amounts.entries)
        entry.key: entry.value.fold(
            0.0,
            (sum, payment) =>
                sum + (payment['amount'] as num).toDouble()) // キャスト処理
    };
    double totalAmount = payMap.values.reduce((a, b) => a + b);
    List<PieChartSectionData> sections = [];
    int index = 0; // インデックスを初期化
    payMap.entries.forEach((entry) {
      sections.add(PieChartSectionData(
        value: entry.value,
        title:
            '${entry.key}: ${((entry.value / totalAmount) * 100).toStringAsFixed(1)}%',
        color: _getColor(index, payMap.length), // 支払い者ごとに色を指定
        radius: 100,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        showTitle: true,
      ));
      index++; // インデックスをインクリメント
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "分析",
          style: TextStyle(
            fontFamily: 'Roboto',
          ),
        ),
        backgroundColor: const Color(0xFF75A9D6),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0), // 余白を調整
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // 上詰め配置
          crossAxisAlignment: CrossAxisAlignment.start, // 左詰め配置
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 120, // 画像サイズを少し小さく
                  height: 120,
                  child: const ClipOval(
                    child: Image(
                      image: AssetImage('images/支払提案.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16), // 画像とテキスト間の余白を調整
                const Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "次のお会計金額を入力。 ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  fontFamily: 'Montserrat',
                                  color: Colors.black87,
                                ),
                              ),
                              TextSpan(
                                text: "\n「誰がいくら払うべきか」\nを教えてもらいましょう。",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Roboto',
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8), // 区切りスペース
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50, // 高さを調整
                    child: TextField(
                      controller: _amountController,
                      decoration: InputDecoration(
                        labelText: '次の会計金額',
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 12), // 縦方向の余白を減らす
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: DropdownButton<String>(
                      value: selectedCurrencies,
                      items: currencies.map((String currency) {
                        return DropdownMenuItem<String>(
                          value: currency,
                          child: Text(currency),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCurrencies = newValue ?? "JPY";
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _addAmount,
                    child: Text(
                      '金額を追加',
                      style: TextStyle(
                        fontFamily: "Roboto",
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF75A9D6),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // 支払い状況の表示部分（スクロール対応）
            SizedBox(
              height: 200, // 高さを設定してスクロールさせる
              child: suggestionResults.isEmpty
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      itemCount: suggestionResults.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(suggestionResults[index]),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 8),
            // 支払い状況の表示（payMapに基づいて）
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // テキスト部分
                  Expanded(
                    flex: 2, // テキスト部分を広めに設定
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '現在の支払い状況:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto',
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...payMap.entries.map((entry) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Text(
                              '${entry.key}: ${entry.value.round()} 円',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Roboto',
                                color: Colors.black54,
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                  // グラフ部分
                  Expanded(
                    flex: 3, // グラフ部分を広めに設定
                    child: PieChart(
                      PieChartData(
                        sections: sections.map((section) {
                          return PieChartSectionData(
                            color: section.color, // セクションごとの色を設定
                            value: section.value,
                            title: section.title,
                            radius: 50, // グラフの半径
                            titleStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black, // タイトルの色を白に設定
                            ),
                          );
                        }).toList(),
                        borderData: FlBorderData(show: false),
                        centerSpaceRadius: 50, // 中央にスペースを開ける
                        sectionsSpace: 2, // セクション間のスペース
                        startDegreeOffset: 90, // 円の起点を上に設定
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      backgroundColor: const Color(0xFFE0ECF8),
    );
  }
}
