import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gladiators/provider/provider.dart';
import 'package:gladiators/widgets/enquip_character.dart';
import 'package:gladiators/widgets/inventory.dart';

class SelectPage extends ConsumerStatefulWidget {
  const SelectPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SelectPageState();
}

class _SelectPageState extends ConsumerState<SelectPage> {
  final pageController = PageController();

  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    await ref.read(inventoryProvider.notifier).getInventory();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(inventoryProvider)?.data;
    ref.watch(gladiatorsContainerProvider);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: EnquipCharacterWidget()),
            Expanded(
              child: Stack(
                children: [
                  // SizedBox(
                  //   width: MediaQuery.of(context).size.width,
                  //   height: MediaQuery.of(context).size.height,
                  //   child: Image.asset(
                  //     'lib/assets/img/wall.jpg',
                  //     fit: BoxFit.cover,
                  //   ),
                  // ),
                  Inventory(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
