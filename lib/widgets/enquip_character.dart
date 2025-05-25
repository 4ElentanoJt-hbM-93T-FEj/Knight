import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gladiators/pages/arena_page.dart';
import 'package:gladiators/provider/provider.dart';
import 'package:lottie/lottie.dart';

class EnquipCharacterWidget extends ConsumerStatefulWidget {
  const EnquipCharacterWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EnquipCharacterWidgetState();
}

class _EnquipCharacterWidgetState extends ConsumerState<EnquipCharacterWidget> {
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var gladiators = ref.watch(gladiatorsContainerProvider);
    return Stack(
      children: [
        Column(
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    "Выбрано гладиаторов ${gladiators.length} из 2",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),

            ref.read(gladiatorsContainerProvider).isNotEmpty
                ? Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: TextField(
                        controller: nameController,
                        onChanged: (String value) {
                          gladiators[gladiators.length - 1].name = value;
                        },
                        decoration: InputDecoration(
                          hintText: "Дайте имя гладиатору",
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                )
                : SizedBox(),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  if (ref.read(gladiatorsContainerProvider).isEmpty) {
                    ref
                        .read(gladiatorsContainerProvider.notifier)
                        .setListGladiator(Gladiator());
                  }
                },
                child:
                    (ref.watch(gladiatorsContainerProvider).isEmpty)
                        ? LottieBuilder.asset('lib/assets/animation/tap.json')
                        : ref.watch(gladiatorsContainerProvider).length == 1
                        ? LottieBuilder.asset(
                          'lib/assets/animation/fighter.json',
                        )
                        : LottieBuilder.asset(
                          'lib/assets/animation/bandito.json',
                        ),
              ),
            ),
            ref.watch(gladiatorsContainerProvider).isNotEmpty
                ? ElevatedButton(
                  onPressed: () {
                    if (gladiators[gladiators.length - 1].name == null) {
                      gladiators[gladiators.length - 1].name =
                          "Гладиатор ${gladiators.length}";
                    }
                    nameController.text = "";
                    if ((ref.read(gladiatorsContainerProvider).length) != 2) {
                      ref
                          .read(gladiatorsContainerProvider.notifier)
                          .setListGladiator(Gladiator());
                    } else {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ArenaPage(),
                        ),
                      );
                    }
                  },
                  child: Text("Готово"),
                )
                : SizedBox(),
          ],
        ),
      ],
    );
  }
}
