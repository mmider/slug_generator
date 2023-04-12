import 'package:slug_generator/src/data_containers.dart';
import 'package:slug_generator/src/words_vault.dart';

class Collections {
  static final all = NestedList(
    [two, three, four],
    comment: "Entry point",
  );
  static final two = NestedList(
    [an],
    comment: "Two words (may also contain prepositions)",
  );
  static final three = NestedList(
    [aan, ano, anl, nuo, as2, s2o, s2l, sl2],
    comment: "Three words (may also contain prepositions)",
  );
  static final four = NestedList(
    [aano, aanl, anuo, as2o, s2uo, as2l, asl2],
    comment: "Four words (may also contain prepositions)",
  );
  static final an = CartesianList(
    [adjAny, subj],
    comment: "adjective-noun",
  );
  static final aan = CartesianList(
    [adjFar, adjNear, subj],
    comment: "adjective-adjective-noun",
  );
  static final ano = CartesianList(
    [adjAny, subj, of, ofNounAny],
    comment: "adjective-noun-of-noun",
  );
  static final anl = CartesianList(
    [adjAny, subj, from, WordsVault.fromNounNoMod],
    comment: "adjective-noun-from-location",
  );
  static final nuo = CartesianList(
    [subj, of, WordsVault.ofModifier, WordsVault.ofNoun],
    comment: "noun-of-adjective-noun",
  );
  static final as2 = CartesianList(
    [adjFar, WordsVault.subj2],
    comment: "adjective-2word-subject",
  );
  static final s2o = CartesianList(
    [WordsVault.subj2, of, ofNounAny],
    comment: "2word-subject-of-noun",
  );
  static final s2l = CartesianList(
    [WordsVault.subj2, from, WordsVault.fromNounNoMod],
    comment: "2word-subject-from-location",
  );
  static final sl2 = CartesianList(
    [subj, from, WordsVault.from2],
    comment: "subject-from-some-location",
  );
  static final aano = CartesianList(
    [adjFar, adjNear, subj, of, ofNounAny],
    comment: "adjective-adjective-noun-of-noun",
  );
  static final aanl = CartesianList(
    [adjFar, adjNear, subj, from, WordsVault.fromNounNoMod],
    comment: "adjective-adjective-noun-from-location",
  );
  static final anuo = CartesianList(
    [adjAny, subj, of, WordsVault.ofModifier, WordsVault.ofNoun],
    comment: "adjective-noun-of-adjective-noun",
  );
  static final as2o = CartesianList(
    [adjFar, WordsVault.subj2, of, ofNounAny],
    comment: "adjective-2word-subject-of-noun",
  );
  static final s2uo = CartesianList(
    [WordsVault.subj2, of, WordsVault.ofModifier, WordsVault.ofNoun],
    comment: "adjective-2word-subject-of-adjective-noun",
  );
  static final as2l = CartesianList(
    [adjFar, WordsVault.subj2, from, WordsVault.fromNounNoMod],
    comment: "adjective-2word-subject-from-location",
  );
  static final asl2 = CartesianList(
    [adjAny, subj, from, WordsVault.from2],
    comment: "adjective-subject-from-some-location",
  );
  static final adjFar = NestedList(
    [
      WordsVault.adjective,
      WordsVault.adjectiveFirst,
      WordsVault.nounAdjective,
      WordsVault.size,
    ],
    comment: "First adjective (with more following)",
  );
  static final adjNear = NestedList(
    [
      WordsVault.adjective,
      WordsVault.adjectiveNear,
      WordsVault.nounAdjective,
      WordsVault.prefix,
    ],
    comment: "Last adjective (closest to the subject)",
  );
  static final adjAny = NestedList(
    [
      WordsVault.adjective,
      WordsVault.adjectiveNear,
      WordsVault.nounAdjective,
      WordsVault.prefix,
      WordsVault.size,
    ],
    comment: "The only adjective (includes everything)",
  );
  static final subj = NestedList(
    [
      WordsVault.animal,
      WordsVault.animalBreed,
      WordsVault.animalFantasy,
    ],
    comment: "The subject (animal)",
  );
  static final of = Singleton.fromString("of");
  static final ofNounAny = NestedList(
    [WordsVault.ofNoun, WordsVault.ofNounNoMod],
  );
  static final from = Singleton.fromString("from");
}
