// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gladiators/provider/model.dart';

class HistoryBattle {
  HistoryBattle();
  static String historyBattle = "";
}

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

class Gladiator {
  String? name;
  Armor? armor;
  Armor? weapons;
  Armor? shields;
  int health;
  int maxHealth;
  int baseAttack;
  int baseDefense;
  int baseSpeed;
  int luck;

  Gladiator({
    this.name,
    this.health = 100,
    this.armor,
    this.weapons,
    this.shields,
    this.maxHealth = 100,
    this.baseAttack = 5,
    this.baseDefense = 0,
    this.baseSpeed = 10,
    this.luck = 1,
  });

  // Добавить методы боя (просчёт урона, проснёч поглощения
  // бронёй, парирование возможно) и уклонения

  int get attack {
    int attack = baseAttack;
    if (weapons != null) {
      if (weapons!.specialEffects!.contains('+')) {
        var matches = RegExp(r'\+(\d+)').allMatches(weapons!.specialEffects!);
        for (var match in matches) {
          attack += int.parse(match.group(1)!);
        }
      }
    }
    return attack;
  }

  int get defense {
    int defense = baseDefense;
    if (armor != null) {
      defense += armor!.defense as int;
    }
    if (shields != null) {
      defense += shields!.defenseBonus as int;
    }
    return defense;
  }

  int get speed {
    int speed = baseSpeed;
    if (armor != null) {
      speed -= (armor!.weight as int) ~/ 3;
      if (armor!.specialEffects!.contains('скорость')) {
        speed += 10;
      }
    }
    if (shields != null) {
      speed -= (shields!.weight as int) ~/ 2;
    }
    return speed.clamp(1, 100);
  }

  bool isAlive() => health > 0;

  void takeDamage(int damage) {
    // Проверка на разрушение щита
    if (shields != null && damage > 10) {
      shields!.durability = shields!.durability! - (damage ~/ 4);
      if (shields!.durability! <= 0) {
        HistoryBattle.historyBattle += ('${shields!.name} $name разрушен!');
        shields = null;
      }
    }

    // Проверка на разрушение брони
    if (armor != null) {
      armor!.durability = armor!.durability! - (damage ~/ 5);
      if (armor!.durability! <= 0) {
        HistoryBattle.historyBattle += ('${armor!.name} $name разрушена!');
        armor = null;
      }
    }

    health -= damage;
    if (health < 0) health = 0;
  }

  void heal(int amount) {
    health += amount;
    if (health > maxHealth) health = maxHealth;
  }

  void _checkWeaponDurability() {
    if (weapons != null) {
      weapons!.durability = weapons!.durability! - (1 + Random().nextInt(3));

      if (weapons!.durability! <= 0) {
        HistoryBattle.historyBattle += ('${weapons!.name} $name сломалось!');
        weapons = null;
      }
    }
  }

  int calculateDamage(Gladiator opponent) {
    _checkWeaponDurability();

    if (weapons == null) {
      HistoryBattle.historyBattle += ('$name атакует без оружия!\n');
      return max(1, baseAttack ~/ 3);
    }

    int baseDamage = _parseDamageDice(weapons!.damage as String);
    int armorReduction = opponent.defense ~/ 2;

    if (opponent.armor != null) {
      if (weapons!.specialEffects!.contains('пробивает броню')) {
        int armorPenetration = int.parse(
          RegExp(r'(\d+)%').firstMatch(weapons!.specialEffects!)!.group(1)!,
        );
        armorReduction = (armorReduction * (100 - armorPenetration) ~/ 100);
      }

      if (weapons!.type == 'меч' &&
          opponent.armor!.specialEffects!.contains('режущего')) {
        baseDamage = (baseDamage * 0.85).toInt();
      }
      if (weapons!.type == 'колющее' &&
          opponent.armor!.specialEffects!.contains('колющего')) {
        baseDamage = (baseDamage * 0.75).toInt();
      }
    }

    int finalDamage = max(1, baseDamage - armorReduction);

    bool isCritical = Random().nextInt(100) < luck;
    if (isCritical) {
      int critMultiplier = 2;
      if (weapons != null &&
          weapons!.specialEffects!.contains('критический удар')) {
        critMultiplier = int.parse(
          RegExp(r'x(\d+)').firstMatch(weapons!.specialEffects!)!.group(1)!,
        );
      }
      HistoryBattle.historyBattle +=
          ('$name наносит критический удар (x$critMultiplier)!\n');
      finalDamage *= critMultiplier;
    }

    return finalDamage;
  }

