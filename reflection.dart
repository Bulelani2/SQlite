final String reflectionTable = "Reflection";

class ReflectionFields {
  static final String username = 'username';
  static final String title = 'title';
  static final String done = 'done';
  static final String created = 'created';
  static final List<String> allFields = [username, title, done, created];
}

class Reflection {
  final String username;
  final String title;
  bool done;
  final DateTime created;

  Reflection({
    required this.username,
    required this.title,
    this.done = false,
    required this.created,
  });

  Object? get arg01 => username;

  Object? get arg02 => title;

  Map<String, Object?> toJson() => {
        ReflectionFields.username: username,
        ReflectionFields.title: title,
        ReflectionFields.done: done ? 1 : 0,
        ReflectionFields.created: created.toIso8601String(),
      };
  static Reflection fromJson(Map<String, Object?> json) => Reflection(
        username: json[ReflectionFields.username] as String,
        title: json[ReflectionFields.title] as String,
        done: json[ReflectionFields.done] == 1 ? true : false,
        created: DateTime.parse(json[ReflectionFields.created] as String),
      );

  @override
  bool operator ==(covariant Reflection reflection) {
    return (this.username == reflection.username) &&
        (this.title.toUpperCase().compareTo(
                  reflection.title.toUpperCase(),
                ) ==
            0);
  }
}
