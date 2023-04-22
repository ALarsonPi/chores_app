import 'dart:math';

import 'package:chore_app/Widgets/ConcentricChart/RotatingPieChart/Objects/PieInfo.dart';
import 'package:flutter/material.dart';

import '../Objects/PieChartItem.dart';

class TextParsingService {
  TextParsingService(
    this.numChunks,
    this.spaceBetweenLines,
    this.overflowLineLimit,
    double ringBorder1,
    double ringBorder2,
    this.overflowLimitProportion,
    this.pieTextStyle,
  ) {
    middleVeritcalRadius = (ringBorder1 + ringBorder2) / 2;
  }
  int numChunks;
  double spaceBetweenLines;
  int overflowLineLimit;
  double overflowLimitProportion;
  TextStyle pieTextStyle;
  late double middleVeritcalRadius;

  late List<PieChartItem> items;

  setItems(List<PieChartItem> items) {
    this.items = items;
  }

  List<PieChartItem> getItems() {
    return items;
  }

  int getNumChunks() {
    return numChunks;
  }

  void setNumChunks(int newNum) {
    numChunks = newNum;
  }

  List<List<String>> chunkPhraseList = List.empty(growable: true);
  List<List<String>> reversePhraseChunkList = List.empty(growable: true);
  List<List<double>> forwardAlphaList = List.empty(growable: true);
  List<List<double>> reverseAlphaList = List.empty(growable: true);

  List<List<String>> getChunkPhraseList() => chunkPhraseList;
  List<List<String>> getReversePhraseChunkList() => reversePhraseChunkList;
  List<List<double>> getForwardAlphaList() => forwardAlphaList;
  List<List<double>> getReverseAlphaList() => reverseAlphaList;

  void clearAllTextLists() {
    chunkPhraseList.clear();
    reversePhraseChunkList.clear();
    forwardAlphaList.clear();
    reverseAlphaList.clear();
  }

  /// Sets up all the lists - phrases and alpha lists for upper and lower quadrants
  setUpPhraseChunks(int numChunks, List<PieChartItem> items) {
    assert(numChunks > 0);
    clearAllTextLists();
    for (int i = 0; i < numChunks; i++) {
      setUpPhraseChunkAndAddToLists(items[i].name);
    }
    fillAlphaLists();
  }

  /// Checks to see if the phrase should overflow into the next line
  /// Should overflow if the alphaDifference (chunkAlpha - actualAlphaOfPhrase)
  /// is less than the limit provided by the overflowLimitProportion
  bool checkIfShouldOverflow(double alphaDifference) {
    return alphaDifference <= overflowLimitProportion;
  }

  /// Master method that gets overflowed chunks and adds them to the appropriate lists
  void setUpPhraseChunkAndAddToLists(String fullPhrase) {
    List<String> forwardPhrases = getOverflowedPhrasePartsForChunk(fullPhrase);
    List<String> reversePhrases = getOverflowedPhrasePartsForReverseChunk(
        fullPhrase, forwardPhrases.length);
    assert(forwardPhrases.isNotEmpty);
    assert(reversePhrases.isNotEmpty);
    chunkPhraseList.add(forwardPhrases);
    reversePhraseChunkList.add(reversePhrases);
  }

  /// For forward phrases, this function splits the phrase into chunks that
  /// all fit into the segment. Returns a list of those split phrases for the chunks
  List<String> getOverflowedPhrasePartsForChunk(String fullPhrase) {
    List<String> phrasesToReturn = List.empty(growable: true);
    String currPhrase = fullPhrase;
    double radiusToMeasureAgainst = getMiddleVerticalRadius();

    double phraseAlpha =
        getTotalPhraseAlpha(currPhrase, radiusToMeasureAgainst);
    double chunkDifference = (2 * pi / numChunks) - phraseAlpha;

    bool isOverflowing = checkIfShouldOverflow(chunkDifference);
    int numLines = 1;
    if (isOverflowing) {
      // If it's one word, don't split
      if ((currPhrase.split(" ").length == 1)) {
        // Unless it has a char breakpoint
        if (!phraseHasCharacterBreakpoint(currPhrase)) {
          phrasesToReturn.add(currPhrase);
          return phrasesToReturn;
        }
      }
      while (isOverflowing && numLines <= overflowLineLimit) {
        phraseAlpha = getTotalPhraseAlpha(currPhrase, radiusToMeasureAgainst);
        chunkDifference = (2 * pi / numChunks) - phraseAlpha;

        radiusToMeasureAgainst -= spaceBetweenLines;

        if (checkIfShouldOverflow(chunkDifference) &&
            numLines <= overflowLineLimit) {
          List<String> splitPhraseParts = splitPhraseForOverflow(currPhrase);
          currPhrase = splitPhraseParts.last;

          // Check for special case where we're finishing up and need to add
          // the last line due to the overflow limit
          phraseAlpha = getTotalPhraseAlpha(currPhrase, radiusToMeasureAgainst);
          chunkDifference = (2 * pi / numChunks) - phraseAlpha;
          if (numLines == overflowLineLimit) {
            if (splitPhraseParts.first.characters.last == "-") {
              splitPhraseParts.first = splitPhraseParts.first
                  .substring(0, splitPhraseParts.first.length - 1);
            }
            splitPhraseParts.first += splitPhraseParts.last;
            phrasesToReturn.add(splitPhraseParts.first);
          } else {
            phrasesToReturn.add(splitPhraseParts.first);
          }
        } else {
          isOverflowing = false;
          phrasesToReturn.add(currPhrase);
        }
        numLines++;
      }
    } else {
      phrasesToReturn.add(fullPhrase);
    }

    return phrasesToReturn;
  }

