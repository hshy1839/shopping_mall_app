import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; // 날짜 형식화
import 'package:shared_preferences/shared_preferences.dart';

class StatusController  extends  ChangeNotifier {

  String? attendanceStatus;
  String? checkInTime;
  String? checkOutTime;
  String? attendanceDate;
  bool isLoading = false; // 로딩 상태 추가

  // 출석 체크 함수
  Future<void> checkIn(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final currentDate = DateTime.now(); // 현재 날짜
    final formattedDate = DateFormat('yyyy-MM-dd').format(currentDate); // 날짜 포맷

    // 한국 시간으로 변환
    final koreaTime = currentDate.add(Duration(hours: 9)); // UTC+9: 한국 시간
    final formattedTime = DateFormat('HH:mm:ss').format(
        koreaTime); // 시간 포맷 (예: 14:30:00)

    // 출석 상태를 '출근 중'으로 설정
    final attendanceStatus = '출근 완료';

    // POST 요청을 보낼 URL
    final url = 'http://192.168.25.24:8864/api/users/checkIn';

    // 헤더 설정
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    // 요청 body
    final body = jsonEncode({
      'attendanceStatus': attendanceStatus,
      'date': formattedDate,
      'checkInTime': formattedTime,
      'checkOutTime': '출근 중',
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        // 출석 상태가 성공적으로 변경되었을 때
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('출석 체크가 완료되었습니다.')),

        );
      } else if (response.statusCode == 401) {
        // 서버에서 오류가 발생했을 때
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('인증되지 않은 사용자입니다.')),
        );
      } else if (response.statusCode == 400) {
        // 서버에서 오류가 발생했을 때
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('이미 출근 하셨습니다 !')),
        );
      } else if (response.statusCode == 500) {
        // 서버에서 오류가 발생했을 때
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('서버에 오류가 발생했습니다.')),
        );
      }
    } catch (e) {
      // 네트워크 오류 발생 시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('서버와 연결이 실패했습니다. 다시 시도해 주세요.')),
      );
    }
  }

  Future<void> checkOut(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final currentDate = DateTime.now(); // 현재 날짜
    final formattedDate = DateFormat('yyyy-MM-dd').format(currentDate); // 날짜 포맷

    // 한국 시간으로 변환
    final koreaTime = currentDate.add(Duration(hours: 9)); // UTC+9: 한국 시간
    final formattedTime = DateFormat('HH:mm:ss').format(
        koreaTime); // 시간 포맷 (예: 14:30:00)

    // 출석 상태를 '퇴근 중'으로 설정
    final attendanceStatus = '퇴근 완료';

    // PUT 요청을 보낼 URL
    final url = 'http://192.168.25.24:8864/api/users/checkOut';

    // 헤더 설정
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    // 요청 body
    final body = jsonEncode({
      'attendanceStatus': attendanceStatus,
      'date': formattedDate,
      'checkOutTime': formattedTime, // 퇴근 시간
    });

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        // 출석 상태가 성공적으로 업데이트되었을 때
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('퇴근 체크가 완료되었습니다.')),
        );
      } else if (response.statusCode == 404) {
        // 서버에서 오류가 발생했을 때
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('출근을 먼저 해주세요!')),
        );
      } else if (response.statusCode == 500) {
        // 서버에서 오류가 발생했을 때
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('서버에 오류가 발생했습니다.')),
        );
      } else if (response.statusCode == 400) {
        // 서버에서 오류가 발생했을 때
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('이미 퇴근하셨습니다 !')),
        );
      }
    } catch (e) {
      // 네트워크 오류 발생 시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('서버와 연결이 실패했습니다. 다시 시도해 주세요.')),
      );
    }
  }

  // 출결 정보 가져오기
  Future<void> getAttendanceInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final url = 'http://192.168.25.24:8864/api/users/attendanceInfo';
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    try {
      isLoading = true;
      notifyListeners();  // 상태 변경을 알림
      final response = await http.get(Uri.parse(url), headers: headers);
      final currentDate = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day).toIso8601String();
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        final Status = data.firstWhere(
              (status) => status['date']?.substring(0, 10) == currentDate.substring(0, 10),
          orElse: () => {},
        );


        if (Status.isNotEmpty) {
          attendanceStatus = Status['attendanceStatus'] ?? '출근 전';
          checkInTime = Status['checkInTime'] ?? '';
          checkOutTime = Status['checkOutTime'] ?? '';
          attendanceDate = Status['date'] ?? '';


          notifyListeners();  // 상태 변경을 알림
        } else if (Status.isEmpty){
          print('출석 정보 가져왔는데 비어있음');
        }
      } else {
        throw Exception('출근 상태를 가져오는데 실패했습니다.');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading = false;
      notifyListeners();  // 상태 변경을 알림
    }
  }
}

