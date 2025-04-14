import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gladiators/provider/provider.dart';

class Inventory extends ConsumerStatefulWidget {
  const Inventory({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InventoryState();
}

class _InventoryState extends ConsumerState<Inventory> {
  @override
  Widget build(BuildContext context) {
    String currentTab = ref.watch(tabInventoryProvider);
    var inventory = ref.watch(inventoryProvider)?.data;
    return Column(
      children: [
        Row(
          children: [
            for (var tab
                in ref.watch(tabInventoryProvider.notifier).tabs.keys) ...[
              GestureDetector(
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
                  child: Text(
                    ref.watch(tabInventoryProvider.notifier).tabs[tab] ?? "",
                    style: TextStyle(
                      color: tab == currentTab ? Colors.white : Colors.black,
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
              maxCrossAxisExtent: 200,
              childAspectRatio: 3 / 2,
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
                onTap: () {},
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    // color: Colors.amber,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(width: 1, style: BorderStyle.solid),
                  ),
                  child: Column(
                    children: [
                      // AspectRatio(aspectRatio: 3 / 2, child: Image.asset("")),
                      Text(
                        currentTab == "armor"
                            ? (inventory?.armor?[index].name ?? "")
                            : currentTab == "weapons"
                            ? (inventory?.weapons?[index].name ?? "")
                            : (inventory?.shields?[index].name ?? ""),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
