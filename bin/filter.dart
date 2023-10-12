import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

final filterAPI = Uri.parse(
    "https://us-central1-milestone-rest.cloudfunctions.net/filterSubjects");

void main() async {
  print("授業のフィルター条件を入力してください。");

  print("曜日:");
  String? day = stdin.readLineSync();

  print("時限:");
  String? period = stdin.readLineSync();

  print("学期:");
  String? semester = stdin.readLineSync();

  print("名前:");
  String? name = stdin.readLineSync();

  print("教員名:");
  String? teacher = stdin.readLineSync();

  print("学部");
  String? faculty = stdin.readLineSync();

  // APIに送るデータを作成
  final Map<String, dynamic> filterData = {
    if (day != null && day.isNotEmpty) 'day': day,
    if (semester != null && semester.isNotEmpty) 'semester': semester,
    if (name != null && name.isNotEmpty) 'name': name,
    if (period != null && period.isNotEmpty) 'period': period,
    if (teacher != null && teacher.isNotEmpty) 'teacher': teacher,
    if (faculty != null && faculty.isNotEmpty) 'faculty': faculty,
  };

  // APIにリクエストを送る
  final response = await http.post(
    filterAPI,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(filterData),
  );

  // レスポンスを処理
  if (response.statusCode == 200) {
    final List<dynamic> subjects = jsonDecode(response.body);
    if (subjects.isEmpty) {
      print("該当する授業はありませんでした。");
    } else {
      print("該当する授業は以下の通りです：");
      for (var subject in subjects) {
        print(subject);
      }
    }
  } else {
    print("エラーが発生しました。ステータスコード: ${response.statusCode}");
  }
}
