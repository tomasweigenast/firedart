import 'package:firedart/firestore/firestore_gateway.dart';

abstract class Reference {
  final FirestoreGateway _gateway;
  final String path;

  String get id => path.substring(path.lastIndexOf('/') + 1);
  String get fullPath => '${_gateway.database}/$path';

  Reference(this._gateway, String path)
      : path = _trimSlashes(path.startsWith(_gateway.database)
            ? path.substring(_gateway.database.length + 1)
            : path);

  factory Reference.create(FirestoreGateway gateway, String path) {
    return _trimSlashes(path).split('/').length % 2 == 0
        ? DocumentReference(gateway, path)
        : CollectionReference(gateway, path);
  }

  @override
  int get hashCode => Object.hash(runtimeType, fullPath);

  static String _trimSlashes(String path) {
    path = path.startsWith('/') ? path.substring(1) : path;
    return path.endsWith('/') ? path.substring(0, path.length - 2) : path;
  }

  @override
  bool operator ==(Object other) =>
      other is Reference && runtimeType == other.runtimeType && fullPath == other.fullPath;
}
