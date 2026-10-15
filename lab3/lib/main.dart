import 'dart:async';
import 'dart:convert';

// ==========================================
// EXERCISE 1: Product Model & Repository
// ==========================================

class Product {
  final int id;
  final String name;
  final double price;

  Product({required this.id, required this.name, required this.price});

  @override
  String toString() => 'Product(id: $id, name: $name, price: \$$price)';
}

class ProductRepository {
  // Danh sách sản phẩm mẫu ban đầu
  final List<Product> _products = [
    Product(id: 1, name: 'Laptop', price: 1200.0),
    Product(id: 2, name: 'Mouse', price: 25.0),
  ];

  // Sử dụng broadcast StreamController để cho phép nhiều listener lắng nghe đồng thời
  final StreamController<Product> _productController =
  StreamController<Product>.broadcast();

  // Trả về danh sách sản phẩm qua Future (giả lập bất đồng bộ)
  Future<List<Product>> getAll() async {
    await Future.delayed(const Duration(milliseconds: 500)); // Giả lập độ trễ mạng
    return _products;
  }

  // Cung cấp Stream để nhận cập nhật sản phẩm thời gian thực
  Stream<Product> liveAdded() => _productController.stream;

  // Thêm sản phẩm mới và bắn sự kiện qua Stream
  void addProduct(Product product) {
    _products.add(product);
    _productController.add(product); // Phát sự kiện đến các listener
  }

  // Đóng controller khi không còn sử dụng để tránh rò rỉ bộ nhớ
  void dispose() {
    _productController.close();
  }
}

Future<void> runExercise1() async {
  print('--- EXERCISE 1: Product Model & Repository ---');
  final repo = ProductRepository();

  // Lắng nghe stream thời gian thực
  final subscription = repo.liveAdded().listen((product) {
    print('🔄 [Stream Event] Sản phẩm mới được thêm: $product');
  });

  // Lấy danh sách ban đầu qua Future
  print('Đang tải danh sách sản phẩm...');
  var initialProducts = await repo.getAll();
  print('Danh sách ban đầu: $initialProducts');

  // Thêm sản phẩm mới sau một khoảng trễ nhỏ để kiểm tra Stream
  await Future.delayed(const Duration(milliseconds: 300));
  repo.addProduct(Product(id: 3, name: 'Keyboard', price: 75.0));

  // Chờ một chút để stream kịp in kết quả trước khi chuyển bài
  await Future.delayed(const Duration(milliseconds: 300));
  await subscription.cancel();
  repo.dispose();
  print('\n');
}

// ==========================================
// EXERCISE 2: User Repository with JSON
// ==========================================

class User {
  final String name;
  final String email;

  User({required this.name, required this.email});

  // Factory constructor để khởi tạo đối tượng từ Map (JSON)
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
  // Giả lập dữ liệu trả về từ API dưới dạng chuỗi JSON
  final String _mockApiResponse = '''
  [
    {"name": "Nguyen Van Truong", "email": "nguyen@example.com"},
    {"name": "Tran Thi Loan", "email": "tran@example.com"},
    {"name": "Le Van Bang", "email": "le@example.com"}
  ]
  ''';

  // Giả lập việc fetch và parse JSON dữ liệu người dùng
  Future<List<User>> fetchUsers() async {
    await Future.delayed(const Duration(milliseconds: 500)); // Giả lập mạng

    // Giải mã chuỗi JSON thành List động
    List<dynamic> jsonList = jsonDecode(_mockApiResponse);

    // Chuyển đổi từng phần tử JSON thành đối tượng User
    return jsonList.map((jsonItem) => User.fromJson(jsonItem)).toList();
  }
}

Future<void> runExercise2() async {
  print('--- EXERCISE 2: User Repository with JSON ---');
  final userRepo = UserRepository();

  print('Đang gọi API lấy danh sách người dùng...');
  List<User> users = await userRepo.fetchUsers();

  print('Kết quả parse JSON thành công:');
  for (var user in users) {
    print('- $user');
  }
  print('\n');
}

