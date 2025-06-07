class AboutItem {
  final String title;
  final String description;

  /// NOTE Represents an item in the About section of the application.
  /// NOTE Contains fields for title and description.
  AboutItem({required this.title, required this.description});

  /// NOTE Factory constructor to create an AboutItem instance from a JSON map.
  /// NOTE Contains fields for title and description.
  factory AboutItem.fromJson(Map<String, dynamic> json) {
    return AboutItem(
      title: json['title'] as String,
      description: json['description'] as String,
    );
  }
}
