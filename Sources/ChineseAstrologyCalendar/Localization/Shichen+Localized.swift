import Foundation

extension Shichen {
  /// The current `ke` (quarter-hour subdivision) spelled out in the given language.
  ///
  /// `.zhHant`/`.zhHans` both return ``currentKeSpellOut`` — the characters
  /// (初二三四五六七末) are identical in both scripts.
  public func localizedKeSpellOut(in language: DisplayLanguage) -> String {
    switch language {
    case .zhHant, .zhHans: return currentKeSpellOut
    case .en: return Self.englishKeOrdinals[currentKe]
    }
  }

  private static let englishKeOrdinals = ["1st", "2nd", "3rd", "4th", "5th", "6th", "7th", "8th"]
}
