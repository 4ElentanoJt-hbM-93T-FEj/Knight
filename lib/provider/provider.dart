import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gladiators/provider/model.dart';

class TabInventory extends StateNotifier<String> {
  TabInventory() : super('armor');

  Map<String, String> tabs = {
    "armor": "Броня",
    "weapons": "Оружие",
    "shields": "Щиты",
  };

  void setTab(String tab) {
    if (state != tab) {
      state = tab;
    }
  }
}

final tabInventoryProvider = StateNotifierProvider<TabInventory, String>(
  (ref) => TabInventory(),
);

final inventoryProvider =
    StateNotifierProvider<SelectArmorNotifier, Interface?>(
      (ref) => SelectArmorNotifier(),
    );

class SelectArmorNotifier extends StateNotifier<Interface?> {
  SelectArmorNotifier._() : super(null);
  static SelectArmorNotifier instance = SelectArmorNotifier._();
  factory SelectArmorNotifier() => instance;

  Future<void> getInventory() async {
    state = Interface.fromJson(
      jsonDecode(await rootBundle.loadString('lib/data/data.json')),
    );
  }
}

class Gladiators {
  int hp;
  int damage;
  Armor? armor;
  Armor? weapons;
  Armor? shields;

  Gladiators({
    this.hp = 100,
    this.damage = 5,
    this.armor,
    this.weapons,
    this.shields,
  });

  // Добавить методы боя (просчёт урона, проснёч поглощения
  // бронёй, парирование возможно) и уклонения
}

class GladiatorsContainer extends StateNotifier<List<Gladiators>> {
  GladiatorsContainer() : super([Gladiators(), Gladiators()]);

  void setArmor(Gladiators gladiator, Armor armor, int index) {
    state[index].armor = armor;
  }

  void setWearpon(Gladiators gladiator, Armor weapon, int index) {
    state[index].weapons = weapon;
  }

  void setShield(Gladiators gladiator, Armor shield, int index) {
    state[index].shields = shield;
  }
}

final gladiatorsContainerProvider =
    StateNotifierProvider<GladiatorsContainer, List<Gladiators>>(
      (ref) => GladiatorsContainer(),
    );
