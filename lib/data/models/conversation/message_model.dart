import 'package:equatable/equatable.dart';
import '../../../domain/entity/conversation/message.dart';

class MessageModel extends Equatable {
  final int id;
  final String role;
  final String content;
  final DateTime createdAt;

  const MessageModel({
    required this.id,
    required this.role,
    required this.content,
    required this.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
    id: json['id'] ?? 0,
    role: json['role'] ?? '',
    content: json['content'] ?? '',
    createdAt: json['created_at'] != null
        ? DateTime.parse(json['created_at'])
        : DateTime.now(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'role': role,
    'content': content,
    'created_at': createdAt.toIso8601String(),
  };

  Message toEntity() =>
      Message(id: id, role: role, content: content, createdAt: createdAt);

  @override
  List<Object> get props => [id, role, content, createdAt];
}
