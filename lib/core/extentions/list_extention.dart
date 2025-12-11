extension ListExtension<T> on List<T> {
  bool containsAll(List<T> elementsToCheck) {
    return elementsToCheck.every((element) => contains(element));
  }
}
