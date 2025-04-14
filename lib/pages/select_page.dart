import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gladiators/provider/provider.dart';
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

  List<Widget> getGladiatorsSelectPages() {
    return [SizedBox()];
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(inventoryProvider)?.data;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              controller: pageController,
              children: getGladiatorsSelectPages(),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Inventory(),
            ),
          ),
        ],
      ),
    );
  }
}
