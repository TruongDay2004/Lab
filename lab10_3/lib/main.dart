// main.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Lab 10.3 Auto Login',
      home: SplashScreen(),
    );
  }
}

// --- 1. Màn hình Splash (Kiểm tra đăng nhập) ---
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  Future<void> _checkToken() async {
    // Khởi tạo SharedPreferences để đọc dữ liệu đã lưu
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    // Giả lập thời gian chờ của Splash Screen
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Nếu token tồn tại và không rỗng -> Vào thẳng Home, ngược lại -> Login
    if (token != null && token.isNotEmpty) {
      final name = prefs.getString('user_name') ?? 'User';
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen(name: name))
      );
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Đang kiểm tra phiên đăng nhập...'),
          ],
        ),
      ),
    );
  }
}

// --- 2. Màn hình Đăng nhập ---
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userCtrl = TextEditingController(text: 'emilys');
  final _passCtrl = TextEditingController(text: 'emilyspass');
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() => _isLoading = true);
    try {
      final res = await http.post(
        Uri.parse('https://dummyjson.com/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': _userCtrl.text, 'password': _passCtrl.text}),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final token = data['token'] ?? data['accessToken'] ?? '';
        final name = data['firstName'] ?? 'User';

        // LƯU TOKEN VÀ TÊN VÀO SHAREDPREFERENCES
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        await prefs.setString('user_name', name);

        if (!mounted) return;
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => HomeScreen(name: name))
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đăng nhập thất bại!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login & Save Session')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(controller: _userCtrl, decoration: const InputDecoration(labelText: 'Username')),
            TextField(controller: _passCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'Password')),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(onPressed: _login, child: const Text('Đăng nhập')),
          ],
        ),
      ),
    );
  }
}

// --- 3. Màn hình Home (Có chức năng Đăng xuất) ---
class HomeScreen extends StatelessWidget {
  final String name;
  const HomeScreen({super.key, required this.name});

  Future<void> _logout(BuildContext context) async {
    // XÓA TOKEN KHỎI SHAREDPREFERENCES ĐỂ ĐĂNG XUẤT
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_name');

    if (!context.mounted) return;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Chào mừng, $name!', style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              onPressed: () => _logout(context),
              child: const Text('Đăng xuất', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}