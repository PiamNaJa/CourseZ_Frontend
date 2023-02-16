import 'package:coursez/model/user.dart';

class Inbox {
  int inboxId;
  int user1Id;
  User user1;
  int user2Id;
  User user2;
  String lastMessage;
  int lastMessageUserId;

  Inbox(
      {required this.inboxId,
      required this.user1Id,
      required this.user1,
      required this.user2Id,
      required this.user2,
      required this.lastMessage,
      required this.lastMessageUserId});

  factory Inbox.fromJson(Map<String, dynamic> json) {
    return Inbox(
        inboxId: json['inbox_id'],
        user1Id: json['user1_id'],
        user1: User.fromJson(json['user1']),
        user2Id: json['user2_id'],
        user2: User.fromJson(json['user2']),
        lastMessage: json['last_message'],
        lastMessageUserId: json['last_message_user_id']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['inbox_id'] = inboxId;
    data['user1_id'] = user1Id;
    data['user1'] = user1.toJson();
    data['user2_id'] = user2Id;
    data['user2'] = user2.toJson();
    data['last_message'] = lastMessage;
    data['last_message_user_id'] = lastMessageUserId;
    return data;
  }
}

class ChatRoom {
  int inboxId;
  List<Conversations> conversations;

  ChatRoom({required this.inboxId, required this.conversations});

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
        inboxId: json['inbox_id'],
        conversations: List.from(json['conversations']
            .map((v) => Conversations.fromJson(v))
            .toList()));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['inbox_id'] = inboxId;
    data['conversations'] = conversations.map((v) => v.toJson()).toList();
    return data;
  }
}

class Conversations {
  int conversationId;
  int chatroomId;
  int senderId;
  String message;
  int createAt;

  Conversations(
      {required this.conversationId,
      required this.chatroomId,
      required this.senderId,
      required this.message,
      required this.createAt});

  factory Conversations.fromJson(Map<String, dynamic> json) {
    return Conversations(
        conversationId: json['conversation_id'],
        chatroomId: json['chatroom_id'],
        senderId: json['sender_id'],
        message: json['message'],
        createAt: json['create_at']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['conversation_id'] = conversationId;
    data['chatroom_id'] = chatroomId;
    data['sender_id'] = senderId;
    data['message'] = message;
    data['create_at'] = createAt;
    return data;
  }
}
