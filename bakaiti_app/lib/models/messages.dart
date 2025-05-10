class Messages {
  String? msg;
  String? toID;
  String? msgType;
  String? sentTime;
  String? readTime;
  String? fromID;

  Messages(
      {this.msg,
      this.toID,
      this.msgType,
      this.sentTime,
      this.readTime,
      this.fromID});

  Messages.fromJson(Map<String, dynamic> json) {
    msg = json['msg'].toString();
    toID = json['toID'].toString();
    msgType = json['msgType'].toString() == Type.image.name
        ? Type.image.name
        : Type.text.name;
    sentTime = json['sentTime'].toString();
    readTime = json['readTime'].toString();
    fromID = json['fromID'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['toID'] = this.toID;
    data['msgType'] = this.msgType;
    data['sentTime'] = this.sentTime;
    data['readTime'] = this.readTime;
    data['fromID'] = this.fromID;
    return data;
  }
}

enum Type { text, image }
