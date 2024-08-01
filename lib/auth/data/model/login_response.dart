class AuthResponse {
  int? id;
  String? token;
  String? error;

  AuthResponse({
    this.id,
    this.token,
    this.error,
  });

  AuthResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    token = json['token'];
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['error'] = error;
    data['token'] = token;
    return data;
  }
}
