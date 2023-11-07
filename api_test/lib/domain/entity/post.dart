import 'package:json_annotation/json_annotation.dart';

part 'post.g.dart';

@JsonSerializable()
class Post {
  final String name;
  final Map<String, dynamic> main;
  final Map<String, dynamic> sys;

  Post({
    required this.name,
    required this.main,
    required this.sys,
  });

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
  Map<String, dynamic> toJson() => _$PostToJson(this);
}
