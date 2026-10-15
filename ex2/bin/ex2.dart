abstract class Employee {
  String name;
  Employee(this.name);
  void work();
}

// TODO 1: Khai báo mixin CheckInAbility giới hạn cho Employee (dùng từ khóa "on")
mixin CheckInAbility on Employee {
  void checkIn() {
    print("$name đã điểm danh");
  }
}

// TODO 2: Tích hợp mixin CheckInAbility vào class Developer bằng từ khóa "with"
class Developer extends Employee with CheckInAbility {
  Developer(String name) : super(name);

  @override
  void work() => print("$name đang viết code.");
}

void main() {
  List<Developer> teamA = [Developer("An"), Developer("Bình")];
  List<Developer> teamB = [Developer("Cường")];

  // TODO 3: Dùng Spread Operator (...) để gộp teamA và teamB vào allStaff
  List<Developer> allStaff = [...teamA, ...teamB];

  // TODO 4: Dùng vòng lặp gọi hàm checkIn() cho tất cả nhân sự trong allStaff
  for (var dev in allStaff) {
    dev.checkIn();
  }
}