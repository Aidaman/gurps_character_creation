class PersonalInfo {
  String avatarURL;

  String name;
  String playerName;

  int sizeModifier;
  int height;
  int weight;
  int age;

  String appearanceDetails;

  PersonalInfo({
    this.name = '',
    this.playerName = '',
    this.avatarURL = '',
    this.appearanceDetails = '',
    this.height = 0,
    this.weight = 0,
    this.age = 0,
    this.sizeModifier = 0,
  });

  factory PersonalInfo.copyWith(
    PersonalInfo info, {
    String? name,
    String? avatarURL,
    String? appearanceDetails,
    int? height,
    int? weight,
    int? age,
    int? sizeModifier,
  }) {
    return PersonalInfo(
      name: name ?? info.name,
      avatarURL: avatarURL ?? info.avatarURL,
      appearanceDetails: appearanceDetails ?? info.appearanceDetails,
      height: height ?? info.height,
      weight: weight ?? info.weight,
      age: age ?? info.age,
      sizeModifier: sizeModifier ?? info.sizeModifier,
    );
  }

  factory PersonalInfo.fromJson(Map<String, dynamic> json) => PersonalInfo(
        name: json['name'],
        avatarURL: json['avatar_url'],
        appearanceDetails: json['appearance_details'],
        height: json['height'],
        weight: json['weight'],
        age: json['age'],
        sizeModifier: json['size_modifier'],
      );

  Map<String, dynamic> get toJson => {
        'name': name,
        'avatar_url': avatarURL,
        'appearance_details': appearanceDetails,
        'height': height,
        'weight': weight,
        'age': age,
        'size_modifier': sizeModifier,
      };
}
