import 'dart:math';

enum Category {
  ONES,
  TWOS,
  THREES,
  FOURS,
  FIVES,
  SIXES,
  THREE_OF_A_KIND,
  FOUR_OF_A_KIND,
  FULL_HOUSE,
  SMALL_STRAIGHT,
  LARGE_STRAIGHT,
  YEETZEE,
  CHANCE
}

class Game {
  Player p1;
  Player p2;
  int currentTurn;

  Game(int numDice)
      : p1 = Player(numDice),
        p2 = Player(numDice),
        currentTurn = 1;

  Player getCurrentPlayer() {
    if (currentTurn % 2 != 0) {
      return p1;
    } else {
      return p2;
    }
  }

  int getCategoryScore(Category category) {
    return getCurrentDice().checkDice(category);
  }

  bool rollDice() {
    return getCurrentPlayer().rollDice();
  }

  DiceSet getCurrentDice() {
    return getCurrentPlayer().getCurrentDice();
  }

  Die getCurrentDie(int diePosition) {
    return getCurrentDice().dice[diePosition];
  }

  List<int> getCurrentDiceValues() {
    return getCurrentPlayer().getCurrentDiceValues();
  }
}

class Player {
  DiceSet playerDice;
  int score;

  Player(int numDice)
      : playerDice = DiceSet(numDice),
        score = 0;

  Map<Category, int> categoryScores = {
    Category.ONES: -1,
    Category.TWOS: -1,
    Category.THREES: -1,
    Category.FOURS: -1,
    Category.FIVES: -1,
    Category.SIXES: -1,
    Category.THREE_OF_A_KIND: -1,
    Category.FOUR_OF_A_KIND: -1,
    Category.FULL_HOUSE: -1,
    Category.SMALL_STRAIGHT: -1,
    Category.LARGE_STRAIGHT: -1,
    Category.YEETZEE: -1,
    Category.CHANCE: -1
  };

  bool rollDice() {
    return playerDice.rollDice();
  }

  List<int> getCurrentDiceValues() {
    return playerDice.getDiceValues();
  }

  DiceSet getCurrentDice() {
    return playerDice;
  }

  void updateScore(Category category, int newScore) {
    categoryScores[category] = newScore;
    score += newScore;
  }

  bool checkCategoryPlayable(Category category) {
    return categoryScores[category] != -1;
  }
}

class DiceSet {
  int numDice;
  List<Die> dice = [];

  DiceSet(this.numDice) {
    dice = initDice(numDice);
  }

  /// Initializes a set of [numDice] dice (usually 5).
  List<Die> initDice(int numDice) {
    List<Die> dice = [];
    for (int i = 0; i < numDice; i++) {
      dice.add(Die());
    }
    return dice;
  }

  /// Rolls only dice that can be rolled. Updates dice if any can roll.
  bool rollDice() {
    bool allKeep = true;
    for (Die d in dice) {
      int newDieValue = d.roll();
      if (newDieValue > 0) {
        allKeep = false;
      }
    }
    if (allKeep) {
      noRoll();
    } else {
      completeRoll();
    }
    return !allKeep;
  }

  /// Notifies player that no dice can be rolled. Nothing else happens.
  void noRoll() {
    print("Can't roll dice, all are being kept");
  }

  /// Runs the roll animation and increments the number of rolls that the player has taken.
  void completeRoll() {
    List<int> diceValues = getDiceValues();
    print(diceValues);
  }

  /// Returns a list of the die values
  List<int> getDiceValues() {
    List<int> diceValues = [];
    for (Die d in dice) {
      {
        diceValues.add(d.value);
      }
    }
    return diceValues;
  }

  /// Returns a map with counts of each die value in a dice set.
  Map<int, int> countDice() {
    Map<int, int> valueCounts = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0};

    for (Die d in dice) {
      valueCounts[d.value] = valueCounts[d.value]! + 1;
    }

