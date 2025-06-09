// To parse this JSON data, do
//
//     final interface = interfaceFromJson(jsonString);

import 'dart:convert';

Interface interfaceFromJson(String str) => Interface.fromJson(json.decode(str));

String interfaceToJson(Interface data) => json.encode(data.toJson());

class Interface {
  Data? data;

  Interface({this.data});

  Interface copyWith({Data? data}) => Interface(data: data ?? this.data);

  factory Interface.fromJson(Map<String, dynamic> json) => Interface(
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {"data": data?.toJson()};
}

class Data {
  List<Armor>? armor;
  List<Armor>? weapons;
  List<Armor>? shields;

  Data({this.armor, this.weapons, this.shields});

  Data copyWith({
    List<Armor>? armor,
    List<Armor>? weapons,
    List<Armor>? shields,
  }) => Data(
    armor: armor ?? this.armor,
    weapons: weapons ?? this.weapons,
    shields: shields ?? this.shields,
  );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    armor:
        json["armor"] == null
            ? []
            : List<Armor>.from(json["armor"]!.map((x) => Armor.fromJson(x))),
    weapons:
        json["weapons"] == null
            ? []
            : List<Armor>.from(json["weapons"]!.map((x) => Armor.fromJson(x))),
    shields:
        json["shields"] == null
            ? []
            : List<Armor>.from(json["shields"]!.map((x) => Armor.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "armor":
        armor == null ? [] : List<dynamic>.from(armor!.map((x) => x.toJson())),
    "weapons":
        weapons == null
            ? []
            : List<dynamic>.from(weapons!.map((x) => x.toJson())),
    "shields":
        shields == null
            ? []
            : List<dynamic>.from(shields!.map((x) => x.toJson())),
  };
}

class Armor {
  int? id;
  String? name;
  String? type;
  int? defense;
  int? weight;
  int? durability;
  String? material;
  String? specialEffects;
  int? defenseBonus;
  String? damage;
  int? range;
  String? image;

  Armor({
    this.id,
    this.name,
    this.type,
    this.defense,
    this.weight,
    this.durability,
    this.material,
    this.specialEffects,
    this.defenseBonus,
    this.damage,
    this.range,
    this.image,
  });

  Armor copyWith({
    int? id,
    String? name,
    String? type,
    int? defense,
    int? weight,
    int? durability,
    String? material,
    String? specialEffects,
    int? defenseBonus,
    String? damage,
    int? range,
    String? image,
  }) => Armor(
    id: id ?? this.id,
    name: name ?? this.name,
    type: type ?? this.type,
    defense: defense ?? this.defense,
    weight: weight ?? this.weight,
    durability: durability ?? this.durability,
    material: material ?? this.material,
    specialEffects: specialEffects ?? this.specialEffects,
    defenseBonus: defenseBonus ?? this.defenseBonus,
    damage: damage ?? this.damage,
    range: range ?? this.range,
    image: image ?? this.image,
  );

  factory Armor.fromJson(Map<String, dynamic> json) => Armor(
    id: json["id"],
    name: json["name"],
    type: json["type"],
    defense: json["defense"],
    weight: json["weight"],
    durability: json["durability"],
    material: json["material"],
    specialEffects: json["special_effects"],
    defenseBonus: json["defense_bonus"],
    damage: json["damage"],
    range: json["range"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "type": type,
    "defense": defense,
    "weight": weight,
    "durability": durability,
    "material": material,
    "special_effects": specialEffects,
    "defense_bonus": defenseBonus,
    "damage": damage,
    "range": range,
    "image": image,
  };
}
