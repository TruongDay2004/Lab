// 1. Định nghĩa lớp cơ sở (Superclass) Phương tiện giao thông
class PhuongTien {
  String hangSanXuat;
  String tenModel;
  int namSanXuat;

  // Constructor
  PhuongTien(this.hangSanXuat, this.tenModel, this.namSanXuat);

  // Phương thức hiển thị thông tin chung
  void hienThiThongTin() {
    print('Hãng: $hangSanXuat | Model: $tenModel | Năm SX: $namSanXuat');
  }

  // Phương thức hành động chung (viết liền không dấu cách)
  void diChuyen() {
    print('$tenModel đang di chuyển trên đường...');
  }
}

// 2. Định nghĩa lớp con (Subclass) Ô tô kế thừa từ PhuongTien
class Oto extends PhuongTien {
  int soChoNgoi;
  String loaiNhienLieu;

  // Constructor sử dụng từ khóa super để gọi constructor của lớp cha
  Oto(String hangSanXuat, String tenModel, int namSanXuat, this.soChoNgoi, this.loaiNhienLieu)
      : super(hangSanXuat, tenModel, namSanXuat);

  // Ghi đè phương thức (Override) để hiển thị chi tiết hơn cho Ô tô
  @override
  void hienThiThongTin() {
    super.hienThiThongTin();
    print('-> Số chỗ ngồi: $soChoNgoi | Nhiên liệu: $loaiNhienLieu');
  }
}

// 3. Định nghĩa lớp con Xe máy kế thừa từ PhuongTien
class XeMay extends PhuongTien {
  double dungTichXiLanh;

  XeMay(String hangSanXuat, String tenModel, int namSanXuat, this.dungTichXiLanh)
      : super(hangSanXuat, tenModel, namSanXuat);

  @override
  void hienThiThongTin() {
    super.hienThiThongTin();
    print('-> Dung tích xi-lanh: ${dungTichXiLanh}cc');
  }
}

// 4. Hàm main để chạy chương trình quản lý phương tiện
void main() {
  print('=== QUẢN LÝ PHƯƠNG TIỆN GIAO THÔNG ===\n');

  // Khởi tạo đối tượng Ô tô
  Oto oto1 = Oto('Toyota', 'Camry', 2023, 5, 'Xăng');
  print('Thông tin Ô tô:');
  oto1.hienThiThongTin();
  oto1.diChuyen();

  print('-' * 40);

  // Khởi tạo đối tượng Xe máy
  XeMay xemay1 = XeMay('Honda', 'SH 150i', 2024, 150.0);
  print('Thông tin Xe máy:');
  xemay1.hienThiThongTin();
  xemay1.diChuyen();
}