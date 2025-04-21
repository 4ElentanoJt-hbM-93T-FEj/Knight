import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gladiators/provider/provider.dart';
import 'package:lottie/lottie.dart';

class ArenaPage extends ConsumerStatefulWidget {
  const ArenaPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ArenaPageState();
}

class _ArenaPageState extends ConsumerState<ArenaPage> {
  String resultBattle = "";

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: LottieBuilder.asset(
                ref.watch(battleStatusProvider) == "Ожидание"
                    ? "lib/assets/animation/battle_anim.json"
                    : "lib/assets/animation/finish_1.json",
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Expanded(
                    child: Text(
                      "Статус игры: ${ref.watch(battleStatusProvider)}",
                      style: TextStyle(fontSize: 24),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          Text("История боя", style: TextStyle(fontSize: 24)),
                          Text(HistoryBattle.historyBattle),
                        ],
                      ),
                    ),
                  ),
                ),
                ref.watch(battleStatusProvider) == "Ожидание"
                    ? Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              ref
                                  .read(battleStatusProvider.notifier)
                                  .changeStatus("Идёт сражение");

                              ref
                                  .read(battleStatusProvider.notifier)
                                  .changeStatus(
                                    await Battle.fight(
                                      ref.read(gladiatorsContainerProvider)[0],
                                      ref.read(gladiatorsContainerProvider)[1],
                                    ),
                                  );
                            },
                            child: Text("Начать бой"),
                          ),
                        ],
                      ),
                    )
                    : SizedBox(),
              ],
            ),
          ),

          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [Text("Arena")],
          // ),
          // SizedBox(
          //   width: MediaQuery.of(context).size.width,
          //   height: MediaQuery.of(context).size.height,
          //   child: Image.asset('lib/assets/img/kuznets.jpg', fit: BoxFit.cover),
          // ),
        ],
      ),
    );
  }
}
