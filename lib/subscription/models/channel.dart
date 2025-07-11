// To parse this JSON data, do
//
//     final channel = channelFromJson(jsonString);

import 'dart:convert';

//Channel channelFromJson(String str) => Channel.fromJson(jsonDecode(str));
//List<Channel> channelFromJson(String str) => List<Channel>.from(json.decode(str).map((x) => Channel.fromJson(x)));

String channelToJson(Channel data) => json.encode(data.toJson());

class Channel {
  int id;
  String title;
  String description;
  int totalFollowers;

  Channel({
    required this.id,
    required this.title,
    required this.description,
    required this.totalFollowers,
  });

  factory Channel.fromJson(Map<String, dynamic> json) => Channel(
    id: int.parse(json['id'].toString()),
    title: json['title'].toString(),
    description: json['description'].toString(),
    totalFollowers: int.parse(json['totalFollowers'].toString()),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'totalFollowers': totalFollowers,
  };
}
