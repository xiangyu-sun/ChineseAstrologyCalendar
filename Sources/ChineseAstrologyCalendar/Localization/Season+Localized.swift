import Foundation

extension Season: LocalizedNaming {
  public func localizedName(in language: DisplayLanguage) -> String {
    switch language {
    case .zhHant, .zhHans: return traditionalChineseName // 春夏秋冬 identical in both scripts
    case .en: return Self.englishNames[self] ?? traditionalChineseName
    }
  }

  private static let englishNames: [Season: String] = [
    .spring: "Spring",
    .summer: "Summer",
    .fall: "Autumn",
    .winter: "Winter",
  ]
}
