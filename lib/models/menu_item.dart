class MenuItem {
  const MenuItem({
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.badge,
    required this.image,
  });

  final String name;
  final String description;
  final int price;
  final String category;
  final String badge;
  final String image;
}
