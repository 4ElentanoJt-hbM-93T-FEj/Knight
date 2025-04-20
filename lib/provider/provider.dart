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
  GladiatorsContainer() : super([]);

  void setListGladiator(Gladiators character) {
    // if (state.isNotEmpty) {
    //   listGladiator.add(state[0]);
    // }
    List<Gladiators> listGladiator = [];
    listGladiator = [...state];
    listGladiator.add(character);
    state = listGladiator;
  }

  void setArmor(Armor armor, int index) {
    List<Gladiators> listGladiator = [];
    listGladiator = [...state];
    listGladiator[index - 1].armor = armor;
    state = listGladiator;
  }

  void setWearpon(Armor weapon, int index) {
    List<Gladiators> listGladiator = [];
    listGladiator = [...state];
    listGladiator[index - 1].weapons = weapon;
    state = listGladiator;
  }

  void setShield(Armor shield, int index) {
    List<Gladiators> listGladiator = [];
    listGladiator = [...state];
    listGladiator[index - 1].shields = shield;
    state = listGladiator;
  }
}

final gladiatorsContainerProvider =
    StateNotifierProvider<GladiatorsContainer, List<Gladiators>>(
      (ref) => GladiatorsContainer(),
    );
