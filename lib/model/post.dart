//import 'package:intl/intl.dart';

class PostModel {
  String owner;
  String eventName;
  String eventLocation;
  DateTime eventTime;
  DateTime creationTime;
  int preferedNumberOfPeople;

  PostModel(
      {required this.owner,
      required this.eventName,
      required this.eventLocation,
      required this.eventTime,
      required this.creationTime,
      required this.preferedNumberOfPeople});

  Map<String, dynamic> toMap() {
    return ({
      "owner": owner,
      "eventName": eventName,
      "eventLocation": eventLocation,
      "eventTime": eventTime,
      "creationTime": creationTime,
      "preferedNumberOfPeople": preferedNumberOfPeople
    });
  }
}
