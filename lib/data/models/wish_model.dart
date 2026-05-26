class WishModel {
  final String id;
  final String recipientCategory;
  final String message;
  final String cardStyle;
  final DateTime sentAt;

  const WishModel({
    required this.id,
    required this.recipientCategory,
    required this.message,
    required this.cardStyle,
    required this.sentAt,
  });

  WishModel copyWith({
    String? id,
    String? recipientCategory,
    String? message,
    String? cardStyle,
    DateTime? sentAt,
  }) {
    return WishModel(
      id: id ?? this.id,
      recipientCategory: recipientCategory ?? this.recipientCategory,
      message: message ?? this.message,
      cardStyle: cardStyle ?? this.cardStyle,
      sentAt: sentAt ?? this.sentAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'recipientCategory': recipientCategory,
    'message': message,
    'cardStyle': cardStyle,
    'sentAt': sentAt.toIso8601String(),
  };

  factory WishModel.fromJson(Map<String, dynamic> json) => WishModel(
    id: json['id'] as String,
    recipientCategory: json['recipientCategory'] as String,
    message: json['message'] as String,
    cardStyle: json['cardStyle'] as String,
    sentAt: DateTime.parse(json['sentAt'] as String),
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WishModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
