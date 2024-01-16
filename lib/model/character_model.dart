class Character {
  final int id;
  final String name;
  final String species;
  final String gender;
  final Map origin;
  final Map location;
  final String image;

  Character({required this.id, required this.name, required this.species, required this.gender, required this.origin, required this.location, required this.image});

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'],
      name: json['name'],
      species: json['species'],
      gender: json['gender'],
      origin: json['origin'],
      location: json['location'],
      image: json['image'],
    );
  }
}