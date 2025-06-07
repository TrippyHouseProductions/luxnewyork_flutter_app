class AboutItem {
  final String title;
  final String description;

  AboutItem({required this.title, required this.description});

  factory AboutItem.fromJson(Map<String, dynamic> json) {
    return AboutItem(
      title: json['title'] as String,
      description: json['description'] as String,
    );
  }
}
