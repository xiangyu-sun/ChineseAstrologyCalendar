import Foundation

extension Bazi {
  /// A formatted display of the four pillars with labels, in the given language.
  ///
  /// Equivalent to ``formattedDescription`` for `.zhHant`.
  public func localizedFormattedDescription(in language: DisplayLanguage) -> String {
    switch language.base {
    case .zhHant:
      return "年:\(nian.description) 月:\(yue.description) 日:\(ri.description) 時:\(shi.description)"
    case .zhHans:
      return "年:\(nian.description) 月:\(yue.description) 日:\(ri.description) 时:\(shi.description)"
    case .en:
      return "Year: \(pinyinPillar(nian))  Month: \(pinyinPillar(yue))  Day: \(pinyinPillar(ri))  Hour: \(pinyinPillar(shi))"
    case .es:
      return "Año: \(pinyinPillar(nian))  Mes: \(pinyinPillar(yue))  Día: \(pinyinPillar(ri))  Hora: \(pinyinPillar(shi))"
    }
  }

  /// Renders a single pillar for non-Chinese display as `"Pinyin (漢字)"`.
  private func pinyinPillar(_ pillar: Ganzhi) -> String {
    "\(pillar.pinyin) (\(pillar.description))"
  }
}
