// This Dart code defines a set of Failure classes that extend Equatable.
// Failures are used to represent various error scenarios in an application.

// The Failure abstract class extends Equatable to enable easy value comparison.
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];
}

// ServerFailures class represents failures related to server interactions.
class ServerFailures extends Failure {}

// CacheFailures class represents failures related to caching data.
class CacheFailures extends Failure {}
