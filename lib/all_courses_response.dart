import 'dart:convert';

import 'package:equatable/equatable.dart';

AllCoursesResponse allCoursesResponseFromMap(String str) =>
    AllCoursesResponse.fromMap(json.decode(str));

String allCoursesResponseToMap(AllCoursesResponse data) =>
    json.encode(data.toMap());

class AllCoursesResponse {
  AllCoursesResponse({
    this.coursesData,
    this.result,
  });

  final AllCoursesData? coursesData;
  final AllCoursesResult? result;

  factory AllCoursesResponse.fromMap(Map<String, dynamic> json) =>
      AllCoursesResponse(
        coursesData:
            json["data"] == null ? null : AllCoursesData.fromMap(json["data"]),
        result: json["result"] == null
            ? null
            : AllCoursesResult.fromMap(json["result"]),
      );

  Map<String, dynamic> toMap() => {
        "data": coursesData?.toMap(),
        "result": result?.toMap(),
      };
}

class AllCoursesData {
  AllCoursesData({this.en, this.bn});

  final List<AllCoursesDatum>? en, bn;

  factory AllCoursesData.fromMap(Map<String, dynamic> json) => AllCoursesData(
        en: json["coursesData"]["en"] != null
            ? List<AllCoursesDatum>.from(json["coursesData"]["en"]
                .map((x) => AllCoursesDatum.fromMap(x)))
            : null,
        bn: json["coursesData"]["bn"] != null
            ? List<AllCoursesDatum>.from(json["coursesData"]["bn"]
                .map((x) => AllCoursesDatum.fromMap(x)))
            : null,
      );

  Map<String, dynamic> toMap() => {
        "en": en != null ? List<dynamic>.from(en!.map((x) => x.toMap())) : null,
        "bn": bn != null ? List<dynamic>.from(bn!.map((x) => x.toMap())) : null,
      };
}

class AllCoursesDatum extends Equatable {
  AllCoursesDatum({
    this.available,
    this.courseId,
    this.title,
    this.intro,
    this.introduction,
    this.description,
    this.thumbnail,
    this.courseLength,
    this.totalLecture,
    this.price,
    this.instructor,
  });

  final String? courseId;
  final String? title;
  final String? intro;
  final String? introduction;
  final List<String>? description;
  final String? thumbnail;
  final String? courseLength;
  final String? totalLecture;
  final String? price;
  final AllCoursesInstructor? instructor;
  final bool? available;

  factory AllCoursesDatum.fromMap(Map<String, dynamic> json) => AllCoursesDatum(
        courseId: json["courseID"],
        title: json["title"],
        intro: json["courseIntro"],
        introduction: json["introduction"],
        description: json["description"] != null
            ? List<String>.from(json["description"].map((x) => x))
            : null,
        thumbnail: json["thumbnail"],
        courseLength: json["courseLength"],
        totalLecture: json["totalLecture"],
        price: json["price"],
        available: json["available"],
        instructor: json["instructor"] != null
            ? AllCoursesInstructor.fromMap(json["instructor"])
            : null,
      );

  Map<String, dynamic> toMap() => {
        "available": available,
        "courseID": courseId,
        "title": title,
        "courseIntro": intro,
        "introduction": introduction,
        "description": description != null
            ? List<dynamic>.from(description!.map((x) => x))
            : null,
        "thumbnail": thumbnail,
        "courseLength": courseLength,
        "totalLecture": totalLecture,
        "price": price,
        "instructor": instructor?.toMap(),
      };

  @override
  List<Object?> get props => [courseId];
}

class AllCoursesInstructor {
  AllCoursesInstructor({
    this.id,
    this.name,
    this.image,
    this.designation,
    this.description,
    this.courses,
  });

  final int? id;
  final String? name;
  final String? image;
  final String? designation;
  final List<String>? description;
  final List<String>? courses;

  factory AllCoursesInstructor.fromMap(Map<String, dynamic> json) =>
      AllCoursesInstructor(
        id: json["_id"],
        name: json["name"],
        image: json["image"],
        designation: json["designation"],
        description: json["description"] != null
            ? json["description"] is String
                ? [json["description"]]
                : List<String>.from(json["description"].map((x) => x))
            : null,
        courses: json["courses"] != null
            ? List<String>.from(json["courses"].map((x) => x))
            : null,
      );

  Map<String, dynamic> toMap() => {
        "_id": id,
        "name": name,
        "image": image,
        "designation": designation,
        "description": description,
        "courses":
            courses != null ? List<dynamic>.from(courses!.map((x) => x)) : null,
      };
}

class AllCoursesResult {
  AllCoursesResult({
    this.isError,
    this.status,
    this.errMsg,
  });

  final bool? isError;
  final int? status;
  final String? errMsg;

  factory AllCoursesResult.fromMap(Map<String, dynamic> json) =>
      AllCoursesResult(
        isError: json["isError"],
        status: json["status"],
        errMsg: json["errMsg"] ?? json['errorMsg'],
      );

  Map<String, dynamic> toMap() => {
        "isError": isError,
        "status": status,
        "errMsg": errMsg,
      };
}