  /// For reverse phrases (those which will be used in the lower quadrants),
  /// this function splits the phrase into chunks that
  /// all fit into the segment. Returns a list of those split phrases for the chunks
  List<String> getOverflowedPhrasePartsForReverseChunk(
      String fullPhrase, int numLines) {
    List<String> phrasesToReturn = List.empty(growable: true);

    //Reverse string so that the split actually makes
    //sense when we reverse everything back
    String currPhrase = fullPhrase.split('').reversed.join();

    double radiusToMeasureAgainst = getMiddleVerticalRadius() -
        (spaceBetweenLines * numLines) +
        (3 * spaceBetweenLines / 2);

    double phraseAlpha =
        getTotalPhraseAlpha(currPhrase, radiusToMeasureAgainst);
    double chunkDifference = (2 * pi / numChunks) - phraseAlpha;

    bool isOverflowing = checkIfShouldOverflow(chunkDifference);
    if (isOverflowing) {
      // If it's one word, don't split
      if ((currPhrase.split(" ").length == 1)) {
        // Unless it has a char breakpoint
        if (!phraseHasCharacterBreakpoint(currPhrase)) {
          phrasesToReturn.add(currPhrase);
          return phrasesToReturn;
        }
      }
      int numLines = 1;
      while (isOverflowing && numLines <= overflowLineLimit) {
        phraseAlpha = getTotalPhraseAlpha(currPhrase, radiusToMeasureAgainst);
        chunkDifference = (2 * pi / numChunks) - phraseAlpha;

        radiusToMeasureAgainst += spaceBetweenLines;

        if (checkIfShouldOverflow(chunkDifference) &&
            numLines != overflowLineLimit) {
          List<String> splitPhraseParts = splitPhraseForOverflow(currPhrase);
          currPhrase = splitPhraseParts.last;

          // Check for special case where we're finishing up and need to add
          // the last line due to the overflow limit
          phraseAlpha = getTotalPhraseAlpha(currPhrase, radiusToMeasureAgainst);
          chunkDifference = (2 * pi / numChunks) - phraseAlpha;
          if (numLines == overflowLineLimit) {
            if (splitPhraseParts.first.characters.last == "-") {
              splitPhraseParts.first = splitPhraseParts.first
                  .substring(0, splitPhraseParts.first.length - 1);
            }
            splitPhraseParts.first += splitPhraseParts.last;
            phrasesToReturn.add(splitPhraseParts.first);
          } else {
            phrasesToReturn.add(splitPhraseParts.first);
          }
        } else {
          isOverflowing = false;
          phrasesToReturn.add(currPhrase);
        }
        numLines++;
      }
    } else {
      // If there's only one (no overflow)
      phrasesToReturn.add(fullPhrase.split('').reversed.join());
    }

    for (int i = 0; i < phrasesToReturn.length; i++) {
      phrasesToReturn[i] = phrasesToReturn[i].split('').reversed.join();
    }

    return phrasesToReturn.reversed.toList();
  }

  /// Fills the alpha lists for each chunk of phrases
  fillAlphaLists() {
    for (List<String> phrasesInAChunk in chunkPhraseList) {
      List<double> alphaList =
          createAlphaListForward(phrasesInAChunk, getMiddleVerticalRadius());
      forwardAlphaList.add(alphaList);
    }
    for (List<String> reversePhrasesInAChunk in reversePhraseChunkList) {
      List<double> alphaListReverse = createAlphaListReverse(
          reversePhrasesInAChunk, getMiddleVerticalRadius());
      reverseAlphaList.add(alphaListReverse);
    }
  }

