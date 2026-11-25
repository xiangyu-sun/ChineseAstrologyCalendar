import Foundation

// MARK: - DizhiRelationship + LocalizedNaming
//
// Chinese names join the branch characters with the relationship suffix
// (子午沖 / 子午冲). English and Spanish names join the branches' pinyin, e.g.
// "Zǐ–Wǔ Clash" / "Choque Zǐ–Wǔ".

extension DizhiRelationship.Chong: LocalizedNaming {
  public func localizedName(in language: DisplayLanguage) -> String {
    let (a, b) = branches
    switch language.base {
    case .zhHant: return chineseName
    case .zhHans: return a.chineseCharacter + b.chineseCharacter + "冲"
    case .en: return pairName(a, b) + " Clash"
    case .es: return "Choque " + pairName(a, b)
    }
  }
}

extension DizhiRelationship.LiuHe: LocalizedNaming {
  public func localizedName(in language: DisplayLanguage) -> String {
    let (a, b) = branches
    switch language.base {
    case .zhHant, .zhHans: return chineseName
    case .en: return pairName(a, b) + " Harmony"
    case .es: return "Armonía " + pairName(a, b)
    }
  }
}

extension DizhiRelationship.SanHe: LocalizedNaming {
  public func localizedName(in language: DisplayLanguage) -> String {
    let (a, b, c) = branches
    switch language.base {
    case .zhHant, .zhHans: return chineseName
    case .en: return joinedPinyin([a, b, c]) + " Triad"
    case .es: return "Tríada " + joinedPinyin([a, b, c])
    }
  }
}

extension DizhiRelationship.LiuHai: LocalizedNaming {
  public func localizedName(in language: DisplayLanguage) -> String {
    let (a, b) = branches
    switch language.base {
    case .zhHant, .zhHans: return chineseName
    case .en: return pairName(a, b) + " Harm"
    case .es: return "Daño " + pairName(a, b)
    }
  }
}

private func pairName(_ a: Dizhi, _ b: Dizhi) -> String {
  joinedPinyin([a, b])
}

/// Branch names are Pinyin in both English and Spanish.
private func joinedPinyin(_ branches: [Dizhi]) -> String {
  branches.map { $0.localizedName(in: .en) }.joined(separator: "–")
}
