import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gladiators/provider/provider.dart';
import 'package:lottie/lottie.dart';

class EnquipCharacterWidget extends ConsumerStatefulWidget {
  const EnquipCharacterWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EnquipCharacterWidgetState();
}

class _EnquipCharacterWidgetState extends ConsumerState<EnquipCharacterWidget> {
  @override
  Widget build(BuildContext context) {
    var gladiators = ref.watch(gladiatorsContainerProvider);
    return Stack(
      children: [
        // SizedBox(
        //   width: MediaQuery.of(context).size.width,
        //   height: MediaQuery.of(context).size.height,
        //   child: Image.asset('lib/assets/img/kuznets.jpg', fit: BoxFit.cover),
        // ),
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
            SizedBox(height: 20),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  if (ref.read(gladiatorsContainerProvider).isEmpty) {
                    ref
                        .read(gladiatorsContainerProvider.notifier)
                        .setListGladiator(Gladiators());
                  }
                },
                child:
                    (ref.watch(gladiatorsContainerProvider).isEmpty)
                        ? LottieBuilder.asset(
                          'lib/assets/animation/anim_one.json',
                        )
                        : LottieBuilder.asset(
                          'lib/assets/animation/knight.json',
                        ),
              ),
            ),
            ref.watch(gladiatorsContainerProvider).isNotEmpty
                ? ElevatedButton(
                  onPressed: () {
                    if ((ref.read(gladiatorsContainerProvider).length) != 2) {
                      ref
                          .read(gladiatorsContainerProvider.notifier)
                          .setListGladiator(Gladiators());
                    }
                    if ((ref.read(gladiatorsContainerProvider).length) == 2) {
                      // Добавить навигацию на страницу боя
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
