class Items {
  String expandedValue;
  String headerValue;
  bool isExpanded;

  Items(
      {required this.expandedValue,
      required this.headerValue,
      this.isExpanded = false});
}

List<Items> generateItem(int number) {
  return List.generate(number, (index) {
    return Items(
        headerValue: 'Panel $index', expandedValue: 'This is item $index');
  });
}
