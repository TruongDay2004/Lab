// main.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: ApiLoginScreen());
  }
}

class ApiLoginScreen extends StatefulWidget {
  const ApiLoginScreen({super.key});

  @override
  State<ApiLoginScreen> createState() => _ApiLoginScreenState();
}

class _ApiLoginScreenState extends State<ApiLoginScreen> {
  final _usernameController = TextEditingController(text: 'emilys');
  final _passwordController = TextEditingController(text: 'emilyspass');
  bool _isLoading = false;

  Future<void> _loginWithApi() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.post(
        Uri.parse('https://dummyjson.com/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': _usernameController.text,
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Khắc phục lỗi Null bằng cách kiểm tra key trả về hoặc gán giá trị mặc định
        final token = data['token'] ?? data['accessToken'] ?? 'Không tìm thấy Token';
        final name = data['firstName'] ?? 'User';

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomeScreen(token: token.toString(), name: name.toString()),
          ),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đăng nhập thất bại. Kiểm tra lại thông tin!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi kết nối: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DummyJSON API Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username')
            ),
            TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password')
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                onPressed: _loginWithApi,
                child: const Text('Login với Real API')
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final String token;
  final String name;
  const HomeScreen({super.key, required this.token, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Chào mừng, $name!', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            SelectableText('Token: $token'),
          ],
        ),
      ),
    );
  }
}