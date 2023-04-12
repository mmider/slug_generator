import 'dart:math' show Random;

import 'package:slug_generator/slug_generator.dart';

void main() {
  final gen = Random(42);
  const n = 5;
  print("Here are $n random sentences:");
  for (var i = 0; i < 5; i++) {
    print(gen.nextSlugTokens().join(' '));
  }
  print("\nAnd here are $n random slugs:");
  for (var i = 0; i < 5; i++) {
    print(gen.nextSlug());
  }

  print("\nHere are $n random slugs guaranteed to be of length 4:");
  for (var i = 0; i < 5; i++) {
    print(gen.nextSlug(Collections.four));
  }

  print("\nHere are $n random slugs of length 3:");
  for (var i = 0; i < 5; i++) {
    print(gen.nextSlug(Collections.three));
  }

  print("\nHere are $n random slugs of length 2:");
  for (var i = 0; i < 5; i++) {
    print(gen.nextSlug(Collections.two));
  }
}
