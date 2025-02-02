class PersonalInfo {
  String name;
  String playerName;
  String avatarURL;
  String appearanceDetails;

  int height;
  int weight;
  int age;

  PersonalInfo({
    this.name = '',
    this.playerName = '',
    this.avatarURL = '',
    this.appearanceDetails = '',
    this.height = 0,
    this.weight = 0,
    this.age = 0,
  });

  factory PersonalInfo.copyWith(
    PersonalInfo info, {
    String? name,
    String? avatarURL,
    String? appearanceDetails,
    int? height,
    int? weight,
    int? age,
  }) {
    return PersonalInfo(
      name: name ?? info.name,
      avatarURL: avatarURL ?? info.avatarURL,
      appearanceDetails: appearanceDetails ?? info.appearanceDetails,
      height: height ?? info.height,
      weight: weight ?? info.weight,
      age: age ?? info.age,
    );
  }

  factory PersonalInfo.fromJson(Map<String, dynamic> json) => PersonalInfo(
        name: json['name'],
        avatarURL: json['avatar_url'],
        appearanceDetails: json['appearance_details'],
        height: json['height'],
        weight: json['weight'],
        age: json['age'],
      );

  Map<String, dynamic> get toJson => {
        'name': name,
        'avatar_url': avatarURL,
        'appearance_details': appearanceDetails,
        'height': height,
        'weight': weight,
        'age': age,
      };
}
