import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../interfaces/serializable.dart';
import 'package:lloo_mobile/app/debug/channel_logger.dart' as L;
import 'package:lloo_mobile/app/modules/user/models/user_details.dart';
import 'package:lloo_mobile/app/core/lloo_exceptions.dart';

extension AutoPersist<T> on Rx<T> {
  /// Automatically persists the value of this Rx observable to GetStorage using the specified [key].
  /// For complex objects, they must extend the Serializable class.
  /// 
  /// Example usage:
  /// ```dart
  /// // For simple types:
  /// final count = Rx<int>(0).autopersist('count');
  /// 
  /// // For complex objects (must extend Serializable):
  /// final user = Rx<UserDetails?>(null).autopersist('user_details');
  /// ```
  Rx<T> autopersist(String key) {
    final box = GetStorage();

    L.verbose('AUTOPERSIST', 'Registering property with key $key on $this');

    // Load initial value if it exists
    if (box.hasData(key)) {
      try {
        final dynamic stored = box.read(key);
        if (stored != null) {
          if (_isBasicType(stored)) {
            value = stored as T;
          } else if (stored is Map<String, dynamic>) {
            if (T.toString() == 'UserDetails' || T.toString() == 'UserDetails?') {
              value = UserDetails.fromJson(stored) as T;
            } else {
              throw LlooParseException('Unsupported type for deserialization: $T');
            }
          }
        }
      } catch (e) {
        L.error('AUTOPERSIST', 'Error loading persisted value for key $key: $e');
      }
    }

    // Listen to changes and save them
    ever(this, (dynamic val) {
      try {
        if (val == null) {
          box.write(key, null);
        } else if (_isBasicType(val)) {
          box.write(key, val);
        } else if (val is Serializable) {
          box.write(key, val.toJson());
        }
      } catch (e) {
        L.error('AUTOPERSIST', 'Error saving value for key $key: $e');
      }
    });

    return this;
  }

  bool _isBasicType(dynamic value) {
    return value is num || value is String || value is bool || value is DateTime;
  }
}

extension AutoPersistList<T> on RxList<T> {
  /// Automatically persists this RxList to GetStorage using the specified [key].
  /// For lists of complex objects, they must extend the Serializable class.
  /// 
  /// Example usage:
  /// ```dart
  /// // For simple types:
  /// final items = <String>[].obs.autopersist('items');
  /// 
  /// // For complex objects (must extend Serializable):
  /// final users = <UserDetails>[].obs.autopersist('users');
  /// ```
  RxList<T> autopersist(String key) {
    final box = GetStorage();

    // Load initial value if it exists
    if (box.hasData(key)) {
      try {
        final List<dynamic>? stored = box.read<List<dynamic>?>(key);
        if (stored != null) {
          if (_isBasicType(stored.first)) {
            assignAll(stored.cast<T>());
          } else {
            if (T.toString() == 'UserDetails') {
              assignAll(stored
                  .map((item) => UserDetails.fromJson(item as Map<String, dynamic>) as T)
                  .toList());
            } else {
              throw LlooParseException('Unsupported type for list deserialization: $T');
            }
          }
        }
      } catch (e) {
        L.error('AUTOPERSIST', 'Error loading persisted list for key $key: $e');
      }
    }

    // Listen to changes and save them
    listen((List<T> items) {
      try {
        if (items.isNotEmpty) {
          if (_isBasicType(items.first)) {
            box.write(key, items.toList());
          } else if (items.first is Serializable) {
            box.write(key, items.map((item) => (item as Serializable).toJson()).toList());
          }
        } else {
          box.write(key, []);
        }
      } catch (e) {
        L.error('AUTOPERSIST', 'Error saving list for key $key: $e');
      }
    });

    return this;
  }

  bool _isBasicType(dynamic value) {
    return value is num || value is String || value is bool || value is DateTime;
  }
}
