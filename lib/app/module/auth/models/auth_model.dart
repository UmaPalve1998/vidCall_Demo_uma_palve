class LoginResponse {
  final String? access_token;
  final String? message;
  final String? statusCode;


  LoginResponse({
    this.access_token,
    this.message,
    this.statusCode,

  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      access_token: json['access_token'],
      message: json['message'],
      statusCode: json['statusCode'],

    );
  }
}

class LoginDetails {
  LoginDetails({
    required this.id,
    required this.lastLogin,
    required this.createdOn,
    required this.clientId,
    required this.companyId,
    required this.employee,
    required this.userName,
    required this.empId,
    required this.role,
  });

  final dynamic? id;
  final dynamic lastLogin;
  final DateTime? createdOn;
  final dynamic? clientId;
  final dynamic? companyId;
  final String? empId;
  final Emp? employee;
  final String? userName;
  final String? role;

  factory LoginDetails.fromJson(Map<String, dynamic> json){
    return LoginDetails(
      id: json["id"],
      lastLogin: json["lastLogin"],
      createdOn: DateTime.tryParse(json["createdOn"] ?? ""),
      clientId: json["clientId"],
      companyId: json["companyId"],
      employee: json["employee"] == null ? null : Emp.fromJson(json["employee"]),
      userName: json["userName"],
      role: json["Role"],
      empId: json['empId'],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "lastLogin": lastLogin,
    "createdOn": createdOn?.toIso8601String(),
    "clientId": clientId,
    "companyId": companyId,
    "employee": employee?.toJson(),
    "userName": userName,
    "Role": role,
    'empId': empId,
  };

}

class Emp {
  Emp({
    required this.id,
    required this.active,
    required this.createdOn,
    required this.modifiedOn,
    required this.company,
    required this.empId,
    required this.gender,
    required this.dateOfJoining,
    required this.dateOfLeaving,
    required this.dateOfBirth,
    required this.email,
    required this.reportingManager,
    required this.role,
    required this.empType,
    required this.designation,
    required this.sitePostedTo,
    required this.name,
    required this.phoneNumber,
    required this.companyName,
  });

  final dynamic? id;
  final dynamic? active;
  final String? createdOn;
  final dynamic modifiedOn;
  final Company? company;
  final String? empId;
  final String? gender;
  final String? dateOfJoining;
  final dynamic dateOfLeaving;
  final String? dateOfBirth;
  final String? email;
  final String? reportingManager;
  final String? role;
  final Designation? empType;
  final Designation? designation;
  final SitePostedTo? sitePostedTo;
  final String? name;
  final String? phoneNumber;
  final String? companyName;

