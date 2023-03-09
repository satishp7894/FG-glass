
class SalesPersonList {
  SalesPersonList({
    required this.salesPersonList,
  });
  List<SalesPerson> salesPersonList;


  factory SalesPersonList.fromJson(Map<String, dynamic> json) => SalesPersonList(
      salesPersonList: List<SalesPerson>.from(json["SalesPerson"].map((x) => SalesPerson.fromJson(x)))
  );

  Map<String, dynamic> toJson() => {
    "SalesPerson": List<dynamic>.from(salesPersonList.map((x) => x.toJson()))
  };
}

class SalesPerson {
  SalesPerson({
     this.salesPersonID,
     this.salesPersonName,
    this.emailID,
    this.totalCount,
    this.openCount,
    this.closeCount,
    this.tlID,
    this.cancelledCount,
    this.closedPIPercent,
    this.openPIPercent,
    this.salesAchievedPercent,
    this.cancelledPIPercent,
    this.salesTarget,
    this.salesAmount,
  });

  int? salesPersonID;
  String? salesPersonName;
  String? emailID;
  int? totalCount;
  int? openCount;
  int? closeCount;
  int? tlID;
  int? cancelledCount;
  double? closedPIPercent;
  double? openPIPercent;
  double? salesAchievedPercent;
  double? cancelledPIPercent;
  String? salesTarget;
  String? salesAmount;


  factory SalesPerson.fromJson(Map<String, dynamic> json) => SalesPerson(
    salesPersonID: json["SalesPersonID"],
    salesPersonName: json["SalesPersonName"],
    emailID: json["EmailID"],
    totalCount: json["TotalCount"],
    openCount: json["OpenCount"],
    closeCount: json["CloseCount"],
    tlID: json["TL_ID"],
    cancelledCount: json["CancelledCount"],
    closedPIPercent: json["ClosedPIPercent"],
    openPIPercent: json["OpenPIPercent"],
    salesAchievedPercent: json["SalesAchievedPercent"],
    cancelledPIPercent: json["CancelledPIPercent"],
    salesTarget: json["SalesTarget"],
    salesAmount: json["SalesAmount"],
  );

  Map<String, dynamic> toJson() => {
    "SalesPersonID": salesPersonID,
    "SalesPersonName": salesPersonName,
    "EmailID": emailID,
    "TotalCount": totalCount,
    "OpenCount": openCount,
    "CloseCount": closeCount,
    "TL_ID": tlID,
    "CancelledCount": cancelledCount,
    "ClosedPIPercent": closedPIPercent,
    "OpenPIPercent": openPIPercent,
    "SalesAchievedPercent": salesAchievedPercent,
    "CancelledPIPercent": cancelledPIPercent,
    "SalesTarget": salesTarget,
    "SalesAmount": salesAmount,

  };
}


