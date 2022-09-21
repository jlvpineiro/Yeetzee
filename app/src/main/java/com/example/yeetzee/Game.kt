package com.example.yeetzee
import kotlin.random.Random

enum class Categories {
    ONES, TWOS, THREES, FOURS, FIVES, SIXES,
    THREE_OF_A_KIND, FOUR_OF_A_KIND, FULL_HOUSE,
    SMALL_STRAIGHT, LARGE_STRAIGHT, yeetzee, CHANCE
}

class Game (NUM_DICE: Int) {

    var p1 = Player(NUM_DICE);
    var p2 = Player(NUM_DICE);

    var currentTurn = 0;
}

class Player (NUM_DICE : Int) {
    var playerDice = DiceSet(NUM_DICE);
    var score = 0;

    var categoryScores = mutableMapOf<Categories, Int>(
        Categories.ONES to -1,
        Categories.TWOS to -1,
        Categories.THREES to -1,
        Categories.FOURS to -1,
        Categories.FIVES to -1,
        Categories.SIXES to -1,

        Categories.THREE_OF_A_KIND to -1,
        Categories.FOUR_OF_A_KIND to -1,
        Categories.FULL_HOUSE to -1,

        Categories.SMALL_STRAIGHT to -1,
        Categories.LARGE_STRAIGHT to -1,
        Categories.yeetzee to -1,
        Categories.CHANCE to -1
    )

    fun updateScore(category: Categories, newScore: Int) {
        this.categoryScores[category] = newScore;
        this.score += newScore;
    }

    fun checkCategoryPlayable(category: Categories) : Boolean {
        return categoryScores.getValue(category) != -1;
    }

}

class DiceSet (_NUM_DICE: Int) {

    val NUM_DICE = _NUM_DICE;

    var dice = initDice(NUM_DICE);

    /**
     * Initializes a set of [numDice] dice (usually 5).
     */
    fun initDice(numDice: Int) : Array<Die>{
        return Array(numDice) {Die()}
    }


    /**
     * Rolls only dice that can be rolled. Updates dice if any can roll.
     */
    fun rollDice() {
        var allKeep = true;
        for (d in this.dice) {
            val newDieValue = d.roll();
            if (newDieValue > 0) {
                allKeep = false;
            }
        }

        if (allKeep) {
            noRoll();
        } else {
            completeRoll();
        }
    }

    /**
     * Notifies player that no dice can be rolled. Nothing else happens.
     */
    fun noRoll() {

    }

    /**
     * Runs the roll animation and increments the number of rolls that the player has taken.
     */
    fun completeRoll() {

    }

    /**
     * Returns a map with counts of each die value in a dice set.
     */
    private fun countDice() : Map<Int, Int> {
        val valueCounts = mutableMapOf<Int, Int>(
            1 to 0,
            2 to 0,
            3 to 0,
            4 to 0,
            5 to 0,
            6 to 0
        );
        for (d in this.dice) {
            valueCounts[d.value] = valueCounts.getValue(d.value) + 1;
        }
        return valueCounts;
    }

    /**
     * Sums the face values of each die in a dice set.
     */
    private fun sumDice() : Int {
        var total = 0;
        for (d in this.dice) {total += d.value;}
        return total;
    }

    /**
     * Checks the value of the dice set for a particular category
     */
    fun checkDice(category: Categories) : Int {

        var total = 0;
        when (category) {

            Categories.ONES -> {
                for (d in this.dice) {
                    if (d.value == 1) {
                        total += d.value;
                    }
                }
            }

            Categories.TWOS -> {
                for (d in this.dice) {
                    if (d.value == 2) {
                        total += d.value;
                    }
                }
            }

            Categories.THREES -> {
                for (d in this.dice) {
                    if (d.value == 3) {
                        total += d.value;
                    }
                }
            }

            Categories.FOURS -> {
                for (d in this.dice) {
                    if (d.value == 4) {
                        total += d.value;
                    }
                }
            }

            Categories.FIVES -> {
                for (d in this.dice) {
                    if (d.value == 5) {
                        total += d.value;
                    }
                }
            }

            Categories.SIXES -> {
                for (d in this.dice) {
                    if (d.value == 6) {
                        total += d.value;
                    }
                }
            }

            Categories.THREE_OF_A_KIND -> {
                val valueCounts = this.countDice();
                var flag = false;
                valueCounts.forEach {if (it.value >= 3) {flag = true;}}
                if (flag) {total = this.sumDice();}
            }

            Categories.FOUR_OF_A_KIND -> {
                val valueCounts = this.countDice();
                var flag = false;
                valueCounts.forEach {if (it.value >= 4) {flag = true;}}
                if (flag) {total = this.sumDice();}
            }

            Categories.FULL_HOUSE -> {
                val valueCounts = this.countDice();
                var isThree = false;
                var isTwo = false;
                valueCounts.forEach {
                    if (it.value == 3) {isThree = true;}
                    if (it.value == 2) {isTwo = true;}
                }
                if (isThree && isTwo) {total = 25;}
            }

            Categories.SMALL_STRAIGHT -> {
                val valueCounts = this.countDice();
                if (valueCounts.getValue(3) >= 1 && valueCounts.getValue(4) >= 1) {
                    if (valueCounts.getValue(1) >= 1 && valueCounts.getValue(2) >= 1) {total = 30;}
                    else if (valueCounts.getValue(2) >= 1 && valueCounts.getValue(5) >= 1) {total = 30;}
                    else if (valueCounts.getValue(5) >= 1 && valueCounts.getValue(6) >= 1) {total = 30;}
                }
            }

            Categories.LARGE_STRAIGHT -> {
                val valueCounts = this.countDice();
                if (valueCounts.getValue(2) == 1 && valueCounts.getValue(3) == 1 && valueCounts.getValue(4) == 1 && valueCounts.getValue(5) == 1) {
                    total = 40;
                }
            }

            Categories.yeetzee -> {
                var idx = 0;
                while (idx + 1 < NUM_DICE && idx + 2 < NUM_DICE && dice[idx].value == dice[idx+1].value) {idx++}
                if (idx + 2 == NUM_DICE) {
                    total = 50;
                }
            }

            Categories.CHANCE -> {
                total = this.sumDice();
            }
        }
        return total;
    }
}

class Die() {

    var keep = false;
    var value = 0;
    var unrolled = true;

    /**
     * Checks if the die can be rolled, rolls it if it can, and returns either
     * the new value or -1 if it can't be rolled.
     */
    fun roll(): Int {
        this.unrolled = false;
        if (!this.keep) {
            val newValue = Random(System.nanoTime()).nextInt(1, 7);
            this.value = newValue;
            return newValue;
        } else {
            return -1;
        }
    }

    /**
     * Toggles whether a die can be rolled.
     */
    fun toggleDie() : Boolean {
        keep = !keep;
        return keep;
    }
}