
import Foundation

/// Cardinal directions used with the five elements.
public enum FangWei: CaseIterable, WuxingConvertable, Sendable {

  case dong
  case nan
  case xi
  case bei
  case zhong

  // MARK: Public

  /// Chinese character representation of the direction.
  public var chineseCharacter: String {
    switch self {
    case .dong:
      return "東"
    case .nan:
      return "南"
    case .xi:
      return "西"
    case .bei:
      return "北"
    case .zhong:
      return "中"
    }
  }

  /// Chinese character representation of the direction.
  @available(*, deprecated, renamed: "chineseCharacter", message: "Use chineseCharacter instead (spelling corrected)")
  public var chineseCharactor: String {
    chineseCharacter
  }

  /// ``Wuxing`` element corresponding to the direction.
  public var wuxing: Wuxing {
    switch self {
    case .dong:
      return .mu
    case .nan:
      return .huo
    case .xi:
      return .jin
    case .bei:
      return .shui
    case .zhong:
      return .tu
    }
  }

  /// The two ``Tiangan`` (Heavenly Stems) associated with this direction.
  public var tiangan: (Tiangan, Tiangan) { wuxing.tiangan }

  /// The ``Dizhi`` (Earthly Branches) associated with this direction.
  public var dizhi: [Dizhi] { wuxing.dizhi }
}
