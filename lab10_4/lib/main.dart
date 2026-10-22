// main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 10.4 Firebase Google Sign-In',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const GoogleSignInScreen(),
    );
  }
}

class GoogleSignInScreen extends StatefulWidget {
  const GoogleSignInScreen({super.key});

  @override
  State<GoogleSignInScreen> createState() => _GoogleSignInScreenState();
}

class _GoogleSignInScreenState extends State<GoogleSignInScreen> {
  User? _user;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Kiểm tra xem người dùng đã đăng nhập Firebase từ trước chưa
    _user = FirebaseAuth.instance.currentUser;
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      // 1. Kích hoạt luồng đăng nhập Google
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        setState(() => _isLoading = false);
        return; // Người dùng hủy đăng nhập
      }

      // 2. Lấy thông tin xác thực (tokens)
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // 3. Tạo credential cho Firebase
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4. Đăng nhập vào Firebase bằng credential
      final UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

      setState(() {
        _user = userCredential.user;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi đăng nhập Google: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _signOut() async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
    setState(() {
      _user = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firebase Google Sign-In')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _isLoading
              ? const CircularProgressIndicator()
              : _user == null
              ? ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            onPressed: _signInWithGoogle,
            icon: const Icon(Icons.login),
            label: const Text('Đăng nhập bằng Google', style: TextStyle(fontSize: 16)),
          )
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_user!.photoURL != null)
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(_user!.photoURL!),
                ),
              const SizedBox(height: 16),
              Text(
                'Xin chào, ${_user!.displayName ?? "User"}!',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Email: ${_user!.email ?? "N/A"}'),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                onPressed: _signOut,
                child: const Text('Đăng xuất', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}