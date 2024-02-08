class DataReport {
  final int idCompany;
  final int idReport;
  final DateTime dateReport;
  final bool isAnnualReport;
  final bool includesDetail;
  final String typeReport;
  final String urlReport;

  DataReport({
    required this.idCompany,
    required this.idReport,
    required this.dateReport,
    this.isAnnualReport = false,
    this.includesDetail = false,
    required this.typeReport,
    required this.urlReport,
  });

    factory DataReport.fromJson(Map<String, dynamic> json) {
      return DataReport(
        idCompany: json['idCompany'] as int,
        idReport: json['idReport'] as int,
        dateReport: DateTime.parse(json['dateReport']),
        isAnnualReport: (json['annualReport'] as String).toUpperCase() == 'S',
        includesDetail: (json['detailReport'] as String).toUpperCase() == 'S',
        typeReport: json['typeReport'] as String,
        urlReport: json['urlReport'] as String,
      );
    }




  @override
  String toString() {
    return 'DataReport{idCompany: $idCompany, idReport: $idReport, dateReport: $dateReport, isAnnualReport: $isAnnualReport, includesDetail: $includesDetail, typeReport: $typeReport, urlReport: $urlReport}';
  }
}
