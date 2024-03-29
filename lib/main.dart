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

extension CategoryToString on Category {
  String toShortString() {
    return toString().split('.').last;
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

  void submitTurn() {
    game.submitTurn();
    setState(() {});
  }

  Image getDieImage(Die die) {
    return Image.asset(
        'graphics/dice/${die.value}${die.keep ? 'Kept' : ''}.png');
  }

  bool toggleDie(Die die) {
    setState(() {});
    return die.toggleDie();
  }

  void selectCategory(Category category) {
    if (game.getCurrentPlayer().categoryScores[category] == -1 &&
        !game.getCurrentDice().unRolled()) {
      game.selectedCategory = category;
      setState(() {});
    }
  }

  String getCategoryButtonText(Category category) {
    String categoryString = category.toShortString();
    if (game.selectedCategory == category) {
      return '$categoryString: $categoryString';
    } else if (game.getCurrentPlayer().categoryScores[category]! > -1) {
      return '$categoryString: ${game.getCurrentPlayer().categoryScores[category]}';
    } else {
      return categoryString;
    }
  }

  String getCategoryButtonScoreText(Category category) {
    if (game.selectedCategory == category) {
      return game.getCategoryScore(category).toString().padLeft(2, " ");
    } else if (game.getCurrentPlayer().categoryScores[category]! > -1) {
      return game
          .getCurrentPlayer()
          .categoryScores[category]
          .toString()
          .padLeft(2, " ");
    } else {
      return "  ";
    }
  }

  List<Category> categories = [
    Category.ONES,
    Category.TWOS,
    Category.THREES,
    Category.FOURS,
    Category.FIVES,
    Category.SIXES,
    Category.THREE_OF_A_KIND,
    Category.FOUR_OF_A_KIND,
    Category.FULL_HOUSE,
    Category.SMALL_STRAIGHT,
    Category.LARGE_STRAIGHT,
    Category.YEETZEE,
    Category.CHANCE
  ];

  Image getCategoryButtonImage(Category category) {
    String categoryString = category.toShortString().toLowerCase();
    return Image.asset('graphics/categories/$categoryString.png');
  }

  IconButton createCategoryButton(Category category) {
    return IconButton(
        onPressed: () => selectCategory(category),
        icon: getCategoryButtonImage(category));
  }

  List<IconButton> createCategoryButtonsList(List<Category> categories) {
    List<IconButton> categoryButtons = [];
    for (int i = 0; i < categories.length; i++) {
      categoryButtons.add(createCategoryButton(categories[i]));
    }
    return categoryButtons;
  }

  Widget createCategoryButtonWidgetList(List<Category> categories) {
    List<Widget> categoryButtonWidgets = [];
    categories.forEach((category) => {
          categoryButtonWidgets.add(Expanded(
              child: Row(
            children: [
              Expanded(child: createCategoryButton(category)),
              Text(getCategoryButtonScoreText(category))
            ],
          )))
        });

    return Column(children: categoryButtonWidgets);
  }

  List<DieIconButton> createDiceIconButtons(numDice) {
    List<DieIconButton> diceIconButtons = [];
    for (int i = 0; i < numDice; i++) {
      Die d = game.getCurrentDie(i);
      diceIconButtons.add(DieIconButton(
          pos: i, die: d, icon: getDieImage(d), onPressed: () => toggleDie(d)));
    }
    return diceIconButtons;
  }

  @override
  Widget build(BuildContext context) {
    // Category Buttons
    List<IconButton> categoryButtons = createCategoryButtonsList(categories);

    //Die Buttons
    List<DieIconButton> diceIconButtons = createDiceIconButtons(numDice);

    return Scaffold(
        appBar: AppBar(
          title: const Text('In Game'),
        ),
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("graphics/board.png"),
                    fit: BoxFit.cover)),
            child: Column(children: [
              Text(
                  'Player: ${game.currentTurn % 2 != 0 ? 1 : 2}, Rolls: ${game.rolls}/3'),
              Text('P1 Score: ${game.p1.score}, P2 Score: ${game.p2.score}'),
              Expanded(
                  child: Row(
                children: [
                  Expanded(
                      child: createCategoryButtonWidgetList(
                          categories.sublist(0, 6))

                      // child: Column(
                      //   children: [
                      //     Expanded(child: categoryButtons[0]),
                      //     Expanded(child: categoryButtons[1]),
                      //     Expanded(child: categoryButtons[2]),
                      //     Expanded(child: categoryButtons[3]),
                      //     Expanded(child: categoryButtons[4]),
                      //     Expanded(child: categoryButtons[5]),
                      //   ],
                      // ),
                      ),
                  Expanded(
                      child:
                          createCategoryButtonWidgetList(categories.sublist(6))
                      //     child: Column(
                      //   children: [
                      //     Expanded(child: categoryButtons[6]),
                      //     Expanded(child: categoryButtons[7]),
                      //     Expanded(child: categoryButtons[8]),
                      //     Expanded(child: categoryButtons[9]),
                      //     Expanded(child: categoryButtons[10]),
                      //     Expanded(child: categoryButtons[11]),
                      //     Expanded(child: categoryButtons[12]),
                      //   ],
                      // )
                      ),
                ],
              )),
              Row(children: [
                Expanded(child: diceIconButtons[0]),
                Expanded(child: diceIconButtons[1]),
                Expanded(child: diceIconButtons[2]),
                Expanded(child: diceIconButtons[3]),
                Expanded(child: diceIconButtons[4]),
              ]),
              ElevatedButton(
                onPressed: () => roll(game, diceIconButtons),
                child: const Text('Roll'),
              ),
              ElevatedButton(
                onPressed: submitTurn,
                child: const Text('Submit'),
              ),
            ])));
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
