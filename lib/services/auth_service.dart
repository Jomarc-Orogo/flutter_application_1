import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService with ChangeNotifier {
  bool _isLoading = false;
  bool _isLoggedIn = false;
  String? _token;
  String? _userEmail;
  String? _userType;
  String? _username;
  String? _studentId;
  String? _teacherId;

  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  String? get token => _token;
  String? get userEmail => _userEmail;
  String? get userType => _userType;
  String? get username => _username;
  String? get studentId => _studentId;
  String? get teacherId => _teacherId;

  AuthService() {
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    _userEmail = prefs.getString('user_email');
    _userType = prefs.getString('user_type');
    _username = prefs.getString('username');
    _studentId = prefs.getString('student_id');
    _teacherId = prefs.getString('teacher_id');
    _isLoggedIn = _token != null;
    notifyListeners();
  }

  Future<bool> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        // DEMO: Special handling for test accounts
        if (email == 'teacher@example.com' && password == 'teacher123') {
          _token = 'demo_teacher_token';
          _userEmail = email;
          _username = 'Demo Teacher';
          _userType = 'teacher';
          _teacherId = 'T001';
          _isLoggedIn = true;
        } 
        else if (email == 'student@example.com' && password == 'student123') {
          _token = 'demo_student_token';
          _userEmail = email;
          _username = 'Demo Student';
          _userType = 'student';
          _studentId = '2023-00123';
          _isLoggedIn = true;
        }
        // For regular login
        else {
          final prefs = await SharedPreferences.getInstance();
          
          _token = 'demo_token_${DateTime.now().millisecondsSinceEpoch}';
          _userEmail = email;
          _username = email.split('@')[0];
          _isLoggedIn = true;
          
          // Try to get stored user type from registration
          final storedUserType = prefs.getString('user_type');
          final storedEmail = prefs.getString('user_email');
          
          if (storedEmail == email && storedUserType != null) {
            _userType = storedUserType;
            if (storedUserType == 'student') {
              _studentId = prefs.getString('student_id');
            } else if (storedUserType == 'teacher') {
              _teacherId = prefs.getString('teacher_id');
            }
          } else {
            _userType = email.contains('teacher') ? 'teacher' : 'student';
            if (_userType == 'student') {
              _studentId = '2023-00123';
            } else if (_userType == 'teacher') {
              _teacherId = 'T001';
            }
          }
        }

        if (rememberMe) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', _token!);
          await prefs.setString('user_email', _userEmail!);
          await prefs.setString('user_type', _userType!);
          await prefs.setString('username', _username!);
          
          if (_userType == 'student' && _studentId != null) {
            await prefs.setString('student_id', _studentId!);
          } else if (_userType == 'teacher' && _teacherId != null) {
            await prefs.setString('teacher_id', _teacherId!);
          }
        }

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        throw Exception('Invalid credentials');
      }
    } catch (e) {
      _isLoading = false;
      _isLoggedIn = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
    required String email,
    required String username,
    required String password,
    required String userType,
    String? studentId,
    String? teacherId,
  }) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    try {
      if (email.isNotEmpty && username.isNotEmpty && password.isNotEmpty) {
        _token = 'demo_token_${DateTime.now().millisecondsSinceEpoch}';
        _userEmail = email;
        _userType = userType;
        _username = username;
        _isLoggedIn = true;

        if (userType == 'student') {
          _studentId = studentId ?? '2023-00123';
        } else if (userType == 'teacher') {
          _teacherId = teacherId ?? 'T001';
        }

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', _token!);
        await prefs.setString('user_email', _userEmail!);
        await prefs.setString('user_type', _userType!);
        await prefs.setString('username', _username!);

        if (userType == 'student' && _studentId != null) {
          await prefs.setString('student_id', _studentId!);
        } else if (userType == 'teacher' && _teacherId != null) {
          await prefs.setString('teacher_id', _teacherId!);
        }

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        throw Exception('Registration failed');
      }
    } catch (e) {
      _isLoading = false;
      _isLoggedIn = false;
      notifyListeners();
      return false;
    }
  }

  static Future<Map<String, dynamic>> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'email': prefs.getString('user_email'),
      'userType': prefs.getString('user_type'),
      'username': prefs.getString('username'),
      'studentId': prefs.getString('student_id'),
      'teacherId': prefs.getString('teacher_id'),
    };
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user_email');
    await prefs.remove('user_type');
    await prefs.remove('username');
    await prefs.remove('student_id');
    await prefs.remove('teacher_id');

    _token = null;
    _userEmail = null;
    _userType = null;
    _username = null;
    _studentId = null;
    _teacherId = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}