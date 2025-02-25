import 'package:lloo_mobile/app/core/interfaces/serializable.dart';
import 'package:lloo_mobile/app/core/lloo_exceptions.dart';
import 'package:lloo_mobile/app/debug/channel_logger.dart' as L;

class UserDetails extends Serializable {
  final String userId;
  final String email;
  final String? username;
  final String? avatarUrl;
  final String? walletAddress;

  const UserDetails({
    required this.userId,
    required this.email,
    this.username,
    this.avatarUrl,
    this.walletAddress,
  }) : super();

  factory UserDetails.fromJson(Map<String, dynamic> json) {
     try {
        return UserDetails(
          userId: json['userId']?.toString() ?? '',
          email: json['email']?.toString() ?? '',
          username: json['username']?.toString(),
          avatarUrl: json['avatarUrl']?.toString(),
          walletAddress: json['walletAddress']?.toString(),
        );
      } catch (e) {
        L.error('USER_DETAILS', 'Invalid JSON format: $e');
        throw LlooParseException("Error parsing user details", underlyingError: e);
      }
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'userId': userId,
      'avatarUrl': avatarUrl,
      'walletAddress': walletAddress,
    };
  }


  /// Creates a copy of this [UserDetails] but with the given fields replaced with the new values.
  UserDetails copyWith({
    String? userId,
    String? email,
    String? username,
    String? avatarUrl,
    String? walletAddress,
  }) {
    return UserDetails(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      walletAddress: walletAddress ?? this.walletAddress,
    );
  }

  @override
  String toString() => toJson().toString();
}