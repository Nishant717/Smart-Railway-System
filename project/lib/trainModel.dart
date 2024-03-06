// ignore_for_file: camel_case_types, file_names, unnecessary_new, prefer_collection_literals, unnecessary_this

class StationsBase {
  final String name;
  final String code;

  StationsBase({required this.name, required this.code});

  factory StationsBase.fromJson(Map<String, dynamic> json) {
    return StationsBase(
      name: json['name'],
      code: json['code'],
    );
  }
}

class trainModel {
  bool? success;
  int? timeStamp;
  List<Data>? data;

  trainModel({this.success, this.timeStamp, this.data});

  trainModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    timeStamp = json['time_stamp'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['time_stamp'] = this.timeStamp;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  TrainBase? trainBase;

  Data({this.trainBase});

  Data.fromJson(Map<String, dynamic> json) {
    trainBase = json['train_base'] != null
        ? new TrainBase.fromJson(json['train_base'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.trainBase != null) {
      data['train_base'] = this.trainBase!.toJson();
    }
    return data;
  }
}

class TrainBase {
  String? trainNo;
  String? trainName;
  String? sourceStnName;
  String? sourceStnCode;
  String? dstnStnName;
  String? dstnStnCode;
  String? fromStnName;
  String? fromStnCode;
  String? toStnName;
  String? toStnCode;
  String? fromTime;
  String? toTime;
  String? travelTime;
  String? runningDays;

  TrainBase(
      {this.trainNo,
      this.trainName,
      this.sourceStnName,
      this.sourceStnCode,
      this.dstnStnName,
      this.dstnStnCode,
      this.fromStnName,
      this.fromStnCode,
      this.toStnName,
      this.toStnCode,
      this.fromTime,
      this.toTime,
      this.travelTime,
      this.runningDays});

  TrainBase.fromJson(Map<String, dynamic> json) {
    trainNo = json['train_no'];
    trainName = json['train_name'];
    sourceStnName = json['source_stn_name'];
    sourceStnCode = json['source_stn_code'];
    dstnStnName = json['dstn_stn_name'];
    dstnStnCode = json['dstn_stn_code'];
    fromStnName = json['from_stn_name'];
    fromStnCode = json['from_stn_code'];
    toStnName = json['to_stn_name'];
    toStnCode = json['to_stn_code'];
    fromTime = json['from_time'];
    toTime = json['to_time'];
    travelTime = json['travel_time'];
    runningDays = json['running_days'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['train_no'] = this.trainNo;
    data['train_name'] = this.trainName;
    data['source_stn_name'] = this.sourceStnName;
    data['source_stn_code'] = this.sourceStnCode;
    data['dstn_stn_name'] = this.dstnStnName;
    data['dstn_stn_code'] = this.dstnStnCode;
    data['from_stn_name'] = this.fromStnName;
    data['from_stn_code'] = this.fromStnCode;
    data['to_stn_name'] = this.toStnName;
    data['to_stn_code'] = this.toStnCode;
    data['from_time'] = this.fromTime;
    data['to_time'] = this.toTime;
    data['travel_time'] = this.travelTime;
    data['running_days'] = this.runningDays;
    return data;
  }
}
