import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gladiators/provider/model.dart';
import 'package:gladiators/provider/provider.dart';

class Inventory extends ConsumerStatefulWidget {
  const Inventory({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InventoryState();
}

class _InventoryState extends ConsumerState<Inventory> {
  bool isSelectedItem(
    String tab,
    int index,
    List<Gladiators> gladiators,
    Data? inventory,
  ) {
    return tab == "armor"
        ? (gladiators.isEmpty ||
            gladiators[gladiators.length - 1].armor != inventory?.armor?[index])
        : tab == "weapons"
        ? (gladiators.isEmpty ||
            gladiators[gladiators.length - 1].weapons !=
                inventory?.weapons?[index])
        : (gladiators.isEmpty ||
            gladiators[gladiators.length - 1].shields !=
                inventory?.shields?[index]);
  }

  @override
  Widget build(BuildContext context) {
    String currentTab = ref.watch(tabInventoryProvider);
    var inventory = ref.watch(inventoryProvider)?.data;
    var gladiators = ref.watch(gladiatorsContainerProvider);
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              for (var tab
                  in ref.watch(tabInventoryProvider.notifier).tabs.keys) ...[
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      ref.read(tabInventoryProvider.notifier).setTab(tab);
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color:
                            tab == currentTab
                                ? Colors.blueAccent
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          ref.watch(tabInventoryProvider.notifier).tabs[tab] ??
                              "",
                          style: TextStyle(
                            color:
                                tab == currentTab ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 250,
                childAspectRatio: 1,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              itemCount:
                  currentTab == "armor"
                      ? (inventory?.armor?.length ?? 0)
                      : currentTab == "weapons"
                      ? (inventory?.weapons?.length ?? 0)
                      : (inventory?.shields?.length ?? 0),
              itemBuilder: (BuildContext ctx, index) {
                return GestureDetector(
                  onTap: () {
                    if (gladiators.isNotEmpty) {
                      currentTab == "armor"
                          ? ref
                              .watch(gladiatorsContainerProvider.notifier)
                              .setArmor(
                                gladiators[gladiators.length - 1].armor ==
                                        inventory?.armor?[index]
                                    ? Armor()
                                    : inventory!.armor![index],
                                gladiators.length,
                              )
                          : currentTab == "weapons"
                          ? ref
                              .watch(gladiatorsContainerProvider.notifier)
                              .setWearpon(
                                gladiators[gladiators.length - 1].weapons ==
                                        inventory?.weapons?[index]
                                    ? Armor()
                                    : inventory!.weapons![index],
                                gladiators.length,
                              )
                          : ref
                              .watch(gladiatorsContainerProvider.notifier)
                              .setShield(
                                gladiators[gladiators.length - 1].shields ==
                                        inventory?.shields?[index]
                                    ? Armor()
                                    : inventory!.shields![index],
                                gladiators.length,
                              );
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color:
                          isSelectedItem(
                                currentTab,
                                index,
                                gladiators,
                                inventory,
                              )
                              ? Colors.transparent
                              : Colors.green[200],
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        width: 1,
                        style: BorderStyle.solid,
                        color:
                            isSelectedItem(
                                  currentTab,
                                  index,
                                  gladiators,
                                  inventory,
                                )
                                ? Colors.black
                                : Colors.green,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                currentTab == "armor"
                                    ? (inventory?.armor?[index].name ?? "")
                                    : currentTab == "weapons"
                                    ? (inventory?.weapons?[index].name ?? "")
                                    : (inventory?.shields?[index].name ?? ""),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        // AspectRatio(aspectRatio: 3 / 2),
                        Expanded(
                          child: Center(
                            child:
                                // "armor": "Броня",
                                // "weapons": "Оружие",
                                // "shields": "Щиты",
                                currentTab == "armor"
                                    ? SvgPicture.asset(
                                      "lib/assets/img/swords/armor.svg",
                                    )
                                    : Image.asset(
                                      currentTab == "weapons"
                                          ? "lib/assets/img/swords/sword.png"
                                          : currentTab == "shields"
                                          ? "lib/assets/img/swords/shield.png"
                                          : "",
                                    ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                currentTab == "armor"
                                    ? "Защита +${(inventory?.armor?[index].defense ?? 0)}"
                                    : currentTab == "weapons"
                                    ? "Урон ~${(inventory?.weapons?[index].damage ?? "")}"
                                    : "Защита +${(inventory?.shields?[index].defenseBonus ?? 0)}",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
