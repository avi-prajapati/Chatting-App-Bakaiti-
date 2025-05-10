class UserChat {
  String? image;
  String? about;
  String? name;
  String? createdAt;
  String? id;
  String? lastActive;
  bool? isOnline;
  String? email;
  String? pushToken;

  UserChat(
      {this.image,
      this.about,
      this.name,
      this.createdAt,
      this.id,
      this.lastActive,
      this.isOnline,
      this.email,
      this.pushToken});

  //This convert the json data into the dart object or a Custom object.
  UserChat.fromJson(Map<String, dynamic> json) {
    image = json['image'] ?? '';
    about = json['about'];
    name = json['name'];
    createdAt = json['created_at'];
    id = json['id'];
    lastActive = json['last_active'];
    isOnline = json['is_online'];
    email = json['email'];
    pushToken = json['push_token'];
  }

  //This Convert the custom object into the json data.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['about'] = this.about;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    data['last_active'] = this.lastActive;
    data['is_online'] = this.isOnline;
    data['email'] = this.email;
    data['push_token'] = this.pushToken;
    return data;
  }
}
