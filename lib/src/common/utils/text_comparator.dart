abstract interface class TextComparator {
  factory TextComparator() = TextComparatorImpl;

  (bool isSame, double samePercentage) compare(String text1, String text2);
}

final class TextComparatorImpl implements TextComparator {
  @override
  (bool, double) compare(String text1, String text2) {
    final similarity = _calculateSimilarity(text1, text2);
    final isSame = similarity >= 70;
    return (isSame, similarity);
  }

  double _calculateSimilarity(String text1, String text2) {
    var words1 = text1.split(' ').toSet();
    var words2 = text2.split(' ').toSet();
    var commonWords = words1.intersection(words2);
    var totalWords = words1.union(words2).length;
    return (commonWords.length / totalWords) * 100;
  }
}
