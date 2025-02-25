abstract class Serializable {
  const Serializable();
  
  Map<String, dynamic> toJson();
  
  /// Create an instance from a JSON map.
  /// Each subclass must implement this as a factory constructor.
  /// 
  /// Example:
  /// ```dart
  /// factory MyClass.fromJson(Map<String, dynamic> json) {
  ///   return MyClass(
  ///     field: json['field'],
  ///   );
  /// }
  /// ```
  static T fromJson<T extends Serializable>(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJson) {
    return fromJson(json);
  }
}
