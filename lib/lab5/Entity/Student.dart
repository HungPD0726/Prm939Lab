// Entity/Student.dart
// Model (Entity) mô tả sinh viên. Viết theo đúng kiểu Product:
// có fromJson/toJson/copyWith và một danh sách dữ liệu cứng.

class Student {
  final String id; // mã sinh viên
  final String name; // họ tên
  final String className; // lớp
  final String email;

  Student({
    required this.id,
    required this.name,
    required this.className,
    required this.email,
  });

  // Tạo Student từ Map JSON.
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      name: json['name'],
      className: json['className'],
      email: json['email'],
    );
  }

  // Chuyển Student thành Map JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'className': className,
      'email': email,
    };
  }

  @override
  String toString() {
    return 'Student{id: $id, name: $name, className: $className, email: $email}';
  }

  // Tạo bản sao có chỉnh sửa.
  Student copyWith({
    String? id,
    String? name,
    String? className,
    String? email,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      className: className ?? this.className,
      email: email ?? this.email,
    );
  }

  static List<Student> students = [
    Student(
      id: "SE187004",
      name: "Pham Duy Hung",
      className: "SE1923",
      email: "hungpdhe187004@fpt.edu.vn",
    ),
    Student(
      id: "SE181234",
      name: "Hoang Van B",
      className: "SE1923",
      email: "bhvse181234@fpt.edu.vn",
    ),
    Student(
      id: "SE180001",
      name: "Nguyen Van A",
      className: "SE1924",
      email: "anvse180001@fpt.edu.vn",
    ),
  ];
}