  int _parseDamageDice(String damageStr) {
    var match = RegExp(r'(\d+)d(\d+)\+?(\d+)?').firstMatch(damageStr);
    if (match == null) return baseAttack ~/ 2;

    int diceCount = int.parse(match.group(1)!);
    int diceSides = int.parse(match.group(2)!);
    int bonus = match.group(3) != null ? int.parse(match.group(3)!) : 0;

    int total = 0;
    for (int i = 0; i < diceCount; i++) {
      total += Random().nextInt(diceSides) + 1;
    }
    return total + bonus;
  }

  bool dodgeAttack(Gladiator opponent) {
    int shieldBonus = shields != null ? 5 + (shields!.defenseBonus as int) : 0;
    int dodgeChance = (speed - opponent.speed) + 5 + shieldBonus;
    dodgeChance = dodgeChance.clamp(0, 40);

    if (weapons != null && weapons!.name == 'Кинжал теней') {
      dodgeChance += 20;
    }

    return Random().nextInt(100) < dodgeChance;
  }

  Future<void> specialAbility(Gladiator opponent) async {
    if (weapons != null) {
      _useWeaponSpecial(opponent);
    } else {
      HistoryBattle.historyBattle += ('$name использует базовую атаку!\n');
      int damage = calculateDamage(opponent);
      opponent.takeDamage(damage);
      HistoryBattle.historyBattle +=
          ('$name наносит $damage урона ${opponent.name}!\n');
    }
  }

  Future<void> _useWeaponSpecial(Gladiator opponent) async {
    switch (weapons!.name) {
      case 'Двуручный меч':
        HistoryBattle.historyBattle +=
            ('$name совершает мощный размашистый удар двуручным мечом!');
        int damage = calculateDamage(opponent) + 3;
        opponent.takeDamage(damage);
        HistoryBattle.historyBattle +=
            ('$name наносит $damage урона ${opponent.name}!\n');
        break;
      case 'Арбалет':
        HistoryBattle.historyBattle +=
            ('$name стреляет из арбалета в ${opponent.name}!\n');
        if (opponent.shields != null &&
            opponent.shields!.name == 'Башенный щит') {
          HistoryBattle.historyBattle +=
              ('${opponent.name} полностью закрывается башенным щитом!\n');
          if (Random().nextBool()) {
            HistoryBattle.historyBattle += ('Выстрел не пробивает щит!\n');
            return;
          }
        }
        int damage = calculateDamage(opponent);
        opponent.takeDamage(damage);
        HistoryBattle.historyBattle +=
            ('$name наносит $damage урона ${opponent.name}!\n');
        break;
      case 'Боевой топор':
        HistoryBattle.historyBattle += ('$name замахивается боевым топором!\n');
        int damage = calculateDamage(opponent);
        if (Random().nextInt(100) < 25) {
          HistoryBattle.historyBattle +=
              ('${opponent.name} оглушен ударом топора!\n');
          opponent.baseSpeed = max(1, opponent.baseSpeed - 3);
        }
        opponent.takeDamage(damage);
        HistoryBattle.historyBattle +=
            ('$name наносит $damage урона ${opponent.name}!\n');
        break;
      case 'Кинжал теней':
        HistoryBattle.historyBattle += ('$name атакует из тени кинжалом!\n');
        int prevLuck = luck;
        luck += 20;
        int damage = calculateDamage(opponent);
        luck = prevLuck;
        opponent.takeDamage(damage);
        HistoryBattle.historyBattle +=
            ('$name наносит $damage урона ${opponent.name}!\n');
        break;
      default:
        HistoryBattle.historyBattle +=
            ('$name атакует с помощью ${weapons!.name}!\n');
        int damage = calculateDamage(opponent);
        opponent.takeDamage(damage);
        HistoryBattle.historyBattle +=
            ('$name наносит $damage урона ${opponent.name}!\n');
    }
  }

  Future<void> printEquipmentStatus() async {
    Future<void> printItem(String type, Armor? item) async {
      if (item != null) {
        HistoryBattle.historyBattle +=
            ('$type: ${item.type} (прочность: ${item.durability})\n');
      } else {
        HistoryBattle.historyBattle += ('$type: нет\n');
      }
    }

    HistoryBattle.historyBattle += ('\nСостояние экипировки $name:');
    printItem('Оружие', weapons);
    printItem('Броня', armor);
    printItem('Щит', shields);
  }

  @override
  String toString() {
    String equipment = '';
    if (weapons != null) equipment += 'Оружие: ${weapons!.name}, ';
    if (armor != null) equipment += 'Броня: ${armor!.name}, ';
    if (shields != null) equipment += 'Щит: ${shields!.name}';

    return '$name (Здоровье: $health/$maxHealth, Атака: $attack, Защита: $defense, Скорость: $speed, Удача: $luck%) | Экипировка: $equipment';
  }
}

