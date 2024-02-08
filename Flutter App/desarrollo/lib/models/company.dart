
class Company {
  int idCompany;
  String nameCompany;
  String nifCompany;
  String categoryCompany;
  String? photoCompany;
  String countryCompany;
  int employeesCompany;
  String adminCompany;
  String statusCompany;
  String uidAdminCompany;

  Company({required this.idCompany,required this.nameCompany, required this.nifCompany,
          required this.categoryCompany, this.photoCompany,
          required this.countryCompany, required this.employeesCompany,
          required this.adminCompany, required this.statusCompany,required this.uidAdminCompany});

          
  factory Company.fromJson(Map<String, dynamic> json) {
  return Company(
    idCompany: json['idCompany'] as int,
    nameCompany: json['nameCompany'] as String,
    nifCompany: json['nifCompany'] as String,
    categoryCompany: json['categoryCompany'] as String,
    photoCompany: json['photoCompany'] as String?, // Manejo de nulos
    countryCompany: json['countryCompany'] as String,
    employeesCompany: json['employeesCompany'] as int,
    adminCompany: json['adminCompany'] as String, 
    statusCompany: json['statusCompany'] as String,
    uidAdminCompany: json['uidAdminCompany'] as String,
  );
}


  @override
  String toString() {
    return 'Company{idCompany: $idCompany, nameCompany: $nameCompany, nifCompany: $nifCompany, categoryCompany: $categoryCompany, photoCompany: $photoCompany, countryCompany: $countryCompany, employeesCompany: $employeesCompany, adminCompany: $adminCompany, statusCompany: $statusCompany, uidAdminCompany: $uidAdminCompany}';
  }
}