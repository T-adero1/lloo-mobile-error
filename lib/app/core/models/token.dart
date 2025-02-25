// Token Model
// @TODO: Replace usage of this with Memory
class Token {
  final String thumbnailUrl;
  final String name;
  final String description;
  final double attnValue;
  final double fiatValue;

  Token({
    required this.thumbnailUrl,
    required this.name,
    required this.description,
    required this.attnValue,
    required this.fiatValue,
  });
}