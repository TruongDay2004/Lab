// ==========================================
// LAB 2 – DART ESSENTIALS PRACTICE LAB
// ==========================================

void main() async {
  print('=== EXERCISE 1: Basic Syntax & Data Types ===');
  exercise1();

  print('\n=== EXERCISE 2: Collections & Operators ===');
  exercise2();

  print('\n=== EXERCISE 3: Control Flow & Functions ===');
  exercise3();

  print('\n=== EXERCISE 4: Intro to OOP ===');
  exercise4();

  print('\n=== EXERCISE 5: Async, Future, Null Safety & Streams ===');
  await exercise5();
}

// ------------------------------------------
// EXERCISE 1: Basic Syntax & Data Types
// ------------------------------------------
void exercise1() {
  int age = 21;
  double gpa = 3.65;
  String name = 'Nguyen Van Truong';
  bool isStudent = true;

  print('Họ và tên: $name');
  print('Tuổi: $age, Điểm GPA: $gpa');
  print('Là sinh viên: $isStudent');
  print('Biểu thức trong string: Năm sau tôi sẽ ${age + 1} tuổi.');
}

// ------------------------------------------
// EXERCISE 2: Collections & OperatorsS
// ------------------------------------------
void exercise2() {
  List<int> numbers = [10, 20, 30, 40];
  numbers.add(50);
  print('List ban đầu: $numbers');
  print('Phần tử tại index 1: ${numbers[1]}');

  // Đã sửa lỗi trùng lặp phần tử trong Set
  Set<String> uniqueColors = {'Red', 'Green', 'Blue', 'Yellow'};
  print('Set (loại bỏ trùng lặp): $uniqueColors');

  Map<String, dynamic> studentInfo = {
    'name': 'Bình',
    'score': 8.5,
    'passed': true,
  };
  print('Map thông tin: $studentInfo');
  print('Tên sinh viên từ Map: ${studentInfo['name']}');

  int a = 10;
  int b = 5;
  bool comparison = (a > b) && (b != 0);
  String resultText = (a > b) ? 'a lớn hơn b' : 'a nhỏ hơn hoặc bằng b';

  print('Kết quả phép toán so sánh: $comparison');
  print('Kết quả toán tử 3 ngôi: $resultText');
}

// ------------------------------------------
// EXERCISE 3: Control Flow & Functions
// ------------------------------------------
void exercise3() {
  double score = 8.2;
  if (score >= 8.0) {
    print('Xếp loại: Giỏi (Score: $score)');
  } else if (score >= 6.5) {
    print('Xếp loại: Khá (Score: $score)');
  } else {
    print('Xếp loại: Trung bình/Yếu (Score: $score)');
  }

  String day = 'Monday';
  switch (day) {
    case 'Monday':
      print('Đầu tuần làm việc hiệu quả!');
      break;
    case 'Friday':
      print('Cuối tuần sắp đến rồi!');
      break;
    default:
      print('Một ngày bình thường trong tuần.');
  }

  List<String> subjects = ['Dart', 'Java', 'SQL'];

  print('Dùng vòng lặp for truyền thống:');
  for (int i = 0; i < subjects.length; i++) {
    print('- ${subjects[i]}');
  }

  print('Dùng vòng lặp for-in:');
  for (var sub in subjects) {
    print('- $sub');
  }

  print('Dùng hàm forEach():');
  subjects.forEach((sub) => print('- $sub'));

  print('Tổng bình thường: ${addNumbers(5, 10)}');
  print('Nhân bằng arrow function: ${multiplyNumbers(4, 5)}');
}

int addNumbers(int x, int y) {
  return x + y;
}

int multiplyNumbers(int x, int y) => x * y;

// ------------------------------------------
// EXERCISE 4: Intro to OOP
// ------------------------------------------
class Car {
  String brand;

  Car(this.brand);

  Car.unknown() : brand = 'Unknown Brand';

  void drive() {
    print('Xe hãng $brand đang chạy trên đường.');
  }
}

class ElectricCar extends Car {
  int batteryCapacity; // kWh

  ElectricCar(String brand, this.batteryCapacity) : super(brand);

  // Đã sửa lỗi chính tả từ @Override thành @override (chữ o thường)
  @override
  void drive() {
    print('Xe điện hãng $brand đang chạy cực kỳ êm ái với dung lượng pin ${batteryCapacity}kWh!');
  }
}

void exercise4() {
  Car car1 = Car('Toyota');
  Car car2 = Car.unknown();

  car1.drive();
  car2.drive();

  ElectricCar tesla = ElectricCar('Tesla', 75);
  tesla.drive();
}

// ------------------------------------------
// EXERCISE 5: Async, Future, Null Safety & Streams
// ------------------------------------------
Future<String> loadDataFromServer() async {
  print('Đang tải dữ liệu từ server...');
  await Future.delayed(Duration(seconds: 2));
  return 'Tải dữ liệu thành công!';
}

// Đã sửa kiểu trả về của exercise5 thành Future<void> để dùng được với await trong main()
Future<void> exercise5() async {
  String response = await loadDataFromServer();
  print(response);

  String? nullableName;

  String displayName = nullableName ?? 'Khách vãng lai (Guest)';
  print('Tên hiển thị: $displayName');

  nullableName = 'Hoàng Nam';
  print('Độ dài tên: ${nullableName.length}');

  print('Bắt đầu lắng nghe Stream...');
  Stream<int> numberStream = Stream.periodic(Duration(seconds: 1), (count) => count + 1).take(3);

  await for (int number in numberStream) {
    print('Stream nhận được giá trị: $number');
  }
  print('Hoàn thành Stream!');
}