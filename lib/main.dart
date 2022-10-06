import 'package:flutter/material.dart';
import 'game.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomePage'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Start Game'),
          onPressed: () {
            // Navigate to second route when tapped.
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => InGameState()),
            );
          },
        ),
      ),
    );
  }
}

class InGameState extends StatefulWidget {
  @override
  _InGameState createState() => _InGameState();
}

class _InGameState extends State<InGameState> {
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  Game game = Game(5);
  int numDice = 5;

  void roll(Game game, List<DieIconButton> dButtons) {
    bool rolled = game.rollDice();
    if (rolled) {
      DiceSet diceSet = game.getCurrentDice();
      for (int i = 0; i < diceSet.numDice; i++) {
        setState(() => {dButtons[i].die = diceSet.dice[i]});
      }
    }
  }

  Image getDieImage(Die die) {
    return Image.asset(
        'graphics/dice/${die.value}${die.keep ? 'Kept' : ''}.png');
  }

  bool toggleDie(Die die) {
    setState(() {});
    return die.toggleDie();
  }

  @override
  Widget build(BuildContext context) {
    // Category Buttons
    ElevatedButton onesButton = ElevatedButton(
        onPressed: () => game.getCategoryScore(Category.ONES),
        child: const Text('Ones'));
    ElevatedButton twosButton = ElevatedButton(
        onPressed: () => game.getCategoryScore(Category.TWOS),
        child: const Text('Twos'));
    ElevatedButton threesButton = ElevatedButton(
        onPressed: () => game.getCategoryScore(Category.THREES),
        child: const Text('Threes'));
    ElevatedButton foursButton = ElevatedButton(
        onPressed: () => game.getCategoryScore(Category.FOURS),
        child: const Text('Fours'));
    ElevatedButton fivesButton = ElevatedButton(
        onPressed: () => game.getCategoryScore(Category.FIVES),
        child: const Text('Fives'));
    ElevatedButton sixesButton = ElevatedButton(
        onPressed: () => game.getCategoryScore(Category.SIXES),
        child: const Text('Sixes'));

    ElevatedButton toakButton = ElevatedButton(
        onPressed: () => game.getCategoryScore(Category.THREE_OF_A_KIND),
        child: const Text('ToaK'));
    ElevatedButton foakButton = ElevatedButton(
        onPressed: () => game.getCategoryScore(Category.FOUR_OF_A_KIND),
        child: const Text('FoaK'));
    ElevatedButton fhButton = ElevatedButton(
        onPressed: () => game.getCategoryScore(Category.FULL_HOUSE),
        child: const Text('FH'));
    ElevatedButton ssButton = ElevatedButton(
        onPressed: () => game.getCategoryScore(Category.SMALL_STRAIGHT),
        child: const Text('SS'));
    ElevatedButton lsButton = ElevatedButton(
        onPressed: () => game.getCategoryScore(Category.LARGE_STRAIGHT),
        child: const Text('LS'));
    ElevatedButton yeetButton = ElevatedButton(
        onPressed: () => game.getCategoryScore(Category.YEETZEE),
        child: const Text('Yeetzee'));
    ElevatedButton chanceButton = ElevatedButton(
        onPressed: () => game.getCategoryScore(Category.CHANCE),
        child: const Text('?'));

    //Die Buttons
    List<DieIconButton> diceIconButtons = [];
    for (int i = 0; i < numDice; i++) {
      Die d = game.getCurrentDie(i);
      diceIconButtons.add(DieIconButton(
          pos: i, die: d, icon: getDieImage(d), onPressed: () => toggleDie(d)));
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('In Game'),
        ),
        body: Column(children: [
          Expanded(
              child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Expanded(child: onesButton),
                    Expanded(child: twosButton),
                    Expanded(child: threesButton),
                    Expanded(child: foursButton),
                    Expanded(child: fivesButton),
                    Expanded(child: sixesButton),
                  ],
                ),
              ),
              Expanded(
                  child: Column(
                children: [
                  Expanded(child: toakButton),
                  Expanded(child: foakButton),
                  Expanded(child: fhButton),
                  Expanded(child: ssButton),
                  Expanded(child: lsButton),
                  Expanded(child: yeetButton),
                  Expanded(child: chanceButton),
                ],
              )),
            ],
          )),
          Expanded(
              child: Row(children: [
            Expanded(child: diceIconButtons[0]),
            Expanded(child: diceIconButtons[1]),
            Expanded(child: diceIconButtons[2]),
            Expanded(child: diceIconButtons[3]),
            Expanded(child: diceIconButtons[4]),
          ])),
          Expanded(
            child: ElevatedButton(
              onPressed: () => roll(game, diceIconButtons),
              child: const Text('Roll'),
            ),
          ),
        ]));
  }
}

class DieIconButton extends IconButton {
  int pos;
  Die die;

  DieIconButton({
    icon,
    onPressed,
    required this.pos,
    required this.die,
  }) : super(icon: icon, onPressed: onPressed);
}
