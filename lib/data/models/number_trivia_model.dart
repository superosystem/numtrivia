import 'dart:convert';

import '../../domain/entities/number_trivia.dart';

class NumberTriviaModel extends NumberTrivia {
  const NumberTriviaModel({
    required String text,
    required int number,
  }) : super(text: text, number: number);

  NumberTriviaModel copyWith({
    String? text,
    int? number,
  }) =>
      NumberTriviaModel(
        text: text ?? this.text,
        number: number ?? this.number,
      );

  factory NumberTriviaModel.fromRawJson(String str) =>
      NumberTriviaModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NumberTriviaModel.fromJson(Map<String, dynamic> json) =>
      NumberTriviaModel(
        text: json["text"],
        number: json["number"],
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "number": number,
      };
}
