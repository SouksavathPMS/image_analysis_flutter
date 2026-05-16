enum MessageRole { user, model }

class ChatMessage {
  final String text;
  final MessageRole role;
  final String? imagePath;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.role,
    this.imagePath,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'text': text,
    'role': role.name,
    'imagePath': imagePath,
    'timestamp': timestamp.toIso8601String(),
  };

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
    text: json['text'],
    role: MessageRole.values.firstWhere((e) => e.name == json['role']),
    imagePath: json['imagePath'],
    timestamp: DateTime.parse(json['timestamp']),
  );
}
