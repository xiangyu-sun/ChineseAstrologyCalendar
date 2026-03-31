import Foundation

// MARK: - DizhiRelationship

/// The six types of relationships between Earthly Branches (地支六害).
///
/// Traditional Chinese astrology defines several interaction types between
/// the twelve Earthly Branches, used for compatibility analysis and date selection.
public enum DizhiRelationship: Sendable {

  // MARK: - Clash (六冲)
  /// The six opposing pairs that "clash" (冲) with each other.
  /// Clashing branches are 6 positions apart in the cycle.
  public enum Chong: CaseIterable, Sendable {
    case ziWu   // 子午冲
    case chouWei // 丑未冲
    case yinShen // 寅申冲
    case maoYou  // 卯酉冲
    case chenXu  // 辰戌冲
    case siHai   // 巳亥冲

    /// The two branches that clash in this pair.
    public var branches: (Dizhi, Dizhi) {
      switch self {
      case .ziWu:   return (.zi, .wu)
      case .chouWei: return (.chou, .wei)
      case .yinShen: return (.yin, .shen)
      case .maoYou:  return (.mao, .you)
      case .chenXu:  return (.chen, .xu)
      case .siHai:   return (.si, .hai)
      }
    }

    /// Chinese name of this clash pair.
    public var chineseName: String {
      let (a, b) = branches
      return a.chineseCharacter + b.chineseCharacter + "冲"
    }
  }

  // MARK: - Six Harmonies (六合)
  /// The six pairs that "combine harmoniously" (六合).
  public enum LiuHe: CaseIterable, Sendable {
    case ziChou   // 子丑合化土
    case yinHai   // 寅亥合化木
    case maoXu    // 卯戌合化火
    case chenYou  // 辰酉合化金
    case siShen   // 巳申合化水
    case wuWei    // 午未合化火土（日月合）

    /// The two branches that combine in this pair.
    public var branches: (Dizhi, Dizhi) {
      switch self {
      case .ziChou:  return (.zi, .chou)
      case .yinHai:  return (.yin, .hai)
      case .maoXu:   return (.mao, .xu)
      case .chenYou: return (.chen, .you)
      case .siShen:  return (.si, .shen)
      case .wuWei:   return (.wu, .wei)
      }
    }

    /// The Wuxing element produced when these two branches combine.
    public var resultingElement: Wuxing {
      switch self {
      case .ziChou:  return .tu
      case .yinHai:  return .mu
      case .maoXu:   return .huo
      case .chenYou: return .jin
      case .siShen:  return .shui
      case .wuWei:   return .huo
      }
    }

    /// Chinese name of this combination pair.
    public var chineseName: String {
      let (a, b) = branches
      return a.chineseCharacter + b.chineseCharacter + "合"
    }
  }

  // MARK: - Three Harmonies (三合)
  /// The four triads that form a "three harmony" (三合) combination.
  public enum SanHe: CaseIterable, Sendable {
    case shenZiChen  // 申子辰三合水局
    case yinWuXu     // 寅午戌三合火局
    case siYouChou   // 巳酉丑三合金局
    case haiMaoWei   // 亥卯未三合木局

    /// The three branches forming this triad.
    public var branches: (Dizhi, Dizhi, Dizhi) {
      switch self {
      case .shenZiChen: return (.shen, .zi, .chen)
      case .yinWuXu:    return (.yin, .wu, .xu)
      case .siYouChou:  return (.si, .you, .chou)
      case .haiMaoWei:  return (.hai, .mao, .wei)
      }
    }

    /// The Wuxing element produced by this triad.
    public var resultingElement: Wuxing {
      switch self {
      case .shenZiChen: return .shui
      case .yinWuXu:    return .huo
      case .siYouChou:  return .jin
      case .haiMaoWei:  return .mu
      }
    }

    /// Chinese name of this triad.
    public var chineseName: String {
      let (a, b, c) = branches
      return a.chineseCharacter + b.chineseCharacter + c.chineseCharacter + "三合"
    }
  }

  // MARK: - Harm (六害)
  /// The six pairs that "harm" each other (六害).
  public enum LiuHai: CaseIterable, Sendable {
    case ziWei   // 子未害
    case chouWu  // 丑午害
    case yinSi   // 寅巳害
    case maochen // 卯辰害
    case shenHai // 申亥害
    case youXu   // 酉戌害

    /// The two branches that harm each other.
    public var branches: (Dizhi, Dizhi) {
      switch self {
      case .ziWei:   return (.zi, .wei)
      case .chouWu:  return (.chou, .wu)
      case .yinSi:   return (.yin, .si)
      case .maochen: return (.mao, .chen)
      case .shenHai: return (.shen, .hai)
      case .youXu:   return (.you, .xu)
      }
    }

    /// Chinese name of this harm pair.
    public var chineseName: String {
      let (a, b) = branches
      return a.chineseCharacter + b.chineseCharacter + "害"
    }
  }
}

// MARK: - Dizhi relationship queries

extension Dizhi {

  /// Returns the branch that clashes (冲) with this one.
  ///
  /// Each branch has exactly one clash partner, 6 positions away.
  /// ```swift
  /// Dizhi.zi.chong // .wu
  /// Dizhi.mao.chong // .you
  /// ```
  public var chong: Dizhi {
    // branches are 6 apart in a 12-cycle
    let offset = ((rawValue - 1 + 6) % 12) + 1
    return Dizhi(rawValue: offset)!
  }

  /// Returns whether this branch clashes with the given branch.
  public func clashes(with other: Dizhi) -> Bool {
    chong == other
  }

  /// Returns the ``DizhiRelationship/LiuHe`` pair if this branch forms a six-harmony with `other`.
  public func liuHe(with other: Dizhi) -> DizhiRelationship.LiuHe? {
    DizhiRelationship.LiuHe.allCases.first { pair in
      let (a, b) = pair.branches
      return (self == a && other == b) || (self == b && other == a)
    }
  }

  /// Returns whether this branch has a six-harmony with the given branch.
  public func formsLiuHe(with other: Dizhi) -> Bool {
    liuHe(with: other) != nil
  }

  /// Returns the ``DizhiRelationship/SanHe`` triad if this branch participates with both others.
  public func sanHe(with second: Dizhi, and third: Dizhi) -> DizhiRelationship.SanHe? {
    DizhiRelationship.SanHe.allCases.first { triad in
      let (a, b, c) = triad.branches
      let set = Set([a, b, c])
      return set == Set([self, second, third])
    }
  }

  /// Returns all ``DizhiRelationship/SanHe`` triads that include this branch.
  public var sanHeTriads: [DizhiRelationship.SanHe] {
    DizhiRelationship.SanHe.allCases.filter { triad in
      let (a, b, c) = triad.branches
      return self == a || self == b || self == c
    }
  }

  /// Returns the ``DizhiRelationship/LiuHai`` pair if this branch harms `other`.
  public func liuHai(with other: Dizhi) -> DizhiRelationship.LiuHai? {
    DizhiRelationship.LiuHai.allCases.first { pair in
      let (a, b) = pair.branches
      return (self == a && other == b) || (self == b && other == a)
    }
  }

  /// Returns whether this branch forms a six-harm with the given branch.
  public func formsLiuHai(with other: Dizhi) -> Bool {
    liuHai(with: other) != nil
  }
}
