// ignore_for_file: non_constant_identifier_names, strict_top_level_inference
// ignore_for_file: avoid_print, unused_local_variable

class Person {
  final String id;
  final String name;
  final int age;
  Person({required this.id, required this.name, this.age = 0});
  Print() => "Hello Person";
}

class Teacher extends Person {
  final String subject;
  Teacher({
    required super.id,
    required super.name,
    required super.age,
    required this.subject,
  });
  @override
  Print() => "Hello Teacher";
  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      subject: json['subject'],
    );
  }
}

class Data<T> {
  final T value;
  Data(this.value);
}

class Student extends Person {
  final double gpa;
  Student({
    required super.id,
    required super.name,
    required super.age,
    this.gpa = 0,
  });
  @override
  Print() => "Hello Student";
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      gpa: json['gpa'],
    );
  }
}

void main() {
  var base = [2, 5, 8, 9, 4];
  var x = [
    ...base,
    for (var i in base) {if (i % 2 == 0) i},
    for (var i in base) {if (i % 2 != 0) i},
  ];
  print(x);

  Data<Student> data = Data(
    Student.fromJson({
      "id": "sv01",
      "name": "Nguyen Van A",
      "age": 20,
      "gpa": 3.5,
    }),
  );
  Teacher teacher = Teacher.fromJson({
    "id": "gv01",
    "name": "Tran Thi B",
    "age": 30,
    "subject": "Toan cao cap",
  });
  Student student = Student.fromJson({
    "id": "sv01",
    "name": "Nguyen Van A",
    "age": 20,
    "gpa": 3.5,
  });
}

class Student1 implements Person {
  @override
  final String id;
  @override
  final String name;
  @override
  final int age;
  Student1({required this.id, required this.name, this.age = 0});
  @override
  Print() => "Hello Student";
}
