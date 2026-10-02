import Foundation

// MARK: - DizhiRelationship + LocalizedNaming
//
// Chinese names join the branch characters with the relationship suffix
// (子午沖 / 子午冲). English names join the branches' pinyin, e.g. "Zǐ–Wǔ Clash".

extension DizhiRelationship.Chong: LocalizedNaming {
  public func localizedName(in language: DisplayLanguage) -> String {
    let (a, b) = branches
    switch language.base {
    case .zhHant: return chineseName
    case .zhHans: return a.chineseCharacter + b.chineseCharacter + "冲"
    case .en: return pairName(a, b) + " Clash"
    }
  }
}

extension DizhiRelationship.LiuHe: LocalizedNaming {
  public func localizedName(in language: DisplayLanguage) -> String {
    let (a, b) = branches
    switch language.base {
    case .zhHant, .zhHans: return chineseName
    case .en: return pairName(a, b) + " Harmony"
    }
  }
}

extension DizhiRelationship.SanHe: LocalizedNaming {
  public func localizedName(in language: DisplayLanguage) -> String {
    let (a, b, c) = branches
    switch language.base {
    case .zhHant, .zhHans: return chineseName
    case .en: return [a, b, c].map { $0.localizedName(in: .en) }.joined(separator: "–") + " Triad"
    }
  }
}

extension DizhiRelationship.LiuHai: LocalizedNaming {
  public func localizedName(in language: DisplayLanguage) -> String {
    let (a, b) = branches
    switch language.base {
    case .zhHant, .zhHans: return chineseName
    case .en: return pairName(a, b) + " Harm"
    }
  }
}

private func pairName(_ a: Dizhi, _ b: Dizhi) -> String {
  a.localizedName(in: .en) + "–" + b.localizedName(in: .en)
}
