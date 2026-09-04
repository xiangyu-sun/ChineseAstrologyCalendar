import Foundation

extension Bazi {
  /// A formatted display of the four pillars with labels, in the given language.
  ///
  /// Equivalent to ``formattedDescription`` for `.zhHant`.
  public func localizedFormattedDescription(in language: DisplayLanguage) -> String {
    switch language {
    case .zhHant:
      return "年:\(nian.description) 月:\(yue.description) 日:\(ri.description) 時:\(shi.description)"
    case .zhHans:
      return "年:\(nian.description) 月:\(yue.description) 日:\(ri.description) 时:\(shi.description)"
    case .en:
      return "Year: \(pillarEN(nian))  Month: \(pillarEN(yue))  Day: \(pillarEN(ri))  Hour: \(pillarEN(shi))"
    }
  }

  /// Renders a single pillar for English display as `"Pinyin (漢字)"`.
  private func pillarEN(_ pillar: Ganzhi) -> String {
    "\(pillar.pinyin) (\(pillar.description))"
  }
}