// ==========================================
// EXERCISE 3: Async + Microtask Debugging
// ==========================================

void runExercise3() {
  print('--- EXERCISE 3: Async + Microtask Debugging ---');

  print('1. Synchronous: Bắt đầu chạy chương trình');

  // Đưa một tác vụ vào Event Queue
  Future(() {
    print('4. Event Queue: Future callback được chạy');
  });

  // Đưa một tác vụ vào Microtask Queue
  scheduleMicrotask(() {
    print('3. Microtask Queue: Microtask được chạy');
  });

  print('2. Synchronous: Kết thúc khối lệnh đồng bộ');

  // Giải thích:
  // - Các lệnh đồng bộ (1 và 2) luôn chạy trước tiên.
  // - Sau khi khối đồng bộ kết thúc, Event Loop ưu tiên chạy toàn bộ các tác vụ
  //   trong Microtask Queue trước khi chuyển sang Event Queue. Do đó microtask (3)
  //   luôn chạy trước Future callback (4).

  // Dùng delay nhỏ để đợi bất đồng bộ in ra hết trước khi sang bài tiếp theo
}

// ==========================================
// EXERCISE 4: Stream Transformation
// ==========================================

Future<void> runExercise4() async {
  print('--- EXERCISE 4: Stream Transformation ---');

  // 1. Tạo một stream chứa các số từ 1 đến 5
  Stream<int> numberStream = Stream.fromIterable([1, 2, 3, 4, 5]);

  print('Thực hiện biến đổi Stream (Bình phương và lọc số chẵn):');

  // 2 & 3. Dùng map() để bình phương, dùng where() để lọc lấy số chẵn
  await numberStream
      .map((number) => number * number) // Bình phương: 1, 4, 9, 16, 25
      .where((squared) => squared % 2 == 0) // Lọc số chẵn: 4, 16
      .forEach((result) {
    // 4. Lắng nghe và in ra từng giá trị thỏa mãn
    print('Giá trị hợp lệ từ Stream: $result');
  });

  print('\n');
}

// ==========================================
// EXERCISE 5: Factory Constructors & Cache
// ==========================================

class Settings {
  // Biến static lưu trữ instance duy nhất (Singleton)
  static final Settings _instance = Settings._internal();

  // Constructor riêng tư (private constructor) ngăn việc khởi tạo trực tiếp từ bên ngoài
  Settings._internal();

  // Factory constructor trả về instance đã được cache sẵn
  factory Settings() {
    return _instance;
  }

  // Thuộc tính ví dụ cho cấu hình ứng dụng
  String theme = "Dark Mode";
}

void runExercise5() {
  print('--- EXERCISE 5: Factory Constructors & Cache ---');

  // Khởi tạo 2 đối tượng Settings
  Settings s1 = Settings();
  Settings s2 = Settings();

  // Thay đổi thuộc tính qua s1
  s1.theme = "Light Mode";

  print('Cấu hình của s1: ${s1.theme}');
  print('Cấu hình của s2: ${s2.theme}'); // s2 cũng thay đổi vì chung một instance

  // Kiểm tra xem hai biến có trỏ cùng một vùng nhớ không
  bool areIdentical = identical(s1, s2);
  print('identical(s1, s2) -> $areIdentical');
  print('Xác nhận: Factory constructor đã hoạt động như một Singleton thành công!\n');
}

// ==========================================
// MAIN FUNCTION - RUN ALL LAB
// ==========================================

Future<void> main() async {
  print('========== RUN LAB 3 ==========');

  await runExercise1();
  await runExercise2();

  runExercise3();
  // Chờ một chút cho Exercise 3 in xong async/microtask
  await Future.delayed(const Duration(milliseconds: 100));
  print('\n');

  await runExercise4();
  runExercise5();

  print('========== HOÀN THÀNH TẤT CẢ BÀI TẬP ==========');
}