  /// Creates the alpha list for lower quadrant phrases
  List<double> createAlphaListReverse(
      List<String> reversePhrases, double initialRadius) {
    List<double> alphaList = List.empty(growable: true);
    double currRadius = initialRadius;
    for (String phrase in reversePhrases.reversed) {
      alphaList.add(getTotalPhraseAlpha(phrase, currRadius));
      currRadius -= spaceBetweenLines;
    }
    return alphaList;
  }

  /// Creates the alpha list for forward phrases
  List<double> createAlphaListForward(
      List<String> phrases, double initialRadius) {
    List<double> alphaList = List.empty(growable: true);
    double currRadius = initialRadius;
    for (String phrase in phrases) {
      alphaList.add(getTotalPhraseAlpha(phrase, currRadius));
      currRadius -= spaceBetweenLines;
    }
    return alphaList;
  }

  /// Splits a phrase if overflow is necessary.
  /// Finds where the string needs to split to no longer be overflowing.
  /// Then, tries to find a space ' ' a certain number of letters before
  /// but if it can't find a space, will just add a hyphen and split from there
  List<String> splitPhraseForOverflow(String phraseToSplit) {
    List<String> phraseParts = List.empty(growable: true);
    int numLettersToCheck = 6;

    bool shouldOverflow = true;
    int index = phraseToSplit.length;
    String subString = phraseToSplit;
    for (; index > 1; index--) {
      subString = phraseToSplit.substring(0, index);
      double phraseAlpha =
          getTotalPhraseAlpha(subString, getMiddleVerticalRadius());
      double alphaDifference = (2 * pi / numChunks) - phraseAlpha;
      shouldOverflow = checkIfShouldOverflow(alphaDifference);
      if (!shouldOverflow) {
        break;
      }
    }
    String spaceSubString = subString;
    int index2 = index;
    bool foundSpace = false;
    for (int checkerIndex = 0;
        checkerIndex <= numLettersToCheck;
        checkerIndex++) {
      index2 = subString.length - checkerIndex;
      spaceSubString = subString.substring(0, index2);
      if (index2 == 0) {
        break;
      }
      assert(spaceSubString.isNotEmpty);

      if (hasCharacterBreakpoint(spaceSubString.characters.last)) {
        foundSpace = true;
        break;
      }
    }
    if (foundSpace) {
      // Minus 1 to account for the space
      phraseParts.add(phraseToSplit.substring(0, index2));
      phraseParts.add(phraseToSplit.substring(index2));
    } else {
      // Minus 1 to account for the hyphen
      // ignore: prefer_interpolation_to_compose_strings
      phraseParts.add(phraseToSplit.substring(0, index - 1) + "-");
      phraseParts.add(phraseToSplit.substring(index - 1));
    }

    return phraseParts;
  }

  bool hasCharacterBreakpoint(var currChar) {
    List acceptableBreakpoints = [" ", "\t", "\n", "-", ",", ".", "_", "/"];
    bool foundBreakpoint = false;
    for (var breakpoint in acceptableBreakpoints) {
      if (currChar == breakpoint) {
        foundBreakpoint = true;
      }
    }
    return foundBreakpoint;
  }

  bool phraseHasCharacterBreakpoint(String currPhrase) {
    bool hasBreakpointChar = false;
    for (var currChar in currPhrase.toString().characters) {
      if (hasCharacterBreakpoint(currChar)) {
        hasBreakpointChar = true;
      }
    }
    return hasBreakpointChar;
  }

  double getMiddleVerticalRadius() {
    return middleVeritcalRadius;
  }

  /// Gets the alpha for a phrase using the [getAlphaForSpecificLetter] method
  double getTotalPhraseAlpha(String word, double desiredRadius) {
    double sum = 0;
    for (var currLetter in word.characters) {
      sum += getAlphaForSpecificLetter(currLetter, desiredRadius);
    }
    return sum;
  }

  final _testPainter = TextPainter(textDirection: TextDirection.ltr);

  /// Gets the alpha for a specific letter based on it's size and fontstyle
  double getAlphaForSpecificLetter(String letter, double desiredRadius) {
    _testPainter.text = TextSpan(
      text: letter,
      style: pieTextStyle,
    );
    _testPainter.layout(
      minWidth: 0,
      maxWidth: double.maxFinite,
    );
    final double d = _testPainter.width;
    final double alpha = 2 * asin(d / (2 * desiredRadius));
    return alpha;
  }
}