  factory Emp.fromJson(Map<String, dynamic> json){
    return Emp(
      id: json["id"],
      active: json["active"],
      createdOn: json["createdOn"] ,
      modifiedOn: json["modifiedOn"],
      company: json["company"] == null ? null : Company.fromJson(json["company"]),
      empId: json["empId"],
      gender: json["gender"],
      dateOfJoining: json["dateOfJoining"] ,
      dateOfLeaving: json["dateOfLeaving"],
      dateOfBirth: json["dateOfBirth"] ,
      email: json["email"],
      reportingManager: json["reportingManager"],
      role: json["role"],
      empType: json["empType"] == null ? null : Designation.fromJson(json["empType"]),
      designation: json["designation"] == null ? null : Designation.fromJson(json["designation"]),
      sitePostedTo: json["sitePostedTo"] == null ? null : SitePostedTo.fromJson(json["sitePostedTo"]),
      name: json["name"],
      phoneNumber: json["phoneNumber"],
      companyName: json["companyName"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "active": active,
    "createdOn": createdOn,
    "modifiedOn": modifiedOn,
    "company": company?.toJson(),
    "empId": empId,
    "gender": gender,
    "dateOfJoining": dateOfJoining,
    "dateOfLeaving": dateOfLeaving,
    "dateOfBirth": dateOfBirth,
    "email": email,
    "reportingManager": reportingManager,
    "role": role,
    "empType": empType?.toJson(),
    "designation": designation?.toJson(),
    "sitePostedTo": sitePostedTo?.toJson(),
    "name": name,
    "phoneNumber": phoneNumber,
    "companyName": companyName,
  };

}


class Company {
  Company({
    required this.id,
    required this.createdBy,
    required this.createdOn,
    required this.modifiedOn,
    required this.prefix,
    required this.name,
    required this.phoneNumber,
  });

  final dynamic? id;
  final String? createdBy;
  final String? createdOn;
  final String? modifiedOn;
  final String? prefix;
  final String? name;
  final String? phoneNumber;

  factory Company.fromJson(Map<String, dynamic> json){
    return Company(
      id: json["id"],
      createdBy: json["createdBy"],
      createdOn: json["createdOn"] ,
      modifiedOn: json["modifiedOn"] ,
      prefix: json["prefix"],
      name: json["name"],
      phoneNumber: json["phoneNumber"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "createdBy": createdBy,
    "createdOn": createdOn,
    "modifiedOn": modifiedOn,
    "prefix": prefix,
    "name": name,
    "phoneNumber": phoneNumber,
  };

}

class Designation {
  Designation({
    required this.id,
    required this.name,
    required this.companyId,
    required this.companyName,
    required this.empType,
  });

  final dynamic? id;
  final String? name;
  final dynamic? companyId;
  final String? companyName;
  final String? empType;

  factory Designation.fromJson(Map<String, dynamic> json){
    return Designation(
      id: json["id"],
      name: json["name"],
      companyId: json["companyId"],
      companyName: json["companyName"],
      empType: json["empType"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "companyId": companyId,
    "companyName": companyName,
    "empType": empType,
  };

}

class SitePostedTo {
  SitePostedTo({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.active,
    required this.createdOn,
    required this.modifiedOn,
    required this.siteEmail,
    required this.siteAddress,
    required this.contactPersonName,
    required this.contactPersonNumber,
    required this.noOfGuards,
    required this.clientId,
    required this.name,
    required this.siteInchargeId,
    required this.companyId,
    required this.siteInchargeEmpId,
    required this.siteInchargeName,
    required this.companyName,
  });

  final dynamic? id;
  final dynamic? latitude;
  final dynamic? longitude;
  final dynamic? active;
  final String? createdOn;
  final String? modifiedOn;
  final dynamic siteEmail;
  final dynamic siteAddress;
  final dynamic contactPersonName;
  final dynamic contactPersonNumber;
  final dynamic? noOfGuards;
  final String? clientId;
  final String? name;
  final dynamic? siteInchargeId;
  final dynamic companyId;
  final String? siteInchargeEmpId;
  final String? siteInchargeName;
  final dynamic companyName;

  factory SitePostedTo.fromJson(Map<String, dynamic> json){
    return SitePostedTo(
      id: json["id"],
      latitude: json["latitude"],
      longitude: json["longitude"],
      active: json["active"],
      createdOn: json["createdOn"] ,
      modifiedOn: json["modifiedOn"] ,
      siteEmail: json["siteEmail"],
      siteAddress: json["siteAddress"],
      contactPersonName: json["contactPersonName"],
      contactPersonNumber: json["contactPersonNumber"],
      noOfGuards: json["noOfGuards"],
      clientId: json["clientId"],
      name: json["name"],
      siteInchargeId: json["siteInchargeId"],
      companyId: json["companyId"],
      siteInchargeEmpId: json["siteInchargeEmpId"],
      siteInchargeName: json["siteInchargeName"],
      companyName: json["companyName"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "latitude": latitude,
    "longitude": longitude,
    "active": active,
    "createdOn": createdOn,
    "modifiedOn": modifiedOn,
    "siteEmail": siteEmail,
    "siteAddress": siteAddress,
    "contactPersonName": contactPersonName,
    "contactPersonNumber": contactPersonNumber,
    "noOfGuards": noOfGuards,
    "clientId": clientId,
    "name": name,
    "siteInchargeId": siteInchargeId,
    "companyId": companyId,
    "siteInchargeEmpId": siteInchargeEmpId,
    "siteInchargeName": siteInchargeName,
    "companyName": companyName,
  };

}

