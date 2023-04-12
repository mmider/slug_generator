import 'dart:math';

import 'package:slug_generator/src/collections.dart';
import 'package:slug_generator/src/data_containers.dart';
import 'package:slug_generator/src/fundamental_extensions.dart';

extension SlugGenerator on Random {
  List<String> _generateFrom(DataContainer data) {
    final n = BigInt.from(data.numberOfTerms);
    while (true) {
      final sample = nextBigInt(n).toInt();
      final proposal = data[sample].toListOfStrings();
      if (data.constraints.areSatisfiedBy(proposal)) {
        return proposal;
      }
    }
  }

  /// Generate a random, tokenized slug drawing from a repository of terms [data] ([Collections.all] by default)
  ///
  /// Same as [nextSlug], but instead of joining constituent words with `-`,
  /// drawn terms are returned as a list.
  List<String> nextSlugTokens([DataContainer? data]) {
    return _generateFrom(data ?? Collections.all);
  }

  /// Generate a random slug drawing from a repository of terms [data] ([Collections.all] by default)
  ///
  /// ### Example
  /// ```
  /// final rng = Random(1)
  /// final slug = rng.nextSlug();
  /// // slug == 'precious-loose-chihuahua-of-acceptance';
  /// final shortSlug = rng.nextSlug(Collections.two);
  /// // shortSlug == 'lavender-skua'
  /// ```
  String nextSlug([DataContainer? data]) => nextSlugTokens(data).join('-');
}
