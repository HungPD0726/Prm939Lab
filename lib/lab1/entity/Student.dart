//Buoi 2
class Person{
  final String pid;
  final String pname;
  final int age;
  Person({required this.pid,required this.pname,this.age=0});
  Print()=>"Hello person";
}
//ke thua
class Student extends Person{
  final double gpa;
  Student({required super.id,required super.name,required super.age,this,gpa=0});
}
//generics
class Data<T>{
  final
}
//interfaces
class Student1 implements Person{
  @override final String id;
  @override final String name;
  @override final int age;
  Student1({required this.id,required this.name,this.age=0});
  @override
  Print() =>{"Hello Student"};
  //factory
 factory Student.fromJson(Map<String,dynamic>json){
  return Student(id: json['id'], name: json['name'], age: json['age'],gpa: json['gpa']);
}
}
void main(){
  //tap hop
  var base=[2,5,8,9,4];
  var x=[...base,for (var i in base){if(i%2==0)i},for(var i in base){if(i%2!=0)i}];
  print(x);

  Data<Student> data=Data(Student.fromJson) //generics
  Student student=Student.fromJson({"id":"sv01","name":"A","age":20,"gpa":3.5});
}

//Buoi 1 /{
class Student {
  final String id;
  final String name;
  final int age;
  Student({required this.id,this.name="",this.age=0});
  Student copyTo({String? id,String?name,int?age}){
    return Student(id: id?? this.id,name: name?? this.name,age: age??this.age);
  }
  static List<Student> students=[
    Student(id: "01",name: "A",age: 20),
    Student(id: "02",name: "B",age: 21),
    Student(id: "03",name: "C",age:10),
  ];
  List<Student> getAgerThan(int age){
    return students.where((x) => x.age > age).toList();
  }
  List<Student> addAge(int age){
    List<Student> ls=[];
    for(var x in students){
      var y=x.copyTo(age: x.age+age);
      ls.add(y);
    }
    return students.map((x)=>x.copyTo(age: x.age+age)).toList();
  }
}