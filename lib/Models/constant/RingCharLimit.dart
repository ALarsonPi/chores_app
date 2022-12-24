class RingCharLimits {
  static RingCharLimit twoItemLimit =
      RingCharLimit(numItems: 2, secondRingLimit: 35, thirdRingLimit: 45);
  static RingCharLimit threeItemLimit =
      RingCharLimit(numItems: 3, secondRingLimit: 30, thirdRingLimit: 40);
  static RingCharLimit fourItemLimit =
      RingCharLimit(numItems: 4, secondRingLimit: 25, thirdRingLimit: 35);
  static RingCharLimit fiveItemLimit =
      RingCharLimit(numItems: 5, secondRingLimit: 20, thirdRingLimit: 30);
  static RingCharLimit sixItemLimit =
      RingCharLimit(numItems: 6, secondRingLimit: 15, thirdRingLimit: 25);
  static RingCharLimit sevenItemLimit =
      RingCharLimit(numItems: 7, secondRingLimit: 12, thirdRingLimit: 20);
  static RingCharLimit eightItemLimit =
      RingCharLimit(numItems: 8, secondRingLimit: 12, thirdRingLimit: 20);
}

class RingCharLimit {
  RingCharLimit({
    required this.numItems,
    required this.secondRingLimit,
    required this.thirdRingLimit,
  });

  int numItems;
  int secondRingLimit;
  int thirdRingLimit;
}