    return valueCounts;
  }

  /// Sums the face values of each die in a dice set.
  int sumDice() {
    var total = 0;
    for (Die d in dice) {
      total += d.value;
    }
    return total;
  }

  /// Checks the value of the dice set for a particular category
  int checkDice(Category category) {
    int total = 0;
    switch (category) {
      case Category.ONES:
        for (Die d in dice) {
          if (d.value == 1) {
            total += d.value;
          }
        }
        break;

      case Category.TWOS:
        for (Die d in dice) {
          if (d.value == 2) {
            total += d.value;
          }
        }
        break;

      case Category.THREES:
        for (Die d in dice) {
          if (d.value == 3) {
            total += d.value;
          }
        }
        break;

      case Category.FOURS:
        for (Die d in dice) {
          if (d.value == 4) {
            total += d.value;
          }
        }
        break;

      case Category.FIVES:
        for (Die d in dice) {
          if (d.value == 5) {
            total += d.value;
          }
        }
        break;

      case Category.SIXES:
        for (Die d in dice) {
          if (d.value == 6) {
            total += d.value;
          }
        }
        break;

      case Category.THREE_OF_A_KIND:
        var valueCounts = countDice();
        var flag = false;
        valueCounts.forEach((k, v) => {
              if (v >= 3) {flag = true}
            });
        if (flag) {
          total = sumDice();
        }
        break;

      case Category.FOUR_OF_A_KIND:
        var valueCounts = countDice();
        var flag = false;
        valueCounts.forEach((k, v) => {
              if (v >= 4) {flag = true}
            });
        if (flag) {
          total = sumDice();
        }
        break;

      case Category.FULL_HOUSE:
        var valueCounts = countDice();
        bool isThree = false;
        bool isTwo = false;
        valueCounts.forEach((k, v) => {
              if (v == 3) {isThree = true},
              if (v == 2) {isTwo = true}
            });

        if (isThree && isTwo) {
          total = 25;
        }
        break;

      case Category.SMALL_STRAIGHT:
        var valueCounts = countDice();
        if (valueCounts[3]! >= 1 && valueCounts[4]! >= 1) {
          if (valueCounts[1]! >= 1 && valueCounts[2]! >= 1) {
            total = 30;
          } else if (valueCounts[2]! >= 1 && valueCounts[5]! >= 1) {
            total = 30;
          } else if (valueCounts[5]! >= 1 && valueCounts[6]! >= 1) {
            total = 30;
          }
        }
        break;

      case Category.LARGE_STRAIGHT:
        var valueCounts = countDice();
        if (valueCounts[2] == 1 &&
            valueCounts[3] == 1 &&
            valueCounts[4] == 1 &&
            valueCounts[5] == 1) {
          total = 40;
        }
        break;

      case Category.YEETZEE:
        int idx = 0;
        while (idx + 1 < numDice &&
            idx + 2 < numDice &&
            dice[idx].value == dice[idx + 1].value) {
          idx++;
        }
        if (idx + 2 == numDice) {
          total = 50;
        }
        break;

      case Category.CHANCE:
        total = sumDice();
        break;

      default:
        total = 0;
        print("wtf");
    }

    print('Total = $total');
    return total;
  }
}

class Die {
  bool keep;
  int value;
  bool unrolled;

  Die()
      : keep = false,
        value = 0,
        unrolled = true;

  /// Checks if the die can be rolled, rolls it if it can.
  /// Returns either the new value or -1 if it can't be rolled.
  int roll() {
    unrolled = false;
    if (!keep) {
      int newValue = Random().nextInt(5) + 1;
      print('Changing value from $value to $newValue');
      value = newValue;
      return newValue;
    } else {
      print('Keeping value at $value');
      return -1;
    }
  }

  /// Toggles whether a die can be rolled.
  bool toggleDie() {
    if (!unrolled) {
      keep = !keep;
      print('Toggling from ${!keep} to $keep');
    }
    return keep;
  }
}
