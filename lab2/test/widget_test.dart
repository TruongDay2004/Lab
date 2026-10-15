import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
  // Chạy các bài tập Lab 3 và in kết quả ra Console
  runLab3Exercises();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 3 - Advanced Dart',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LabHomeScreen(),
    );
  }
}

class LabHomeScreen extends StatelessWidget {
  const LabHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 3 - Advanced Dart Practice'),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Đã chạy xong các bài tập Lab 3!\nVui lòng kiểm tra cửa sổ Console (Run) trong Android Studio để xem chi tiết kết quả.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// HỆ THỐNG THỰC THI 5 BÀI TẬP LAB 3
// ==========================================

Future<void> runLab3Exercises() async {
  print('========== BẮT ĐẦU CHẠY LAB 3 ==========\n');

  await _runExercise1();
  await _runExercise2();
  _runExercise3();

  await Future.delayed(const Duration(milliseconds: 100));
  await _runExercise4();
  _runExercise5();

  print('========== HOÀN THÀNH TẤT CẢ BÀI TẬP ==========');
}

// --- EXERCISE 1: Product Model & Repository ---
class Product {
  final int id;
  final String name;
  final double price;

  Product({required this.id, required this.name, required this.price});

  @override
  String toString() => 'Product(id: $id, name: $name, price: \$$price)';
}

class ProductRepository {
  final List<Product> _products = [
    Product(id: 1, name: 'Laptop', price: 1200.0),
    Product(id: 2, name: 'Mouse', price: 25.0),
  ];

  final StreamController<Product> _productController =
  StreamController<Product>.broadcast();

  Future<List<Product>> getAll() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _products;
  }

  Stream<Product> liveAdded() => _productController.stream;

  void addProduct(Product product) {
    _products.add(product);
    _productController.add(product);
  }

  void dispose() {
    _productController.close();
  }
}

Future<void> _runExercise1() async {
  print('--- EXERCISE 1: Product Model & Repository ---');
  final repo = ProductRepository();

  final subscription = repo.liveAdded().listen((product) {
    print('🔄 [Stream Event] Sản phẩm mới: $product');
  });

  var initialProducts = await repo.getAll();
  print('Danh sách ban đầu: $initialProducts');

  await Future.delayed(const Duration(milliseconds: 200));
  repo.addProduct(Product(id: 3, name: 'Keyboard', price: 75.0));

  await Future.delayed(const Duration(milliseconds: 200));
  await subscription.cancel();
  repo.dispose();
  print('\n');
}

// --- EXERCISE 2: User Repository with JSON ---
class User {
  final String name;
  final String email;

  User({required this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }

  @override
  String toString() => 'User(name: $name, email: $email)';
}

class UserRepository {
  final String _mockApiResponse = '''
  [
    {"name": "Nguyen Van A", "email": "a.nguyen@example.com"},
    {"name": "Tran Thi B", "email": "b.tran@example.com"}
  ]
  ''';

  Future<List<User>> fetchUsers() async {
    await Future.delayed(const Duration(milliseconds: 300));
    List<dynamic> jsonList = jsonDecode(_mockApiResponse);
    return jsonList.map((item) => User.fromJson(item)).toList();
  }
}

Future<void> _runExercise2() async {
  print('--- EXERCISE 2: User Repository with JSON ---');
  final userRepo = UserRepository();
  List<User> users = await userRepo.fetchUsers();

  print('Kết quả parse JSON thành công:');
  for (var user in users) {
    print('- $user');
  }
  print('\n');
}

// --- EXERCISE 3: Async + Microtask Debugging ---
void _runExercise3() {
  print('--- EXERCISE 3: Async + Microtask Debugging ---');
  print('1. Synchronous: Bắt đầu');

  Future(() {
    print('4. Event Queue: Future callback chạy');
  });

  scheduleMicrotask(() {
    print('3. Microtask Queue: Microtask chạy');
  });

  print('2. Synchronous: Kết thúc');
  print('Giải thích: Microtask luôn chạy trước Event Queue sau các lệnh đồng bộ.\n');
}

// --- EXERCISE 4: Stream Transformation ---
Future<void> _runExercise4() async {
  print('--- EXERCISE 4: Stream Transformation ---');
  Stream<int> numberStream = Stream.fromIterable([1, 2, 3, 4, 5]);

  print('Kết quả sau khi map() bình phương và where() lọc số chẵn:');
  await numberStream
      .map((n) => n * n)
      .where((squared) => squared % 2 == 0)
      .forEach((result) {
    print('Giá trị hợp lệ: $result');
  });
  print('\n');
}

// --- EXERCISE 5: Factory Constructors & Cache ---
class Settings {
  static final Settings _instance = Settings._internal();
  Settings._internal();

  factory Settings() => _instance;

  String theme = "Dark Mode";
}

void _runExercise5() {
  print('--- EXERCISE 5: Factory Constructors & Cache ---');
  Settings s1 = Settings();
  Settings s2 = Settings();

  s1.theme = "Light Mode";
  print('s1.theme: ${s1.theme}');
  print('s2.theme: ${s2.theme}');

  bool areIdentical = identical(s1, s2);
  print('identical(s1, s2) -> $areIdentical');
  print('Xác nhận: Factory constructor hoạt động như Singleton thành công!\n');
}