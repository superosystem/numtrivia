// This Dart code defines a NetworkInfo abstraction to check the internet connection status.

// NetworkInfo abstract class outlines the interface for checking internet connectivity.
import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

// NetworkInfoImpl class implements the NetworkInfo interface using the InternetConnectionChecker.
class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker connectionChecker;

  // Constructor takes an instance of InternetConnectionChecker.
  NetworkInfoImpl(this.connectionChecker);

  // Implementation of the isConnected method using the hasConnection property from InternetConnectionChecker.
  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
}
