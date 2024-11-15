import 'dart:math';

void main() {
  // サンプルのデータを含むMapを定義
  Map<String, double> payMap = {
    "Alice": 1000,
    "Bob": 2000,
    "Charlie": 3000,
  };

  // seisan関数を呼び出し、結果を受け取る
  List<String> result = seisan(payMap);

  // 結果を表示
  for (String line in result) {
    print(line);
  }
}

List<String> seisan(Map<String, double> payMap) {
  int people = payMap.length;
  double sumPay = payMap.values.reduce((a, b) => a + b);

  double aPay = sumPay / people;

  // 新しい支払状況のマップ
  Map<String, double> newPay = {
    for (var entry in payMap.entries) entry.key: entry.value - aPay
  };

  List<String> conceqence = [];

  while (true) {
    // 最小の支払うべき金額と、その人のリスト
    double pay = newPay.values.reduce(min);
    List<String> payPeople = newPay.entries
        .where((entry) => entry.value == pay)
        .map((entry) => entry.key)
        .toList();

    // 最大の受け取るべき金額と、その人のリスト
    double get = newPay.values.reduce(max);
    List<String> getPeople = newPay.entries
        .where((entry) => entry.value == get)
        .map((entry) => entry.key)
        .toList();

    // 支払う金額を決定
    double payment = min(get, pay.abs());

    for (int i = 0; i < min(payPeople.length, getPeople.length); i++) {
      newPay[payPeople[i]] = newPay[payPeople[i]]! + payment;
      newPay[getPeople[i]] = newPay[getPeople[i]]! - payment;

      conceqence.add('${payPeople[i]}が${getPeople[i]}に支払い：${payment.round()}');
    }

    // 全員の支払額がほぼ0になったか確認
    if (newPay.values.every((value) => (value).abs() < 1e-9)) {
      return conceqence;
    }
  }
}