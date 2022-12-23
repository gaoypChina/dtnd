import 'package:dtnd/=models=/local/local_catalog.dart';
import 'package:hive_flutter/hive_flutter.dart';

@HiveType(typeId: 4)
class UserCatalog extends HiveObject implements LocalCatalog {
  UserCatalog({required String name, List<String>? stocks})
      : _name = name,
        _stocks = stocks;

  @HiveField(0)
  final String _name;

  @HiveField(1)
  final List<String>? _stocks;

  @override
  String get name => _name;

  @override
  List<String>? get stocks => _stocks;
}
