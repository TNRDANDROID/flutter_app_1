
class Tag {
  String name;
  String id;

  Tag(this.name, this.id);

  factory Tag.fromJson(dynamic json) {
    return Tag(json['name'] as String, json['id'] as String);
  }

  @override
  String toString() {
    return '{ ${this.name}, ${this.id} }';
  }
}