class Battle {
  static Future<String> fight(
    Gladiator gladiator1,
    Gladiator gladiator2,
  ) async {
    HistoryBattle.historyBattle += ('\n=== НАЧАЛО БОЯ ===\n');
    HistoryBattle.historyBattle +=
        ('${gladiator1.name} против ${gladiator2.name}!\n');

    await gladiator1.printEquipmentStatus();
    await gladiator2.printEquipmentStatus();

    Gladiator attacker, defender;
    if (gladiator1.speed > gladiator2.speed) {
      attacker = gladiator1;
      defender = gladiator2;
    } else if (gladiator1.speed < gladiator2.speed) {
      attacker = gladiator2;
      defender = gladiator1;
    } else {
      attacker = Random().nextBool() ? gladiator1 : gladiator2;
      defender = attacker == gladiator1 ? gladiator2 : gladiator1;
    }

    HistoryBattle.historyBattle +=
        ('\n${attacker.name} атакует первым благодаря своей скорости!\n');

    int round = 1;
    while (gladiator1.isAlive() && gladiator2.isAlive()) {
      HistoryBattle.historyBattle += ('\n=== Раунд $round ===\n');

      _performAttack(attacker, defender);
      if (!defender.isAlive()) break;

      _performAttack(defender, attacker);
      if (!attacker.isAlive()) break;

      var temp = attacker;
      attacker = defender;
      defender = temp;

      round++;
      // sleep(Duration(seconds: 1));
    }

    HistoryBattle.historyBattle += ('\n=== БОЙ ОКОНЧЕН ===');
    if (gladiator1.isAlive()) {
      return ('${gladiator1.name} побеждает с ${gladiator1.health} здоровья!\n');
      // gladiator1.printEquipmentStatus();
    } else {
      return ('${gladiator2.name} побеждает с ${gladiator2.health} здоровья!\n');
      // gladiator2.printEquipmentStatus();
    }
  }

  static Future<void> _performAttack(
    Gladiator attacker,
    Gladiator defender,
  ) async {
    if (defender.dodgeAttack(attacker)) {
      HistoryBattle.historyBattle +=
          ('${defender.name} ловко уклоняется от атаки!');
      return;
    }

    attacker.specialAbility(defender);
  }
}

class GladiatorsContainer extends StateNotifier<List<Gladiator>> {
  GladiatorsContainer() : super([]);

  void setListGladiator(Gladiator character) {
    List<Gladiator> listGladiator = [];
    listGladiator = [...state];
    listGladiator.add(character);
    state = listGladiator;
  }

  void setArmor(Armor armor, int index) {
    List<Gladiator> listGladiator = [];
    listGladiator = [...state];
    listGladiator[index - 1].armor = armor;
    state = listGladiator;
  }

  void setWearpon(Armor weapons, int index) {
    List<Gladiator> listGladiator = [];
    listGladiator = [...state];
    listGladiator[index - 1].weapons = weapons;
    state = listGladiator;
  }

  void setShield(Armor shields, int index) {
    List<Gladiator> listGladiator = [];
    listGladiator = [...state];
    listGladiator[index - 1].shields = shields;
    state = listGladiator;
  }
}

final gladiatorsContainerProvider =
    StateNotifierProvider<GladiatorsContainer, List<Gladiator>>(
      (ref) => GladiatorsContainer(),
    );

class BattleStatus extends StateNotifier<String> {
  BattleStatus() : super('Ожидание');

  void changeStatus(String status) {
    state = status;
  }
}

final battleStatusProvider = StateNotifierProvider<BattleStatus, String>(
  (ref) => BattleStatus(),
);

// void main() {
  // Создаем гладиаторов с разными характеристиками
  // var gladiators = [Gladiator(), Gladiator()];

  // // Выбираем двух случайных гладиаторов
  // final random = Random();
  // var gladiator1 = gladiators[random.nextInt(gladiators.length)];
  // var gladiator2 = gladiators[random.nextInt(gladiators.length)];

  // // Убедимся, что это разные гладиаторы
  // while (gladiator2.name == gladiator1.name) {
  //   gladiator2 = gladiators[random.nextInt(gladiators.length)];
  // }

  // // Экипируем их
  // gladiator1.equipArmor(Equipment.getRandomArmor());
  // gladiator1.equipWeapon(Equipment.getRandomWeapon());
  // if (random.nextBool()) {
  //   gladiator1.equipShield(Equipment.getRandomShield());
  // }

  // gladiator2.equipArmor(Equipment.getRandomArmor());
  // gladiator2.equipWeapon(Equipment.getRandomWeapon());
  // if (random.nextBool()) {
  //   gladiator2.equipShield(Equipment.getRandomShield());
  // }

  // Восстанавливаем здоровье
  // gladiator1.heal(gladiator1.maxHealth);
  // gladiator2.heal(gladiator2.maxHealth);

  // Начинаем бой
  // Battle.fight(gladiator1, gladiator2);
// }
