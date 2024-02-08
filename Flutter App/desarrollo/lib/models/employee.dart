class Employee {
  final String name;
  final String uidUser;
  final int idUser;
  String position;
  final String imagepath;

  Employee({required this.name,required this.uidUser, required this.idUser, required this.position, required this.imagepath,});


  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      name: json['name'] as String,
      uidUser: json['uidUser'] as String,
      idUser: json['idUser'] as int,
      position: json['position'] as String,
      imagepath: json['imagepath'] as String,
    );
  }


  @override
  String toString() {
    return 'Employee{name: $name, uidUser: $uidUser, idUser: $idUser, position: $position, imagePath: $imagepath}';
  }
}