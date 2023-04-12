// =============================================================================
//
//  Defines classes that facilitate creation of word collections and combination
//  of those collections into more elaborate word collections.
//
//  `RawListOfWords` is the most basic word collection. Each should contain
//  words belonging to a single part of speech family.
//
//  `NestedList` is a the "grouping" collection, that allows collecting multiple
//  other collections and "throwing them into a single bag with a common label".
//
//  `CartesianList` is a collection that defines a 'pattern' for a phrase. It
//  defines a sequence of word-placeholders, and then, it indicates which groups
//  of collections are allowed to pass their words into which placeholder.
//
// =============================================================================

import 'package:slug_generator/src/fundamental_extensions.dart';

// =============================
//
//  Term
//  ----
//  A unit representing a ~`word`
//
// =============================

/// The most basic unit defining a term/part of speech
///
/// Most commonly comprises of a single word and is represented by a
/// `SingleWord`; however, sometimes names comprise of two words, for instance:
/// a `fire ant` and they are represented by a `TwoWordTerm` instead.
abstract class Term {
  /// Total number of non-whitespace characters
  int get length;
  const Term();

  /// Arrange constituent words into a list of strings
  List<String> toListOfStrings();
}

/// A wrapper around a string representing a term/part of speech
///
/// Most common form of a [Term], where only a single word is used.
class SingleWord extends Term {
  final String value;
  const SingleWord(this.value);

  @override
  int get length => value.length;

  @override
  List<String> toListOfStrings() {
    return [value];
  }

  @override
  String toString() => value;
}

/// A wrapper around two strings representing a term/part of speech
///
/// Less common form of a [Term], where two words are used, for instance:
/// a "fire ant".
class TwoWordTerm extends Term {
  final String first;
  final String second;
  const TwoWordTerm(this.first, this.second);

  @override
  int get length => first.length + second.length;

  @override
  List<String> toListOfStrings() {
    return [first, second];
  }

  @override
  String toString() => "$first $second";
}

// =========================================
//
//  AbstractPhrase
//  --------------
//  A collection of words making up a phrase
//
// =========================================

/// A collection of words making up a phrase
///
/// Regular implementation is a [Phrase]. If a collection comprises of a single
/// word, then an optimized container [SingletonPhrase] can be used.
abstract class AbstractPhrase {
  const AbstractPhrase();
  List<String> toListOfStrings();
}

/// A collection of words making up a phrase
///
/// For [Phrase]s that are known a-priori to comprise of a single word use a
/// [SingletonPhrase].
class Phrase extends AbstractPhrase {
  final List<Term> terms;
  const Phrase(this.terms);
  @override
  List<String> toListOfStrings() {
    return terms.expand((term) => term.toListOfStrings()).toList();
  }
}

/// A degenerate [AbstractPhrase] that comprises of a single word
class SingletonPhrase<T extends Term> extends AbstractPhrase {
  final T value;
  const SingletonPhrase(this.value);
  @override
  List<String> toListOfStrings() {
    return value.toListOfStrings();
  }
}

// ============================================
//
//  Constraints
//  -----------
//  Constrains that are put on [DataContainer]s
//
// ============================================

/// A set of constrains that a [DataContainer] can be decorated with.
///
/// A [Phrase] generated/fetched from such a [DataContainer] can then be checked
/// against the [Constraints] using [areSatisfiedBy].
class Constraints {
  /// Whether each word in a phrase need be unique within that phrase
  final bool ensureUnique;

  /// Whether a prefix of each word (comprising of the first
  /// `ensureUniquePrefixOfLength` number of letters) need be unique within that
  /// phrase (if a word has less letters then the prefix limmit, the whole word
  /// is considered to be a prefix)
  final int? ensureUniquePrefixOfLength;

  /// Whether total number of characters (excluding whitespaces) must be no
  /// greater than `maxLength`.
  final int? maxLength;

  /// check whether defined constraints are not degenrate
  bool get areValid =>
      (ensureUniquePrefixOfLength == null || ensureUniquePrefixOfLength! > 0) &&
      (maxLength == null || maxLength! > 0);

  const Constraints({
    this.ensureUnique = true,
    this.ensureUniquePrefixOfLength,
    this.maxLength,
  });

  /// Check if a list of words that defines a phrase satisfies the given constraints
  bool areSatisfiedBy(List<String> words) {
    assert(areValid);

    if (ensureUnique && !words.hasNoRepeats) {
      return false;
    }
    if (ensureUniquePrefixOfLength != null &&
        !words.map((w) => w.prefix(ensureUniquePrefixOfLength!)).hasNoRepeats) {
      return false;
    }
    if (maxLength != null && words.totalNumberOfCharacters > maxLength!) {
      return false;
    }
    return true;
  }
}

// ====================================================
//
//  DataContainer
//  -------------
//  Containers collecting words into groups or patterns
//
// ====================================================

/// A parent to all collections of words
abstract class DataContainer {
  /// Most complex containers are simply collections of simpler containers.
  /// These simpler containers are stored here (they can have their own
  /// subcontainers).
  final List<DataContainer> subcontainers;

  /// Total number of terms that this container holds
  final int numberOfTerms;

  /// Comment for a developer (has no impact on functionality)
  final String? comment;

  /// Constraints on the container. They must be externally enforced, as
  /// `DataContainer` does not do any autmatic checks against them
  final Constraints constraints;

  const DataContainer({
    this.subcontainers = const [],
    required this.numberOfTerms,
    this.comment,
    this.constraints = const Constraints(),
  });

  /// Extract the `i`th `phrase` from the container. It is an `AbstractPhrase`
  /// as opposed to a `Term`, as a `DataContainer` can contain a complex
  /// composition of `Term`s. See `CartesianList` for more info.
  AbstractPhrase operator [](int i);
}

/// Some utility functions for computing total number of terms of containers
extension SubcontainersExt on List<DataContainer> {
  int sumNumberOfTerms() => fold(0, (prev, sc) => prev + sc.numberOfTerms);
  int multiplyNumberOfTerms() => fold(1, (prev, sc) => prev * sc.numberOfTerms);
}

/// The most basic container used for defining a collection of words that belong
/// to the same category of: part of speech/semantic group etc.
class RawListOfWords<T extends Term> extends DataContainer {
  /// A list of terms defined by this container.
  /// (NOTE: this container has no `subcontainer`s!)
  final List<T> data;

  /// Comment for a developer expanding upon `comment` field. (has no impact on functionality)
  final List<String>? examples;

  /// Check whether container's constrained are satisfied by all the terms
  /// stored inside of it
  bool get areConstraintsSatisfied =>
      constraints.maxLength == null ||
      !data.any((d) => d.length > constraints.maxLength!);

  RawListOfWords({
    required this.data,
    this.examples,
    int? maxLength,
    super.comment,
  }) : super(
          numberOfTerms: data.length,
          constraints: Constraints(maxLength: maxLength),
        );

  static RawListOfWords<SingleWord> fromListOfStrings({
    required List<String> data,
    List<String>? examples,
    int? maxLength,
    String? comment,
  }) {
    return RawListOfWords(
      data: data.map((v) => SingleWord(v)).toList(),
      examples: examples,
      maxLength: maxLength,
      comment: comment,
    );
  }

  @override
  SingletonPhrase<T> operator [](int i) => SingletonPhrase(data[i]);
}

/// A List of words/phrases that bags together other lists of words/phrases
///
/// ### Example
/// For instance, if
/// ```
/// final listA = RawListOfWords(data: ['a', 'b']);
/// final listB = RawListOfWords(data: ['c', 'd']);
/// final nestedList = NestedList([listA, listB]);
/// ```
/// Then `nestedList` is like ~ `RawListOfWords(data: ['a', 'b', 'c', 'd'])`;
class NestedList extends DataContainer {
  NestedList(List<DataContainer> subcontainers, {super.comment})
      : super(
          subcontainers: subcontainers
            ..sort(
              // sort subcontainers, with larger first, to optimize sampling
              (a, b) => b.numberOfTerms.compareTo(a.numberOfTerms),
            ),
          numberOfTerms: subcontainers.sumNumberOfTerms(),
        );

  @override
  AbstractPhrase operator [](int i) {
    if (i >= numberOfTerms || i < 0) {
      throw IndexError.withLength(i, numberOfTerms);
    }
    int n;
    for (var container in subcontainers) {
      n = container.numberOfTerms;
      if (i < n) {
        return container[i];
      }
      i -= n;
    }
    throw Exception("Unexpected indexing error. There must have been an "
        "earlier error with the computation of the `numberOfTerms`.");
  }
}

/// A List of phrases that combines together terms/phrases from its sublists
/// according to the "pattern" defined by the order of subcontainers.
///
/// The terms from subcontainers are combined together according to the rules of
/// Cartesian Product to create phrases.
///
/// ### Example
/// For instance, if
/// ```
/// final listA = RawListOfWords(data: ['a', 'b']);
/// final listB = RawListOfWords(data: ['c', 'd']);
/// final cartesianList = CartesianList([listA, listB]);
/// ```
/// Then `cartesianList` is like
/// ~ `[['a', 'c'], ['a', 'd'], ['b', 'c'], ['b', 'd']]`;
class CartesianList extends DataContainer {
  late final List<int> revCumNumberOfTerms;

  CartesianList(List<DataContainer> subcontainers, {super.comment})
      : super(
          subcontainers: subcontainers,
          numberOfTerms: subcontainers.multiplyNumberOfTerms(),
        ) {
    revCumNumberOfTerms = List<int>.filled(subcontainers.length + 1, 1);
    var n = numberOfTerms;
    revCumNumberOfTerms[0] = n;
    for (var i = 0; i < subcontainers.length; i++) {
      n ~/= subcontainers[i].numberOfTerms;
      revCumNumberOfTerms[i + 1] = n;
    }
  }

  @override
  Phrase operator [](int i) {
    if (i >= numberOfTerms || i < 0) {
      throw IndexError.withLength(i, numberOfTerms);
    }
    final terms = <Term>[];
    for (var j = 0; j < subcontainers.length; j++) {
      final container = subcontainers[j];
      final n = revCumNumberOfTerms[j + 1];
      terms.add((container[i ~/ n] as SingletonPhrase).value);
      i %= n;
    }
    return Phrase(terms);
  }
}

/// A degenerate [DataContainer] that comprises of a single [Term]
class Singleton<T extends Term> extends DataContainer {
  final T value;
  Singleton(this.value) : super(numberOfTerms: 1);

  static Singleton<SingleWord> fromString(String value) {
    return Singleton(SingleWord(value));
  }

  @override
  SingletonPhrase<T> operator [](int i) => SingletonPhrase(value);
}
